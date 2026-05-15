Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0368C3FF1D8;
	Fri, 15 May 2026 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860573; cv=none; b=PDonjLTm13OcZCon/ZrRu5HjeIIiu/uWNJDNqNuNrb3Dr5YGun2De4a9975BmxE0CYTotIdE36IzD2jK2b/gS9ajz1lUJNVyhTRdNeM+GJbxuu45bsS7JnG/NI99E3jJZAsSMJs1NiGgsAyTOUxXaKGfQG759XB3KZAFv3/p0Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860573; c=relaxed/simple;
	bh=037JBb0AIpZsIR84vnMOybji4OlCfKCFqvhOqQNpca0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMjoQEd1xQRZl0Weqsel7Lcb8TxD6fMLtWD+pha0KGtD/Ommt48r2GCYJmUAT+BGeEc4OJk71OcmTb71ko18K4Tylkz6xhvpK+uzV3ls5l6hjw1cyl6yA1FMPD4hpAIfs5Pjz/w13DdBJTTIM04+PNmO0hjTg6K9BxJCJ5Vj78w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWgc/0qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWgc/0qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51125C2BCB3;
	Fri, 15 May 2026 15:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860572;
	bh=037JBb0AIpZsIR84vnMOybji4OlCfKCFqvhOqQNpca0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWgc/0qQ3pqQiP5OqWQ+em88qkU3GP/PCrriSpCZoz4Jr0AhFR/oIAPnei1zqmt+7
	 afGpq7uCvg/Ga39dON/xEJH6wY3zcaI07yYB5aXTh1db+WhdP/SFddocZ7RhRPVQYK
	 gGbaNwSYAC07jRIdzt+/vXizDVswsn6epLAfMrNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 6.12 140/144] vsock/virtio: fix empty payload in tap skb for non-linear buffers
Date: Fri, 15 May 2026 17:49:26 +0200
Message-ID: <20260515154656.771522592@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

commit 3a3e3d90cbc79600544536723911657730759af3 upstream.

For non-linear skbs, virtio_transport_build_skb() goes through
virtio_transport_copy_nonlinear_skb() to copy the original payload
in the new skb to be delivered to the vsockmon tap device.
This manually initializes an iov_iter but does not set iov_iter.count.
Since the iov_iter is zero-initialized, the copy length is zero and no
payload is actually copied to the monitor interface, leaving data
un-initialized.

Fix this by removing the linear vs non-linear split and using
skb_copy_datagram_iter() with iov_iter_kvec() for all cases, as
vhost-vsock already does. This handles both linear and non-linear skbs,
properly initializes the iov_iter, and removes the now unused
virtio_transport_copy_nonlinear_skb().

While touching this code, let's also check the return value of
skb_copy_datagram_iter(), even though it's unlikely to fail.

Fixes: 4b0bf10eb077 ("vsock/virtio: non-linear skb handling for tap")
Reported-by: Yiqi Sun <sunyiqixm@gmail.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Link: https://patch.msgid.link/20260508164411.261440-3-sgarzare@redhat.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |   40 +++++++++-----------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -140,27 +140,6 @@ static void virtio_transport_init_hdr(st
 	hdr->fwd_cnt	= cpu_to_le32(0);
 }
 
-static void virtio_transport_copy_nonlinear_skb(const struct sk_buff *skb,
-						void *dst,
-						size_t len)
-{
-	struct iov_iter iov_iter = { 0 };
-	struct kvec kvec;
-	size_t to_copy;
-
-	kvec.iov_base = dst;
-	kvec.iov_len = len;
-
-	iov_iter.iter_type = ITER_KVEC;
-	iov_iter.kvec = &kvec;
-	iov_iter.nr_segs = 1;
-
-	to_copy = min_t(size_t, len, skb->len);
-
-	skb_copy_datagram_iter(skb, VIRTIO_VSOCK_SKB_CB(skb)->offset,
-			       &iov_iter, to_copy);
-}
-
 /* Packet capture */
 static struct sk_buff *virtio_transport_build_skb(void *opaque)
 {
@@ -218,13 +197,18 @@ static struct sk_buff *virtio_transport_
 	skb_put_data(skb, pkt_hdr, sizeof(*pkt_hdr));
 
 	if (payload_len) {
-		if (skb_is_nonlinear(pkt)) {
-			void *data = skb_put(skb, payload_len);
-
-			virtio_transport_copy_nonlinear_skb(pkt, data, payload_len);
-		} else {
-			skb_put_data(skb, pkt->data + VIRTIO_VSOCK_SKB_CB(pkt)->offset,
-				     payload_len);
+		struct iov_iter iov_iter;
+		struct kvec kvec;
+		void *data = skb_put(skb, payload_len);
+
+		kvec.iov_base = data;
+		kvec.iov_len = payload_len;
+		iov_iter_kvec(&iov_iter, ITER_DEST, &kvec, 1, payload_len);
+
+		if (skb_copy_datagram_iter(pkt, VIRTIO_VSOCK_SKB_CB(pkt)->offset,
+					   &iov_iter, payload_len)) {
+			kfree_skb(skb);
+			return NULL;
 		}
 	}
 


