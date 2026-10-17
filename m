Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37139B4A5;
	Sat, 17 Oct 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254713; cv=none; b=krHpiRYvuQ/xxtAgDxpmHZwvPy/OxgnLdcEpZi99M4ecH7jH7Uok9fJAXEqVeOZ0lac1SKAV8TeVfV+H+TRkalMdwRfd/g9CE3iNyRwDkiRKNmlVuAlG+xP2e6FxbjilXZjnnaguK5boUPlDJId+hPAl7vVJ2m7hpSYQbhv/drI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254713; c=relaxed/simple;
	bh=CnTE+otAz6hF544uHLa2hF7W0oPnyaxPRuyErFriLsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPLAOb6EpIKTfVredpiVgF5szpgB2JvW6eJjJXTdPmgobD9DvzmGU2CEQLwcYHmn5FKDP2kmUPQLNYfGfo0So7DUO+2HcIPdp9+E54ShA6nptHMRBi9iSIt5sWcV2v3m/JegDVMrM4sE0yh3UsgIUf9QTI1N43dqGTo1f3TSBO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI9ZgXGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI9ZgXGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30901F000C4;
	Sat, 17 Oct 2026 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254712;
	bh=uCS+bZBFx1geug6zwQHTwl2RFprHxK0ClixueEx6RpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tI9ZgXGRz5GFIyB9KsccZoqJNAtjbesrzNyiazGv8efCAGOZNXoL23ALUAykv/Pqo
	 KJeKaZq6Xvy/8U6/PPYRJZdRizQXnEYQtviioq9xPr9mNCpSQXufcsDsedhBbcACqk
	 /m9irTWbv2OKQ82W057moD8o0biAkjeEKwZt3Wnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 537/869] EDAC/igen6: Skip absent memory controllers
Date: Sat, 17 Oct 2026 17:56:18 +0200
Message-ID: <20261017160050.867512123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 20e190b1c1fd88b21cc5106c12cfe6def5ab849d ]

Some BIOS versions may fuse off certain memory controllers and set the
registers of these absent memory controllers to ~0. The current igen6_edac
mistakenly enumerates these absent memory controllers and registers them
with the EDAC core.

Skip the absent memory controllers to avoid mistakenly enumerating them.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20250408132455.489046-2-qiuxu.zhuo@intel.com
Stable-dep-of: ab1f9d466c7d ("EDAC/igen6: Fix call trace due to missing release()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 78 +++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 6eb8bfff1ab0b..d4b034737e31f 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -127,6 +127,7 @@
 
 static struct res_config {
 	bool machine_check;
+	/* The number of present memory controllers. */
 	int num_imc;
 	u32 imc_base;
 	u32 cmf_base;
@@ -1191,23 +1192,21 @@ static void igen6_check(struct mem_ctl_info *mci)
 		irq_work_queue(&ecclog_irq_work);
 }
 
-static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
+/* Check whether the memory controller is absent. */
+static bool igen6_imc_absent(void __iomem *window)
+{
+	return readl(window + MAD_INTER_CHANNEL_OFFSET) == ~0;
+}
+
+static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev)
 {
 	struct edac_mc_layer layers[2];
 	struct mem_ctl_info *mci;
 	struct igen6_imc *imc;
-	void __iomem *window;
 	int rc;
 
 	edac_dbg(2, "\n");
 
-	mchbar += mc * MCHBAR_SIZE;
-	window = ioremap(mchbar, MCHBAR_SIZE);
-	if (!window) {
-		igen6_printk(KERN_ERR, "Failed to ioremap 0x%llx\n", mchbar);
-		return -ENODEV;
-	}
-
 	layers[0].type = EDAC_MC_LAYER_CHANNEL;
 	layers[0].size = NUM_CHANNELS;
 	layers[0].is_virt_csrow = false;
@@ -1273,7 +1272,6 @@ static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 fail2:
 	edac_mc_free(mci);
 fail:
-	iounmap(window);
 	return rc;
 }
 
@@ -1299,6 +1297,56 @@ static void igen6_unregister_mcis(void)
 	}
 }
 
+static int igen6_register_mcis(struct pci_dev *pdev, u64 mchbar)
+{
+	void __iomem *window;
+	int lmc, pmc, rc;
+	u64 base;
+
+	for (lmc = 0, pmc = 0; pmc < NUM_IMC; pmc++) {
+		base   = mchbar + pmc * MCHBAR_SIZE;
+		window = ioremap(base, MCHBAR_SIZE);
+		if (!window) {
+			igen6_printk(KERN_ERR, "Failed to ioremap 0x%llx for mc%d\n", base, pmc);
+			rc = -ENOMEM;
+			goto out_unregister_mcis;
+		}
+
+		if (igen6_imc_absent(window)) {
+			iounmap(window);
+			edac_dbg(2, "Skip absent mc%d\n", pmc);
+			continue;
+		}
+
+		rc = igen6_register_mci(lmc, window, pdev);
+		if (rc)
+			goto out_iounmap;
+
+		/* Done, if all present MCs are detected and registered. */
+		if (++lmc >= res_cfg->num_imc)
+			break;
+	}
+
+	if (!lmc) {
+		igen6_printk(KERN_ERR, "No mc found.\n");
+		return -ENODEV;
+	}
+
+	if (lmc < res_cfg->num_imc)
+		igen6_printk(KERN_WARNING, "Expected %d mcs, but only %d detected.",
+			     res_cfg->num_imc, lmc);
+
+	return 0;
+
+out_iounmap:
+	iounmap(window);
+
+out_unregister_mcis:
+	igen6_unregister_mcis();
+
+	return rc;
+}
+
 static int igen6_mem_slice_setup(u64 mchbar)
 {
 	struct igen6_imc *imc = &igen6_pvt->imc[0];
@@ -1395,7 +1443,7 @@ static void opstate_set(struct res_config *cfg, const struct pci_device_id *ent)
 static int igen6_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	u64 mchbar;
-	int i, rc;
+	int rc;
 
 	edac_dbg(2, "\n");
 
@@ -1411,11 +1459,9 @@ static int igen6_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	opstate_set(res_cfg, ent);
 
-	for (i = 0; i < res_cfg->num_imc; i++) {
-		rc = igen6_register_mci(i, mchbar, pdev);
-		if (rc)
-			goto fail2;
-	}
+	rc = igen6_register_mcis(pdev, mchbar);
+	if (rc)
+		goto fail;
 
 	if (res_cfg->num_imc > 1) {
 		rc = igen6_mem_slice_setup(mchbar);
-- 
2.53.0



