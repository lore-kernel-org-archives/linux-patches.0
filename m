Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5421993A9;
	Thu,  6 Jun 2024 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683230; cv=none; b=TrB4k5aRfhtx/1lecJ8q3hUwhZeel96K5WYV1XCfPN9jeM3SqJcU0uRDXOUwRoXucRQt3zzgyPji5PvfKP93BoG4Ps7ufJKGbQPOTuY9W5WNRg1a5vC++oGtddO8dugVRNON/ENQXAV06kV7Z9sLN7vkvqL02Ui+4OsVLilTByM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683230; c=relaxed/simple;
	bh=Kc6bRUsVcgx/2A/Mvuq6KtW9aElTSebRWheINd+cPSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njsQuYoPls6EwNjXx6AlOGOi8BR9rqm0LRXCPwqSxyM9B5DE+RnaUlrwEe4pI/T+wSqzZwf/OA/Or6N0Q3MI+spsgEDIA63tgIbhW+iOQsm4d0fiVDxiya/vPE78MLnJGtOfzYSuFh7g6slbTQXMySgfYuVsB1HHQ1QY+7b/Qeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVrhu7PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVrhu7PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3B7C32781;
	Thu,  6 Jun 2024 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683230;
	bh=Kc6bRUsVcgx/2A/Mvuq6KtW9aElTSebRWheINd+cPSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVrhu7PECIatwQCGqF+/klCY0r36bKijjBqIYjQ0nEXESaP+4cMGl8IZ15pPlt6bI
	 0i9TDY8jz5lbcm07h+MsdC/LwDQxRWPv5W16L/VysroHpJdhPC0oVHAuNZP+HAyhjD
	 fSTO3LxM64EHdRF8miP7uNXFjL/QOof6X19BwQuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/473] scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5
Date: Thu,  6 Jun 2024 16:00:35 +0200
Message-ID: <20240606131703.420499758@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 9c02aa24bf404a39ec509d9f50539056b9b128f7 ]

On SM8550, depending on the Qunipro, we can run with G5 or G4.  For now,
when the major version is 5 or above, we go with G5.  Therefore, we need to
specifically tell UFS HC that.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 823150ecf04f ("scsi: ufs: qcom: Perform read back after writing unipro mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 8 ++++++--
 drivers/ufs/host/ufs-qcom.h | 6 +++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a5d981d3dd6be..ce18c43937a22 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -226,6 +226,10 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL,
 		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
 		   REG_UFS_CFG1);
+
+	if (host->hw_ver.major == 0x05)
+		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
+
 	/* make sure above configuration is applied before we return */
 	mb();
 }
@@ -498,9 +502,9 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		mb();
 	}
 
-	if (update_link_startup_timer) {
+	if (update_link_startup_timer && host->hw_ver.major != 0x5) {
 		ufshcd_writel(hba, ((core_clk_rate / MSEC_PER_SEC) * 100),
-			      REG_UFS_PA_LINK_STARTUP_TIMER);
+			      REG_UFS_CFG0);
 		/*
 		 * make sure that this configuration is applied before
 		 * we return
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 112e53efafe2b..24367cee0b3ff 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -38,7 +38,8 @@ enum {
 	REG_UFS_PA_ERR_CODE                 = 0xCC,
 	/* On older UFS revisions, this register is called "RETRY_TIMER_REG" */
 	REG_UFS_PARAM0                      = 0xD0,
-	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
+	/* On older UFS revisions, this register is called "REG_UFS_PA_LINK_STARTUP_TIMER" */
+	REG_UFS_CFG0                        = 0xD8,
 	REG_UFS_CFG1                        = 0xDC,
 	REG_UFS_CFG2                        = 0xE0,
 	REG_UFS_HW_VERSION                  = 0xE4,
@@ -76,6 +77,9 @@ enum {
 #define UFS_CNTLR_2_x_x_VEN_REGS_OFFSET(x)	(0x000 + x)
 #define UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(x)	(0x400 + x)
 
+/* bit definitions for REG_UFS_CFG0 register */
+#define QUNIPRO_G4_SEL		BIT(5)
+
 /* bit definitions for REG_UFS_CFG1 register */
 #define QUNIPRO_SEL		0x1
 #define UTP_DBG_RAMS_EN		0x20000
-- 
2.43.0



