Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C501A76C6;
	Wed, 20 Nov 2024 12:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107494; cv=none; b=WlJjA5PFZ2pVF4SeY9i+ulfgQZ0aYSaxXtVwSh4k2qxylH/XomeAI0rTJSvEiXZM7mHs1xUM57I4IhAe6d1cuGjxXXnnYcMRwLiO5DwTJc1m91kxUFm279PmUrZMK1e4kJpfV5OE5Q4W46uUEosjTQ8nDaO+aM6BAOVFYuMog/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107494; c=relaxed/simple;
	bh=7SvS5dmHBeLL6IDRQlylaQgsaiLTuYHBvcYL3rnWg50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNOgE5hr2lwIJtRY9PempZUgr/CuKibGaF/dT366aNRnh7IU5X4HaL1TsbIdYVdZxl5scgUoamMPP5/jvNnRdbHdHwDQYbSe8ce1sOs9m9ejHk7GuS6v3cefV3cY2w7bFpj5zViCUBcKEXjJ+KyySh3GT0WlGMRw8om/oZMlCbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzRCtVpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzRCtVpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C0FC4CED2;
	Wed, 20 Nov 2024 12:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107493;
	bh=7SvS5dmHBeLL6IDRQlylaQgsaiLTuYHBvcYL3rnWg50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzRCtVprFwFrLze81VUX3rnfuQpGjJRl+iskfXFrXY46+FgXt/sBkYS6cjDiCvWA+
	 qMnIiGgy24HgiBOqJyG7RorvsbXafhnzcBrA2oLBPyvo1yumWdd+wxYctwgtjffwZH
	 LjuYJrSZm503GI0iUfXa9ip5tVJ7lC863V56cXzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 016/107] vsock: Fix sk_error_queue memory leak
Date: Wed, 20 Nov 2024 13:55:51 +0100
Message-ID: <20241120125630.045209269@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit fbf7085b3ad1c7cc0677834c90f985f1b4f77a33 ]

Kernel queues MSG_ZEROCOPY completion notifications on the error queue.
Where they remain, until explicitly recv()ed. To prevent memory leaks,
clean up the queue when the socket is destroyed.

unreferenced object 0xffff8881028beb00 (size 224):
  comm "vsock_test", pid 1218, jiffies 4294694897
  hex dump (first 32 bytes):
    90 b0 21 17 81 88 ff ff 90 b0 21 17 81 88 ff ff  ..!.......!.....
    00 00 00 00 00 00 00 00 00 b0 21 17 81 88 ff ff  ..........!.....
  backtrace (crc 6c7031ca):
    [<ffffffff81418ef7>] kmem_cache_alloc_node_noprof+0x2f7/0x370
    [<ffffffff81d35882>] __alloc_skb+0x132/0x180
    [<ffffffff81d2d32b>] sock_omalloc+0x4b/0x80
    [<ffffffff81d3a8ae>] msg_zerocopy_realloc+0x9e/0x240
    [<ffffffff81fe5cb2>] virtio_transport_send_pkt_info+0x412/0x4c0
    [<ffffffff81fe6183>] virtio_transport_stream_enqueue+0x43/0x50
    [<ffffffff81fe0813>] vsock_connectible_sendmsg+0x373/0x450
    [<ffffffff81d233d5>] ____sys_sendmsg+0x365/0x3a0
    [<ffffffff81d246f4>] ___sys_sendmsg+0x84/0xd0
    [<ffffffff81d26f47>] __sys_sendmsg+0x47/0x80
    [<ffffffff820d3df3>] do_syscall_64+0x93/0x180
    [<ffffffff8220012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 0ff9b2dd86bac..a0202d9b47921 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -835,6 +835,9 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
+	/* Flush MSG_ZEROCOPY leftovers. */
+	__skb_queue_purge(&sk->sk_error_queue);
+
 	vsock_deassign_transport(vsk);
 
 	/* When clearing these addresses, there's no need to set the family and
-- 
2.43.0



