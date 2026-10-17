Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C7737DEBE;
	Sat, 17 Oct 2026 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254710; cv=none; b=DkQU00bW9koQstLMbyxGW5nVQPzlWI+R1/hMqiemYJXZZI/5SzAQQ9KxdEGtFAwJg44KTT86zszwpE3fltQgI+twI6eFsjaF6WyC8f4f3GdUb+K/FtOwwy3TdcPhj9EdF6TZdZ83V5r5lEhuLUMNkyK2UQ6cUidtZLqEdj65Zzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254710; c=relaxed/simple;
	bh=YQVoRrCuz/5Lb6g+X7FUhtiZTMTZmqSwspdMCQ7+UJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4nF8UfJJVmt4JtbqkEVIZ/7GXGYugxRZGod2w6ZqvK9FxqNFOfetRi9DovQc27Yz3TijueKXKoZnfohEM/y7sFt9Re7oi8ktgvlnrKtinEWoL6ozVSNBhcjKW1qmeWxVow6usoF5trTzYmCkmBL4eXUEa8+6xrNW2E2Pki72Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aE2f7Zlp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aE2f7Zlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E61F000C4;
	Sat, 17 Oct 2026 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254709;
	bh=BARD3Sp5ME1XreI4kd/y8VBKm5V0ORJifaoBjs2GkLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aE2f7ZlpyZVHVIAj8fJjj+Of9PCwyzj0qaeC6RD6A/9rUi7LccW0XB83hQZCOeR3n
	 nE6rFbqA/aebM3pqU0PolE8gKIEq+9nQT2Nb3FdtabH/49NZANIhWxYW/Z8T5JgbZ6
	 WQUrUpJbQWweHnVALTXqyqIthEZ+wpXpE2hbCNWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 536/869] EDAC/igen6: Add polling support
Date: Sat, 17 Oct 2026 17:56:17 +0200
Message-ID: <20261017160050.844376098@linuxfoundation.org>
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

From: Orange Kao <orange@aiven.io>

[ Upstream commit e14232afa94445e03fc3a0291b07a68f3408c120 ]

Some PCs with Intel N100 (with PCI device 8086:461c, DID_ADL_N_SKU4)
experienced issues with error interrupts not working, even with the
following configuration in the BIOS.

    In-Band ECC Support: Enabled
    In-Band ECC Operation Mode: 2 (make all requests protected and
                                   ignore range checks)
    IBECC Error Injection Control: Inject Correctable Error on insertion
                                   counter
    Error Injection Insertion Count: 251658240 (0xf000000)

Add polling mode support for these machines to ensure that memory error
events are handled.

Signed-off-by: Orange Kao <orange@aiven.io>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://lore.kernel.org/all/20241106114024.941659-3-orange@aiven.io
Stable-dep-of: ab1f9d466c7d ("EDAC/igen6: Fix call trace due to missing release()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 003db3d9f1913..6eb8bfff1ab0b 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1177,6 +1177,20 @@ static int igen6_pci_setup(struct pci_dev *pdev, u64 *mchbar)
 	return -ENODEV;
 }
 
+static void igen6_check(struct mem_ctl_info *mci)
+{
+	struct igen6_imc *imc = mci->pvt_info;
+	u64 ecclog;
+
+	/* errsts_clear() isn't NMI-safe. Delay it in the IRQ context */
+	ecclog = ecclog_read_and_clear(imc);
+	if (!ecclog)
+		return;
+
+	if (!ecclog_gen_pool_add(imc->mc, ecclog))
+		irq_work_queue(&ecclog_irq_work);
+}
+
 static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 {
 	struct edac_mc_layer layers[2];
@@ -1218,6 +1232,8 @@ static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 	mci->edac_cap = EDAC_FLAG_SECDED;
 	mci->mod_name = EDAC_MOD_STR;
 	mci->dev_name = pci_name(pdev);
+	if (edac_op_state == EDAC_OPSTATE_POLL)
+		mci->edac_check = igen6_check;
 	mci->pvt_info = &igen6_pvt->imc[mc];
 
 	imc = mci->pvt_info;
@@ -1357,8 +1373,18 @@ static void unregister_err_handler(void)
 	unregister_nmi_handler(NMI_SERR, IGEN6_NMI_NAME);
 }
 
-static void opstate_set(struct res_config *cfg)
+static void opstate_set(struct res_config *cfg, const struct pci_device_id *ent)
 {
+	/*
+	 * Quirk: Certain SoCs' error reporting interrupts don't work.
+	 *        Force polling mode for them to ensure that memory error
+	 *        events can be handled.
+	 */
+	if (ent->device == DID_ADL_N_SKU4) {
+		edac_op_state = EDAC_OPSTATE_POLL;
+		return;
+	}
+
 	/* Set the mode according to the configuration data. */
 	if (cfg->machine_check)
 		edac_op_state = EDAC_OPSTATE_INT;
@@ -1383,7 +1409,7 @@ static int igen6_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto fail;
 
-	opstate_set(res_cfg);
+	opstate_set(res_cfg, ent);
 
 	for (i = 0; i < res_cfg->num_imc; i++) {
 		rc = igen6_register_mci(i, mchbar, pdev);
-- 
2.53.0



