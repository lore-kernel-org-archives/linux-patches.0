Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC43F1C284;
	Wed,  3 Jan 2024 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqMr+EkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E555C433C7;
	Wed,  3 Jan 2024 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302054;
	bh=0w91XEDJWimXsMzCxA18HGUGd5VxmG4g3SkUhStJs9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqMr+EkO/+xhnXwBTh4HeHVf8Y+S48ksMpCrzPZtHAzEVTM3clBLgsne/Rvm6gHTe
	 AdhdJFgNpWlXsdPeeRJgeLL33O+aVPWQTE0Oo+pwbw3thARrUfD2cMBOLkTK661Twk
	 /XimWOff7d+VvEehmv27IW+VoLn2Z6V+vEK4j6Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/49] platform/x86/intel/pmc: Allow reenabling LTRs
Date: Wed,  3 Jan 2024 17:55:53 +0100
Message-ID: <20240103164840.170043803@linuxfoundation.org>
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

[ Upstream commit 6f9cc5c1f94daa98846b2073733d03ced709704b ]

Commit 804951203aa5 ("platform/x86:intel/pmc: Combine core_init() and
core_configure()") caused a network performance regression due to the GBE
LTR ignore that it added during probe. The fix will move the ignore to
occur at suspend-time (so as to not affect suspend power). This will
require the ability to enable the LTR again on resume. Modify
pmc_core_send_ltr_ignore() to allow enabling an LTR.

Fixes: 804951203aa5 ("platform/x86:intel/pmc: Combine core_init() and core_configure()")
Signed-off-by: "David E. Box" <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20231223032548.1680738-5-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/adl.c  | 2 +-
 drivers/platform/x86/intel/pmc/cnp.c  | 2 +-
 drivers/platform/x86/intel/pmc/core.c | 9 ++++++---
 drivers/platform/x86/intel/pmc/core.h | 2 +-
 drivers/platform/x86/intel/pmc/mtl.c  | 2 +-
 drivers/platform/x86/intel/pmc/tgl.c  | 2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/adl.c b/drivers/platform/x86/intel/pmc/adl.c
index 5006008e01bea..a887c388cf16d 100644
--- a/drivers/platform/x86/intel/pmc/adl.c
+++ b/drivers/platform/x86/intel/pmc/adl.c
@@ -323,7 +323,7 @@ int adl_core_init(struct pmc_dev *pmcdev)
 	 * when a cable is attached. Tell the PMC to ignore it.
 	 */
 	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3);
+	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/cnp.c b/drivers/platform/x86/intel/pmc/cnp.c
index 420aaa1d7c769..10498204962cd 100644
--- a/drivers/platform/x86/intel/pmc/cnp.c
+++ b/drivers/platform/x86/intel/pmc/cnp.c
@@ -218,7 +218,7 @@ int cnp_core_init(struct pmc_dev *pmcdev)
 	 * when a cable is attached. Tell the PMC to ignore it.
 	 */
 	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3);
+	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 5ab470d87ad7e..022afb97d531c 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -460,7 +460,7 @@ static int pmc_core_pll_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(pmc_core_pll);
 
-int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value)
+int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value, int ignore)
 {
 	struct pmc *pmc;
 	const struct pmc_reg_map *map;
@@ -498,7 +498,10 @@ int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value)
 	mutex_lock(&pmcdev->lock);
 
 	reg = pmc_core_reg_read(pmc, map->ltr_ignore_offset);
-	reg |= BIT(ltr_index);
+	if (ignore)
+		reg |= BIT(ltr_index);
+	else
+		reg &= ~BIT(ltr_index);
 	pmc_core_reg_write(pmc, map->ltr_ignore_offset, reg);
 
 	mutex_unlock(&pmcdev->lock);
@@ -521,7 +524,7 @@ static ssize_t pmc_core_ltr_ignore_write(struct file *file,
 	if (err)
 		return err;
 
-	err = pmc_core_send_ltr_ignore(pmcdev, value);
+	err = pmc_core_send_ltr_ignore(pmcdev, value, 1);
 
 	return err == 0 ? count : err;
 }
diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index 38d888e3afa63..71ba7d691d691 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -488,7 +488,7 @@ extern const struct pmc_bit_map *mtl_ioem_lpm_maps[];
 extern const struct pmc_reg_map mtl_ioem_reg_map;
 
 extern void pmc_core_get_tgl_lpm_reqs(struct platform_device *pdev);
-extern int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value);
+int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value, int ignore);
 
 int pmc_core_resume_common(struct pmc_dev *pmcdev);
 int get_primary_reg_base(struct pmc *pmc);
diff --git a/drivers/platform/x86/intel/pmc/mtl.c b/drivers/platform/x86/intel/pmc/mtl.c
index 2204bc666980e..71dc11811e112 100644
--- a/drivers/platform/x86/intel/pmc/mtl.c
+++ b/drivers/platform/x86/intel/pmc/mtl.c
@@ -1006,7 +1006,7 @@ int mtl_core_init(struct pmc_dev *pmcdev)
 	 * when a cable is attached. Tell the PMC to ignore it.
 	 */
 	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3);
+	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
 
 	return 0;
 }
diff --git a/drivers/platform/x86/intel/pmc/tgl.c b/drivers/platform/x86/intel/pmc/tgl.c
index 2449940102db4..078263db24c7a 100644
--- a/drivers/platform/x86/intel/pmc/tgl.c
+++ b/drivers/platform/x86/intel/pmc/tgl.c
@@ -268,7 +268,7 @@ int tgl_core_init(struct pmc_dev *pmcdev)
 	 * when a cable is attached. Tell the PMC to ignore it.
 	 */
 	dev_dbg(&pmcdev->pdev->dev, "ignoring GBE LTR\n");
-	pmc_core_send_ltr_ignore(pmcdev, 3);
+	pmc_core_send_ltr_ignore(pmcdev, 3, 1);
 
 	return 0;
 }
-- 
2.43.0



