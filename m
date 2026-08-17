Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA59E41F34C;
	Mon, 17 Aug 2026 14:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977941; cv=none; b=V20Ueshm8yIba0K+ozzy0NXyzKGZAtvqSRxHHN5I97NphIE4nigEvpHbRpci59SnQOmaPk6YOtMTA/5ZDfXtrQZyfxzOTQBqgN2V6RcymzBZ+mDThi7Hp3RYrVuY5YcEzrDN1V1vpuZhQr3XZEGVqmiuVFPjSygWJHSlDxIwAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977941; c=relaxed/simple;
	bh=FcqiCgJx1DDPGH7lb5jLgqGJr3REMZwSMGSsxhcMDx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvQANb2AW+oduvt9rNIrBm+6W9AoRL4923iROEuGBks15fvbBwm2zULMUxHgob6mH3p9kiDWMauamwUnye1d4HgoiBH1j90gtUMXKfJSQnxJng3M3LJvlM5Z2BGUKLz+1WZl1n5gKyfsbb0aZqJOuFUJJe/Lvx29NGQJ5i5h0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HCtGvvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HCtGvvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ED91F00A3A;
	Mon, 17 Aug 2026 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977939;
	bh=68ZkY1z5RnLtKLbDiXlD++9dYKVbpD8OCshqUJEets4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HCtGvvCefyXFwFTwABDrQjJCWrysOJKR4zRHBpj9Jx7DDzGbQkQQ9hqqWhYdHKIT
	 Ctphr7/Oi+y99VteZZXOonpLn4pISNOHVEZDem2fugq9uHZQAaXvrWFTvuyd6mHuq6
	 U/ZYMgc18okUP5O1q8lDL0Kv2GF+F20OoRwFEn2Y=
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
Subject: [PATCH 6.12 047/181] bnxt_en: Move RSS table fill outside __bnxt_hwrm_vnic_set_rss()
Date: Mon, 17 Aug 2026 15:32:21 +0200
Message-ID: <20260817132537.247840175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Shravya KN <shravya.k-n@broadcom.com>

[ Upstream commit 1d0fc6c7ea49994b8ff50d02979d1e4207ec6c4f ]

This is a refactor patch with no change in behavior.  The caller
will now fill the RSS table before calling __bnxt_hwrm_vnic_set_rss().
In the next patch, we'll add code to determine the default ring for
the VNIC when we fill the RSS table.

Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260731190937.807270-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0b137529a899 ("bnxt_en: Refresh VNIC default ring on queue restart if needed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4970e20b2cb1b..ce7de01000160 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6367,6 +6367,9 @@ static void bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
 	u16 i, j;
 
+	if (!vnic->rss_table)
+		return;
+
 	/* Fill the RSS indirection table with ring group ids */
 	for (i = 0, j = 0; i < HW_HASH_INDEX_SIZE; i++) {
 		if (!no_rss)
@@ -6406,13 +6409,8 @@ static void
 __bnxt_hwrm_vnic_set_rss(struct bnxt *bp, struct hwrm_vnic_rss_cfg_input *req,
 			 struct bnxt_vnic_info *vnic)
 {
-	if (bp->flags & BNXT_FLAG_CHIP_P5_PLUS) {
-		bnxt_fill_hw_rss_tbl_p5(bp, vnic);
-		if (bp->flags & BNXT_FLAG_CHIP_P7)
-			req->flags |= VNIC_RSS_CFG_REQ_FLAGS_IPSEC_HASH_TYPE_CFG_SUPPORT;
-	} else {
-		bnxt_fill_hw_rss_tbl(bp, vnic);
-	}
+	if (bp->flags & BNXT_FLAG_CHIP_P7)
+		req->flags |= VNIC_RSS_CFG_REQ_FLAGS_IPSEC_HASH_TYPE_CFG_SUPPORT;
 
 	if (bp->rss_hash_delta) {
 		req->hash_type = cpu_to_le32(bp->rss_hash_delta);
@@ -6464,6 +6462,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp,
 	if (!set_rss)
 		return hwrm_req_send(bp, req);
 
+	bnxt_fill_hw_rss_tbl_p5(bp, vnic);
 	__bnxt_hwrm_vnic_set_rss(bp, req, vnic);
 	ring_tbl_map = vnic->rss_table_dma_addr;
 	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
@@ -10299,6 +10298,7 @@ static int __bnxt_setup_vnic(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 	}
 
 skip_rss_ctx:
+	bnxt_fill_hw_rss_tbl(bp, vnic);
 	/* configure default vnic, ring grp */
 	rc = bnxt_hwrm_vnic_cfg(bp, vnic);
 	if (rc) {
-- 
2.53.0



