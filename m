Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F7318E368;
	Mon, 28 Oct 2024 06:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097643; cv=none; b=BWwNEAj167tkdmIaa2tvtAvRqqG9DrXSMimdQg+a4wYLVWDKJr+GN8B5a37XjRIfsFOQXx9z/5LKKG9gwG8CJqM5f3VSvNwHaRdRmDCjELGz+Ke+8BREtcCnAXjsgnZKoFg5l/lnXnNDKs5RtcMe7lETY4YEA27paaOOYB7Zy4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097643; c=relaxed/simple;
	bh=5It9kH4ifKb4X1yp4IccPctnDjTvoRSwK2zgsieDgEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKfhELUNkojbs+Zy2e6YtNb3rnSGbjbpW7VMHb6wWTJzS+B5ZLaNNYB7YfNTG47N/G1n9dUapPCrbPAeWEk0k9xERmpsEgcaTYZi/KieF38k03qvteORveW0qssxwykgCoH769XjiqFQlvvgEgKuMkvoI2Q07dAtVZpwjCXYVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNXVjNEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNXVjNEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58758C4CEC3;
	Mon, 28 Oct 2024 06:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097642;
	bh=5It9kH4ifKb4X1yp4IccPctnDjTvoRSwK2zgsieDgEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNXVjNEh2CDbm9XX0F3DSqO9dkfC7JgdtU8dtNJbKhDx6u0gHl36l99Y2mhYJOOkF
	 JspkoSZiKIXjPmZ2wTT20lMZd+eLep4EWPy2OpJ+/PGk9Oh5ipNQb6Lta1TdgE2FK8
	 /Wi+JN+RrHQzH+Cj0uSh6QtidWbXW2NwjVG6PCeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/208] vsock: Update rx_bytes on read_skb()
Date: Mon, 28 Oct 2024 07:24:23 +0100
Message-ID: <20241028062308.692651433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e87fd9480acda..072878012b51e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1508,6 +1508,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	struct sock *sk = sk_vsock(vsk);
+	struct virtio_vsock_hdr *hdr;
 	struct sk_buff *skb;
 	int off = 0;
 	int err;
@@ -1517,10 +1518,16 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
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



