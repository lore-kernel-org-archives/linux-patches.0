Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB99B613A
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDD3C433C8;
	Wed,  9 Aug 2023 10:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577830;
	bh=QVFIyZG/GqkO1ivYyfPx42VvhK+Ld1dEwLdSIc+epRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNbjDfBy0h+HrmMTCF1c+HJ1rfQHjzNZfGO60i8vRvImgBeQ6v4SWKE99arXlOWV5
	 RF3rQBxNqua+d++UgSMXlmKHNupfTupGSizZU5dZPj7vzb2IpnREUCOcagV6jQZi9R
	 ejo6Ch2PhMfoc1+n6qDReDbnYsiCPtC0u3bbW0rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: [PATCH 6.4 002/165] iommu/arm-smmu-v3: Work around MMU-600 erratum 1076982
Date: Wed,  9 Aug 2023 12:38:53 +0200
Message-ID: <20230809103642.809440049@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robin Murphy <robin.murphy@arm.com>

commit f322e8af35c7f23a8c08b595c38d6c855b2d836f upstream

MMU-600 versions prior to r1p0 fail to correctly generate a WFE wakeup
event when the command queue transitions fom full to non-full. We can
easily work around this by simply hiding the SEV capability such that we
fall back to polling for space in the queue - since MMU-600 implements
MSIs we wouldn't expect to need SEV for sync completion either, so this
should have little to no impact.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/08adbe3d01024d8382a478325f73b56851f76e49.1683731256.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst      |    2 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   29 ++++++++++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |    6 +++++
 3 files changed, 37 insertions(+)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -143,6 +143,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | MMU-600         | #1076982        | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Broadcom       | Brahma-B53      | N/A             | ARM64_ERRATUM_845719        |
 +----------------+-----------------+-----------------+-----------------------------+
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3429,6 +3429,33 @@ static int arm_smmu_device_reset(struct
 	return 0;
 }
 
+#define IIDR_IMPLEMENTER_ARM		0x43b
+#define IIDR_PRODUCTID_ARM_MMU_600	0x483
+
+static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
+{
+	u32 reg;
+	unsigned int implementer, productid, variant, revision;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
+	implementer = FIELD_GET(IIDR_IMPLEMENTER, reg);
+	productid = FIELD_GET(IIDR_PRODUCTID, reg);
+	variant = FIELD_GET(IIDR_VARIANT, reg);
+	revision = FIELD_GET(IIDR_REVISION, reg);
+
+	switch (implementer) {
+	case IIDR_IMPLEMENTER_ARM:
+		switch (productid) {
+		case IIDR_PRODUCTID_ARM_MMU_600:
+			/* Arm erratum 1076982 */
+			if (variant == 0 && revision <= 2)
+				smmu->features &= ~ARM_SMMU_FEAT_SEV;
+			break;
+		}
+		break;
+	}
+}
+
 static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
@@ -3635,6 +3662,8 @@ static int arm_smmu_device_hw_probe(stru
 
 	smmu->ias = max(smmu->ias, smmu->oas);
 
+	arm_smmu_device_iidr_probe(smmu);
+
 	if (arm_smmu_sva_supported(smmu))
 		smmu->features |= ARM_SMMU_FEAT_SVA;
 
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -69,6 +69,12 @@
 #define IDR5_VAX			GENMASK(11, 10)
 #define IDR5_VAX_52_BIT			1
 
+#define ARM_SMMU_IIDR			0x18
+#define IIDR_PRODUCTID			GENMASK(31, 20)
+#define IIDR_VARIANT			GENMASK(19, 16)
+#define IIDR_REVISION			GENMASK(15, 12)
+#define IIDR_IMPLEMENTER		GENMASK(11, 0)
+
 #define ARM_SMMU_CR0			0x20
 #define CR0_ATSCHK			(1 << 4)
 #define CR0_CMDQEN			(1 << 3)


