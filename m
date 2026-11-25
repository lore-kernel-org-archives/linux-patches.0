Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622121;
	b=jTO4QDiQfRczRxlaU7TOv6SRjmP4UVzK/Dh1rxt9P79CdfB9P3r/4W3MR2vIVbb5pU8E
	 lDd9dmFvNE7yHp9iVSL/L2gWDdUT/bEwQ7ePA3wux2cjugV0p6JCWisW9BFjlKgk8VsxB
	 bQ63JOFhmhyyFPsqi3Adj8fjBSYdwUVz40hcM9pBFB/g9Nx7FKo+sffr2+/5dEu51kBqT
	 zlk5BFWc+MLcSpTHyCdCRlfs+nOzlqNm0VNJmagDITDrUU8Jdcl70X3BeZeNNvDQQ6t7s
	 yDHnpAKhlD3zPRhpK7B7swagmoeZdVzijw7u9JSYYTgHM/be6kNSHLp+gPUxtdWQCvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9pnzx2zYswCj5jNb+6hgyAUn0JqYBdTrXAZthsQeEU0=;
	b=lKeNyGBys682nJdywslxEjI1zg06FCY0lJaCpVopKRYMfxWLb53v8ucm6xHIGOphHNfy
	 rt7t10UzrS5gs1+JxudWEbOOd+GwB+04NVmEmTWtRlWec7a6WCvv5RLVkf/7zb58PZxSq
	 VwDm3LNYN9Gb1uw/cx/5j6Pvop48VwSe8LGd/HOthH7mvRAXy5DzMJ0hboIjOQQdtpc+9
	 UeMqXMMXqN4oDTD/y3ODur+qzloGhQkXnio4Oci32nFBQ4IVRyTB6b7V5aC2GlZoLfdI5
	 JTW1z+vssx3mylM4ssuWaUem874bZvAkNGIYd6Q+J7m/dxFqYkUejjR7+Y0+Nc5OzpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVaHnhMl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19D606A321;
	Wed, 25 Nov 2026 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVaHnhMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4FE1F000C4;
	Wed, 25 Nov 2026 15:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622121;
	bh=9pnzx2zYswCj5jNb+6hgyAUn0JqYBdTrXAZthsQeEU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVaHnhMlYiqG9l/sTNGzN6rUszrjUdVngYQAdpkY+lV485CLzvqMm2+nT1boLBM0b
	 OKi1aAN9xRrTsENMwQrMb3RaGN2PBtAJEx9raouysrpGQblbdFijtHAevVYQMnXTnq
	 ugZTXoYQ3m4DZtAIvsH5c7M/hL9802buVcK1wfMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 429/990] net: Segment CHECKSUM_UNNECESSARY GSO skbs other than fraglist
Date: Wed, 25 Nov 2026 15:29:56 +0100
Message-ID: <20261125143832.143795875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit fdca4b030c78fa2773a94fda3a6dc3ce5558a727 ]

The netif_needs_gso function lets a GSO skb reach the device unsegmented
when it is CHECKSUM_PARTIAL or CHECKSUM_UNNECESSARY. The second case was
added for FCoE, whose transmit path marked CRC offload that way at the
time. Commit 253aab0597d9 ("fcoe: Use CHECKSUM_PARTIAL to indicate CRC
offload") moved FCoE back to CHECKSUM_PARTIAL but left the exemption in
place, with nothing left that needed it. Fraglist GSO, added later, is
its only user today, as its segments already carry valid checksums.

A TCP GSO skb can still arrive as CHECKSUM_UNNECESSARY without being
fraglist. Hardware LRO builds its aggregates that way, for example mlx5
sets SKB_GSO_TCPV4 or SKB_GSO_TCPV6 and CHECKSUM_UNNECESSARY, without
SKB_GSO_DODGY. IP forwarding and bridging turn LRO off, but a tc mirred
redirect does not, so such an skb can be sent out another device. It
has no csum_start and its TCP checksum field is whatever the aggregate
left there. Drivers that only set up TSO for CHECKSUM_PARTIAL, such as
fbnic, i40e and ice, then send the whole skb as one oversized frame
with a bad checksum.

Have the validate_xmit_skb function mark any CHECKSUM_UNNECESSARY GSO
skb other than fraglist as CHECKSUM_NONE, which means the same on
transmit but is not exempt in the netif_needs_gso function. The
__skb_gso_segment function then unshares the header and the TCP GSO
code sets the skb up as CHECKSUM_PARTIAL, so a device with TSO segments
it in hardware. Without TSO, and for UDP, it is segmented in software.
The callers of the netif_needs_gso function that decide on segmentation
for themselves, such as tap, are left as they are.

Found by code inspection. In QEMU with an emulated fbnic, TCPv4 and
TCPv6 GSO skbs built this way each went out as a single 11 KB frame
with a bad TCP checksum. With this change they are segmented into
MSS-sized frames with valid checksums.

Fixes: 253aab0597d9 ("fcoe: Use CHECKSUM_PARTIAL to indicate CRC offload")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/179372577673.49909.11253315483074546903.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index e4216b78a1a49..91da33c29aa18 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4045,6 +4045,18 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	if (unlikely(!skb))
 		goto out_null;
 
+	/* Only fraglist GSO, whose segments already carry valid checksums,
+	 * can be handed to a device as CHECKSUM_UNNECESSARY. Any other GSO
+	 * skb has no csum_start for the device to segment from. NONE means
+	 * the same on transmit, but makes netif_needs_gso() send it to the
+	 * GSO code, which turns TCP into CHECKSUM_PARTIAL for TSO and
+	 * segments anything the device cannot offload in software.
+	 */
+	if (unlikely(skb->ip_summed == CHECKSUM_UNNECESSARY &&
+		     skb_is_gso(skb) &&
+		     !(skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)))
+		skb->ip_summed = CHECKSUM_NONE;
+
 	features = netif_skb_features(skb);
 	skb = validate_xmit_vlan(skb, features);
 	if (unlikely(!skb))
-- 
2.53.0



