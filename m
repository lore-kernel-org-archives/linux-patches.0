Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF52F9492;
	Tue, 17 Jun 2025 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177248; cv=none; b=V4p20wW/0jtz39anw8ZhDmAgofu/Wnjh/ZG/POb68qS+fximUlwnI8Th6OeJT9lI/s3TPE2DWTtrFLVOKiqmFXCoew5IjHVGi3fKbigNzvHUqb8UNR1FmyqTddb56YwJNBHGkEKH8IV9kpxbCJcpJtIJSrv+mSX2kIVLM/Mqkz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177248; c=relaxed/simple;
	bh=d/sOActGyxksS981kqg1LbxdqGJVundRozjeOgnNfyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhsRxpCeecmiCbFfcCNyyu5LjHPEXkuO/VNnAZGgn8aCZ5KfkSBe5k7/7WBgDxgMo5GlELnKU60Hf4Ptn3wRff1mmkb0R3GaOQRBLalSebOdT2EF+Yc+28oBqH8q0pwvZ1AWfirWqO2QrGfD+cb/u/s6Mecq7JdknbhgN6M9VXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ov6pVI57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ov6pVI57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6092C4CEE3;
	Tue, 17 Jun 2025 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177248;
	bh=d/sOActGyxksS981kqg1LbxdqGJVundRozjeOgnNfyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ov6pVI57sTeKj/8TX9QRb2dAFrjhHJFN6qBApKUF6jfLgWA2grBMOO8WOsxMUe3jm
	 xEtgQKBS34XUZtRtSov2J3aUtwV2G4CWeTcICHkBk9EnnpJyOToE3TnINfKpmXs6dL
	 zyrXfbd6fSOrn1emfadn9Osw0aml/nRqc5lsewOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Denis Benato <benato.denis96@gmail.com>,
	Yijun Shen <Yijun_Shen@Dell.com>,
	David Perry <david.perry@amd.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/512] PCI: Explicitly put devices into D0 when initializing
Date: Tue, 17 Jun 2025 17:24:39 +0200
Message-ID: <20250617152432.297176178@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4d4c10f763d7808fbade28d83d237411603bca05 ]

AMD BIOS team has root caused an issue that NVMe storage failed to come
back from suspend to a lack of a call to _REG when NVMe device was probed.

112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states") added
support for calling _REG when transitioning D-states, but this only works
if the device actually "transitions" D-states.

967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
added support for runtime PM on PCI devices, but never actually
'explicitly' sets the device to D0.

To make sure that devices are in D0 and that platform methods such as
_REG are called, explicitly set all devices into D0 during initialization.

Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Denis Benato <benato.denis96@gmail.com>
Tested-By: Yijun Shen <Yijun_Shen@Dell.com>
Tested-By: David Perry <david.perry@amd.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://patch.msgid.link/20250424043232.1848107-1-superm1@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c |  6 ------
 drivers/pci/pci.c        | 13 ++++++++++---
 drivers/pci/pci.h        |  1 +
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 35270172c8331..a90990157e0b7 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -555,12 +555,6 @@ static void pci_pm_default_resume(struct pci_dev *pci_dev)
 	pci_enable_wake(pci_dev, PCI_D0, false);
 }
 
-static void pci_pm_power_up_and_verify_state(struct pci_dev *pci_dev)
-{
-	pci_power_up(pci_dev);
-	pci_update_current_state(pci_dev, PCI_D0);
-}
-
 static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 {
 	pci_pm_power_up_and_verify_state(pci_dev);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7ca5422feb2d4..1a6639dbe81b3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3185,6 +3185,12 @@ void pci_d3cold_disable(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_d3cold_disable);
 
+void pci_pm_power_up_and_verify_state(struct pci_dev *pci_dev)
+{
+	pci_power_up(pci_dev);
+	pci_update_current_state(pci_dev, PCI_D0);
+}
+
 /**
  * pci_pm_init - Initialize PM functions of given PCI device
  * @dev: PCI device to handle.
@@ -3195,9 +3201,6 @@ void pci_pm_init(struct pci_dev *dev)
 	u16 status;
 	u16 pmc;
 
-	pm_runtime_forbid(&dev->dev);
-	pm_runtime_set_active(&dev->dev);
-	pm_runtime_enable(&dev->dev);
 	device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;
 
@@ -3259,6 +3262,10 @@ void pci_pm_init(struct pci_dev *dev)
 	pci_read_config_word(dev, PCI_STATUS, &status);
 	if (status & PCI_STATUS_IMM_READY)
 		dev->imm_ready = 1;
+	pci_pm_power_up_and_verify_state(dev);
+	pm_runtime_forbid(&dev->dev);
+	pm_runtime_set_active(&dev->dev);
+	pm_runtime_enable(&dev->dev);
 }
 
 static unsigned long pci_ea_flags(struct pci_dev *dev, u8 prop)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 65df6d2ac0032..c1a5874eeb6cf 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -146,6 +146,7 @@ void pci_dev_adjust_pme(struct pci_dev *dev);
 void pci_dev_complete_resume(struct pci_dev *pci_dev);
 void pci_config_pm_runtime_get(struct pci_dev *dev);
 void pci_config_pm_runtime_put(struct pci_dev *dev);
+void pci_pm_power_up_and_verify_state(struct pci_dev *pci_dev);
 void pci_pm_init(struct pci_dev *dev);
 void pci_ea_init(struct pci_dev *dev);
 void pci_msi_init(struct pci_dev *dev);
-- 
2.39.5



