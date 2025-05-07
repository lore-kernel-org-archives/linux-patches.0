Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA4514A4C7;
	Wed,  7 May 2025 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643476; cv=none; b=n6ZA1n8q1F+F2yMBMrRfQ1QCCjmdE9ZCdzHwGZn7HlbUU036e7h2Bt4+BioXuej6faXJYfGgfLLNL1nzOoTJ7vijvvqngkKFrqlOs1V99B5E2GbJCpvEfimioLz9QEAb8XHPKkQpldv5HvQIH9qrZYaiS2wakoo+lWE2TMqlra4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643476; c=relaxed/simple;
	bh=ezmJQQf0R0hS0HD1qHg/QOLoxnZwjKx9E++B5+hjGSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzfbhKzaw1SvOYBA5AHcZfpiNxg2qbPUKNUzbeHOqdLGy4UgbE+kyiLbWRAKyvlhtNpxC8FtepF4N7RRis+5C6Hynzm2O2ZCecOzBrKDAXaEnZj58IBgWXocJ75JFpb4rzp0a/3Kk25BmpmXqY+llmol5YAEwEF8CUh7UjFAMk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPu0exPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPu0exPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0044CC4CEE9;
	Wed,  7 May 2025 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643476;
	bh=ezmJQQf0R0hS0HD1qHg/QOLoxnZwjKx9E++B5+hjGSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPu0exPPeesZ4SWq9PKEepa6A8uz+7TZAyIrPqG7qXPGg0fYNkIMbZs7woA1cq0Bi
	 B/Xd8o1h9d+0XmpxaTcnFgoePyxBHirbNOGmGiEl01PLPLK5Z3zoRJlZNV+nLalu39
	 NqSJN9uiPpJzENa10kssAke4ZYleKF1hWc4WN7cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhao Sun <weiguangtwk@outlook.com>,
	Mingcong Bai <jeffbai@aosc.io>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 17/97] iommu/vt-d: Apply quirk_iommu_igfx for 8086:0044 (QM57/QS57)
Date: Wed,  7 May 2025 20:38:52 +0200
Message-ID: <20250507183807.678748156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingcong Bai <jeffbai@aosc.io>

commit 2c8a7c66c90832432496616a9a3c07293f1364f3 upstream.

On the Lenovo ThinkPad X201, when Intel VT-d is enabled in the BIOS, the
kernel boots with errors related to DMAR, the graphical interface appeared
quite choppy, and the system resets erratically within a minute after it
booted:

DMAR: DRHD: handling fault status reg 3
DMAR: [DMA Write NO_PASID] Request device [00:02.0] fault addr 0xb97ff000
[fault reason 0x05] PTE Write access is not set

Upon comparing boot logs with VT-d on/off, I found that the Intel Calpella
quirk (`quirk_calpella_no_shadow_gtt()') correctly applied the igfx IOMMU
disable/quirk correctly:

pci 0000:00:00.0: DMAR: BIOS has allocated no shadow GTT; disabling IOMMU
for graphics

Whereas with VT-d on, it went into the "else" branch, which then
triggered the DMAR handling fault above:

... else if (!disable_igfx_iommu) {
	/* we have to ensure the gfx device is idle before we flush */
	pci_info(dev, "Disabling batched IOTLB flush on Ironlake\n");
	iommu_set_dma_strict();
}

Now, this is not exactly scientific, but moving 0x0044 to quirk_iommu_igfx
seems to have fixed the aforementioned issue. Running a few `git blame'
runs on the function, I have found that the quirk was originally
introduced as a fix specific to ThinkPad X201:

commit 9eecabcb9a92 ("intel-iommu: Abort IOMMU setup for igfx if BIOS gave
no shadow GTT space")

Which was later revised twice to the "else" branch we saw above:

- 2011: commit 6fbcfb3e467a ("intel-iommu: Workaround IOTLB hang on
  Ironlake GPU")
- 2024: commit ba00196ca41c ("iommu/vt-d: Decouple igfx_off from graphic
  identity mapping")

I'm uncertain whether further testings on this particular laptops were
done in 2011 and (honestly I'm not sure) 2024, but I would be happy to do
some distro-specific testing if that's what would be required to verify
this patch.

P.S., I also see IDs 0x0040, 0x0062, and 0x006a listed under the same
`quirk_calpella_no_shadow_gtt()' quirk, but I'm not sure how similar these
chipsets are (if they share the same issue with VT-d or even, indeed, if
this issue is specific to a bug in the Lenovo BIOS). With regards to
0x0062, it seems to be a Centrino wireless card, but not a chipset?

I have also listed a couple (distro and kernel) bug reports below as
references (some of them are from 7-8 years ago!), as they seem to be
similar issue found on different Westmere/Ironlake, Haswell, and Broadwell
hardware setups.

Cc: stable@vger.kernel.org
Fixes: 6fbcfb3e467a ("intel-iommu: Workaround IOTLB hang on Ironlake GPU")
Fixes: ba00196ca41c ("iommu/vt-d: Decouple igfx_off from graphic identity mapping")
Link: https://groups.google.com/g/qubes-users/c/4NP4goUds2c?pli=1
Link: https://bugs.archlinux.org/task/65362
Link: https://bbs.archlinux.org/viewtopic.php?id=230323
Reported-by: Wenhao Sun <weiguangtwk@outlook.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=197029
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Link: https://lore.kernel.org/r/20250415133330.12528-1-jeffbai@aosc.io
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4836,6 +4836,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e40, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e90, quirk_iommu_igfx);
 
+/* QM57/QS57 integrated gfx malfunctions with dmar */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0044, quirk_iommu_igfx);
+
 /* Broadwell igfx malfunctions with dmar */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1606, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x160B, quirk_iommu_igfx);
@@ -4913,7 +4916,6 @@ static void quirk_calpella_no_shadow_gtt
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0040, quirk_calpella_no_shadow_gtt);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0044, quirk_calpella_no_shadow_gtt);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0062, quirk_calpella_no_shadow_gtt);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x006a, quirk_calpella_no_shadow_gtt);
 


