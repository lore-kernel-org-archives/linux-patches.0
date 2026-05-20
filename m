Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B2B3EC2DB;
	Wed, 20 May 2026 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297224; cv=none; b=HiTw6Op0QX4kaltLUhJ4mdIIPaa0JHlC/ax99r5LXD9jsCmLKfo6qdsMXPl4+Y4V/gLiT1IDvyl4kBH6bZMILY68WNo4MmlEBVGFNWT8KqgpmbgACS/Y4VbHAOmBaSAPA8e5sEPZUYaNycigr/6t0uyFLCTfCwXybeIu95RC6to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297224; c=relaxed/simple;
	bh=xA24qydCFX86B1+XyJRtOBfXVj7HbGgbLmTqYAsXw4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZn//7TMfmsVT4F1XIB/xJhrGFnkFYhtBStILd6K8PWa26tGBoD71RTp+hcwbEnoIl8D4O9bo+Bp+5PgmZg+/+c8wbNYrSFBaoO8lMir8JFx4I1Tk9XlCaP+VwiSxxOpH6wxwnj5dWDCuAtsXJkIl3a0xPuP+EovIcCiEmTkz3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oO4tYCPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oO4tYCPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AA81F000E9;
	Wed, 20 May 2026 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297222;
	bh=YCx79QTX5vMefxbBRgBaaqfL/22z3k3ZxcgMEK0Nc0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oO4tYCPZqIn7Lb4NnZlIxF2V+mejh7+OGQ4zml08OhBIj2EvGEeZxCgX/a1sYhj++
	 qYlqzdDvxnKbRrDeorqln0fMxfcV+6WWazB26BR+55kWd560B6SjkVIrgcfmjxvDrb
	 tQLaKy/9xBVH+EtPCLeLJa/swSK2jqCsWIIXa7Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyuan Chen <zc@anthropic.com>,
	Josef Bacik <josef@toxicpanda.com>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.0 1098/1146] iommu/amd: Bounds-check devid in __rlookup_amd_iommu()
Date: Wed, 20 May 2026 18:22:28 +0200
Message-ID: <20260520162213.091351119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

commit 07d0f496fe7ec5abe3bee7e38be709521567bb33 upstream.

iommu_device_register() walks every device on the PCI bus via
bus_for_each_dev() and calls amd_iommu_probe_device() for each. The
inlined check_device() path computes the device's sbdf, calls
rlookup_amd_iommu() to find the owning IOMMU, and only afterwards
verifies devid <= pci_seg->last_bdf. __rlookup_amd_iommu() indexes
rlookup_table[devid] with no bounds check of its own, so for a PCI
device whose BDF is not described by the IVRS, the lookup reads past
the end of the allocation before the caller's bounds check can run.

This was harmless before commit e874c666b15b ("iommu/amd: Change
rlookup, irq_lookup, and alias to use kvalloc()"): the table was a
zeroed page-order allocation, so the over-read returned NULL and the
caller's NULL check skipped the device. After that commit the table is
a tight kvcalloc() and the over-read returns adjacent slab contents,
which check_device() then dereferences as a struct amd_iommu *,
causing a boot-time GPF.

Seen on Google Compute Engine ct6e VMs, where the virtualized IVRS
describes only the four TPU endpoints 00:04.0-07.0; the gVNIC at
00:08.0 (devid 0x40) indexes 56 bytes past the 456-byte allocation,
into the adjacent kmalloc-512 slab object:

  pci 0000:00:04.0: Adding to iommu group 0
  pci 0000:00:05.0: Adding to iommu group 1
  pci 0000:00:06.0: Adding to iommu group 2
  pci 0000:00:07.0: Adding to iommu group 3
  Oops: general protection fault, probably for non-canonical address 0x3a64695f78746382: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.22 #1
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/06/2025
  RIP: 0010:amd_iommu_probe_device+0x54/0x3a0
  Call Trace:
   __iommu_probe_device+0x107/0x520
   probe_iommu_group+0x29/0x50
   bus_for_each_dev+0x7e/0xe0
   iommu_device_register+0xc9/0x240
   iommu_go_to_state+0x9c0/0x1c60
   amd_iommu_init+0x14/0x40
   pci_iommu_init+0x16/0x60
   do_one_initcall+0x47/0x2f0

Guard the array access in __rlookup_amd_iommu(). With the fix applied
on 6.18.22, the gVNIC at 00:08.0 is skipped cleanly and the VM boots.

Fixes: e874c666b15b ("iommu/amd: Change rlookup, irq_lookup, and alias to use kvalloc()")
Cc: stable@vger.kernel.org
Reported-by: Ziyuan Chen <zc@anthropic.com>
Tested-by: Ziyuan Chen <zc@anthropic.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Assisted-by: Claude:unspecified
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -351,8 +351,12 @@ static struct amd_iommu *__rlookup_amd_i
 	struct amd_iommu_pci_seg *pci_seg;
 
 	for_each_pci_segment(pci_seg) {
-		if (pci_seg->id == seg)
-			return pci_seg->rlookup_table[devid];
+		if (pci_seg->id != seg)
+			continue;
+		/* IVRS may not describe every device on the bus */
+		if (devid > pci_seg->last_bdf)
+			return NULL;
+		return pci_seg->rlookup_table[devid];
 	}
 	return NULL;
 }


