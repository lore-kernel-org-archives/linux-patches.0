Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F9F1494CB;
	Tue, 25 Jun 2024 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308345; cv=none; b=fTJbXH0SaGQ5hCC6vZr8kVzDjccsGv2SxtlqfrnnN0VGPzHw6h04nhKlRzz0KtDZsDZr6iMEl3/QWjmOeSDr2WYQAAQ7QI4/w8i3Vcxj2ZU8SrFumrzaeo1PLkODdkW2K963HHjiGqJppTYiVmiW4015BOE8TKY8YBIFf4iQilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308345; c=relaxed/simple;
	bh=QzT2OUw4mV/V6q5IMgBIxJSBhm9V/ddJKzGJ6xqbxqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxMdQZ/ta9FvVck9dAfuBQHs+KG9iKwz7dTToM7u25LqfodTqcW7gYY42hEPDyaiHsag1YDlr+OUNi6YF6YbmKFnyyn+1Rovh+M7erAKyGPMdi1kNbB5ao5qC+SHqga1GIiWNUiWnnCljriLCWBb5sIBlwwH5t+Q0zP1ZBNYle8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEpvyOAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEpvyOAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8F2C32786;
	Tue, 25 Jun 2024 09:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308344;
	bh=QzT2OUw4mV/V6q5IMgBIxJSBhm9V/ddJKzGJ6xqbxqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEpvyOAzfEtUh/gRa/Rr4r/nw/i8qke6w7gqOwVIDGOZMh5lqBjovxmucYP/7JuFP
	 RSP7F1H8Dbbs2Im5Sj6cVGhemCYk+mvNJKNqIgVljhg2TP13wg6LMAQyW5AuLnYLfO
	 Prp+Zmj2T/i3LdEDSVXVUlT17BiaV1g9dG0lPxz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 089/250] vfio/pci: Collect hot-reset devices to local buffer
Date: Tue, 25 Jun 2024 11:30:47 +0200
Message-ID: <20240625085551.485423995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit f6944d4a0b87c16bc34ae589169e1ded3d4db08e ]

Lockdep reports the below circular locking dependency issue.  The
mmap_lock acquisition while holding pci_bus_sem is due to the use of
copy_to_user() from within a pci_walk_bus() callback.

Building the devices array directly into the user buffer is only for
convenience.  Instead we can allocate a local buffer for the array,
bounded by the number of devices on the bus/slot, fill the device
information into this local buffer, then copy it into the user buffer
outside the bus walk callback.

======================================================
WARNING: possible circular locking dependency detected
6.9.0-rc5+ #39 Not tainted
------------------------------------------------------
CPU 0/KVM/4113 is trying to acquire lock:
ffff99a609ee18a8 (&vdev->vma_lock){+.+.}-{4:4}, at: vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]

but task is already holding lock:
ffff99a243a052a0 (&mm->mmap_lock){++++}-{4:4}, at: vaddr_get_pfns+0x3f/0x170 [vfio_iommu_type1]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_lock){++++}-{4:4}:
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       __might_fault+0x5c/0x80
       _copy_to_user+0x1e/0x60
       vfio_pci_fill_devs+0x9f/0x130 [vfio_pci_core]
       vfio_pci_walk_wrapper+0x45/0x60 [vfio_pci_core]
       __pci_walk_bus+0x6b/0xb0
       vfio_pci_ioctl_get_pci_hot_reset_info+0x10b/0x1d0 [vfio_pci_core]
       vfio_pci_core_ioctl+0x1cb/0x400 [vfio_pci_core]
       vfio_device_fops_unl_ioctl+0x7e/0x140 [vfio]
       __x64_sys_ioctl+0x8a/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #2 (pci_bus_sem){++++}-{4:4}:
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       down_read+0x3e/0x160
       pci_bridge_wait_for_secondary_bus.part.0+0x33/0x2d0
       pci_reset_bus+0xdd/0x160
       vfio_pci_dev_set_hot_reset+0x256/0x270 [vfio_pci_core]
       vfio_pci_ioctl_pci_hot_reset_groups+0x1a3/0x280 [vfio_pci_core]
       vfio_pci_core_ioctl+0x3b5/0x400 [vfio_pci_core]
       vfio_device_fops_unl_ioctl+0x7e/0x140 [vfio]
       __x64_sys_ioctl+0x8a/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&vdev->memory_lock){+.+.}-{4:4}:
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       down_write+0x3b/0xc0
       vfio_pci_zap_and_down_write_memory_lock+0x1c/0x30 [vfio_pci_core]
       vfio_basic_config_write+0x281/0x340 [vfio_pci_core]
       vfio_config_do_rw+0x1fa/0x300 [vfio_pci_core]
       vfio_pci_config_rw+0x75/0xe50 [vfio_pci_core]
       vfio_pci_rw+0xea/0x1a0 [vfio_pci_core]
       vfs_write+0xea/0x520
       __x64_sys_pwrite64+0x90/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&vdev->vma_lock){+.+.}-{4:4}:
       check_prev_add+0xeb/0xcc0
       validate_chain+0x465/0x530
       __lock_acquire+0x4e4/0xb90
       lock_acquire+0xbc/0x2d0
       __mutex_lock+0x97/0xde0
       vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
       __do_fault+0x31/0x160
       do_pte_missing+0x65/0x3b0
       __handle_mm_fault+0x303/0x720
       handle_mm_fault+0x10f/0x460
       fixup_user_fault+0x7f/0x1f0
       follow_fault_pfn+0x66/0x1c0 [vfio_iommu_type1]
       vaddr_get_pfns+0xf2/0x170 [vfio_iommu_type1]
       vfio_pin_pages_remote+0x348/0x4e0 [vfio_iommu_type1]
       vfio_pin_map_dma+0xd2/0x330 [vfio_iommu_type1]
       vfio_dma_do_map+0x2c0/0x440 [vfio_iommu_type1]
       vfio_iommu_type1_ioctl+0xc5/0x1d0 [vfio_iommu_type1]
       __x64_sys_ioctl+0x8a/0xc0
       do_syscall_64+0x8d/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  &vdev->vma_lock --> pci_bus_sem --> &mm->mmap_lock

 Possible unsafe locking scenario:

block dm-0: the capability attribute has been deprecated.
       CPU0                    CPU1
       ----                    ----
  rlock(&mm->mmap_lock);
                               lock(pci_bus_sem);
                               lock(&mm->mmap_lock);
  lock(&vdev->vma_lock);

 *** DEADLOCK ***

2 locks held by CPU 0/KVM/4113:
 #0: ffff99a25f294888 (&iommu->lock#2){+.+.}-{4:4}, at: vfio_dma_do_map+0x60/0x440 [vfio_iommu_type1]
 #1: ffff99a243a052a0 (&mm->mmap_lock){++++}-{4:4}, at: vaddr_get_pfns+0x3f/0x170 [vfio_iommu_type1]

stack backtrace:
CPU: 1 PID: 4113 Comm: CPU 0/KVM Not tainted 6.9.0-rc5+ #39
Hardware name: Dell Inc. PowerEdge T640/04WYPY, BIOS 2.15.1 06/16/2022
Call Trace:
 <TASK>
 dump_stack_lvl+0x64/0xa0
 check_noncircular+0x131/0x150
 check_prev_add+0xeb/0xcc0
 ? add_chain_cache+0x10a/0x2f0
 ? __lock_acquire+0x4e4/0xb90
 validate_chain+0x465/0x530
 __lock_acquire+0x4e4/0xb90
 lock_acquire+0xbc/0x2d0
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 ? lock_is_held_type+0x9a/0x110
 __mutex_lock+0x97/0xde0
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 ? lock_acquire+0xbc/0x2d0
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 ? find_held_lock+0x2b/0x80
 ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
 __do_fault+0x31/0x160
 do_pte_missing+0x65/0x3b0
 __handle_mm_fault+0x303/0x720
 handle_mm_fault+0x10f/0x460
 fixup_user_fault+0x7f/0x1f0
 follow_fault_pfn+0x66/0x1c0 [vfio_iommu_type1]
 vaddr_get_pfns+0xf2/0x170 [vfio_iommu_type1]
 vfio_pin_pages_remote+0x348/0x4e0 [vfio_iommu_type1]
 vfio_pin_map_dma+0xd2/0x330 [vfio_iommu_type1]
 vfio_dma_do_map+0x2c0/0x440 [vfio_iommu_type1]
 vfio_iommu_type1_ioctl+0xc5/0x1d0 [vfio_iommu_type1]
 __x64_sys_ioctl+0x8a/0xc0
 do_syscall_64+0x8d/0x170
 ? rcu_core+0x8d/0x250
 ? __lock_release+0x5e/0x160
 ? rcu_core+0x8d/0x250
 ? lock_release+0x5f/0x120
 ? sched_clock+0xc/0x30
 ? sched_clock_cpu+0xb/0x190
 ? irqtime_account_irq+0x40/0xc0
 ? __local_bh_enable+0x54/0x60
 ? __do_softirq+0x315/0x3ca
 ? lockdep_hardirqs_on_prepare.part.0+0x97/0x140
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f8300d0357b
Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 68 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007f82ef3fb948 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8300d0357b
RDX: 00007f82ef3fb990 RSI: 0000000000003b71 RDI: 0000000000000023
RBP: 00007f82ef3fb9c0 R08: 0000000000000000 R09: 0000561b7e0bcac2
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000200000000 R14: 0000381800000000 R15: 0000000000000000
 </TASK>

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20240503143138.3562116-1-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d94d61b92c1ac..d8c95cc16be81 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -778,25 +778,26 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 }
 
 struct vfio_pci_fill_info {
-	struct vfio_pci_dependent_device __user *devices;
-	struct vfio_pci_dependent_device __user *devices_end;
 	struct vfio_device *vdev;
+	struct vfio_pci_dependent_device *devices;
+	int nr_devices;
 	u32 count;
 	u32 flags;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
-	struct vfio_pci_dependent_device info = {
-		.segment = pci_domain_nr(pdev->bus),
-		.bus = pdev->bus->number,
-		.devfn = pdev->devfn,
-	};
+	struct vfio_pci_dependent_device *info;
 	struct vfio_pci_fill_info *fill = data;
 
-	fill->count++;
-	if (fill->devices >= fill->devices_end)
-		return 0;
+	/* The topology changed since we counted devices */
+	if (fill->count >= fill->nr_devices)
+		return -EAGAIN;
+
+	info = &fill->devices[fill->count++];
+	info->segment = pci_domain_nr(pdev->bus);
+	info->bus = pdev->bus->number;
+	info->devfn = pdev->devfn;
 
 	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
 		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
@@ -809,19 +810,19 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		 */
 		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
 		if (!vdev) {
-			info.devid = VFIO_PCI_DEVID_NOT_OWNED;
+			info->devid = VFIO_PCI_DEVID_NOT_OWNED;
 		} else {
 			int id = vfio_iommufd_get_dev_id(vdev, iommufd);
 
 			if (id > 0)
-				info.devid = id;
+				info->devid = id;
 			else if (id == -ENOENT)
-				info.devid = VFIO_PCI_DEVID_OWNED;
+				info->devid = VFIO_PCI_DEVID_OWNED;
 			else
-				info.devid = VFIO_PCI_DEVID_NOT_OWNED;
+				info->devid = VFIO_PCI_DEVID_NOT_OWNED;
 		}
 		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
-		if (info.devid == VFIO_PCI_DEVID_NOT_OWNED)
+		if (info->devid == VFIO_PCI_DEVID_NOT_OWNED)
 			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
 	} else {
 		struct iommu_group *iommu_group;
@@ -830,13 +831,10 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		if (!iommu_group)
 			return -EPERM; /* Cannot reset non-isolated devices */
 
-		info.group_id = iommu_group_id(iommu_group);
+		info->group_id = iommu_group_id(iommu_group);
 		iommu_group_put(iommu_group);
 	}
 
-	if (copy_to_user(fill->devices, &info, sizeof(info)))
-		return -EFAULT;
-	fill->devices++;
 	return 0;
 }
 
@@ -1258,10 +1256,11 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 {
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
+	struct vfio_pci_dependent_device *devices = NULL;
 	struct vfio_pci_hot_reset_info hdr;
 	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
-	int ret = 0;
+	int ret, count;
 
 	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
@@ -1277,9 +1276,23 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	fill.devices = arg->devices;
-	fill.devices_end = arg->devices +
-			   (hdr.argsz - sizeof(hdr)) / sizeof(arg->devices[0]);
+	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					    &count, slot);
+	if (ret)
+		return ret;
+
+	if (count > (hdr.argsz - sizeof(hdr)) / sizeof(*devices)) {
+		hdr.count = count;
+		ret = -ENOSPC;
+		goto header;
+	}
+
+	devices = kcalloc(count, sizeof(*devices), GFP_KERNEL);
+	if (!devices)
+		return -ENOMEM;
+
+	fill.devices = devices;
+	fill.nr_devices = count;
 	fill.vdev = &vdev->vdev;
 
 	if (vfio_device_cdev_opened(&vdev->vdev))
@@ -1291,16 +1304,23 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 					    &fill, slot);
 	mutex_unlock(&vdev->vdev.dev_set->lock);
 	if (ret)
-		return ret;
+		goto out;
+
+	if (copy_to_user(arg->devices, devices,
+			 sizeof(*devices) * fill.count)) {
+		ret = -EFAULT;
+		goto out;
+	}
 
 	hdr.count = fill.count;
 	hdr.flags = fill.flags;
-	if (copy_to_user(arg, &hdr, minsz))
-		return -EFAULT;
 
-	if (fill.count > fill.devices - arg->devices)
-		return -ENOSPC;
-	return 0;
+header:
+	if (copy_to_user(arg, &hdr, minsz))
+		ret = -EFAULT;
+out:
+	kfree(devices);
+	return ret;
 }
 
 static int
-- 
2.43.0



