Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3765527FD4A;
	Wed, 28 Jan 2026 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615404; cv=none; b=Z1rjWtOpwOloNokQHQ4J1APl3BD3zGkzPk6XwnQuybBPpqQVsXaEAwsImkpvOnfeni7Saw97XXoe6XNufq2GOdu6vBwn4EH8a81ZsOxDQgDDCQ+zzwDic12H2hME6siGRheHjt74fvFUpuK/Cj4RWOH5wFqN9eCGfazk470/i1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615404; c=relaxed/simple;
	bh=b7QE6wx5e9mfyr4iQuOpoZIz+PZ6eHKNcjSe1rkoiKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp/tSuG7l8chh/t+R0t/v/K1G4F+aSNc7cu1WhMgmyBktye048OAc5G3Wwy50HHI9Lmz3YO4olaywRQ/IfCYko3nnWAPr6ImKDYk2yGgx7ppzY9p6H1SWGlEVZKF9FKV+b9BnBAKrCvEDVf5Za17kXORb7X9K1TsJyaG66Jj+jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUG/nt2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUG/nt2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B029C4CEF1;
	Wed, 28 Jan 2026 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615404;
	bh=b7QE6wx5e9mfyr4iQuOpoZIz+PZ6eHKNcjSe1rkoiKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUG/nt2qZwv0hmNkKPrF1fi3B0ZlACWjJ6SQnMFHbknVt+PFYOH0f87iv2OCCHyTl
	 m7Jblq6oC+MaDFSuJR0PBO/BqY5fBpLt/+GILRWWAajzNibwMtmUMqqIAIqNfyvvMg
	 oQRTgeu6P3mBHaI4PNqFQr+Zv/b7qckVjuJt6DF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 169/169] vsock/virtio: Fix message iterator handling on transmit path
Date: Wed, 28 Jan 2026 16:24:12 +0100
Message-ID: <20260128145340.112425445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[Upstream commit 7fb1291257ea1e27dbc3f34c6a37b4d640aafdd7]

Commit 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs for handling
large transmit buffers") converted the virtio vsock transmit path to
utilise nonlinear SKBs when handling large buffers. As part of this
change, virtio_transport_fill_skb() was updated to call
skb_copy_datagram_from_iter() instead of memcpy_from_msg() as the latter
expects a single destination buffer and cannot handle nonlinear SKBs
correctly.

Unfortunately, during this conversion, I overlooked the error case when
the copying function returns -EFAULT due to a fault on the input buffer
in userspace. In this case, memcpy_from_msg() reverts the iterator to
its initial state thanks to copy_from_iter_full() whereas
skb_copy_datagram_from_iter() leaves the iterator partially advanced.
This results in a WARN_ONCE() from the vsock code, which expects the
iterator to stay in sync with the number of bytes transmitted so that
virtio_transport_send_pkt_info() can return -EFAULT when it is called
again:

  ------------[ cut here ]------------
  'send_pkt()' returns 0, but 65536 expected
  WARNING: CPU: 0 PID: 5503 at net/vmw_vsock/virtio_transport_common.c:428 virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
  Modules linked in:
  CPU: 0 UID: 0 PID: 5503 Comm: syz.0.17 Not tainted 6.16.0-syzkaller-12063-g37816488247d #0 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014

Call virtio_transport_fill_skb_full() to restore the previous iterator
behaviour.

Cc: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Fixes: 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers")
Reported-by: syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://patch.msgid.link/20250818180355.29275-3-will@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[halves: adjust __zerocopy_sg_from_iter() parameters]
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -106,13 +106,15 @@ static int virtio_transport_fill_skb(str
 				     size_t len,
 				     bool zcopy)
 {
+	struct msghdr *msg = info->msg;
+
 	if (zcopy)
-		return __zerocopy_sg_from_iter(info->msg, NULL, skb,
-					       &info->msg->msg_iter,
+		return __zerocopy_sg_from_iter(msg, NULL, skb,
+					       &msg->msg_iter,
 					       len);
 
 	virtio_vsock_skb_put(skb, len);
-	return skb_copy_datagram_from_iter(skb, 0, &info->msg->msg_iter, len);
+	return skb_copy_datagram_from_iter_full(skb, 0, &msg->msg_iter, len);
 }
 
 static void virtio_transport_init_hdr(struct sk_buff *skb,


