Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3E2188006;
	Mon, 23 Dec 2024 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970255; cv=none; b=l1Xf/YZcbx5jMW5KCYqHu/94Oih7HLFgl+udTtvcM3DBIos72RvRj67+zvaih31WIe8m+7GQU+iGRgpx4qk++rU6H0PVdzPdMS+qRXGERFb5pb2W/O3P9EFPe9fqGc4qQQb6rjuMK2cDJ1Ag4AEqZWq3P7Ho/4CEE79/WkqBV84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970255; c=relaxed/simple;
	bh=Q04f/SqFyX9uDr1A7kf7+73jdSFyASTNF7CRc06l6GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQhjPdfT62XMByHAXWV7YNH2HfQbJynubVc9R5j+ocKlFviTOfZG7M9U4Jn4O7jDdDx9NEnF/fr2huPybbuOqsYRpsvaIxpq8IepsLfk5GNw3sS5B6wlK/HG/+Q21xyD7uIR+0lj9PITh7p4pvBzQljVFouxJ2WDpd5W+Pk79Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pL+rYY0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pL+rYY0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C58CC4CED3;
	Mon, 23 Dec 2024 16:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970255;
	bh=Q04f/SqFyX9uDr1A7kf7+73jdSFyASTNF7CRc06l6GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pL+rYY0uHPq9TiNJf1BZsk979wEfPMMs257lbWJp05UIKQc6MRi394g8I4m2MdYDo
	 f8AGj+xs7zO+M/iTextzAUaBq8VTRQJqZV3Ftwyc6qMkHZJ518dKjTUcZOs/GHP1HK
	 Rsk74U8nK26h7yOVlEp9qzhtbl6ec1u/brg1EAyg=
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
Subject: [PATCH 6.6 003/116] PCI: vmd: Create domain symlink before pci_bus_add_devices()
Date: Mon, 23 Dec 2024 16:57:53 +0100
Message-ID: <20241223155359.679170563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 992fea22fd9f..5ff2066aa516 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -930,6 +930,9 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 		dev_set_msi_domain(&vmd->bus->dev,
 				   dev_get_msi_domain(&vmd->dev->dev));
 
+	WARN(sysfs_create_link(&vmd->dev->dev.kobj, &vmd->bus->dev.kobj,
+			       "domain"), "Can't create symlink to domain\n");
+
 	vmd_acpi_begin();
 
 	pci_scan_child_bus(vmd->bus);
@@ -969,9 +972,6 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	pci_bus_add_devices(vmd->bus);
 
 	vmd_acpi_end();
-
-	WARN(sysfs_create_link(&vmd->dev->dev.kobj, &vmd->bus->dev.kobj,
-			       "domain"), "Can't create symlink to domain\n");
 	return 0;
 }
 
@@ -1047,8 +1047,8 @@ static void vmd_remove(struct pci_dev *dev)
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



