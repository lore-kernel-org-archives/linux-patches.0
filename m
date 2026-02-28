Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13B0379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302088; cv=none; b=fhDRsmukoqL6uToVJaNQi/cfWYUXfK+p867PI9A6owVaAC+SlcuULRH7/XVGmbj1ZrOU0oi1XP88yxuMw36XvpzFoAMl61qDqrA/aRWDgIsqSiBlK/zMoUlMDr8ZBR4irJOH59ccIqeB2BmmlmRLbII2uxulUbGocxNkuzyuFEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302088; c=relaxed/simple;
	bh=dzNCJYgg+2LfoQhVJ5fo1ONonKCJTRZeJgsLq3wA+Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qm76uBeumU/Q54OIwyrjzx/lON/q/+fw/ii21wjkGPAoy6T9QXBxwcU0G/rvqtboPaKa9nz+lNr206e9PTTRKa5TpOF0k0xh5vUjtVG9iBgapF1uJ3Q89o0zo6ueM31eNzRGuWdmPwzwpNRGKremn0jPLFt292REiUDeNLt7S5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO7zhQOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO7zhQOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6525C19423;
	Sat, 28 Feb 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302088;
	bh=dzNCJYgg+2LfoQhVJ5fo1ONonKCJTRZeJgsLq3wA+Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO7zhQOGHJg0LXSvBNOplPGx2acnznCBB63YwnccJ0c9NZucZOU7KGWDyW7zbjtqk
	 inFBcpI4/tM+2MWf5FteMwwtRFUbULbfZS8JXKt61gwrukuE1+TIN02A1Q+l6BgScV
	 SYr7Gvma3c9GHk66fjLp7HUWcQcX2c+JKz+nyIpLpCi0M5pDsiel+LnuKXsOTI9m0w
	 8aymRYnlwG3tD5J/ayoPiR4mADWDb86PNqyj+XehMMgeHyxaX8Figdz5xZaB/OlhtG
	 8mH6KMf9Hxn96jpwOWcOZxI3bL0dLJgsZi+qcXcWxPsVLgGOpho/UuVptBG//c1fq4
	 /69irJO0ynlog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Narayana Murty N <nnmlinux@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/283] powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event handling
Date: Sat, 28 Feb 2026 13:03:33 -0500
Message-ID: <20260228180709.1583486-71-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Narayana Murty N <nnmlinux@linux.ibm.com>

[ Upstream commit 815a8d2feb5615ae7f0b5befd206af0b0160614c ]

The recent commit 1010b4c012b0 ("powerpc/eeh: Make EEH driver device
hotplug safe") restructured the EEH driver to improve synchronization
with the PCI hotplug layer.

However, it inadvertently moved pci_lock_rescan_remove() outside its
intended scope in eeh_handle_normal_event(), leading to broken PCI
error reporting and improper EEH event triggering. Specifically,
eeh_handle_normal_event() acquired pci_lock_rescan_remove() before
calling eeh_pe_bus_get(), but eeh_pe_bus_get() itself attempts to
acquire the same lock internally, causing nested locking and disrupting
normal EEH event handling paths.

This patch adds a boolean parameter do_lock to _eeh_pe_bus_get(),
with two public wrappers:
    eeh_pe_bus_get() with locking enabled.
    eeh_pe_bus_get_nolock() that skips locking.

Callers that already hold pci_lock_rescan_remove() now use
eeh_pe_bus_get_nolock() to avoid recursive lock acquisition.

Additionally, pci_lock_rescan_remove() calls are restored to the correct
position—after eeh_pe_bus_get() and immediately before iterating affected
PEs and devices. This ensures EEH-triggered PCI removes occur under proper
bus rescan locking without recursive lock contention.

The eeh_pe_loc_get() function has been split into two functions:
    eeh_pe_loc_get(struct eeh_pe *pe) which retrieves the loc for given PE.
    eeh_pe_loc_get_bus(struct pci_bus *bus) which retrieves the location
    code for given bus.

This resolves lockdep warnings such as:
<snip>
[   84.964298] [    T928] ============================================
[   84.964304] [    T928] WARNING: possible recursive locking detected
[   84.964311] [    T928] 6.18.0-rc3 #51 Not tainted
[   84.964315] [    T928] --------------------------------------------
[   84.964320] [    T928] eehd/928 is trying to acquire lock:
[   84.964324] [    T928] c000000003b29d58 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_lock_rescan_remove+0x28/0x40
[   84.964342] [    T928]
                       but task is already holding lock:
[   84.964347] [    T928] c000000003b29d58 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_lock_rescan_remove+0x28/0x40
[   84.964357] [    T928]
                       other info that might help us debug this:
[   84.964363] [    T928]  Possible unsafe locking scenario:

[   84.964367] [    T928]        CPU0
[   84.964370] [    T928]        ----
[   84.964373] [    T928]   lock(pci_rescan_remove_lock);
[   84.964378] [    T928]   lock(pci_rescan_remove_lock);
[   84.964383] [    T928]
                       *** DEADLOCK ***

[   84.964388] [    T928]  May be due to missing lock nesting notation

[   84.964393] [    T928] 1 lock held by eehd/928:
[   84.964397] [    T928]  #0: c000000003b29d58 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_lock_rescan_remove+0x28/0x40
[   84.964408] [    T928]
                       stack backtrace:
[   84.964414] [    T928] CPU: 2 UID: 0 PID: 928 Comm: eehd Not tainted 6.18.0-rc3 #51 VOLUNTARY
[   84.964417] [    T928] Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_022) hv:phyp pSeries
[   84.964419] [    T928] Call Trace:
[   84.964420] [    T928] [c0000011a7157990] [c000000001705de4] dump_stack_lvl+0xc8/0x130 (unreliable)
[   84.964424] [    T928] [c0000011a71579d0] [c0000000002f66e0] print_deadlock_bug+0x430/0x440
[   84.964428] [    T928] [c0000011a7157a70] [c0000000002fd0c0] __lock_acquire+0x1530/0x2d80
[   84.964431] [    T928] [c0000011a7157ba0] [c0000000002fea54] lock_acquire+0x144/0x410
[   84.964433] [    T928] [c0000011a7157cb0] [c0000011a7157cb0] __mutex_lock+0xf4/0x1050
[   84.964436] [    T928] [c0000011a7157e00] [c000000000de21d8] pci_lock_rescan_remove+0x28/0x40
[   84.964439] [    T928] [c0000011a7157e20] [c00000000004ed98] eeh_pe_bus_get+0x48/0xc0
[   84.964442] [    T928] [c0000011a7157e50] [c000000000050434] eeh_handle_normal_event+0x64/0xa60
[   84.964446] [    T928] [c0000011a7157f30] [c000000000051de8] eeh_event_handler+0xf8/0x190
[   84.964450] [    T928] [c0000011a7157f90] [c0000000002747ac] kthread+0x16c/0x180
[   84.964453] [    T928] [c0000011a7157fe0] [c00000000000ded8] start_kernel_thread+0x14/0x18
</snip>

Fixes: 1010b4c012b0 ("powerpc/eeh: Make EEH driver device hotplug safe")
Signed-off-by: Narayana Murty N <nnmlinux@linux.ibm.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251210142559.8874-1-nnmlinux@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/eeh.h   |  2 +
 arch/powerpc/kernel/eeh_driver.c | 11 ++---
 arch/powerpc/kernel/eeh_pe.c     | 74 ++++++++++++++++++++++++++++++--
 3 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.h
index 514dd056c2c84..b5709b9aed238 100644
--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -289,6 +289,8 @@ void eeh_pe_dev_traverse(struct eeh_pe *root,
 void eeh_pe_restore_bars(struct eeh_pe *pe);
 const char *eeh_pe_loc_get(struct eeh_pe *pe);
 struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe);
+const char *eeh_pe_loc_get_bus(struct pci_bus *bus);
+struct pci_bus *eeh_pe_bus_get_nolock(struct eeh_pe *pe);
 
 void eeh_show_enabled(void);
 int __init eeh_init(struct eeh_ops *ops);
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index cc8bedf410ea7..632bf157636ec 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -846,7 +846,7 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 
 	pci_lock_rescan_remove();
 
-	bus = eeh_pe_bus_get(pe);
+	bus = eeh_pe_bus_get_nolock(pe);
 	if (!bus) {
 		pr_err("%s: Cannot find PCI bus for PHB#%x-PE#%x\n",
 			__func__, pe->phb->global_number, pe->addr);
@@ -877,14 +877,15 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 	/* Log the event */
 	if (pe->type & EEH_PE_PHB) {
 		pr_err("EEH: Recovering PHB#%x, location: %s\n",
-			pe->phb->global_number, eeh_pe_loc_get(pe));
+			pe->phb->global_number, eeh_pe_loc_get_bus(bus));
 	} else {
 		struct eeh_pe *phb_pe = eeh_phb_pe_get(pe->phb);
 
 		pr_err("EEH: Recovering PHB#%x-PE#%x\n",
 		       pe->phb->global_number, pe->addr);
 		pr_err("EEH: PE location: %s, PHB location: %s\n",
-		       eeh_pe_loc_get(pe), eeh_pe_loc_get(phb_pe));
+		       eeh_pe_loc_get_bus(bus),
+		       eeh_pe_loc_get_bus(eeh_pe_bus_get_nolock(phb_pe)));
 	}
 
 #ifdef CONFIG_STACKTRACE
@@ -1089,7 +1090,7 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 		eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
 		eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
 
-		bus = eeh_pe_bus_get(pe);
+		bus = eeh_pe_bus_get_nolock(pe);
 		if (bus)
 			pci_hp_remove_devices(bus);
 		else
@@ -1213,7 +1214,7 @@ void eeh_handle_special_event(void)
 				    (phb_pe->state & EEH_PE_RECOVERING))
 					continue;
 
-				bus = eeh_pe_bus_get(phb_pe);
+				bus = eeh_pe_bus_get_nolock(phb_pe);
 				if (!bus) {
 					pr_err("%s: Cannot find PCI bus for "
 					       "PHB#%x-PE#%x\n",
diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 08095aeba5c98..b10fcca520400 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -812,6 +812,24 @@ void eeh_pe_restore_bars(struct eeh_pe *pe)
 const char *eeh_pe_loc_get(struct eeh_pe *pe)
 {
 	struct pci_bus *bus = eeh_pe_bus_get(pe);
+	return eeh_pe_loc_get_bus(bus);
+}
+
+/**
+ * eeh_pe_loc_get_bus - Retrieve location code binding to the given PCI bus
+ * @bus: PCI bus
+ *
+ * Retrieve the location code associated with the given PCI bus. If the bus
+ * is a root bus, the location code is fetched from the PHB device tree node
+ * or root port. Otherwise, the location code is obtained from the device
+ * tree node of the upstream bridge of the bus. The function walks up the
+ * bus hierarchy if necessary, checking each node for the appropriate
+ * location code property ("ibm,io-base-loc-code" for root buses,
+ * "ibm,slot-location-code" for others). If no location code is found,
+ * returns "N/A".
+ */
+const char *eeh_pe_loc_get_bus(struct pci_bus *bus)
+{
 	struct device_node *dn;
 	const char *loc = NULL;
 
@@ -838,8 +856,9 @@ const char *eeh_pe_loc_get(struct eeh_pe *pe)
 }
 
 /**
- * eeh_pe_bus_get - Retrieve PCI bus according to the given PE
+ * _eeh_pe_bus_get - Retrieve PCI bus according to the given PE
  * @pe: EEH PE
+ * @do_lock: Is the caller already held the pci_lock_rescan_remove?
  *
  * Retrieve the PCI bus according to the given PE. Basically,
  * there're 3 types of PEs: PHB/Bus/Device. For PHB PE, the
@@ -847,7 +866,7 @@ const char *eeh_pe_loc_get(struct eeh_pe *pe)
  * returned for BUS PE. However, we don't have associated PCI
  * bus for DEVICE PE.
  */
-struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
+static struct pci_bus *_eeh_pe_bus_get(struct eeh_pe *pe, bool do_lock)
 {
 	struct eeh_dev *edev;
 	struct pci_dev *pdev;
@@ -862,11 +881,58 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 
 	/* Retrieve the parent PCI bus of first (top) PCI device */
 	edev = list_first_entry_or_null(&pe->edevs, struct eeh_dev, entry);
-	pci_lock_rescan_remove();
+	if (do_lock)
+		pci_lock_rescan_remove();
 	pdev = eeh_dev_to_pci_dev(edev);
 	if (pdev)
 		bus = pdev->bus;
-	pci_unlock_rescan_remove();
+	if (do_lock)
+		pci_unlock_rescan_remove();
 
 	return bus;
 }
+
+/**
+ * eeh_pe_bus_get - Retrieve PCI bus associated with the given EEH PE, locking
+ * if needed
+ * @pe: Pointer to the EEH PE
+ *
+ * This function is a wrapper around _eeh_pe_bus_get(), which retrieves the PCI
+ * bus associated with the provided EEH PE structure. It acquires the PCI
+ * rescans lock to ensure safe access to shared data during the retrieval
+ * process. This function should be used when the caller requires the PCI bus
+ * while holding the rescan/remove lock, typically during operations that modify
+ * or inspect PCIe device state in a safe manner.
+ *
+ * RETURNS:
+ * A pointer to the PCI bus associated with the EEH PE, or NULL if none found.
+ */
+
+struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
+{
+	return _eeh_pe_bus_get(pe, true);
+}
+
+/**
+ * eeh_pe_bus_get_nolock - Retrieve PCI bus associated with the given EEH PE
+ * without locking
+ * @pe: Pointer to the EEH PE
+ *
+ * This function is a variant of _eeh_pe_bus_get() that retrieves the PCI bus
+ * associated with the specified EEH PE without acquiring the
+ * pci_lock_rescan_remove lock. It should only be used when the caller can
+ * guarantee safe access to PE structures without the need for that lock,
+ * typically in contexts where the lock is already held locking is otherwise
+ * managed.
+ *
+ * RETURNS:
+ * pointer to the PCI bus associated with the EEH PE, or NULL if none is found.
+ *
+ * NOTE:
+ * Use this function carefully to avoid race conditions and data corruption.
+ */
+
+struct pci_bus *eeh_pe_bus_get_nolock(struct eeh_pe *pe)
+{
+	return _eeh_pe_bus_get(pe, false);
+}
-- 
2.51.0

