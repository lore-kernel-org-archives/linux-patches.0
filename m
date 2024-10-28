Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7297518EFDC;
	Mon, 28 Oct 2024 06:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098238; cv=none; b=LkmWejzIhSq4vkAz8BKW30YVnibtvgktaEkSCAHmnoAIW79p2eOR5I46a69UJekgVuayiueZ2Lj6BP/xdkn7820T4lc8sQ5c9SRjrBhDyYEfRYsnxXrhaH2+8uqQzBbWrUafuGB8B6Aj1IPmxcQXGOmV0IFmbZz6BnXGKasNvOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098238; c=relaxed/simple;
	bh=cMISpjrbbCE1wxvAYyLVaIZSO4bOJYv+nWEXP0VCYLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg73YLKtzuUihGEss44e53aFC4v2XX5oOsZfHZgojSHpdakx8wkieqP2Y+1ImlwC9vUgIAdJV43ahSAkrO7C2iGxxntJWMhmY9S/q2kjGYhe3Mhb6aKJ4i21U/7n+cKoooQPX8SLt4omkvy2n2k0Jj3PbP4Hp5TrNpfm6Fj+T34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMwMFduK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMwMFduK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11714C4CEEB;
	Mon, 28 Oct 2024 06:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098238;
	bh=cMISpjrbbCE1wxvAYyLVaIZSO4bOJYv+nWEXP0VCYLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMwMFduKn1kUkYmJyFFeyPJLlbCuPMlKICJsjQdu3TCxvaBrpHJFINOLXoUbXj/y8
	 8z2Ce50gIZYOAcH5DLkAqz8jkr5jlvUGdACG8NEpmKmlPVnJuIXT2CVk32L6bnkwyH
	 yeT2Pl/Ow3J0a4nICjL+GdwikOpXQczgfM2qNXZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 103/261] vsock: Update rx_bytes on read_skb()
Date: Mon, 28 Oct 2024 07:24:05 +0100
Message-ID: <20241028062314.612708275@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

[ Upstream commit 3543152f2d330141d9394d28855cb90b860091d2 ]

Make sure virtio_transport_inc_rx_pkt() and virtio_transport_dec_rx_pkt()
calls are balanced (i.e. virtio_vsock_sock::rx_bytes doesn't lie) after
vsock_transport::read_skb().

While here, also inform the peer that we've freed up space and it has more
credit.

Failing to update rx_bytes after packet is dequeued leads to a warning on
SOCK_STREAM recv():

[  233.396654] rx_queue is empty, but rx_bytes is non-zero
[  233.396702] WARNING: CPU: 11 PID: 40601 at net/vmw_vsock/virtio_transport_common.c:589

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241013-vsock-fixes-for-redir-v2-2-d6577bbfe742@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3e..0f67cb0c64702 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1672,6 +1672,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	struct sock *sk = sk_vsock(vsk);
+	struct virtio_vsock_hdr *hdr;
 	struct sk_buff *skb;
 	int off = 0;
 	int err;
@@ -1681,10 +1682,16 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	 * works for types other than dgrams.
 	 */
 	skb = __skb_recv_datagram(sk, &vvs->rx_queue, MSG_DONTWAIT, &off, &err);
+	if (!skb) {
+		spin_unlock_bh(&vvs->rx_lock);
+		return err;
+	}
+
+	hdr = virtio_vsock_hdr(skb);
+	virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
 	spin_unlock_bh(&vvs->rx_lock);
 
-	if (!skb)
-		return err;
+	virtio_transport_send_credit_update(vsk);
 
 	return recv_actor(sk, skb);
 }
-- 
2.43.0



