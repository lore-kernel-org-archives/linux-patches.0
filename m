Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1564411CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C26C433C8;
	Mon, 26 Jun 2023 18:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804730;
	bh=h4OGgYGOoaXe/jUyCZ6HglYxQTZ2kVuM9bEgDzkmnGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+5v2UOizvUyCa/EA8dq2Vc58rMaLM9Jjtt3cg7knEc78WNv56KWINhp++M8vofn3
	 Ru2Ud4pJukWZOPMdjdl7ztVSZYE00rp+Tb+/uBmd41rXa9VksNLtH1x/ekoipwHBfi
	 E++csuC/A4WCXtDrAzMYjEOZ4LxCV9tIFWOupsbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 23/96] PCI: hv: Add a per-bus mutex state_lock
Date: Mon, 26 Jun 2023 20:11:38 +0200
Message-ID: <20230626180747.895428436@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dexuan Cui <decui@microsoft.com>

commit 067d6ec7ed5b49380688e06c1e5f883a71bef4fe upstream.

In the case of fast device addition/removal, it's possible that
hv_eject_device_work() can start to run before create_root_hv_pci_bus()
starts to run; as a result, the pci_get_domain_bus_and_slot() in
hv_eject_device_work() can return a 'pdev' of NULL, and
hv_eject_device_work() can remove the 'hpdev', and immediately send a
message PCI_EJECTION_COMPLETE to the host, and the host immediately
unassigns the PCI device from the guest; meanwhile,
create_root_hv_pci_bus() and the PCI device driver can be probing the
dead PCI device and reporting timeout errors.

Fix the issue by adding a per-bus mutex 'state_lock' and grabbing the
mutex before powering on the PCI bus in hv_pci_enter_d0(): when
hv_eject_device_work() starts to run, it's able to find the 'pdev' and call
pci_stop_and_remove_bus_device(pdev): if the PCI device driver has
loaded, the PCI device driver's probe() function is already called in
create_root_hv_pci_bus() -> pci_bus_add_devices(), and now
hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able
to call the PCI device driver's remove() function and remove the device
reliably; if the PCI device driver hasn't loaded yet, the function call
hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able to
remove the PCI device reliably and the PCI device driver's probe()
function won't be called; if the PCI device driver's probe() is already
running (e.g., systemd-udev is loading the PCI device driver), it must
be holding the per-device lock, and after the probe() finishes and releases
the lock, hv_eject_device_work() -> pci_stop_and_remove_bus_device() is
able to proceed to remove the device reliably.

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230615044451.5580-6-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -483,7 +483,10 @@ struct hv_pcibus_device {
 	struct fwnode_handle *fwnode;
 	/* Protocol version negotiated with the host */
 	enum pci_protocol_version_t protocol_version;
+
+	struct mutex state_lock;
 	enum hv_pcibus_state state;
+
 	struct hv_device *hdev;
 	resource_size_t low_mmio_space;
 	resource_size_t high_mmio_space;
@@ -2191,6 +2194,8 @@ static void pci_devices_present_work(str
 	if (!dr)
 		return;
 
+	mutex_lock(&hbus->state_lock);
+
 	/* First, mark all existing children as reported missing. */
 	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_for_each_entry(hpdev, &hbus->children, list_entry) {
@@ -2272,6 +2277,8 @@ static void pci_devices_present_work(str
 		break;
 	}
 
+	mutex_unlock(&hbus->state_lock);
+
 	kfree(dr);
 }
 
@@ -2420,6 +2427,8 @@ static void hv_eject_device_work(struct
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
 	hbus = hpdev->hbus;
 
+	mutex_lock(&hbus->state_lock);
+
 	/*
 	 * Ejection can come before or after the PCI bus has been set up, so
 	 * attempt to find it and tear down the bus state, if it exists.  This
@@ -2456,6 +2465,8 @@ static void hv_eject_device_work(struct
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
 	/* hpdev has been freed. Do not use it any more. */
+
+	mutex_unlock(&hbus->state_lock);
 }
 
 /**
@@ -3218,6 +3229,7 @@ static int hv_pci_probe(struct hv_device
 		return -ENOMEM;
 
 	hbus->bridge = bridge;
+	mutex_init(&hbus->state_lock);
 	hbus->state = hv_pcibus_init;
 	hbus->wslot_res_allocated = -1;
 
@@ -3322,9 +3334,11 @@ static int hv_pci_probe(struct hv_device
 	if (ret)
 		goto free_irq_domain;
 
+	mutex_lock(&hbus->state_lock);
+
 	ret = hv_pci_enter_d0(hdev);
 	if (ret)
-		goto free_irq_domain;
+		goto release_state_lock;
 
 	ret = hv_pci_allocate_bridge_windows(hbus);
 	if (ret)
@@ -3342,12 +3356,15 @@ static int hv_pci_probe(struct hv_device
 	if (ret)
 		goto free_windows;
 
+	mutex_unlock(&hbus->state_lock);
 	return 0;
 
 free_windows:
 	hv_pci_free_bridge_windows(hbus);
 exit_d0:
 	(void) hv_pci_bus_exit(hdev, true);
+release_state_lock:
+	mutex_unlock(&hbus->state_lock);
 free_irq_domain:
 	irq_domain_remove(hbus->irq_domain);
 free_fwnode:
@@ -3580,20 +3597,26 @@ static int hv_pci_resume(struct hv_devic
 	if (ret)
 		goto out;
 
+	mutex_lock(&hbus->state_lock);
+
 	ret = hv_pci_enter_d0(hdev);
 	if (ret)
-		goto out;
+		goto release_state_lock;
 
 	ret = hv_send_resources_allocated(hdev);
 	if (ret)
-		goto out;
+		goto release_state_lock;
 
 	prepopulate_bars(hbus);
 
 	hv_pci_restore_msi_state(hbus);
 
 	hbus->state = hv_pcibus_installed;
+	mutex_unlock(&hbus->state_lock);
 	return 0;
+
+release_state_lock:
+	mutex_unlock(&hbus->state_lock);
 out:
 	vmbus_close(hdev->channel);
 	return ret;


