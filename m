Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D8A1C283;
	Wed,  3 Jan 2024 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIw4q68C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3299C433C7;
	Wed,  3 Jan 2024 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302058;
	bh=X2d0zmnVA1fBrwPs7tqY3jGlS1x1v5jEFV3X+JbP/FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIw4q68CKnGko0o8fsu4DbpXDNRqtjfwhTmo5xSf21fPdRXtVzd0fWf/W3twrLuaz
	 DjjJUyStNy7zXtS7eQ8dA7C9FMhA3l32Px21HCsFc9J4jJdXLhqsdJXxJao9Cxf/iO
	 hgMJuvC/ueU4BaRkmSs168Vrg6aEDtwgEv1F4jJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/49] platform/x86/intel/pmc: Move GBE LTR ignore to suspend callback
Date: Wed,  3 Jan 2024 17:55:54 +0100
Message-ID: <20240103164840.309954973@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 70681aa0746ae61d7668b9f651221fad5e30c71e ]

Commit 804951203aa5 ("platform/x86:intel/pmc: Combine core_init() and
core_configure()") caused a network performance regression due to the GBE
LTR ignore that it added at probe. This was needed in order to allow the
SoC to enter the deepest Package C state. To fix the regression and at
least support PC10 during suspend, move the LTR ignore from probe to the
suspend callback, and enable it again on resume. This solution will allow
PC10 during suspend but restrict Package C entry at runtime to no deeper
than PC8/9 while a network cable it attach to the PCH LAN.

Fixes: 804951203aa5 ("platform/x86:intel/pmc: Combine core_init() and core_configure()")
Signed-off-by: "David E. Box" <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20231223032548.1680738-6-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/adl.c  |  9 +++------
 drivers/platform/x86/intel/pmc/cnp.c  | 26 ++++++++++++++++++++------
 drivers/platform/x86/intel/pmc/core.h |  3 +++
 drivers/platform/x86/intel/pmc/mtl.c  |  9 +++------
 drivers/platform/x86/intel/pmc/tgl.c  |  9 ++++-----
 5 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/adl.c b/drivers/platform/x86/intel/pmc/adl.c
index a887c388cf16d..606f7678bcb0a 100644
--- a/drivers/platform/x86/intel/pmc/adl.c
+++ b/drivers/platform/x86/intel/pmc/adl.c
@@ -314,16 +314,13 @@ int adl_core_init(struct pmc_dev *pmcdev)
 	struct pmc *pmc = pmcdev->pmcs[PMC_IDX_MAIN];
 	int ret;
 
+	pmcdev->suspend = cnl_suspend;
+	pmcdev->resume = cnl_resume;
+
 	pmc->map = &adl_reg_map;
 	ret = get_primary_reg_base(pmc);
 	if (ret)
 		return ret;
 
-	/* Due to a hardware limitation, the GBE LTR blocks PC10
-	 * when a cable is attached. Tell the PMC to ignore it.
-	 */
-	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
-
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/cnp.c b/drivers/platform/x86/intel/pmc/cnp.c
index 10498204962cd..98b36651201a0 100644
--- a/drivers/platform/x86/intel/pmc/cnp.c
+++ b/drivers/platform/x86/intel/pmc/cnp.c
@@ -204,21 +204,35 @@ const struct pmc_reg_map cnp_reg_map = {
 	.etr3_offset = ETR3_OFFSET,
 };
 
+void cnl_suspend(struct pmc_dev *pmcdev)
+{
+	/*
+	 * Due to a hardware limitation, the GBE LTR blocks PC10
+	 * when a cable is attached. To unblock PC10 during suspend,
+	 * tell the PMC to ignore it.
+	 */
+	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
+}
+
+int cnl_resume(struct pmc_dev *pmcdev)
+{
+	pmc_core_send_ltr_ignore(pmcdev, 3, 0);
+
+	return pmc_core_resume_common(pmcdev);
+}
+
 int cnp_core_init(struct pmc_dev *pmcdev)
 {
 	struct pmc *pmc = pmcdev->pmcs[PMC_IDX_MAIN];
 	int ret;
 
+	pmcdev->suspend = cnl_suspend;
+	pmcdev->resume = cnl_resume;
+
 	pmc->map = &cnp_reg_map;
 	ret = get_primary_reg_base(pmc);
 	if (ret)
 		return ret;
 
-	/* Due to a hardware limitation, the GBE LTR blocks PC10
-	 * when a cable is attached. Tell the PMC to ignore it.
-	 */
-	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
-
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index 71ba7d691d691..b66dacbfb94bf 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -502,6 +502,9 @@ int tgl_core_init(struct pmc_dev *pmcdev);
 int adl_core_init(struct pmc_dev *pmcdev);
 int mtl_core_init(struct pmc_dev *pmcdev);
 
+void cnl_suspend(struct pmc_dev *pmcdev);
+int cnl_resume(struct pmc_dev *pmcdev);
+
 #define pmc_for_each_mode(i, mode, pmcdev)		\
 	for (i = 0, mode = pmcdev->lpm_en_modes[i];	\
 	     i < pmcdev->num_lpm_modes;			\
diff --git a/drivers/platform/x86/intel/pmc/mtl.c b/drivers/platform/x86/intel/pmc/mtl.c
index 71dc11811e112..504e3e273c323 100644
--- a/drivers/platform/x86/intel/pmc/mtl.c
+++ b/drivers/platform/x86/intel/pmc/mtl.c
@@ -979,6 +979,8 @@ static void mtl_d3_fixup(void)
 static int mtl_resume(struct pmc_dev *pmcdev)
 {
 	mtl_d3_fixup();
+	pmc_core_send_ltr_ignore(pmcdev, 3, 0);
+
 	return pmc_core_resume_common(pmcdev);
 }
 
@@ -989,6 +991,7 @@ int mtl_core_init(struct pmc_dev *pmcdev)
 
 	mtl_d3_fixup();
 
+	pmcdev->suspend = cnl_suspend;
 	pmcdev->resume = mtl_resume;
 
 	pmcdev->regmap_list = mtl_pmc_info_list;
@@ -1002,11 +1005,5 @@ int mtl_core_init(struct pmc_dev *pmcdev)
 			return ret;
 	}
 
-	/* Due to a hardware limitation, the GBE LTR blocks PC10
-	 * when a cable is attached. Tell the PMC to ignore it.
-	 */
-	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
-
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/tgl.c b/drivers/platform/x86/intel/pmc/tgl.c
index 078263db24c7a..e88d3d00c8539 100644
--- a/drivers/platform/x86/intel/pmc/tgl.c
+++ b/drivers/platform/x86/intel/pmc/tgl.c
@@ -259,16 +259,15 @@ int tgl_core_init(struct pmc_dev *pmcdev)
 	int ret;
 
 	pmc->map = &tgl_reg_map;
+
+	pmcdev->suspend = cnl_suspend;
+	pmcdev->resume = cnl_resume;
+
 	ret = get_primary_reg_base(pmc);
 	if (ret)
 		return ret;
 
 	pmc_core_get_tgl_lpm_reqs(pmcdev->pdev);
-	/* Due to a hardware limitation, the GBE LTR blocks PC10
-	 * when a cable is attached. Tell the PMC to ignore it.
-	 */
-	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
 
 	return 0;
 }
-- 
2.43.0



