Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CF051CF71;
	Wed, 30 Sep 2026 18:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793258; cv=none; b=pBCuZFYM1mig60gEEfTy/SI5YjaeSiMZioLLlLKpPTprDDtIvFOwmm3pxRPASoD+FZqTgIXELyrUdHVrLyTd0FPnW2YgfC5V5Th3w7HjdzUbrhgWsX3Ano7eUi+EEUApodHgCsSvMbzO+mOW2aUduuWUVuJsEXUaYPbA6dZWeww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793258; c=relaxed/simple;
	bh=SHqIAwn9n1sFynYQjMjfzZHWmkDMRdbFvPbpzfV6rM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdQRCs5P15GW5r15IssYRCn4TnGPSdw0d20BDAh4EiqNV0uQmRnFwtXv1BKID1dgvolA3CbxBV18GGw9P5paFBedQVpBY3ib9F6bpZlesERbodHH+58BJbjUnC/iNoJPywYEMf3PMZk+ndkgfi4DaBrVDBtX18dsP4AiOjQAGsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpWzkzst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpWzkzst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A706D1F000FF;
	Wed, 30 Sep 2026 18:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793257;
	bh=rjY9ovyDfwPzyVXU4cq6HvaTA2H+J4jEHn5NbrWztLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpWzkzst/yIUJMDd0ARZjbKBeWXIH1zzX+G0xxpRg14SkD//dogAYj/SOk8e3cyg/
	 0gOJbYFDWKM6hTdWPec1ONxJXAhQjhv6PdrhOWyMKXqG4prHxzsMLz04Pk96a+LH0y
	 yDQTio2pQyCpo4wBfg+SqAQ9L4GY6lJGK6Q6uASc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/395] gve: DQO: reject TSO packets with an out of range MSS
Date: Wed, 30 Sep 2026 17:27:33 +0200
Message-ID: <20260930152344.793712582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ba100f42fad93..b5565d0b197f0 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -582,6 +582,20 @@ static int gve_prep_tso(struct sk_buff *skb)
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
@@ -969,7 +983,17 @@ netdev_features_t gve_features_check_dqo(struct sk_buff *skb,
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



