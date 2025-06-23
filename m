Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1982222B2;
	Mon, 23 Jun 2025 22:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717380; cv=none; b=YQ2hzjDOxyUzbNxhm46Rc4wi9j5pIwWxYya+onL975ZhuJ4xhEpOQA/e6dLW0/OPr1Ei8yP1XAAlqxIsVhgefl9ySI43OLRZtEeU4pvxH5egLhJsVvTGH9m7ImuU0iGwbgX9i1qFlKQYV2YqlbVp6mpkgqT7BTd1iyTY6TlG5UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717380; c=relaxed/simple;
	bh=8gMUq9zi2uGiMtTbjT3JEMPhYoTuMtCL3y543+mU4jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBNn6jnzB3VbbZ8xtQ95W7cGPGD4FD7+ezxI6mIGLq1otIRlcWYXToKfVJFOWajnc/qqjTl1Tj1J2LiBXLC3JApBunXXoZ/oQiATSjCqzmQpEpGWsc2ZaAS9whtl6V+YNgHa2Nogx1nXemsjrt7/Nhu4vHl+moX6Vm1Oi0qEB7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwwgPzC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwwgPzC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D66C4CEEA;
	Mon, 23 Jun 2025 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717380;
	bh=8gMUq9zi2uGiMtTbjT3JEMPhYoTuMtCL3y543+mU4jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwwgPzC59K7FV//1prz9KB2DJkNKrW2HtyiAIUclMTBtb+hLeB7k3WZS9/0lApYG+
	 xy9yqra/DLnSnKdJsx56oQKQnGh4AHKOcAz5Zr97/YGiGkETyDgpc0OkWrO2WtDAZo
	 Cd58P6VXjVhRhZ55/wBGTFyyaHpaWhwKGIe44aOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 376/414] bnxt_en: Update MRU and RSS table of RSS contexts on queue reset
Date: Mon, 23 Jun 2025 15:08:33 +0200
Message-ID: <20250623130651.352810649@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 5dacc94c6fe61cde6f700e95cf35af9944b022c4 ]

The commit under the Fixes tag below which updates the VNICs' RSS
and MRU during .ndo_queue_start(), needs to be extended to cover any
non-default RSS contexts which have their own VNICs.  Without this
step, packets that are destined to a non-default RSS context may be
dropped after .ndo_queue_start().

We further optimize this scheme by updating the VNIC only if the
RX ring being restarted is in the RSS table of the VNIC.  Updating
the VNIC (in particular setting the MRU to 0) will momentarily stop
all traffic to all rings in the RSS table.  Any VNIC that has the
RX ring excluded from the RSS table can skip this step and avoid the
traffic disruption.

Note that this scheme is just an improvement.  A VNIC with multiple
rings in the RSS table will still see traffic disruptions to all rings
in the RSS table when one of the rings is being restarted.  We are
working on a FW scheme that will improve upon this further.

Fixes: 5ac066b7b062 ("bnxt_en: Fix queue start to update vnic RSS table")
Reported-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250613231841.377988-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 56 +++++++++++++++++++++--
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e3dfce365ba40..154f73f121eca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10390,11 +10390,39 @@ void bnxt_del_one_rss_ctx(struct bnxt *bp, struct bnxt_rss_ctx *rss_ctx,
 	bp->num_rss_ctx--;
 }
 
+static bool bnxt_vnic_has_rx_ring(struct bnxt *bp, struct bnxt_vnic_info *vnic,
+				  int rxr_id)
+{
+	u16 tbl_size = bnxt_get_rxfh_indir_size(bp->dev);
+	int i, vnic_rx;
+
+	/* Ntuple VNIC always has all the rx rings. Any change of ring id
+	 * must be updated because a future filter may use it.
+	 */
+	if (vnic->flags & BNXT_VNIC_NTUPLE_FLAG)
+		return true;
+
+	for (i = 0; i < tbl_size; i++) {
+		if (vnic->flags & BNXT_VNIC_RSSCTX_FLAG)
+			vnic_rx = ethtool_rxfh_context_indir(vnic->rss_ctx)[i];
+		else
+			vnic_rx = bp->rss_indir_tbl[i];
+
+		if (rxr_id == vnic_rx)
+			return true;
+	}
+
+	return false;
+}
+
 static int bnxt_set_vnic_mru_p5(struct bnxt *bp, struct bnxt_vnic_info *vnic,
-				u16 mru)
+				u16 mru, int rxr_id)
 {
 	int rc;
 
+	if (!bnxt_vnic_has_rx_ring(bp, vnic, rxr_id))
+		return 0;
+
 	if (mru) {
 		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
 		if (rc) {
@@ -10410,6 +10438,24 @@ static int bnxt_set_vnic_mru_p5(struct bnxt *bp, struct bnxt_vnic_info *vnic,
 	return 0;
 }
 
+static int bnxt_set_rss_ctx_vnic_mru(struct bnxt *bp, u16 mru, int rxr_id)
+{
+	struct ethtool_rxfh_context *ctx;
+	unsigned long context;
+	int rc;
+
+	xa_for_each(&bp->dev->ethtool->rss_ctx, context, ctx) {
+		struct bnxt_rss_ctx *rss_ctx = ethtool_rxfh_context_priv(ctx);
+		struct bnxt_vnic_info *vnic = &rss_ctx->vnic;
+
+		rc = bnxt_set_vnic_mru_p5(bp, vnic, mru, rxr_id);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static void bnxt_hwrm_realloc_rss_ctx_vnic(struct bnxt *bp)
 {
 	bool set_tpa = !!(bp->flags & BNXT_FLAG_TPA);
@@ -15381,12 +15427,11 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 
-		rc = bnxt_set_vnic_mru_p5(bp, vnic, mru);
+		rc = bnxt_set_vnic_mru_p5(bp, vnic, mru, idx);
 		if (rc)
 			return rc;
 	}
-
-	return 0;
+	return bnxt_set_rss_ctx_vnic_mru(bp, mru, idx);
 
 err_free_hwrm_rx_ring:
 	bnxt_hwrm_rx_ring_free(bp, rxr, false);
@@ -15403,8 +15448,9 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 
-		bnxt_set_vnic_mru_p5(bp, vnic, 0);
+		bnxt_set_vnic_mru_p5(bp, vnic, 0, idx);
 	}
+	bnxt_set_rss_ctx_vnic_mru(bp, 0, idx);
 	/* Make sure NAPI sees that the VNIC is disabled */
 	synchronize_net();
 	rxr = &bp->rx_ring[idx];
-- 
2.39.5



