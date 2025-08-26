Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865EA352067;
	Tue, 26 Aug 2025 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217500; cv=none; b=fgkcdnS9scJCH8HQAswP2IDeu0oBwNIdCtXjyUSExvv4MybGTcM3mo0rc1MuDdmS1U0kSQxhUZkfTKNwNDDQ5uw13PjY+IwqXPVciSHF1X2oQCGvrv0cONpvJ9VNH/AZpZg/XuKxAdij88ibrD2MkTmnegMmf/gf824JDNjf6bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217500; c=relaxed/simple;
	bh=qhooIEMwJDB65OM7w//VwOk5EVOboz5QQpV/tG5LiMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oX7uvdJcwk3A3NojjWlyoIn34/bL77KJVN2hN6Ps0cSNOadt27RG67PYZqdtCpsS7LTqO6ptkKF9ay01aeqUDXaGi0h18LO1d10BqUrSYcD/bDKOUvVibTYbW2jHrsQASFOH8Vh50X83SJK4H+HXS6i+FoAI2U+J79bqXQdNC38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiRRNW0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiRRNW0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19906C113CF;
	Tue, 26 Aug 2025 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217500;
	bh=qhooIEMwJDB65OM7w//VwOk5EVOboz5QQpV/tG5LiMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiRRNW0EDm5zpmnTfRDca2KSjTwfyb4mNA+pwS4RQcAZf8/MGQcWjhZ2e+bpWoMDr
	 FsHcvEQiv7dNdp037m16+5mPl5sLRosbCeiPq/6PshFY9OH8w7oDqbJ+7dH60mRb9M
	 IOdOm3/bSbaaWwOh/D9Luk45GrkEYfvomiVxeXgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/523] powerpc/eeh: Make EEH driver device hotplug safe
Date: Tue, 26 Aug 2025 13:06:15 +0200
Message-ID: <20250826110928.540361423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit 1010b4c012b0d78dfb9d3132b49aa2ef024a07a7 ]

Multiple race conditions existed between the PCIe hotplug driver and the
EEH driver, leading to a variety of kernel oopses of the same general
nature:

<pcie device unplug>
<eeh driver trigger>
<hotplug removal trigger>
<pcie tree reconfiguration>
<eeh recovery next step>
<oops in EEH driver bus iteration loop>

A second class of oops is also seen when the underlying bus disappears
during device recovery.

Refactor the EEH module to be PCI rescan and remove safe.  Also clean
up a few minor formatting / readability issues.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/1334208367.1359861.1752615503144.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 48 +++++++++++++++++++++-----------
 arch/powerpc/kernel/eeh_pe.c     | 10 ++++---
 2 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 665d847ef9b5..ed5be1bff60c 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -258,13 +258,12 @@ static void eeh_pe_report_edev(struct eeh_dev *edev, eeh_report_fn fn,
 	struct pci_driver *driver;
 	enum pci_ers_result new_result;
 
-	pci_lock_rescan_remove();
 	pdev = edev->pdev;
 	if (pdev)
 		get_device(&pdev->dev);
-	pci_unlock_rescan_remove();
 	if (!pdev) {
 		eeh_edev_info(edev, "no device");
+		*result = PCI_ERS_RESULT_DISCONNECT;
 		return;
 	}
 	device_lock(&pdev->dev);
@@ -305,8 +304,9 @@ static void eeh_pe_report(const char *name, struct eeh_pe *root,
 	struct eeh_dev *edev, *tmp;
 
 	pr_info("EEH: Beginning: '%s'\n", name);
-	eeh_for_each_pe(root, pe) eeh_pe_for_each_dev(pe, edev, tmp)
-		eeh_pe_report_edev(edev, fn, result);
+	eeh_for_each_pe(root, pe)
+		eeh_pe_for_each_dev(pe, edev, tmp)
+			eeh_pe_report_edev(edev, fn, result);
 	if (result)
 		pr_info("EEH: Finished:'%s' with aggregate recovery state:'%s'\n",
 			name, pci_ers_result_name(*result));
@@ -384,6 +384,8 @@ static void eeh_dev_restore_state(struct eeh_dev *edev, void *userdata)
 	if (!edev)
 		return;
 
+	pci_lock_rescan_remove();
+
 	/*
 	 * The content in the config space isn't saved because
 	 * the blocked config space on some adapters. We have
@@ -394,14 +396,19 @@ static void eeh_dev_restore_state(struct eeh_dev *edev, void *userdata)
 		if (list_is_last(&edev->entry, &edev->pe->edevs))
 			eeh_pe_restore_bars(edev->pe);
 
+		pci_unlock_rescan_remove();
 		return;
 	}
 
 	pdev = eeh_dev_to_pci_dev(edev);
-	if (!pdev)
+	if (!pdev) {
+		pci_unlock_rescan_remove();
 		return;
+	}
 
 	pci_restore_state(pdev);
+
+	pci_unlock_rescan_remove();
 }
 
 /**
@@ -648,9 +655,7 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	if (any_passed || driver_eeh_aware || (pe->type & EEH_PE_VF)) {
 		eeh_pe_dev_traverse(pe, eeh_rmv_device, rmv_data);
 	} else {
-		pci_lock_rescan_remove();
 		pci_hp_remove_devices(bus);
-		pci_unlock_rescan_remove();
 	}
 
 	/*
@@ -666,8 +671,6 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	if (rc)
 		return rc;
 
-	pci_lock_rescan_remove();
-
 	/* Restore PE */
 	eeh_ops->configure_bridge(pe);
 	eeh_pe_restore_bars(pe);
@@ -675,7 +678,6 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	/* Clear frozen state */
 	rc = eeh_clear_pe_frozen_state(pe, false);
 	if (rc) {
-		pci_unlock_rescan_remove();
 		return rc;
 	}
 
@@ -710,7 +712,6 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	pe->tstamp = tstamp;
 	pe->freeze_count = cnt;
 
-	pci_unlock_rescan_remove();
 	return 0;
 }
 
@@ -844,10 +845,13 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 		{LIST_HEAD_INIT(rmv_data.removed_vf_list), 0};
 	int devices = 0;
 
+	pci_lock_rescan_remove();
+
 	bus = eeh_pe_bus_get(pe);
 	if (!bus) {
 		pr_err("%s: Cannot find PCI bus for PHB#%x-PE#%x\n",
 			__func__, pe->phb->global_number, pe->addr);
+		pci_unlock_rescan_remove();
 		return;
 	}
 
@@ -1089,10 +1093,15 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 		eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
 		eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
 
-		pci_lock_rescan_remove();
-		pci_hp_remove_devices(bus);
-		pci_unlock_rescan_remove();
+		bus = eeh_pe_bus_get(pe);
+		if (bus)
+			pci_hp_remove_devices(bus);
+		else
+			pr_err("%s: PCI bus for PHB#%x-PE#%x disappeared\n",
+				__func__, pe->phb->global_number, pe->addr);
+
 		/* The passed PE should no longer be used */
+		pci_unlock_rescan_remove();
 		return;
 	}
 
@@ -1109,6 +1118,8 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 			eeh_clear_slot_attention(edev->pdev);
 
 	eeh_pe_state_clear(pe, EEH_PE_RECOVERING, true);
+
+	pci_unlock_rescan_remove();
 }
 
 /**
@@ -1127,6 +1138,7 @@ void eeh_handle_special_event(void)
 	unsigned long flags;
 	int rc;
 
+	pci_lock_rescan_remove();
 
 	do {
 		rc = eeh_ops->next_error(&pe);
@@ -1166,10 +1178,12 @@ void eeh_handle_special_event(void)
 
 			break;
 		case EEH_NEXT_ERR_NONE:
+			pci_unlock_rescan_remove();
 			return;
 		default:
 			pr_warn("%s: Invalid value %d from next_error()\n",
 				__func__, rc);
+			pci_unlock_rescan_remove();
 			return;
 		}
 
@@ -1181,7 +1195,9 @@ void eeh_handle_special_event(void)
 		if (rc == EEH_NEXT_ERR_FROZEN_PE ||
 		    rc == EEH_NEXT_ERR_FENCED_PHB) {
 			eeh_pe_state_mark(pe, EEH_PE_RECOVERING);
+			pci_unlock_rescan_remove();
 			eeh_handle_normal_event(pe);
+			pci_lock_rescan_remove();
 		} else {
 			eeh_for_each_pe(pe, tmp_pe)
 				eeh_pe_for_each_dev(tmp_pe, edev, tmp_edev)
@@ -1194,7 +1210,6 @@ void eeh_handle_special_event(void)
 				eeh_report_failure, NULL);
 			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
-			pci_lock_rescan_remove();
 			list_for_each_entry(hose, &hose_list, list_node) {
 				phb_pe = eeh_phb_pe_get(hose);
 				if (!phb_pe ||
@@ -1213,7 +1228,6 @@ void eeh_handle_special_event(void)
 				}
 				pci_hp_remove_devices(bus);
 			}
-			pci_unlock_rescan_remove();
 		}
 
 		/*
@@ -1223,4 +1237,6 @@ void eeh_handle_special_event(void)
 		if (rc == EEH_NEXT_ERR_DEAD_IOC)
 			break;
 	} while (rc != EEH_NEXT_ERR_NONE);
+
+	pci_unlock_rescan_remove();
 }
diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 3f55e372f259..fea58e9546f9 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -670,10 +670,12 @@ static void eeh_bridge_check_link(struct eeh_dev *edev)
 	eeh_ops->write_config(edev, cap + PCI_EXP_LNKCTL, 2, val);
 
 	/* Check link */
-	if (!edev->pdev->link_active_reporting) {
-		eeh_edev_dbg(edev, "No link reporting capability\n");
-		msleep(1000);
-		return;
+	if (edev->pdev) {
+		if (!edev->pdev->link_active_reporting) {
+			eeh_edev_dbg(edev, "No link reporting capability\n");
+			msleep(1000);
+			return;
+		}
 	}
 
 	/* Wait the link is up until timeout (5s) */
-- 
2.39.5



