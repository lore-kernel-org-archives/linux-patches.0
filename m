Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C96168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32B3C433EF;
	Mon,  8 May 2023 10:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543203;
	bh=Rw0pSNQBVmqVnVO5qQ0fjbWqjjvpW2WvqxUM+ZkQmb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8EfkHpma77B0kY6EAI2KcwX9Zmib9wSxzJA+qCzNaVHhterozDtAwe9LuvJ8WfKj
	 EjLHvxTZKkUT4ALONrfk1Ub4bn21hF0HcUAp7qpcF+igcxEIyWdUL0AAkWDV0VaK5J
	 n/1Ejeb5OtCrOcpRXyGZC38+xGBO/pv1HgGEtD90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Haeuptle <michael.haeuptle@hpe.com>,
	Ian May <ian.may@canonical.com>,
	Andrey Grodzovsky <andrey2805@gmail.com>,
	Rahul Kumar <rahul.kumar1@amd.com>,
	Jialin Zhang <zhangjialin11@huawei.com>,
	Anatoli Antonovitch <Anatoli.Antonovitch@amd.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Stein <dstein@hpe.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Alex Michon <amichon@kalrayinc.com>,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.3 005/694] PCI: pciehp: Fix AB-BA deadlock between reset_lock and device_lock
Date: Mon,  8 May 2023 11:37:20 +0200
Message-Id: <20230508094432.803880099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

commit f5eff5591b8f9c5effd25c92c758a127765f74c1 upstream.

In 2013, commits

  2e35afaefe64 ("PCI: pciehp: Add reset_slot() method")
  608c388122c7 ("PCI: Add slot reset option to pci_dev_reset()")

amended PCIe hotplug to mask Presence Detect Changed events during a
Secondary Bus Reset.  The reset thus no longer causes gratuitous slot
bringdown and bringup.

However the commits neglected to serialize reset with code paths reading
slot registers.  For instance, a slot bringup due to an earlier hotplug
event may see the Presence Detect State bit cleared during a concurrent
Secondary Bus Reset.

In 2018, commit

  5b3f7b7d062b ("PCI: pciehp: Avoid slot access during reset")

retrofitted the missing locking.  It introduced a reset_lock which
serializes a Secondary Bus Reset with other parts of pciehp.

Unfortunately the locking turns out to be overzealous:  reset_lock is
held for the entire enumeration and de-enumeration of hotplugged devices,
including driver binding and unbinding.

Driver binding and unbinding acquires device_lock while the reset_lock
of the ancestral hotplug port is held.  A concurrent Secondary Bus Reset
acquires the ancestral reset_lock while already holding the device_lock.
The asymmetric locking order in the two code paths can lead to AB-BA
deadlocks.

Michael Haeuptle reports such deadlocks on simultaneous hot-removal and
vfio release (the latter implies a Secondary Bus Reset):

  pciehp_ist()                                    # down_read(reset_lock)
    pciehp_handle_presence_or_link_change()
      pciehp_disable_slot()
        __pciehp_disable_slot()
          remove_board()
            pciehp_unconfigure_device()
              pci_stop_and_remove_bus_device()
                pci_stop_bus_device()
                  pci_stop_dev()
                    device_release_driver()
                      device_release_driver_internal()
                        __device_driver_lock()    # device_lock()

  SYS_munmap()
    vfio_device_fops_release()
      vfio_device_group_close()
        vfio_device_close()
          vfio_device_last_close()
            vfio_pci_core_close_device()
              vfio_pci_core_disable()             # device_lock()
                __pci_reset_function_locked()
                  pci_reset_bus_function()
                    pci_dev_reset_slot_function()
                      pci_reset_hotplug_slot()
                        pciehp_reset_slot()       # down_write(reset_lock)

Ian May reports the same deadlock on simultaneous hot-removal and an
AER-induced Secondary Bus Reset:

  aer_recover_work_func()
    pcie_do_recovery()
      aer_root_reset()
        pci_bus_error_reset()
          pci_slot_reset()
            pci_slot_lock()                       # device_lock()
            pci_reset_hotplug_slot()
              pciehp_reset_slot()                 # down_write(reset_lock)

Fix by releasing the reset_lock during driver binding and unbinding,
thereby splitting and shrinking the critical section.

Driver binding and unbinding is protected by the device_lock() and thus
serialized with a Secondary Bus Reset.  There's no need to additionally
protect it with the reset_lock.  However, pciehp does not bind and
unbind devices directly, but rather invokes PCI core functions which
also perform certain enumeration and de-enumeration steps.

The reset_lock's purpose is to protect slot registers, not enumeration
and de-enumeration of hotplugged devices.  That would arguably be the
job of the PCI core, not the PCIe hotplug driver.  After all, an
AER-induced Secondary Bus Reset may as well happen during boot-time
enumeration of the PCI hierarchy and there's no locking to prevent that
either.

Exempting *de-enumeration* from the reset_lock is relatively harmless:
A concurrent Secondary Bus Reset may foil config space accesses such as
PME interrupt disablement.  But if the device is physically gone, those
accesses are pointless anyway.  If the device is physically present and
only logically removed through an Attention Button press or the sysfs
"power" attribute, PME interrupts as well as DMA cannot come through
because pciehp_unconfigure_device() disables INTx and Bus Master bits.
That's still protected by the reset_lock in the present commit.

Exempting *enumeration* from the reset_lock also has limited impact:
The exempted call to pci_bus_add_device() may perform device accesses
through pcibios_bus_add_device() and pci_fixup_device() which are now
no longer protected from a concurrent Secondary Bus Reset.  Otherwise
there should be no impact.

In essence, the present commit seeks to fix the AB-BA deadlocks while
still retaining a best-effort reset protection for enumeration and
de-enumeration of hotplugged devices -- until a general solution is
implemented in the PCI core.

Link: https://lore.kernel.org/linux-pci/CS1PR8401MB0728FC6FDAB8A35C22BD90EC95F10@CS1PR8401MB0728.NAMPRD84.PROD.OUTLOOK.COM
Link: https://lore.kernel.org/linux-pci/20200615143250.438252-1-ian.may@canonical.com
Link: https://lore.kernel.org/linux-pci/ce878dab-c0c4-5bd0-a725-9805a075682d@amd.com
Link: https://lore.kernel.org/linux-pci/ed831249-384a-6d35-0831-70af191e9bce@huawei.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215590
Fixes: 5b3f7b7d062b ("PCI: pciehp: Avoid slot access during reset")
Link: https://lore.kernel.org/r/fef2b2e9edf245c049a8c5b94743c0f74ff5008a.1681191902.git.lukas@wunner.de
Reported-by: Michael Haeuptle <michael.haeuptle@hpe.com>
Reported-by: Ian May <ian.may@canonical.com>
Reported-by: Andrey Grodzovsky <andrey2805@gmail.com>
Reported-by: Rahul Kumar <rahul.kumar1@amd.com>
Reported-by: Jialin Zhang <zhangjialin11@huawei.com>
Tested-by: Anatoli Antonovitch <Anatoli.Antonovitch@amd.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v4.19+
Cc: Dan Stein <dstein@hpe.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Alex Michon <amichon@kalrayinc.com>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/pciehp_pci.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -63,7 +63,14 @@ int pciehp_configure_device(struct contr
 
 	pci_assign_unassigned_bridge_resources(bridge);
 	pcie_bus_configure_settings(parent);
+
+	/*
+	 * Release reset_lock during driver binding
+	 * to avoid AB-BA deadlock with device_lock.
+	 */
+	up_read(&ctrl->reset_lock);
 	pci_bus_add_devices(parent);
+	down_read_nested(&ctrl->reset_lock, ctrl->depth);
 
  out:
 	pci_unlock_rescan_remove();
@@ -104,7 +111,15 @@ void pciehp_unconfigure_device(struct co
 	list_for_each_entry_safe_reverse(dev, temp, &parent->devices,
 					 bus_list) {
 		pci_dev_get(dev);
+
+		/*
+		 * Release reset_lock during driver unbinding
+		 * to avoid AB-BA deadlock with device_lock.
+		 */
+		up_read(&ctrl->reset_lock);
 		pci_stop_and_remove_bus_device(dev);
+		down_read_nested(&ctrl->reset_lock, ctrl->depth);
+
 		/*
 		 * Ensure that no new Requests will be generated from
 		 * the device.


