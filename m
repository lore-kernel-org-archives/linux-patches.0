Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4975F51614A;
	Wed, 30 Sep 2026 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787412; cv=none; b=ahhfL8QJeYmvz41s+gZK4sx0Zs8f6td/OOnm7h9GD0aAP2G+injkmFQTozIX6ULRtDtuoK5V953rbo/OznDCtn9fqJfLNwzPuc+1NJii5opl+KrIi1iPeVI0Qq71+MZ5R8EBSMxZe+I1xEN9VyTLdiSKvtzvcUfDXE7fyIr8K1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787412; c=relaxed/simple;
	bh=eddxNkJziZaiJFmQJL6pG7dsJ01wTeeytBkSbMEAgTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOsbawr/IyqPQsH0h6u/afsbReg4LvmsQE0NYYAe6lGGi9BDYKC70f1TjQoLyRUVdyWo/gUdvF8D+/q1yqkwfNLfUDO3U6i6Lj7SpfaIeuRX1I3tzZ3EawCiAd5tO98BQHwfFLyUSpBcTc/cFZo233hYiXgOC2eVraZy3KO5ADw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFQTnMMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFQTnMMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10461F000FF;
	Wed, 30 Sep 2026 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787411;
	bh=xuh5OENk2+e/vPmuEscRET4EbUHwWtRdegQLxIP3quA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFQTnMMA26g/CkpRe+Wz4Xn2uH5xA2k3mH+ujZMFlJEWaZ29OlguD4ftfO+0HrNmI
	 znNw/FvYj2dHx4nQIA0LM/FlElczHo/u3SboEXJaRO57D6BgBmx9DQ3b/u2IaT6Cq8
	 oMEjkxs/58hWq4NvYkWtxMwx/rvIb0fZ/HCHnt8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 221/457] gve: DQO: reject TSO packets with an out of range MSS
Date: Wed, 30 Sep 2026 17:25:26 +0200
Message-ID: <20260930152350.819645535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 296c83b5ccc808c080865eb20fd7a477b0355bb7 ]

gve_prep_tso() notes that the device requires the MSS to be <= 9728,
but does not enforce it, assuming the 9K MTU enforced by the hypervisor
and the 64KB limit on TSO sizes are enough.

This does not hold for packets that were not generated locally.
A guest behind a tap, or any packet socket user, can provide an
arbitrary gso_size in virtio_net_hdr. Layer 2 forwarding does not check
the MTU for GSO packets (is_skb_forwardable()), and gso_features_check()
only bounds skb->len and gso_segs, never gso_size.

Such a packet reaches gve_tx_fill_tso_ctx_desc(), which puts gso_size
into the mss field of the TSO context descriptor. This field is 14 bits
wide, so a gso_size of 16384 is silently turned into an MSS of zero.

Drop these packets from gve_prep_tso(), and make sure that
gve_features_check_dqo() leaves their GSO bits alone: skb_segment()
splits at gso_size regardless of the MTU, so falling back to software
segmentation would give the device non TSO packets bigger than the
9728 bytes it supports.

Note that the device can still be given oversized non TSO packets when
the stack segments in software for other reasons, for instance after
TSO has been disabled with ethtool. This is a generic issue, because
the MTU check is skipped for GSO packets in the forwarding path, and
is addressed separately.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260924004252.1196328-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 26 ++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_desc_dqo.h b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
index f7786b03c7444..d2c86c8eeae2a 100644
--- a/drivers/net/ethernet/google/gve/gve_desc_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
@@ -14,6 +14,11 @@
 #define GVE_TX_MAX_HDR_SIZE_DQO 255
 #define GVE_TX_MIN_TSO_MSS_DQO 88
 
+/* HW limit. This also has to fit in the 14 bits of the mss field of
+ * struct gve_tx_tso_context_desc_dqo.
+ */
+#define GVE_TX_MAX_TSO_MSS_DQO 9728
+
 #ifndef __LITTLE_ENDIAN_BITFIELD
 #error "Only little endian supported"
 #endif
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index e5fe17b047981..616c1921aebea 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -577,6 +577,20 @@ static int gve_prep_tso(struct sk_buff *skb)
 	int header_len;
 	int err;
 
+	/* Note: HW requires the total length of the TSO to be <= 262143,
+	 * this is enforced by netif_set_tso_max_size().
+	 *
+	 * MSS (gso_size) can not be trusted: packets forwarded from a tap or
+	 * injected by a packet socket can carry an arbitrary value, while the
+	 * mss field of the TSO context descriptor is only 14 bits wide.
+	 *
+	 * A too big MSS is dropped here instead of being rejected from
+	 * gve_features_check_dqo(), because software segmentation would
+	 * produce packets larger than the device can send.
+	 */
+	if (unlikely(shinfo->gso_size > GVE_TX_MAX_TSO_MSS_DQO))
+		return -1;
+
 	/* Needed because we will modify header. */
 	err = skb_cow_head(skb, 0);
 	if (err < 0)
@@ -964,7 +978,17 @@ netdev_features_t gve_features_check_dqo(struct sk_buff *skb,
 					 struct net_device *dev,
 					 netdev_features_t features)
 {
-	if (skb_is_gso(skb) && !gve_can_send_tso(skb))
+	if (!skb_is_gso(skb))
+		return features;
+
+	/* Keep the GSO bits for a too big MSS, so that gve_prep_tso() drops
+	 * the packet: software segmentation would give packets larger than
+	 * the device can send.
+	 */
+	if (skb_shinfo(skb)->gso_size > GVE_TX_MAX_TSO_MSS_DQO)
+		return features;
+
+	if (!gve_can_send_tso(skb))
 		return features & ~NETIF_F_GSO_MASK;
 
 	return features;
-- 
2.53.0



