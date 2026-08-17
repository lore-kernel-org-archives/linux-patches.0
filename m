Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AD43F12EF;
	Mon, 17 Aug 2026 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974876; cv=none; b=jQ2eoKkBcGFS/4HP+G+jLAIUrPK16yXYY3+Gv4B7TBCaKivtAV/Psa4UA+XAi9dkxtH4EyIV7NWDeFEC6iaqYkB8XGwyKEeTh1F5Nm8eEaXWceBqxuDMS8AHsfzRAzWUpKFValDP7HxZ+acImmW3dxGsZqfmvnK3J34ObVoCCeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974876; c=relaxed/simple;
	bh=MV/db82NB9uAWbLnnx16KHs1cxUM1DT7A2OJaG1WGxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyiYHPmZlcNqX6tGui489I9eYpe+ngddxxCSgTROnJsQeLxQX0oX44HhWZhwDqPYZG0sX8vqYBanIcLLTURlgoFNgMn+5FGM1oelnqyVU/BWErNN6WlPSxIn5BJbGbEvZeHLdQF2hcnFWWLBLd+yEfX9eh2Ahmt3rsIZOJNv6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohUh7O1s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohUh7O1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9411F000E9;
	Mon, 17 Aug 2026 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974873;
	bh=9GFUgRWpw3XTrWxHpPoWh2VPQcRsJUictmpJjB2WMLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohUh7O1sR7TngSFCRSLCfNFwKr3UnmlB86cosiaAwRchn+RPmB7teSQXTIkVHj+xF
	 XP7wcy4lo9ohF1J/08fMN80UUTjyBEAcQRkFkyFU8gYYOoOIySq1e0n04kCL1w8dHB
	 i8SYP2O1kIRoSUQlp3sgG93QiK0TZIKM3/SygWrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/250] bnxt_en: Determine and store default RX ring in vnic structure
Date: Mon, 17 Aug 2026 15:30:46 +0200
Message-ID: <20260817132539.932309708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Shravya KN <shravya.k-n@broadcom.com>

[ Upstream commit 53f01cd594e223aabb538d5288e60111523c96f2 ]

Each VNIC has a default RX ring.  The purpose of the default RX ring
is to provide a destination for any packets that cannot be parsed by
the RSS logic.  Up until now, the default RX ring is always Ring 0.

We neglected to take care of this default RX ring when adding the
queue restart feature.  If ring 0 (default ring) is re-started, it
may now have a new FW ring ID after freeing the old one and
allocating a new one.  The VNIC now may have a stale default ring
and it may generate an internal exception.  This exception may
appear in dmesg:

FW reported unknown error type 10

The best way to resolve this issue is to use a more appropriate
ring for the default ring instead of always ring 0.  Ring 0 may not
even be in the RSS table, especially on a new RSS context.

This patch adds the logic to determine and store the proper default
RX ring for a VNIC.  For an RSS VNIC, the default ring is the lowest
ring number in the RSS table.  The next patch will add proper logic
to update the VNIC if the default ring changes after queue restart.

Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260731190937.807270-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0b137529a899 ("bnxt_en: Refresh VNIC default ring on queue restart if needed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 33 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fba5b7f27ce7b..df5fd228d84ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6593,25 +6593,36 @@ int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
 static void bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 {
 	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
-	u16 i, j;
+	u16 i, j, min_j = bp->rx_nr_rings - 1;
 
 	if (!vnic->rss_table)
-		return;
+		goto skip_rss_tbl;
 
 	/* Fill the RSS indirection table with ring group ids */
 	for (i = 0, j = 0; i < HW_HASH_INDEX_SIZE; i++) {
 		if (!no_rss)
 			j = bp->rss_indir_tbl[i];
+		min_j = min(j, min_j);
 		vnic->rss_table[i] = cpu_to_le16(vnic->fw_grp_ids[j]);
 	}
+
+skip_rss_tbl:
+	if (vnic->rss_table && !no_rss)
+		vnic->default_rx_ring = min_j;
+	else if (vnic->flags & BNXT_VNIC_RFS_FLAG)
+		vnic->default_rx_ring = vnic->vnic_id - 1;
+	else if ((vnic->vnic_id == 1) && BNXT_CHIP_TYPE_NITRO_A0(bp))
+		vnic->default_rx_ring = bp->rx_nr_rings - 1;
+	else
+		vnic->default_rx_ring = 0;
 }
 
 static void bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
 				    struct bnxt_vnic_info *vnic)
 {
+	u16 tbl_size, i, min_j = bp->rx_nr_rings - 1;
 	__le16 *ring_tbl = vnic->rss_table;
 	struct bnxt_rx_ring_info *rxr;
-	u16 tbl_size, i;
 
 	tbl_size = bnxt_get_rxfh_indir_size(bp->dev);
 
@@ -6624,6 +6635,7 @@ static void bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
 			j = ethtool_rxfh_context_indir(vnic->rss_ctx)[i];
 		else
 			j = bp->rss_indir_tbl[i];
+		min_j = min(j, min_j);
 		rxr = &bp->rx_ring[j];
 
 		ring_id = rxr->rx_ring_struct.fw_ring_id;
@@ -6631,6 +6643,7 @@ static void bnxt_fill_hw_rss_tbl_p5(struct bnxt *bp,
 		ring_id = bnxt_cp_ring_for_rx(bp, rxr);
 		*ring_tbl++ = cpu_to_le16(ring_id);
 	}
+	vnic->default_rx_ring = min_j;
 }
 
 static void
@@ -6827,8 +6840,9 @@ int bnxt_hwrm_vnic_cfg(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 		return rc;
 
 	if (bp->flags & BNXT_FLAG_CHIP_P5_PLUS) {
-		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[0];
+		struct bnxt_rx_ring_info *rxr;
 
+		rxr = &bp->rx_ring[vnic->default_rx_ring];
 		req->default_rx_ring_id =
 			cpu_to_le16(rxr->rx_ring_struct.fw_ring_id);
 		req->default_cmpl_ring_id =
@@ -6861,13 +6875,7 @@ int bnxt_hwrm_vnic_cfg(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 		req->cos_rule = cpu_to_le16(0xffff);
 	}
 
-	if (vnic->flags & BNXT_VNIC_RSS_FLAG)
-		ring = 0;
-	else if (vnic->flags & BNXT_VNIC_RFS_FLAG)
-		ring = vnic->vnic_id - 1;
-	else if ((vnic->vnic_id == 1) && BNXT_CHIP_TYPE_NITRO_A0(bp))
-		ring = bp->rx_nr_rings - 1;
-
+	ring = vnic->default_rx_ring;
 	grp_idx = bp->rx_ring[ring].bnapi->index;
 	req->dflt_ring_grp = cpu_to_le16(bp->grp_info[grp_idx].fw_grp_id);
 	req->lb_rule = cpu_to_le16(0xffff);
@@ -11027,6 +11035,9 @@ static int bnxt_setup_nitroa0_vnic(struct bnxt *bp)
 		return rc;
 	}
 
+	/* Setup the proper default RX ring */
+	bnxt_fill_hw_rss_tbl(bp, vnic);
+
 	rc = bnxt_hwrm_vnic_cfg(bp, vnic);
 	if (rc) {
 		netdev_err(bp->dev, "Cannot allocate special vnic for NS2 A0: %x\n",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 3ca989da0eb02..9d9ad2be3239b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1318,6 +1318,7 @@ struct bnxt_vnic_info {
 #define BNXT_VNIC_RSSCTX_FLAG		0x40
 	struct ethtool_rxfh_context *rss_ctx;
 	u32		vnic_id;
+	u16		default_rx_ring;
 };
 
 struct bnxt_rss_ctx {
-- 
2.53.0



