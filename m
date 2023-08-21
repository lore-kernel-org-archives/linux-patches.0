Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BDB11707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE9EC433C7;
	Mon, 21 Aug 2023 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647594;
	bh=ErWUxBFRYBwgi5LFB2OADU2sJaz0VO2puo1+XpykQq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr9+Nh658KQKt7NT2s5K4ycnG6VJF5cGWA+HaHCEFjm9PP5fRsFTBMPOjUdNQPf4P
	 qVI3i11QsyJZLitTbA9j8kg0t6WSudK48VUWf61gtNyGXNs5jAKszglw59N9X+5ylR
	 LMBFasp9LzCZJwawpLCJDNKJPgtqqbmbZnBIfFgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/194] iommu/amd: Introduce Disable IRTE Caching Support
Date: Mon, 21 Aug 2023 21:40:09 +0200
Message-ID: <20230821194124.128047591@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 66419036f68a838c00cbccacd6cb2e99da6e5710 ]

An Interrupt Remapping Table (IRT) stores interrupt remapping configuration
for each device. In a normal operation, the AMD IOMMU caches the table
to optimize subsequent data accesses. This requires the IOMMU driver to
invalidate IRT whenever it updates the table. The invalidation process
includes issuing an INVALIDATE_INTERRUPT_TABLE command following by
a COMPLETION_WAIT command.

However, there are cases in which the IRT is updated at a high rate.
For example, for IOMMU AVIC, the IRTE[IsRun] bit is updated on every
vcpu scheduling (i.e. amd_iommu_update_ga()). On system with large
amount of vcpus and VFIO PCI pass-through devices, the invalidation
process could potentially become a performance bottleneck.

Introducing a new kernel boot option:

    amd_iommu=irtcachedis

which disables IRTE caching by setting the IRTCachedis bit in each IOMMU
Control register, and bypass the IRT invalidation process.

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Co-developed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20230530141137.14376-4-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  1 +
 drivers/iommu/amd/amd_iommu_types.h           |  4 +++
 drivers/iommu/amd/init.c                      | 36 +++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 286be425f3bfa..882b6198dd0d1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -323,6 +323,7 @@
 				       option with care.
 			pgtbl_v1     - Use v1 page table for DMA-API (Default).
 			pgtbl_v2     - Use v2 page table for DMA-API.
+			irtcachedis  - Disable Interrupt Remapping Table (IRT) caching.
 
 	amd_iommu_dump=	[HW,X86-64]
 			Enable AMD IOMMU driver option to dump the ACPI table
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 5ecc17240eff5..f5e9377b55212 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -172,6 +172,7 @@
 #define CONTROL_GAINT_EN	29
 #define CONTROL_XT_EN		50
 #define CONTROL_INTCAPXT_EN	51
+#define CONTROL_IRTCACHEDIS	59
 #define CONTROL_SNPAVIC_EN	61
 
 #define CTRL_INV_TO_MASK	(7 << CONTROL_INV_TIMEOUT)
@@ -708,6 +709,9 @@ struct amd_iommu {
 	/* if one, we need to send a completion wait command */
 	bool need_sync;
 
+	/* true if disable irte caching */
+	bool irtcachedis_enabled;
+
 	/* Handle for IOMMU core code */
 	struct iommu_device iommu;
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index b0af8b5967e0d..f6e64c9858021 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -160,6 +160,7 @@ static int amd_iommu_xt_mode = IRQ_REMAP_XAPIC_MODE;
 static bool amd_iommu_detected;
 static bool amd_iommu_disabled __initdata;
 static bool amd_iommu_force_enable __initdata;
+static bool amd_iommu_irtcachedis;
 static int amd_iommu_target_ivhd_type;
 
 /* Global EFR and EFR2 registers */
@@ -477,6 +478,9 @@ static void iommu_disable(struct amd_iommu *iommu)
 
 	/* Disable IOMMU hardware itself */
 	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
+
+	/* Clear IRTE cache disabling bit */
+	iommu_feature_disable(iommu, CONTROL_IRTCACHEDIS);
 }
 
 /*
@@ -2700,6 +2704,33 @@ static void iommu_enable_ga(struct amd_iommu *iommu)
 #endif
 }
 
+static void iommu_disable_irtcachedis(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_IRTCACHEDIS);
+}
+
+static void iommu_enable_irtcachedis(struct amd_iommu *iommu)
+{
+	u64 ctrl;
+
+	if (!amd_iommu_irtcachedis)
+		return;
+
+	/*
+	 * Note:
+	 * The support for IRTCacheDis feature is dertermined by
+	 * checking if the bit is writable.
+	 */
+	iommu_feature_enable(iommu, CONTROL_IRTCACHEDIS);
+	ctrl = readq(iommu->mmio_base +  MMIO_CONTROL_OFFSET);
+	ctrl &= (1ULL << CONTROL_IRTCACHEDIS);
+	if (ctrl)
+		iommu->irtcachedis_enabled = true;
+	pr_info("iommu%d (%#06x) : IRT cache is %s\n",
+		iommu->index, iommu->devid,
+		iommu->irtcachedis_enabled ? "disabled" : "enabled");
+}
+
 static void early_enable_iommu(struct amd_iommu *iommu)
 {
 	iommu_disable(iommu);
@@ -2710,6 +2741,7 @@ static void early_enable_iommu(struct amd_iommu *iommu)
 	iommu_set_exclusion_range(iommu);
 	iommu_enable_ga(iommu);
 	iommu_enable_xt(iommu);
+	iommu_enable_irtcachedis(iommu);
 	iommu_enable(iommu);
 	iommu_flush_all_caches(iommu);
 }
@@ -2760,10 +2792,12 @@ static void early_enable_iommus(void)
 		for_each_iommu(iommu) {
 			iommu_disable_command_buffer(iommu);
 			iommu_disable_event_buffer(iommu);
+			iommu_disable_irtcachedis(iommu);
 			iommu_enable_command_buffer(iommu);
 			iommu_enable_event_buffer(iommu);
 			iommu_enable_ga(iommu);
 			iommu_enable_xt(iommu);
+			iommu_enable_irtcachedis(iommu);
 			iommu_set_device_table(iommu);
 			iommu_flush_all_caches(iommu);
 		}
@@ -3411,6 +3445,8 @@ static int __init parse_amd_iommu_options(char *str)
 			amd_iommu_pgtable = AMD_IOMMU_V1;
 		} else if (strncmp(str, "pgtbl_v2", 8) == 0) {
 			amd_iommu_pgtable = AMD_IOMMU_V2;
+		} else if (strncmp(str, "irtcachedis", 11) == 0) {
+			amd_iommu_irtcachedis = true;
 		} else {
 			pr_notice("Unknown option - '%s'\n", str);
 		}
-- 
2.40.1



