Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A108427F749;
	Wed,  4 Feb 2026 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217029; cv=none; b=X/NoTiIAQ0laSr5UHyFB1TfxpBbqM9i7BpqykmW9CJeMCFnGdfpfpuEq/jRhJy+uwH6nGlotcFwWi3wV8nbZbTe+KlsK56sipB/Kx+7IcHUor6bG153yZMyovYE03R+40qpyQa34YRbJBPkJgOBg4PdLOOjiXw3AUdbcDO2OehM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217029; c=relaxed/simple;
	bh=owp8SUyoLDuoYXBQFbGTof3YVHWIT+HOf81CobxHJPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryTpos+3deQa9ck46fl94lP7FpgSrDcF1yGXCOvO6rxhjeOvzFEKSdn3n2VkFnVOrTfL0Jy02sbR2bm86K5bFnQwglZk6gb9uBFJkDw2qAVGHDJgAgyDwZsltD7DtvsvgRpXqiUSFIcOa6uRXEmkJCvwLoUvwVqwgujBAgyMjPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ysr0UeaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ysr0UeaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECADEC4CEF7;
	Wed,  4 Feb 2026 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217029;
	bh=owp8SUyoLDuoYXBQFbGTof3YVHWIT+HOf81CobxHJPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ysr0UeaR4wICkLhW6WVfTAkGoFatca2299n9CappBPqUYKkA4wnki5PuJGSdL2Eht
	 CAJVu1gi797E0SkoANGniA4jfcVweBOUewSdItmOoSB/ryIqg/pbYslueiWzASRRzU
	 nvxXgBQllDy2ppus1r9LdHvDOW8SLJoO8s22jdKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/206] octeontx2-af: Fix error handling
Date: Wed,  4 Feb 2026 15:38:54 +0100
Message-ID: <20260204143901.920418037@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 19e4175e997a5b85eab97d522f00cc99abd1873c ]

This commit adds error handling and rollback logic to
rvu_mbox_handler_attach_resources() to properly clean up partially
attached resources when rvu_attach_block() fails.

Fixes: 746ea74241fa0 ("octeontx2-af: Add RVU block LF provisioning support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260121033934.1900761-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 86 ++++++++++++++-----
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 0863fa06c06d1..53f742a507dbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1455,8 +1455,8 @@ static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype,
 	return -ENODEV;
 }
 
-static void rvu_attach_block(struct rvu *rvu, int pcifunc, int blktype,
-			     int num_lfs, struct rsrc_attach *attach)
+static int rvu_attach_block(struct rvu *rvu, int pcifunc, int blktype,
+			    int num_lfs, struct rsrc_attach *attach)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -1466,21 +1466,21 @@ static void rvu_attach_block(struct rvu *rvu, int pcifunc, int blktype,
 	u64 cfg;
 
 	if (!num_lfs)
-		return;
+		return -EINVAL;
 
 	blkaddr = rvu_get_attach_blkaddr(rvu, blktype, pcifunc, attach);
 	if (blkaddr < 0)
-		return;
+		return -EFAULT;
 
 	block = &hw->block[blkaddr];
 	if (!block->lf.bmap)
-		return;
+		return -ESRCH;
 
 	for (slot = 0; slot < num_lfs; slot++) {
 		/* Allocate the resource */
 		lf = rvu_alloc_rsrc(&block->lf);
 		if (lf < 0)
-			return;
+			return -EFAULT;
 
 		cfg = (1ULL << 63) | (pcifunc << 8) | slot;
 		rvu_write64(rvu, blkaddr, block->lfcfg_reg |
@@ -1491,6 +1491,8 @@ static void rvu_attach_block(struct rvu *rvu, int pcifunc, int blktype,
 		/* Set start MSIX vector for this LF within this PF/VF */
 		rvu_set_msix_offset(rvu, pfvf, block, lf);
 	}
+
+	return 0;
 }
 
 static int rvu_check_rsrc_availability(struct rvu *rvu,
@@ -1628,22 +1630,31 @@ int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 	int err;
 
 	/* If first request, detach all existing attached resources */
-	if (!attach->modify)
-		rvu_detach_rsrcs(rvu, NULL, pcifunc);
+	if (!attach->modify) {
+		err = rvu_detach_rsrcs(rvu, NULL, pcifunc);
+		if (err)
+			return err;
+	}
 
 	mutex_lock(&rvu->rsrc_lock);
 
 	/* Check if the request can be accommodated */
 	err = rvu_check_rsrc_availability(rvu, attach, pcifunc);
 	if (err)
-		goto exit;
+		goto fail1;
 
 	/* Now attach the requested resources */
-	if (attach->npalf)
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_NPA, 1, attach);
+	if (attach->npalf) {
+		err = rvu_attach_block(rvu, pcifunc, BLKTYPE_NPA, 1, attach);
+		if (err)
+			goto fail1;
+	}
 
-	if (attach->nixlf)
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_NIX, 1, attach);
+	if (attach->nixlf) {
+		err = rvu_attach_block(rvu, pcifunc, BLKTYPE_NIX, 1, attach);
+		if (err)
+			goto fail2;
+	}
 
 	if (attach->sso) {
 		/* RVU func doesn't know which exact LF or slot is attached
@@ -1653,33 +1664,64 @@ int rvu_mbox_handler_attach_resources(struct rvu *rvu,
 		 */
 		if (attach->modify)
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_SSO);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_SSO,
-				 attach->sso, attach);
+		err = rvu_attach_block(rvu, pcifunc, BLKTYPE_SSO,
+				       attach->sso, attach);
+		if (err)
+			goto fail3;
 	}
 
 	if (attach->ssow) {
 		if (attach->modify)
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_SSOW);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_SSOW,
-				 attach->ssow, attach);
+		err = rvu_attach_block(rvu, pcifunc, BLKTYPE_SSOW,
+				       attach->ssow, attach);
+		if (err)
+			goto fail4;
 	}
 
 	if (attach->timlfs) {
 		if (attach->modify)
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_TIM);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_TIM,
-				 attach->timlfs, attach);
+		err = rvu_attach_block(rvu, pcifunc, BLKTYPE_TIM,
+				       attach->timlfs, attach);
+		if (err)
+			goto fail5;
 	}
 
 	if (attach->cptlfs) {
 		if (attach->modify &&
 		    rvu_attach_from_same_block(rvu, BLKTYPE_CPT, attach))
 			rvu_detach_block(rvu, pcifunc, BLKTYPE_CPT);
-		rvu_attach_block(rvu, pcifunc, BLKTYPE_CPT,
-				 attach->cptlfs, attach);
+		err = rvu_attach_block(rvu, pcifunc, BLKTYPE_CPT,
+				       attach->cptlfs, attach);
+		if (err)
+			goto fail6;
 	}
 
-exit:
+	mutex_unlock(&rvu->rsrc_lock);
+	return 0;
+
+fail6:
+	if (attach->timlfs)
+		rvu_detach_block(rvu, pcifunc, BLKTYPE_TIM);
+
+fail5:
+	if (attach->ssow)
+		rvu_detach_block(rvu, pcifunc, BLKTYPE_SSOW);
+
+fail4:
+	if (attach->sso)
+		rvu_detach_block(rvu, pcifunc, BLKTYPE_SSO);
+
+fail3:
+	if (attach->nixlf)
+		rvu_detach_block(rvu, pcifunc, BLKTYPE_NIX);
+
+fail2:
+	if (attach->npalf)
+		rvu_detach_block(rvu, pcifunc, BLKTYPE_NPA);
+
+fail1:
 	mutex_unlock(&rvu->rsrc_lock);
 	return err;
 }
-- 
2.51.0



