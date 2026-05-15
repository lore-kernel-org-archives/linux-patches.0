Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDB53FF1DD;
	Fri, 15 May 2026 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860570; cv=none; b=fLNwvtioGkReGQwPvglWL7394jFozOGU4RkmtUO7dLxckOM0KX9EvXtUdaXfWiJQYgHDthhZiuIyotU16TFoiVWfMc5/c5bjx9ZMl4bkraQPncmkZMa/sYeSAYwG2+rHtKjkaxbfIk8RHdaxJ72SQFFYBjl/B8yOH+xP8kw/hnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860570; c=relaxed/simple;
	bh=P3ACb67MwP7Kaq63IkghA9vJ/2Z3q2qOQzBP60+Ybt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gfm/lR7NdTEcuoRGAINLUtqjD+7uEWx5Mrg1bm46Z6fXR0xao/7kWIfIFnnI4ixPUFEmGyW2KBNfAmMB4HAiQT5C3TZhs4XP1hNHred5BKdi3NMDbpj5wR3FwJmG+i1WaYGc1MhtIvQlZ5izW4TR5+nNjay0IUvmiYZ5M+EMSJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Elppxxvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Elppxxvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C316BC2BCB0;
	Fri, 15 May 2026 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860570;
	bh=P3ACb67MwP7Kaq63IkghA9vJ/2Z3q2qOQzBP60+Ybt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElppxxvtigMgF4llAuUu+/rwa91Vb39L+Na9vxq5T8rOPQ6CXM2v+SA+w3cRDODTR
	 +vTTwTpiO4H7Qm5s+ICZ+h+00NcOpCyXofsD0LyH3gB6xyh+y70ygjmDjNXoijFji5
	 v10vbYxPx42ioBhA+ZJkn6AskBpBCA6p2aYWwltw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 6.12 139/144] vsock/virtio: fix length and offset in tap skb for split packets
Date: Fri, 15 May 2026 17:49:25 +0200
Message-ID: <20260515154656.748129069@linuxfoundation.org>
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

commit 5f344d809e015fba3709e5219428c00b8ac5d7df upstream.

virtio_transport_build_skb() builds a new skb to be delivered to the
vsockmon tap device. To build the new skb, it uses the original skb
data length as payload length, but as the comment notes, the original
packet stored in the skb may have been split in multiple packets, so we
need to use the length in the header, which is correctly updated before
the packet is delivered to the tap, and the offset for the data.

This was also similar to what we did before commit 71dc9ec9ac7d
("virtio/vsock: replace virtio_vsock_pkt with sk_buff") where we probably
missed something during the skb conversion.

Also update the comment above, which was left stale by the skb
conversion and still mentioned a buffer pointer that no longer exists.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Link: https://patch.msgid.link/20260508164411.261440-2-sgarzare@redhat.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -170,12 +170,12 @@ static struct sk_buff *virtio_transport_
 	struct sk_buff *skb;
 	size_t payload_len;
 
-	/* A packet could be split to fit the RX buffer, so we can retrieve
-	 * the payload length from the header and the buffer pointer taking
-	 * care of the offset in the original packet.
+	/* A packet could be split to fit the RX buffer, so we use
+	 * the payload length from the header, which has been updated
+	 * by the sender to reflect the fragment size.
 	 */
 	pkt_hdr = virtio_vsock_hdr(pkt);
-	payload_len = pkt->len;
+	payload_len = le32_to_cpu(pkt_hdr->len);
 
 	skb = alloc_skb(sizeof(*hdr) + sizeof(*pkt_hdr) + payload_len,
 			GFP_ATOMIC);
@@ -223,7 +223,8 @@ static struct sk_buff *virtio_transport_
 
 			virtio_transport_copy_nonlinear_skb(pkt, data, payload_len);
 		} else {
-			skb_put_data(skb, pkt->data, payload_len);
+			skb_put_data(skb, pkt->data + VIRTIO_VSOCK_SKB_CB(pkt)->offset,
+				     payload_len);
 		}
 	}
 


