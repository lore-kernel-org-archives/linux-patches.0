Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002662DF137;
	Thu, 16 Jul 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209241; cv=none; b=W4sOlmwmUPF4ogrg5eq2L0wdiBGvicXY2CM1B8aesxQWa4z2fmurYHv4OWHYReIJbMFEJp5tV1RxWM2oSNv0WM6N8tByC9zD0QW+DBaTw2yzXzLmTPWJYKl1oapECFBXBa9fQG1qOGNspmwySSsorxyi6E6ovaBcOUVMKtnufxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209241; c=relaxed/simple;
	bh=7jF1x1eZdmJpHeBOohuSRmaEpgtnbauYkzE1ZiO3zes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joFhHkGpm/IXLsIa2NujwG1HJNAg2p9eftfhxkOeA+6xhDC443HkmKwAqYrUIDzP8WwhzUO8YkZgW4Tbm7pUIwyjd7hhU+L0V8lL1b1ZIgx7zSyB6yG8NSRYOZwp62xkBnEezMMHtpJ3M99sfw9dPO7j8QMC3GNocwTCjcRbDgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGiAmt6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGiAmt6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6637D1F000E9;
	Thu, 16 Jul 2026 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209239;
	bh=MHSsUd75Bogoj9NhxAX+WjuyFX/tLXrW6Pvr26EBphE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGiAmt6FDb2sDrQPvbVWZQ0Be7LRIfdWPsNBjw49eSiVquIuNmkqXJzpS3HNTm3y4
	 ghZDVEr33VDntps9U3yIAmD7Cq5iP7+MHo7XEEw6UZ24gyBFEnqNuYoKrsDtLUFLj7
	 /195IuZFgbGkDqEHnXsxpRJL0brs+S2sCcqRQsXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.1 109/518] vfio/pci: Fix racy bitfields and tighten struct layout
Date: Thu, 16 Jul 2026 15:26:17 +0200
Message-ID: <20260716133050.239100645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -101,6 +101,9 @@ struct vfio_pci_core_device {
 	const struct vfio_pci_device_ops *pci_ops;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
+	/* Flags modified at runtime - dedicated storage unit */
+	bool			virq_disabled;
+	bool			bardirty;
 	u8			*pci_config_map;
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
@@ -115,19 +118,19 @@ struct vfio_pci_core_device {
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


