Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E86BB5B;
	Tue, 12 Aug 2025 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024882; cv=none; b=gD47Mjr+ev7Hr7/JtAZgtT0E4Kf8qicMt8bOkbcsjdrOKxxhSCFwyJRGxGmj1JvFSG/olV+PZsjIPg0CXjDHRkrmuoe7TnxL5LOBgrgO7So0kLGHCG/2BZbsBis2tq3UyJ7bLdsmKGoU0HPYMHFlyM/blv6UqnRVB/V1af4VB7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024882; c=relaxed/simple;
	bh=dtovWfYMgz43dCjgwsKTyRq3GNpX6XdYzN4AhR0Jaso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCgZiel/BJf+Bed9Phw7PF0E7vOeUsnjA6eUOgwNAGWZZQu3tHNUw4m0Cwe3fpx7XldqUVzNOSufestOBzN+CT50s2QPsdzEB7IxufhJS6GGWTRCJkly7ffBu9/bfeP3jmZEvWLC1HlkzYPXCTfuHKeaeFuAN6oIITjniJjIzB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moZBsQo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moZBsQo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB3CC4CEF0;
	Tue, 12 Aug 2025 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024882;
	bh=dtovWfYMgz43dCjgwsKTyRq3GNpX6XdYzN4AhR0Jaso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moZBsQo8AegS9YzYXPpV532a/WCbDSlqmnGCB5yCGf9BYOSYwPpyrfx6eaDklXWOt
	 S3I/eNZPRR+91phy+1o/QqL82WK0fFOKpwJ4XpzFdss4h5Yv7Dgn+/7TiZgt0yXx5S
	 S1ijuDx7SAmWVOjZxwnyGu1h83ZQmdQUo62XBan4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 505/627] powerpc/eeh: Make EEH driver device hotplug safe
Date: Tue, 12 Aug 2025 19:33:20 +0200
Message-ID: <20250812173448.068805744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 7efe04c68f0f..dd50de91c438 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -257,13 +257,12 @@ static void eeh_pe_report_edev(struct eeh_dev *edev, eeh_report_fn fn,
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
@@ -304,8 +303,9 @@ static void eeh_pe_report(const char *name, struct eeh_pe *root,
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
@@ -383,6 +383,8 @@ static void eeh_dev_restore_state(struct eeh_dev *edev, void *userdata)
 	if (!edev)
 		return;
 
+	pci_lock_rescan_remove();
+
 	/*
 	 * The content in the config space isn't saved because
 	 * the blocked config space on some adapters. We have
@@ -393,14 +395,19 @@ static void eeh_dev_restore_state(struct eeh_dev *edev, void *userdata)
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
@@ -647,9 +654,7 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	if (any_passed || driver_eeh_aware || (pe->type & EEH_PE_VF)) {
 		eeh_pe_dev_traverse(pe, eeh_rmv_device, rmv_data);
 	} else {
-		pci_lock_rescan_remove();
 		pci_hp_remove_devices(bus);
-		pci_unlock_rescan_remove();
 	}
 
 	/*
@@ -665,8 +670,6 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	if (rc)
 		return rc;
 
-	pci_lock_rescan_remove();
-
 	/* Restore PE */
 	eeh_ops->configure_bridge(pe);
 	eeh_pe_restore_bars(pe);
@@ -674,7 +677,6 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	/* Clear frozen state */
 	rc = eeh_clear_pe_frozen_state(pe, false);
 	if (rc) {
-		pci_unlock_rescan_remove();
 		return rc;
 	}
 
@@ -709,7 +711,6 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 	pe->tstamp = tstamp;
 	pe->freeze_count = cnt;
 
-	pci_unlock_rescan_remove();
 	return 0;
 }
 
@@ -843,10 +844,13 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
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
 
@@ -1094,10 +1098,15 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
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
 
@@ -1114,6 +1123,8 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 			eeh_clear_slot_attention(edev->pdev);
 
 	eeh_pe_state_clear(pe, EEH_PE_RECOVERING, true);
+
+	pci_unlock_rescan_remove();
 }
 
 /**
@@ -1132,6 +1143,7 @@ void eeh_handle_special_event(void)
 	unsigned long flags;
 	int rc;
 
+	pci_lock_rescan_remove();
 
 	do {
 		rc = eeh_ops->next_error(&pe);
@@ -1171,10 +1183,12 @@ void eeh_handle_special_event(void)
 
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
 
@@ -1186,7 +1200,9 @@ void eeh_handle_special_event(void)
 		if (rc == EEH_NEXT_ERR_FROZEN_PE ||
 		    rc == EEH_NEXT_ERR_FENCED_PHB) {
 			eeh_pe_state_mark(pe, EEH_PE_RECOVERING);
+			pci_unlock_rescan_remove();
 			eeh_handle_normal_event(pe);
+			pci_lock_rescan_remove();
 		} else {
 			eeh_for_each_pe(pe, tmp_pe)
 				eeh_pe_for_each_dev(tmp_pe, edev, tmp_edev)
@@ -1199,7 +1215,6 @@ void eeh_handle_special_event(void)
 				eeh_report_failure, NULL);
 			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
-			pci_lock_rescan_remove();
 			list_for_each_entry(hose, &hose_list, list_node) {
 				phb_pe = eeh_phb_pe_get(hose);
 				if (!phb_pe ||
@@ -1218,7 +1233,6 @@ void eeh_handle_special_event(void)
 				}
 				pci_hp_remove_devices(bus);
 			}
-			pci_unlock_rescan_remove();
 		}
 
 		/*
@@ -1228,4 +1242,6 @@ void eeh_handle_special_event(void)
 		if (rc == EEH_NEXT_ERR_DEAD_IOC)
 			break;
 	} while (rc != EEH_NEXT_ERR_NONE);
+
+	pci_unlock_rescan_remove();
 }
diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index d283d281d28e..e740101fadf3 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -671,10 +671,12 @@ static void eeh_bridge_check_link(struct eeh_dev *edev)
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



