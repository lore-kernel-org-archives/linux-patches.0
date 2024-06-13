Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B38244C6F;
	Thu, 13 Jun 2024 12:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281798; cv=none; b=u8ltFfx0a3+yzOSr2b9uBaa94ovwAhIeIkoImQNYCJDzFWNdazHNvp+0qzS+nzqHpKlt9j7ykJ8UyId/Jq/K5fWsYjIIKFBgCjJHI4v30BkLTrhL8w542vXpudXaYTblEKNainrBnOlPwfPiVPvPte5EyUgFYy8SR51aFU0xTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281798; c=relaxed/simple;
	bh=3oK0vLt+EanZitBpwBd46LrJqAOorz68qbn0u9vA5SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFQzGq4ZT2Lx2a+uvZeoK7GckUZDG6c4SNWIbfjMinjo9r+ykGpGhsCXWQVAzh9SZRR4J27aKmYyOm3QZRwrMXld1MT5UNIQFdBTdiGxhkhg3nOJoU7Qj/jNSthjxX2eC5b4fkYlMrxwNgKarMIOSqM/VBXbGe19Fy/o1sboAV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBU6jqTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBU6jqTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F95C2BBFC;
	Thu, 13 Jun 2024 12:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281798;
	bh=3oK0vLt+EanZitBpwBd46LrJqAOorz68qbn0u9vA5SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBU6jqTWvJ//TlDL8W/TnreiFN/b0JKgKbAtWjZNx6xDm/FFSuXwWs/owbJe6Sc1+
	 3clJHBtzxev+RX4QF2SdrJEf2BaPdB7NfX1ANjhkyXCqBr02obmxF5eGrvIPpNM3/Y
	 ShDhH5cnWWPhYQhTcMoETsTc1/PY0rZ24wTN8lN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/402] scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5
Date: Thu, 13 Jun 2024 13:30:17 +0200
Message-ID: <20240613113304.479401499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/ufs-qcom.c | 8 ++++++--
 drivers/scsi/ufs/ufs-qcom.h | 6 +++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4809ced13851e..fb82a27ac9aaa 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -242,6 +242,10 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
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
@@ -515,9 +519,9 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
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
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index b9f9b246c43b3..6b4584893c30a 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -37,7 +37,8 @@ enum {
 	REG_UFS_PA_ERR_CODE                 = 0xCC,
 	/* On older UFS revisions, this register is called "RETRY_TIMER_REG" */
 	REG_UFS_PARAM0                      = 0xD0,
-	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
+	/* On older UFS revisions, this register is called "REG_UFS_PA_LINK_STARTUP_TIMER" */
+	REG_UFS_CFG0                        = 0xD8,
 	REG_UFS_CFG1                        = 0xDC,
 	REG_UFS_CFG2                        = 0xE0,
 	REG_UFS_HW_VERSION                  = 0xE4,
@@ -75,6 +76,9 @@ enum {
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



