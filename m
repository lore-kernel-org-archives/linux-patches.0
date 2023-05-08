Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B99168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D372C433D2;
	Mon,  8 May 2023 11:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544064;
	bh=arutKIuerlIaUwrlEu4X2hryZTkyFfzGpzUeRW/mCCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBDKAsza69L8dotMV4t9wUcc0oVUZ0G4WIExrJnKNimOr9Cph8EDmjW1bVvAszTHe
	 rgxW7lZUUqm2PvkivCLbNv/26md8iGDRVOB8G4mCfHsjQKmMQ1qCm4X6XIgOkI8Cmo
	 /1faYXS2Dfc1nsRLzdvod2ThzgRqHwcW2L02dI1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 291/694] platform/x86/amd: pmc: Move idlemask check into `amd_pmc_idlemask_read`
Date: Mon,  8 May 2023 11:42:06 +0200
Message-Id: <20230508094441.730191202@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 9217bd1d7699f34a01b26ba14ff38c1714ce1185 ]

The version check requirement for idle mask support actually only
applies to RN/CZN/BRC platforms.

So far no issues have happened because the PMFW version string is
bigger on other supported systems.  This can be reset for any new platform
so move the check to only RN/CZN/BRC case.

Fixes: f6045de1f532 ("platform/x86: amd-pmc: Export Idlemask values based on the APU")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230409185348.556161-5-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 74 +++++++++++++++-------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index d6527dea62b8a..f7acb66556987 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -342,33 +342,6 @@ static int amd_pmc_setup_smu_logging(struct amd_pmc_dev *dev)
 	return 0;
 }
 
-static int amd_pmc_idlemask_read(struct amd_pmc_dev *pdev, struct device *dev,
-				 struct seq_file *s)
-{
-	u32 val;
-
-	switch (pdev->cpu_id) {
-	case AMD_CPU_ID_CZN:
-		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_CZN);
-		break;
-	case AMD_CPU_ID_YC:
-	case AMD_CPU_ID_CB:
-	case AMD_CPU_ID_PS:
-		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_YC);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (dev)
-		dev_dbg(pdev->dev, "SMU idlemask s0i3: 0x%x\n", val);
-
-	if (s)
-		seq_printf(s, "SMU idlemask : 0x%x\n", val);
-
-	return 0;
-}
-
 static int get_metrics_table(struct amd_pmc_dev *pdev, struct smu_metrics *table)
 {
 	if (!pdev->smu_virt_addr) {
@@ -543,28 +516,47 @@ static int s0ix_stats_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(s0ix_stats);
 
-static int amd_pmc_idlemask_show(struct seq_file *s, void *unused)
+static int amd_pmc_idlemask_read(struct amd_pmc_dev *pdev, struct device *dev,
+				 struct seq_file *s)
 {
-	struct amd_pmc_dev *dev = s->private;
+	u32 val;
 	int rc;
 
-	/* we haven't yet read SMU version */
-	if (!dev->major) {
-		rc = amd_pmc_get_smu_version(dev);
-		if (rc)
-			return rc;
+	switch (pdev->cpu_id) {
+	case AMD_CPU_ID_CZN:
+		/* we haven't yet read SMU version */
+		if (!pdev->major) {
+			rc = amd_pmc_get_smu_version(pdev);
+			if (rc)
+				return rc;
+		}
+		if (pdev->major > 56 || (pdev->major >= 55 && pdev->minor >= 37))
+			val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_CZN);
+		else
+			return -EINVAL;
+		break;
+	case AMD_CPU_ID_YC:
+	case AMD_CPU_ID_CB:
+	case AMD_CPU_ID_PS:
+		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_YC);
+		break;
+	default:
+		return -EINVAL;
 	}
 
-	if (dev->major > 56 || (dev->major >= 55 && dev->minor >= 37)) {
-		rc = amd_pmc_idlemask_read(dev, NULL, s);
-		if (rc)
-			return rc;
-	} else {
-		seq_puts(s, "Unsupported SMU version for Idlemask\n");
-	}
+	if (dev)
+		dev_dbg(pdev->dev, "SMU idlemask s0i3: 0x%x\n", val);
+
+	if (s)
+		seq_printf(s, "SMU idlemask : 0x%x\n", val);
 
 	return 0;
 }
+
+static int amd_pmc_idlemask_show(struct seq_file *s, void *unused)
+{
+	return amd_pmc_idlemask_read(s->private, NULL, s);
+}
 DEFINE_SHOW_ATTRIBUTE(amd_pmc_idlemask);
 
 static void amd_pmc_dbgfs_unregister(struct amd_pmc_dev *dev)
-- 
2.39.2



