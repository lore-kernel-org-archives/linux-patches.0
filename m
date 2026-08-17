Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A6A43B3F4;
	Mon, 17 Aug 2026 13:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974113; cv=none; b=rAkOdFDBcbG/S3JvIAAJlRinUlJkHfLSuiTLS9FEgfofkOIDP4v+TbA394CsaxWftYq+GljnhmFeuJcuRMiYzk3rZjNT6dyxWSb0knkC8EfZkNfIiQUk9RwPpknT9qwouRkawjNUWiEWfTOS8zldqv7WDDfTGOqK5pA+c4Hu2to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974113; c=relaxed/simple;
	bh=pn3++31WUl8uOhhfgz7D5PUFOtBw4aAjxhO6trfF/Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inN/cwf11b806sIkbzweMaheHJxNx4QgmwfD+/o6yKLriAmEUDJE1aNWCzkGOwD1Z2g8VbnoyrhQYP0ibVrob05/BIo2Y0EnDXgnOYZwNiA5gcjdyBVnOi4gmIsSkZoHhgmkhkyahoLRr9CsiIN0bCBf45pFgOzvhV19rWUAUGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ve5kGPVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ve5kGPVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DC71F000E9;
	Mon, 17 Aug 2026 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974109;
	bh=9TbYF//qLfC1g+4wq8zvd85PEfPb1A8d8ExUNlcEozg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ve5kGPVDcFUUmqEk6Dr01oENrN0cXWEx3//TjtoQjF91800nD7JVMK+j8XjiOESe2
	 a+4BEjGPY5vkro5uiY4oFDtY8/wRm4XamcRQjZTwiYF66MQbkpJX9BCd6sLjDCwi1s
	 ej61iGRS8kRSsBShKJJCnnoJR2z24K2GJNZLRc1k=
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
Subject: [PATCH 7.1 093/271] bnxt_en: Move RSS table fill outside __bnxt_hwrm_vnic_set_rss()
Date: Mon, 17 Aug 2026 15:30:18 +0200
Message-ID: <20260817132540.601502210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cb6e45fc9cd98..2fbc98fa14f62 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6706,6 +6706,9 @@ static void bnxt_fill_hw_rss_tbl(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 	bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
 	u16 i, j;
 
+	if (!vnic->rss_table)
+		return;
+
 	/* Fill the RSS indirection table with ring group ids */
 	for (i = 0, j = 0; i < HW_HASH_INDEX_SIZE; i++) {
 		if (!no_rss)
@@ -6745,13 +6748,8 @@ static void
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
@@ -6803,6 +6801,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp,
 	if (!set_rss)
 		return hwrm_req_send(bp, req);
 
+	bnxt_fill_hw_rss_tbl_p5(bp, vnic);
 	__bnxt_hwrm_vnic_set_rss(bp, req, vnic);
 	ring_tbl_map = vnic->rss_table_dma_addr;
 	nr_ctxs = bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings);
@@ -10866,6 +10865,7 @@ static int __bnxt_setup_vnic(struct bnxt *bp, struct bnxt_vnic_info *vnic)
 	}
 
 skip_rss_ctx:
+	bnxt_fill_hw_rss_tbl(bp, vnic);
 	/* configure default vnic, ring grp */
 	rc = bnxt_hwrm_vnic_cfg(bp, vnic);
 	if (rc) {
-- 
2.53.0



