Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8761AD3E5;
	Mon, 14 Oct 2024 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918019; cv=none; b=neafmGmn97khQaUfQpUBmNeQ6TJXH4VwgkeBuga8Ao2Hp2Rz2xzBY6Ka7uIokVg3lGgSuL0bbp4LJaa8O3x1qeev15xMiBe7GqtqxNtyLke2Vg7vBvcdwaAkm0aLAdWRtMf06YRhyk9r9mPC6I+YJfqzh4JqkLhX28CqfSvqLuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918019; c=relaxed/simple;
	bh=Of7ygNXrMKHhLMADhcUfqrSd2nowARKHSi7tbPV64hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTErqrfSJDPPkeu7u8O26LZINW1yaUK4fh4rbbRB6cLARJopOMsbqngXEvLIH/hepsg9e5eRiy6V+0jh6yaoBcMLs2ddfRjKNTyGqOKXCl9R1Y4q9tErTyX0rRyokct0urBFAoNBc9SOq56RFFKoLFzA2UpxTGlNp0lNNjcCH/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVn14VS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVn14VS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72159C4CEC3;
	Mon, 14 Oct 2024 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918018;
	bh=Of7ygNXrMKHhLMADhcUfqrSd2nowARKHSi7tbPV64hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVn14VS5tSYF8dZGjFIxSsa0J9wXcL5zfgMu+08EZM2QwrvBQfT4cc3YoGHz24T3w
	 NajixySfvEA4Z+5z75WEhQG/DIXQhGHt91z6HfilRPFX2+NpTRnLTDdO614oTB8qE/
	 V5ZZsEbvtOTa7FA+rtZKakH2cGqxMeqtl2LvUQYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/798] PCI/PM: Drop pci_bridge_wait_for_secondary_bus() timeout parameter
Date: Mon, 14 Oct 2024 16:12:33 +0200
Message-ID: <20241014141225.744312767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit e74b2b58ff715ca17bb49c3ad89f665a7150e14b ]

All callers of pci_bridge_wait_for_secondary_bus() supply a timeout of
PCIE_RESET_READY_POLL_MS, so drop the parameter.  Move the definition of
PCIE_RESET_READY_POLL_MS into pci.c, the only user.

[bhelgaas: extracted from
https: //lore.kernel.org/r/20230404052714.51315-3-mika.westerberg@linux.intel.com]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 3e40aa29d47e ("PCI: Wait for Link before restoring Downstream Buses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c |  4 ++--
 drivers/pci/pci.c        | 18 ++++++++++++------
 drivers/pci/pci.h        |  9 +--------
 drivers/pci/pcie/dpc.c   |  3 +--
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index bafe7c9e6d190..cbe47fad4714c 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -579,8 +579,8 @@ static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 
 static void pci_pm_bridge_power_up_actions(struct pci_dev *pci_dev)
 {
-	pci_bridge_wait_for_secondary_bus(pci_dev, "resume",
-					  PCIE_RESET_READY_POLL_MS);
+	pci_bridge_wait_for_secondary_bus(pci_dev, "resume");
+
 	/*
 	 * When powering on a bridge from D3cold, the whole hierarchy may be
 	 * powered on into D0uninitialized state, resume them to give them a
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f7592348ebeee..c845bc3e38e3f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -64,6 +64,14 @@ struct pci_pme_device {
 
 #define PME_TIMEOUT 1000 /* How long between PME checks */
 
+/*
+ * Devices may extend the 1 sec period through Request Retry Status
+ * completions (PCIe r6.0 sec 2.3.1).  The spec does not provide an upper
+ * limit, but 60 sec ought to be enough for any device to become
+ * responsive.
+ */
+#define PCIE_RESET_READY_POLL_MS 60000 /* msec */
+
 static void pci_dev_d3_sleep(struct pci_dev *dev)
 {
 	unsigned int delay_ms = max(dev->d3hot_delay, pci_pm_d3hot_delay);
@@ -4991,7 +4999,6 @@ static int pci_bus_max_d3cold_delay(const struct pci_bus *bus)
  * pci_bridge_wait_for_secondary_bus - Wait for secondary bus to be accessible
  * @dev: PCI bridge
  * @reset_type: reset type in human-readable form
- * @timeout: maximum time to wait for devices on secondary bus (milliseconds)
  *
  * Handle necessary delays before access to the devices on the secondary
  * side of the bridge are permitted after D3cold to D0 transition
@@ -5004,8 +5011,7 @@ static int pci_bus_max_d3cold_delay(const struct pci_bus *bus)
  * Return 0 on success or -ENOTTY if the first device on the secondary bus
  * failed to become accessible.
  */
-int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
-				      int timeout)
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type)
 {
 	struct pci_dev *child __free(pci_dev_put) = NULL;
 	int delay;
@@ -5083,7 +5089,8 @@ int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
 		}
 	}
 
-	return pci_dev_wait(child, reset_type, timeout - delay);
+	return pci_dev_wait(child, reset_type,
+			    PCIE_RESET_READY_POLL_MS - delay);
 }
 
 void pci_reset_secondary_bus(struct pci_dev *dev)
@@ -5120,8 +5127,7 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 {
 	pcibios_reset_secondary_bus(dev);
 
-	return pci_bridge_wait_for_secondary_bus(dev, "bus reset",
-						 PCIE_RESET_READY_POLL_MS);
+	return pci_bridge_wait_for_secondary_bus(dev, "bus reset");
 }
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 88576a22fecb1..5d5813aa5b458 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -69,12 +69,6 @@ struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
  * Reset (PCIe r6.0 sec 5.8).
  */
 #define PCI_RESET_WAIT		1000	/* msec */
-/*
- * Devices may extend the 1 sec period through Request Retry Status completions
- * (PCIe r6.0 sec 2.3.1).  The spec does not provide an upper limit, but 60 sec
- * ought to be enough for any device to become responsive.
- */
-#define PCIE_RESET_READY_POLL_MS 60000	/* msec */
 
 void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 void pci_refresh_power_state(struct pci_dev *dev);
@@ -99,8 +93,7 @@ void pci_msix_init(struct pci_dev *dev);
 bool pci_bridge_d3_possible(struct pci_dev *dev);
 void pci_bridge_d3_update(struct pci_dev *dev);
 void pci_bridge_reconfigure_ltr(struct pci_dev *dev);
-int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
-				      int timeout);
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index acdbf9e770a8a..a5cec2a4e057d 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -171,8 +171,7 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
-	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC",
-					      PCIE_RESET_READY_POLL_MS)) {
+	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC")) {
 		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
 		ret = PCI_ERS_RESULT_DISCONNECT;
 	} else {
-- 
2.43.0



