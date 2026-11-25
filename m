Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624992;
	b=EDNMuAK6mWv0eX+bhFpcCego6+tL1fTIwYi4Q7yW4jzKrjLLyGkhM9b04I0fVqvAvMMv
	 nSbsylmkssziMFsMHlsqqtF8wXpgZrjgC3/bYHRD06OmU59wJ6c2DH9ha8+Tm1mc1tJ8P
	 2zjdRR/dVF/gRm2ASyMk0RdoGslrw51WC+rdtH/ftqLEbJI0T/4N/bYapgJmEl74TtOb4
	 NNGyvSaUkgnIra4IR8JRvVc3z3OFsIIDGBDN40OXc7F36C6Kibfq5Q0AdeuzJPonNWXTu
	 QxHNjI91uslApSOAU4w+PFXOAqZLyZJ9IkQAGTVyG5iAhyoffqKyIfoOkBykeo0d9Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CgHSwefmNvmlqu5wPGfnBzGtfzFXjbjH4gHLyj79GM4=;
	b=Y5wkwj/gjuoszIHvX4DCkbOX5iDRJcO8dWcc1MC200MokKb9gfxfp44RLqZI9dgII7PT
	 lBp5E/tsmwaAl9DqaMIZJ/FSi+4nKCPuHsglhf2Q0YQseNMeVPFMAd9wiTNHgn1J02HVI
	 j0rPoZ0v0MnaaH4nnnswMayxlaizqxP2gFNQD4viSt2RtJuDFhaMnCVX8CDtNmFjtx7ml
	 VUIlCygiMoqP+Ow9JVKzfKQBpuy0tjYAi/P2QKDycs7edAAczdRAHkk4eXNRaf4s3V0SM
	 hC4Lsyi9z5CSHsOBUiQrPhJw0UJhktvZqwhg+Y86dwv33LDcz1eZp+EaeJtxxNBkz+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM+WHk7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F25606A321;
	Wed, 25 Nov 2026 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM+WHk7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63401F000C6;
	Wed, 25 Nov 2026 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624992;
	bh=CgHSwefmNvmlqu5wPGfnBzGtfzFXjbjH4gHLyj79GM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hM+WHk7E71yPF4c2CfYTkVIRrKx0iwCRQHmsIlcn/Stcp+D1VSA1/Ocl+xCHUOxRl
	 0gvPbJGBhXPYJEvNm4zjWHakI6OOWvayObysAJcnKDWnKvMYs/pJlWr+uFHFnGsFCn
	 iBGDPpZsH4izJFZOqMPP1oS7y+1Zar7OEvRLIkLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/816] net: Segment CHECKSUM_UNNECESSARY GSO skbs other than fraglist
Date: Wed, 25 Nov 2026 15:31:14 +0100
Message-ID: <20261125143856.747322217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b0e328fc8adf6..bd1b0f10d9374 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3791,6 +3791,18 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	if (!skb_frags_readable(skb))
 		goto out_kfree_skb;
 
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



