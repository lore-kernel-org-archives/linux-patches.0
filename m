Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08B417E90E;
	Mon, 27 May 2024 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837300; cv=none; b=D7EQk/S/PjRY/tV11ApClPaO/gqG6pzpcUtmjq8HmxXgpe3Rh8SDt8hfm9ifS3BpDV+Y1J6lO+3sej7085Q62taVhyUjnDoU4H5mzJ7yx7i+AGTLtgySt/trJU4HoUFKMRJWL+wNmLdi8FQlikr3KipR7OCi07ItoFqer7sXZw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837300; c=relaxed/simple;
	bh=aZSFCPjMbfc9F0yxiJ90U+iStEmPWiHCffQx+RjPNtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnPrQvu8965TrluypCmpawasyk8XM+34gDpIGf8CdB3aI/xYZT/UAQQYFIYrtYT9JITiBOmdpMXlZkq42f/kyUtLwoQrZ1DL80hNQOf3ag+u9I8UxV/nDrRVOhFexaVsu5UIg3G0foCRPFJq0GHUzm2cDtQr1IAc5VkFmSgr720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3oKbGnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3oKbGnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B30C2BBFC;
	Mon, 27 May 2024 19:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837300;
	bh=aZSFCPjMbfc9F0yxiJ90U+iStEmPWiHCffQx+RjPNtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3oKbGnKUUFbfXaLHLEFCz1KhJ0GyQ3Ylc9lI7yWP9+1Vqdc6O/n5c40aMloKNxuP
	 WtW041rT/jtRU06AK/WTgNPLkEcxyng4kSgmQigUkiafNGzA9QOOYq39Dj5YgCCQB2
	 couJTQhBJ2nFUXh/4csX7QRs255epm7PrHJupTAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 388/427] iommu/vt-d: Decouple igfx_off from graphic identity mapping
Date: Mon, 27 May 2024 20:57:15 +0200
Message-ID: <20240527185634.738597042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit ba00196ca41c4f6d0b0d3c4a6748a133577abe05 ]

A kernel command called igfx_off was introduced in commit <ba39592764ed>
("Intel IOMMU: Intel IOMMU driver"). This command allows the user to
disable the IOMMU dedicated to SOC-integrated graphic devices.

Commit <9452618e7462> ("iommu/intel: disable DMAR for g4x integrated gfx")
used this mechanism to disable the graphic-dedicated IOMMU for some
problematic devices. Later, more problematic graphic devices were added
to the list by commit <1f76249cc3beb> ("iommu/vt-d: Declare Broadwell igfx
dmar support snafu").

On the other hand, commit <19943b0e30b05> ("intel-iommu: Unify hardware
and software passthrough support") uses the identity domain for graphic
devices if CONFIG_DMAR_BROKEN_GFX_WA is selected.

+       if (iommu_pass_through)
+               iommu_identity_mapping = 1;
+#ifdef CONFIG_DMAR_BROKEN_GFX_WA
+       else
+               iommu_identity_mapping = 2;
+#endif
...

static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
{
+        if (iommu_identity_mapping == 2)
+                return IS_GFX_DEVICE(pdev);
...

In the following driver evolution, CONFIG_DMAR_BROKEN_GFX_WA and
quirk_iommu_igfx() are mixed together, causing confusion in the driver's
device_def_domain_type callback. On one hand, dmar_map_gfx is used to turn
off the graphic-dedicated IOMMU as a workaround for some buggy hardware;
on the other hand, for those graphic devices, IDENTITY mapping is required
for the IOMMU core.

Commit <4b8d18c0c986> "iommu/vt-d: Remove INTEL_IOMMU_BROKEN_GFX_WA" has
removed the CONFIG_DMAR_BROKEN_GFX_WA option, so the IDENTITY_DOMAIN
requirement for graphic devices is no longer needed. Therefore, this
requirement can be removed from device_def_domain_type() and igfx_off can
be made independent.

Fixes: 4b8d18c0c986 ("iommu/vt-d: Remove INTEL_IOMMU_BROKEN_GFX_WA")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240428032020.214616-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a7ecd90303dc4..e4a03588a8a0f 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -221,12 +221,11 @@ int intel_iommu_sm = IS_ENABLED(CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON);
 int intel_iommu_enabled = 0;
 EXPORT_SYMBOL_GPL(intel_iommu_enabled);
 
-static int dmar_map_gfx = 1;
 static int intel_iommu_superpage = 1;
 static int iommu_identity_mapping;
 static int iommu_skip_te_disable;
+static int disable_igfx_iommu;
 
-#define IDENTMAP_GFX		2
 #define IDENTMAP_AZALIA		4
 
 const struct iommu_ops intel_iommu_ops;
@@ -265,7 +264,7 @@ static int __init intel_iommu_setup(char *str)
 			no_platform_optin = 1;
 			pr_info("IOMMU disabled\n");
 		} else if (!strncmp(str, "igfx_off", 8)) {
-			dmar_map_gfx = 0;
+			disable_igfx_iommu = 1;
 			pr_info("Disable GFX device mapping\n");
 		} else if (!strncmp(str, "forcedac", 8)) {
 			pr_warn("intel_iommu=forcedac deprecated; use iommu.forcedac instead\n");
@@ -2402,9 +2401,6 @@ static int device_def_domain_type(struct device *dev)
 
 		if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
 			return IOMMU_DOMAIN_IDENTITY;
-
-		if ((iommu_identity_mapping & IDENTMAP_GFX) && IS_GFX_DEVICE(pdev))
-			return IOMMU_DOMAIN_IDENTITY;
 	}
 
 	return 0;
@@ -2705,9 +2701,6 @@ static int __init init_dmars(void)
 		iommu_set_root_entry(iommu);
 	}
 
-	if (!dmar_map_gfx)
-		iommu_identity_mapping |= IDENTMAP_GFX;
-
 	check_tylersburg_isoch();
 
 	ret = si_domain_init(hw_pass_through);
@@ -2798,7 +2791,7 @@ static void __init init_no_remapping_devices(void)
 		/* This IOMMU has *only* gfx devices. Either bypass it or
 		   set the gfx_mapped flag, as appropriate */
 		drhd->gfx_dedicated = 1;
-		if (!dmar_map_gfx)
+		if (disable_igfx_iommu)
 			drhd->ignored = 1;
 	}
 }
@@ -4875,7 +4868,7 @@ static void quirk_iommu_igfx(struct pci_dev *dev)
 		return;
 
 	pci_info(dev, "Disabling IOMMU for graphics on this chipset\n");
-	dmar_map_gfx = 0;
+	disable_igfx_iommu = 1;
 }
 
 /* G4x/GM45 integrated gfx dmar support is totally busted. */
@@ -4956,8 +4949,8 @@ static void quirk_calpella_no_shadow_gtt(struct pci_dev *dev)
 
 	if (!(ggc & GGC_MEMORY_VT_ENABLED)) {
 		pci_info(dev, "BIOS has allocated no shadow GTT; disabling IOMMU for graphics\n");
-		dmar_map_gfx = 0;
-	} else if (dmar_map_gfx) {
+		disable_igfx_iommu = 1;
+	} else if (!disable_igfx_iommu) {
 		/* we have to ensure the gfx device is idle before we flush */
 		pci_info(dev, "Disabling batched IOTLB flush on Ironlake\n");
 		iommu_set_dma_strict();
-- 
2.43.0



