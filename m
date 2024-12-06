Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D865148832;
	Fri,  6 Dec 2024 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497856; cv=none; b=fvZ6iCuK6d5KBisalf89ncyd/123Yi/AZh0ZMEA55xCxk/EIqCDiKRI8tISuftuTLRas18h/WVx+cYB2JmIgpQN6aV0cdI6DAM5/FK2SiXsArQYTo+RCOu53H3qeDQB8L7STMNQiKkl86U9LZC6dITatrbWSoCBEIB7gqGQxj9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497856; c=relaxed/simple;
	bh=XiiLeigv/aDcrpPhLOl9lva5aRGqQZVCWDpkHqukx0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/5CBxFUNq3j2dVX9JkgV7QCPoDGcOdxJ86/gcZTbBu+Fu5Vb6cMdURvi3YcLeUoUi0VbzQPRC2hjyuPVLsUFvvXnD3AFxfJ76UxkUxNMouyyTOxXjguHZMylcY6La+mLnEd3K9ISN0N1QlDU5mPvCdKx0u7Xf1osNwHRwZGJcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G86B79GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G86B79GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED986C2BCFA;
	Fri,  6 Dec 2024 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497856;
	bh=XiiLeigv/aDcrpPhLOl9lva5aRGqQZVCWDpkHqukx0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G86B79GFlbXTtZwx7xrBhljjJGtBt79thL/7Nsl1Cfd+Zjb17vm02wCRkn048mmUg
	 omEO7TvukAMEyWYR2yTWp2M14zRW80rO173rbqjkuPrv5JCCbKAm985sFXtWhD6tO/
	 XmS1DXIG1FZfTLiz1IRduFY/5f9Hd72Fo8dPWWOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 412/676] octeontx2-af: RPM: fix stale FCFEC counters
Date: Fri,  6 Dec 2024 15:33:51 +0100
Message-ID: <20241206143709.438516302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 6fc2164108462b913a1290fa2c44054c70b060ef ]

The corrected words register(FCFECX_VL0_CCW_LO)/Uncorrected words
register (FCFECX_VL0_NCCW_LO) of FCFEC counter has different LMAC
offset which needs to be accessed differently.

Fixes: 84ad3642115d ("octeontx2-af: Add FEC stats for RPM/RPM_USX block")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 24 +++++++++----------
 .../net/ethernet/marvell/octeontx2/af/rpm.h   | 10 ++++----
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 70629f94c27ef..e97fcc51d7f24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -704,27 +704,27 @@ int rpm_get_fec_stats(void *rpmd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
 	 */
 	mutex_lock(&rpm->lock);
 	if (rpm->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_BASER) {
-		val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL0_CCW_LO);
-		val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+		val_lo = rpm_read(rpm, 0, RPMX_MTI_FCFECX_VL0_CCW_LO(lmac_id));
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_FCFECX_CW_HI(lmac_id));
 		rsp->fec_corr_blks = (val_hi << 16 | val_lo);
 
-		val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL0_NCCW_LO);
-		val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+		val_lo = rpm_read(rpm, 0, RPMX_MTI_FCFECX_VL0_NCCW_LO(lmac_id));
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_FCFECX_CW_HI(lmac_id));
 		rsp->fec_uncorr_blks = (val_hi << 16 | val_lo);
 
 		/* 50G uses 2 Physical serdes lines */
 		if (rpm->lmac_idmap[lmac_id]->link_info.lmac_type_id ==
 		    LMAC_MODE_50G_R) {
-			val_lo = rpm_read(rpm, lmac_id,
-					  RPMX_MTI_FCFECX_VL1_CCW_LO);
-			val_hi = rpm_read(rpm, lmac_id,
-					  RPMX_MTI_FCFECX_CW_HI);
+			val_lo = rpm_read(rpm, 0,
+					  RPMX_MTI_FCFECX_VL1_CCW_LO(lmac_id));
+			val_hi = rpm_read(rpm, 0,
+					  RPMX_MTI_FCFECX_CW_HI(lmac_id));
 			rsp->fec_corr_blks += (val_hi << 16 | val_lo);
 
-			val_lo = rpm_read(rpm, lmac_id,
-					  RPMX_MTI_FCFECX_VL1_NCCW_LO);
-			val_hi = rpm_read(rpm, lmac_id,
-					  RPMX_MTI_FCFECX_CW_HI);
+			val_lo = rpm_read(rpm, 0,
+					  RPMX_MTI_FCFECX_VL1_NCCW_LO(lmac_id));
+			val_hi = rpm_read(rpm, 0,
+					  RPMX_MTI_FCFECX_CW_HI(lmac_id));
 			rsp->fec_uncorr_blks += (val_hi << 16 | val_lo);
 		}
 	} else {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index a5773fbacaff8..5194fec4c3b8e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -91,11 +91,11 @@
 #define RPMX_MTI_RSFEC_STAT_FAST_DATA_HI_CDC            0x40000
 #define RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_2		0x40050
 #define RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_3		0x40058
-#define RPMX_MTI_FCFECX_VL0_CCW_LO			0x38618
-#define RPMX_MTI_FCFECX_VL0_NCCW_LO			0x38620
-#define RPMX_MTI_FCFECX_VL1_CCW_LO			0x38628
-#define RPMX_MTI_FCFECX_VL1_NCCW_LO			0x38630
-#define RPMX_MTI_FCFECX_CW_HI				0x38638
+#define RPMX_MTI_FCFECX_VL0_CCW_LO(a)			(0x38618 + ((a) * 0x40))
+#define RPMX_MTI_FCFECX_VL0_NCCW_LO(a)			(0x38620 + ((a) * 0x40))
+#define RPMX_MTI_FCFECX_VL1_CCW_LO(a)			(0x38628 + ((a) * 0x40))
+#define RPMX_MTI_FCFECX_VL1_NCCW_LO(a)			(0x38630 + ((a) * 0x40))
+#define RPMX_MTI_FCFECX_CW_HI(a)			(0x38638 + ((a) * 0x40))
 
 /* CN10KB CSR Declaration */
 #define  RPM2_CMRX_SW_INT				0x1b0
-- 
2.43.0



