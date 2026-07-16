Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0736F28505E;
	Thu, 16 Jul 2026 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211820; cv=none; b=M18dVTWLxQG+xStwQY1WZRPwnPVDw6K4h0+Rm8eugVj9vtFO1b7NTr/bysGDQsQ/07vcVbiQte8MVK26JXBBBrbeZtyFkrIrSyRZxE14IVYdLwvqstKUbdtBukRSruBv2KJ7moK6vTrE+kdxl9n7r/c94xvopUmhsJ3yYOBJcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211820; c=relaxed/simple;
	bh=y6vyNl/CD9DjfaRRxHtRp6ducmThqQN7YXxcw/sAftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAdzvlzJWt9uLAp7vefzGtOUkGBD016AsrG4aF5rnr3+M7EIiVenvrDwGb8n3LhNrPZSBAnra7Yk8bAUfk0py8VDDsb8hCo4Y48oDEAglu+BK+G5djGtI28DdyT+T0DggGMcr6dfqTJYVXatbh0c10tc1WPe+xFX3T0qxGCp4LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORa2hd5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORa2hd5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C15C1F000E9;
	Thu, 16 Jul 2026 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211818;
	bh=dVWSzpmH5sAfFVhMm7yfXGg5y7IgClanzT9BoG1z4mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORa2hd5t2Au+hs8ViRP0b8MS9l7q1eG3QG3xkI5m7vV0SUnQWThpp3NbcwSsBYJdt
	 WMjGssR2CatyAKBuErTyjEFDgPgee8ZQ6XJk24KuavlxGdRPUvpucroyW2a4cW68FO
	 DgMXpFhxstVUTNS5wMGq9wKAUaYc8lkNJDuLGrAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.12 090/349] vfio/pci: Fix racy bitfields and tighten struct layout
Date: Thu, 16 Jul 2026 15:30:24 +0200
Message-ID: <20260716133035.326274066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alex Williamson <alex.williamson@nvidia.com>

commit e73638e55f861758d49f14d7bb5dba3035981cd7 upstream.

Bitfield operations are not atomic, they use a read-modify-write
pattern, therefore we should be careful not to pack bitfields that
can be concurrently updated into the same storage unit.

This split takes a binary approach: flags that are only modified
pre/post open/close remain bitfields, flags modified from user
action, including actions that reach across to another device (ex.
reset) use dedicated storage units.

Note that the virq_disabled and bardirty flags are relocated to fill
an existing hole in the structure.

Bitfield justifications:

  has_dyn_msix: written only in vfio_pci_core_enable()
  pci_2_3: written only in vfio_pci_core_enable()
  reset_works: written only in vfio_pci_core_enable()
  extended_caps: written only in vfio_cap_len() under vfio_config_init()
  has_vga: written only in vfio_pci_core_enable()
  nointx: written only in vfio_pci_core_enable()
  needs_pm_restore: written only in vfio_pci_probe_power_state()
  disable_idle_d3: written only at .init in vfio_pci_core_init_dev()

Dedicated storage units:

  virq_disabled: written by guest INTx command writes in
                 vfio_basic_config_write() while the device is open
  bardirty: written by guest BAR writes in vfio_basic_config_write()
            while the device is open
  pm_intx_masked: written in the runtime-PM suspend path.
  pm_runtime_engaged: written by low-power feature entry/exit paths
  needs_reset: set in vfio_pci_core_disable() and cleared for devices in
               the set by vfio_pci_dev_set_try_reset()
  sriov_active: written by vfio_pci_core_sriov_configure() via sysfs
                sriov_numvfs while bound.

Fixes: 9cd0f6d5cbb6 ("vfio/pci: Use bitfield for struct vfio_pci_core_device flags")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615191241.688297-4-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/vfio_pci_core.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -60,6 +60,9 @@ struct vfio_pci_core_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
+	/* Flags modified at runtime - dedicated storage unit */
+	bool			virq_disabled;
+	bool			bardirty;
 	u8			*pci_config_map;
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
@@ -74,19 +77,19 @@ struct vfio_pci_core_device {
 	u16			msix_size;
 	u32			msix_offset;
 	u32			rbar[7];
+	/* Flags only modified on setup/release - bitfield ok */
 	bool			has_dyn_msix:1;
 	bool			pci_2_3:1;
-	bool			virq_disabled:1;
 	bool			reset_works:1;
 	bool			extended_caps:1;
-	bool			bardirty:1;
 	bool			has_vga:1;
-	bool			needs_reset:1;
 	bool			nointx:1;
 	bool			needs_pm_restore:1;
-	bool			pm_intx_masked:1;
-	bool			pm_runtime_engaged:1;
 	bool			disable_idle_d3:1;
+	/* Flags modified at runtime - dedicated storage unit */
+	bool			needs_reset;
+	bool			pm_intx_masked;
+	bool			pm_runtime_engaged;
 	bool			sriov_active;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;


