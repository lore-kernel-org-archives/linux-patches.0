Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8285E434E4E;
	Tue, 21 Jul 2026 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664953; cv=none; b=rfbnRM2REzorOHKZlY17pU7BlpO2gXlPMVxxtwc4sB3ridFNDl8GxJ2x76HOSMbYiSQbSv/ubyh0sWrT9CZufM4zxyLwB++Xy0gaKB3dxBvOvGu13LXPZb30zj+xHIbHChnO9ZsZ3jNJsRpm5Nms1Kx2KfTemHSeVi4CGbNiaZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664953; c=relaxed/simple;
	bh=FHs/JbLUzJ9nh41vTRNywRaNzcZ1oT2kOWcyL9ai68I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrBMiXSzdKgtLaLxH3ZH/nAnLfbIjTKSaWtZ9MRmLxc4+JvmPIUh9ANqPTaACumPV0n6fA5mwH/EJlETcmTfRX3HZQFa3mjqwOJnnf1BKGbdqUzyFOqHJEfypKmsXp/W6vRVbl1shgdKXpp7NYJpHkt3qbN/wr4BvNcB2DKZMeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ho3xB6Yb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ho3xB6Yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87991F000E9;
	Tue, 21 Jul 2026 20:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664952;
	bh=htLh7UDTJXtn7AgldTzRDVOn4+jrCNToSIVIaCcVJgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ho3xB6Yb01BOW8G0aeU8ExpbubUbygptUNhjGEusEQFZiPJiF3CEPCMxErOpUWdbW
	 JITijGsG0fjhvRxfxdBag80i/+D/x2cOVoVNx/nM+1vwofMswlwE+jNW5CMbgQjPmZ
	 tYLmpLFLVMNS0V4FI6ewua/j6oLNwHj8WEn72W+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.6 0120/1266] vfio/pci: Fix racy bitfields and tighten struct layout
Date: Tue, 21 Jul 2026 17:09:17 +0200
Message-ID: <20260721152444.487958143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -54,6 +54,9 @@ struct vfio_pci_core_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
+	/* Flags modified at runtime - dedicated storage unit */
+	bool			virq_disabled;
+	bool			bardirty;
 	u8			*pci_config_map;
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
@@ -68,19 +71,19 @@ struct vfio_pci_core_device {
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


