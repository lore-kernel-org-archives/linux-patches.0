Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAF31DDA2F;
	Mon,  6 Jan 2025 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178618; cv=none; b=AGv1tVAO0uJtH7REQOdoQmChcNe3zviCJ5NSTlqpQ+hQtQlfzap414RZ0fumWvDBP4NFIKKOgOYod77mOpfOZYd39/dcZbbgU1aP30hauANTfaxz2hTUr8iy6kA0t2+OcM70waKubxSduLPRxIj1fW1ddh/0H4fAYvRn/7QAirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178618; c=relaxed/simple;
	bh=wPjSIFPrWkQzodKP5FCBr4jQI3NFOSWmI4vHgSxgYQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKwK3LCzrdmCx9DfjEVq7yiUol7KH59pf5FpaGkkWZ63Xvx0ZHQ6OMblDxHnIL/Xy73c5/Ihvy3wXjyj82E2FFzXsQCgCDZbQIgiV4NjJ5ajCqcylJusGydZ2Ry4JtouR94PpWo+NUPYgQWmC2tWbidx1qDk+q37563WO4nLp9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgDDrpHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgDDrpHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5303CC4CED2;
	Mon,  6 Jan 2025 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178618;
	bh=wPjSIFPrWkQzodKP5FCBr4jQI3NFOSWmI4vHgSxgYQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgDDrpHiKbJFNLF237gBTDdGt23SNKy5GVe9yTPa+6rqvFZ5/novSY65dLXDl1ciO
	 2NTf7ex4DY61ZEl+3EoOvwxY5E/PT1ftDF4vZgxsAfgLkvt1GEpb/eMEnCleNGZh7k
	 cQsI7NucjwyRaBCzCcr02mwML43IIKhYaj7NPTDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Huang <ahuang12@lenovo.com>,
	Jiwei Sun <sunjw10@lenovo.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/168] PCI: vmd: Create domain symlink before pci_bus_add_devices()
Date: Mon,  6 Jan 2025 16:15:15 +0100
Message-ID: <20250106151138.737627823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiwei Sun <sunjw10@lenovo.com>

[ Upstream commit f24c9bfcd423e2b2bb0d198456412f614ec2030a ]

The vmd driver creates a "domain" symlink in sysfs for each VMD bridge.
Previously this symlink was created after pci_bus_add_devices() added
devices below the VMD bridge and emitted udev events to announce them to
userspace.

This led to a race between userspace consumers of the udev events and the
kernel creation of the symlink.  One such consumer is mdadm, which
assembles block devices into a RAID array, and for devices below a VMD
bridge, mdadm depends on the "domain" symlink.

If mdadm loses the race, it may be unable to assemble a RAID array, which
may cause a boot failure or other issues, with complaints like this:

  (udev-worker)[2149]: nvme1n1: '/sbin/mdadm -I /dev/nvme1n1'(err) 'mdadm: Unable to get real path for '/sys/bus/pci/drivers/vmd/0000:c7:00.5/domain/device''
  (udev-worker)[2149]: nvme1n1: '/sbin/mdadm -I /dev/nvme1n1'(err) 'mdadm: /dev/nvme1n1 is not attached to Intel(R) RAID controller.'
  (udev-worker)[2149]: nvme1n1: '/sbin/mdadm -I /dev/nvme1n1'(err) 'mdadm: No OROM/EFI properties for /dev/nvme1n1'
  (udev-worker)[2149]: nvme1n1: '/sbin/mdadm -I /dev/nvme1n1'(err) 'mdadm: no RAID superblock on /dev/nvme1n1.'
  (udev-worker)[2149]: nvme1n1: Process '/sbin/mdadm -I /dev/nvme1n1' failed with exit code 1.

This symptom prevents the OS from booting successfully.

After a NVMe disk is probed/added by the nvme driver, udevd invokes mdadm
to detect if there is a mdraid associated with this NVMe disk, and mdadm
determines if a NVMe device is connected to a particular VMD domain by
checking the "domain" symlink. For example:

  Thread A                   Thread B             Thread mdadm
  vmd_enable_domain
    pci_bus_add_devices
      __driver_probe_device
       ...
       work_on_cpu
         schedule_work_on
         : wakeup Thread B
                             nvme_probe
                             : wakeup scan_work
                               to scan nvme disk
                               and add nvme disk
                               then wakeup udevd
                                                  : udevd executes
                                                    mdadm command
         flush_work                               main
         : wait for nvme_probe done                ...
      __driver_probe_device                        find_driver_devices
      : probe next nvme device                     : 1) Detect domain symlink
      ...                                            2) Find domain symlink
      ...                                               from vmd sysfs
      ...                                            3) Domain symlink not
      ...                                               created yet; failed
    sysfs_create_link
    : create domain symlink

Create the VMD "domain" symlink before invoking pci_bus_add_devices() to
avoid this race.

Suggested-by: Adrian Huang <ahuang12@lenovo.com>
Link: https://lore.kernel.org/linux-pci/20240605124844.24293-1-sjiwei@163.com
Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index f49001ba96c7..10a078ef4799 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -798,6 +798,9 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	if (vmd->irq_domain)
 		dev_set_msi_domain(&vmd->bus->dev, vmd->irq_domain);
 
+	WARN(sysfs_create_link(&vmd->dev->dev.kobj, &vmd->bus->dev.kobj,
+			       "domain"), "Can't create symlink to domain\n");
+
 	vmd_acpi_begin();
 
 	pci_scan_child_bus(vmd->bus);
@@ -814,9 +817,6 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	pci_bus_add_devices(vmd->bus);
 
 	vmd_acpi_end();
-
-	WARN(sysfs_create_link(&vmd->dev->dev.kobj, &vmd->bus->dev.kobj,
-			       "domain"), "Can't create symlink to domain\n");
 	return 0;
 }
 
@@ -873,8 +873,8 @@ static void vmd_remove(struct pci_dev *dev)
 {
 	struct vmd_dev *vmd = pci_get_drvdata(dev);
 
-	sysfs_remove_link(&vmd->dev->dev.kobj, "domain");
 	pci_stop_root_bus(vmd->bus);
+	sysfs_remove_link(&vmd->dev->dev.kobj, "domain");
 	pci_remove_root_bus(vmd->bus);
 	vmd_cleanup_srcu(vmd);
 	vmd_detach_resources(vmd);
-- 
2.39.5



