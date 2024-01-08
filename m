Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCFB4C634;
	Mon,  8 Jan 2024 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eygXTwb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AABC433C9;
	Mon,  8 Jan 2024 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726572;
	bh=EAL6veoL5CQb6D7ZZ8q87zAkjxUD4sWgYXg/aWWqeak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eygXTwb2JONrMIWqCa0uypJDPxWsU3KoQa1n2D0NlEc3atdhzL4eDOiGi29Vf9vi8
	 UnT71suSdlyrcS4S44qjqG5KMf0/giJuxQyvjTv3Q5MKeAsK+kE7pvlv2lGjinLtPs
	 EWbNPk0KBCS0aREY2r1EmvG/6Om8I4Z7iWGDNkUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Schaller <michael@5challer.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 010/124] Revert "PCI/ASPM: Remove pcie_aspm_pm_state_change()"
Date: Mon,  8 Jan 2024 16:07:16 +0100
Message-ID: <20240108150603.445015618@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit f93e71aea6c60ebff8adbd8941e678302d377869 upstream.

This reverts commit 08d0cc5f34265d1a1e3031f319f594bd1970976c.

Michael reported that when attempting to resume from suspend to RAM on ASUS
mini PC PN51-BB757MDE1 (DMI model: MINIPC PN51-E1), 08d0cc5f3426
("PCI/ASPM: Remove pcie_aspm_pm_state_change()") caused a 12-second delay
with no output, followed by a reboot.

Workarounds include:

  - Reverting 08d0cc5f3426 ("PCI/ASPM: Remove pcie_aspm_pm_state_change()")
  - Booting with "pcie_aspm=off"
  - Booting with "pcie_aspm.policy=performance"
  - "echo 0 | sudo tee /sys/bus/pci/devices/0000:03:00.0/link/l1_aspm"
    before suspending
  - Connecting a USB flash drive

Link: https://lore.kernel.org/r/20240102232550.1751655-1-helgaas@kernel.org
Fixes: 08d0cc5f3426 ("PCI/ASPM: Remove pcie_aspm_pm_state_change()")
Reported-by: Michael Schaller <michael@5challer.de>
Link: https://lore.kernel.org/r/76c61361-b8b4-435f-a9f1-32b716763d62@5challer.de
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c       |    6 ++++++
 drivers/pci/pci.h       |    2 ++
 drivers/pci/pcie/aspm.c |   19 +++++++++++++++++++
 3 files changed, 27 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1335,6 +1335,9 @@ static int pci_set_full_power_state(stru
 		pci_restore_bars(dev);
 	}
 
+	if (dev->bus->self)
+		pcie_aspm_pm_state_change(dev->bus->self);
+
 	return 0;
 }
 
@@ -1429,6 +1432,9 @@ static int pci_set_low_power_state(struc
 				     pci_power_name(dev->current_state),
 				     pci_power_name(state));
 
+	if (dev->bus->self)
+		pcie_aspm_pm_state_change(dev->bus->self);
+
 	return 0;
 }
 
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -566,10 +566,12 @@ int pcie_retrain_link(struct pci_dev *pd
 #ifdef CONFIG_PCIEASPM
 void pcie_aspm_init_link_state(struct pci_dev *pdev);
 void pcie_aspm_exit_link_state(struct pci_dev *pdev);
+void pcie_aspm_pm_state_change(struct pci_dev *pdev);
 void pcie_aspm_powersave_config_link(struct pci_dev *pdev);
 #else
 static inline void pcie_aspm_init_link_state(struct pci_dev *pdev) { }
 static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev) { }
+static inline void pcie_aspm_pm_state_change(struct pci_dev *pdev) { }
 static inline void pcie_aspm_powersave_config_link(struct pci_dev *pdev) { }
 #endif
 
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1001,6 +1001,25 @@ void pcie_aspm_exit_link_state(struct pc
 	up_read(&pci_bus_sem);
 }
 
+/* @pdev: the root port or switch downstream port */
+void pcie_aspm_pm_state_change(struct pci_dev *pdev)
+{
+	struct pcie_link_state *link = pdev->link_state;
+
+	if (aspm_disabled || !link)
+		return;
+	/*
+	 * Devices changed PM state, we should recheck if latency
+	 * meets all functions' requirement
+	 */
+	down_read(&pci_bus_sem);
+	mutex_lock(&aspm_lock);
+	pcie_update_aspm_capable(link->root);
+	pcie_config_aspm_path(link);
+	mutex_unlock(&aspm_lock);
+	up_read(&pci_bus_sem);
+}
+
 void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
 {
 	struct pcie_link_state *link = pdev->link_state;


