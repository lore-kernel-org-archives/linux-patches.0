Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439231EE001;
	Tue,  3 Dec 2024 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239434; cv=none; b=nhkUh1gg9azlVHBnVTOzCA63ADYpxPcaX/cj7tes4Qf5PHz2KINU/dfneoahd1sb+VtCKRKbk/6s232ONoVOimkqL545l/8g1oKYC+4TTz+Ieq6cg4p3rXQTh+3ENil9DBXV9JNbDv+kUp+AZZbWgfJBio1KqqVy/pH8OeZmx50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239434; c=relaxed/simple;
	bh=wIXKvz5J16sADYSBhks38KM1wWtFdr7LmRhtDyO6Uxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c36P+F0ol/nbsA8ja37sPl0CjLvou5rn+ZW9AVWrKx9qg0TeIbc9VLf557m0GBHwODdfEU0oGJ7RZocDjM8As99gs0HrP8nFMgY6Y94p1pRcPfzIwkw2dmqNUQJYvsWQEO67Em/Kn3LxF1fAFBDvTP/ezIWX5/Tc8wC/jaUdhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEew3VWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEew3VWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF347C4CECF;
	Tue,  3 Dec 2024 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239434;
	bh=wIXKvz5J16sADYSBhks38KM1wWtFdr7LmRhtDyO6Uxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEew3VWEkB9DkwcNb/tsDva8wHXWu8ffWUIn6OGjAaCDQpL04JttvSfUVv4ODt0g0
	 ID/3FDbee0nQwiyECs6BNkEiPwmw5uBZF9pYm6UCRfwZulvjxuB4Uzgy7ih/nRsO7U
	 eaOUPB/QbpFdcttOQb/ASUHLq5lu6A3zK8mlqjvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 581/817] octeontx2-af: RPM: fix stale FCFEC counters
Date: Tue,  3 Dec 2024 15:42:33 +0100
Message-ID: <20241203144018.599247908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



