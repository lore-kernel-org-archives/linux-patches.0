Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FC234844D;
	Tue, 16 Dec 2025 12:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888169; cv=none; b=Cmt5kk5hIwykJMn6M+8hymUJm7FU0i1f+0IMe4o2a75puDx4GA8Zue9jRT2ZiLVQz49v15E2EKw9nxowAvEDI01RSLDIFMtulDEp6F8xfA4qLj+djIwjisrHkBq9AVpzeZpt8Tscf4iIZO2eyU2RuPxuGCATq48RurJPD3y6dh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888169; c=relaxed/simple;
	bh=FX9GDEEEBVORWPSfRHxlh4atdYnYVAgmkK5MflrN2eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq0lnJSB35jQ/EyGVuLEwsjmRaCcCVmYSRdwa9gyT8flBls79uulAXABkXAFmHQUtNcnOIzofFj3vpEjM3J6YRwHghRUVg+oq6Ob/FaKU99DWPO5wJnwTJqRFqUnhU+ni8xJ+WL1E51CdT7mjrFLR8fdPw8vm76Ibhi3uwYtFFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea6COSOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea6COSOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC36BC4CEF1;
	Tue, 16 Dec 2025 12:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888169;
	bh=FX9GDEEEBVORWPSfRHxlh4atdYnYVAgmkK5MflrN2eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ea6COSOjZMunqMfJ7qvjn3IP3XcBlqSEhGRfb3TJlVsOnQX8JkRX87fcFRdctjZTl
	 UeYARdz1JCFiCROTq7X0On/iS4gsDsvU4OuxSYp+X/1pjfuRpcGal0kZAj2wNJXwgY
	 YbdDG9YzE64t4qY/OWnk9+wFrB05AyFoA2ggNCis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 420/614] iommu/arm-smmu-qcom: Enable use of all SMR groups when running bare-metal
Date: Tue, 16 Dec 2025 12:13:07 +0100
Message-ID: <20251216111416.588037678@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 5583a55e074b33ccd88ac0542fd7cd656a7e2c8c ]

Some platforms (e.g. SC8280XP and X1E) support more than 128 stream
matching groups. This is more than what is defined as maximum by the ARM
SMMU architecture specification. Commit 122611347326 ("iommu/arm-smmu-qcom:
Limit the SMR groups to 128") disabled use of the additional groups because
they don't exhibit the same behavior as the architecture supported ones.

It seems like this is just another quirk of the hypervisor: When running
bare-metal without the hypervisor, the additional groups appear to behave
just like all others. The boot firmware uses some of the additional groups,
so ignoring them in this situation leads to stream match conflicts whenever
we allocate a new SMR group for the same SID.

The workaround exists primarily because the bypass quirk detection fails
when using a S2CR register from the additional matching groups, so let's
perform the test with the last reliable S2CR (127) and then limit the
number of SMR groups only if we detect that we are running below the
hypervisor (because of the bypass quirk).

Fixes: 122611347326 ("iommu/arm-smmu-qcom: Limit the SMR groups to 128")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 27 ++++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 57c097e876130..c939d0856b719 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -431,17 +431,19 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 
 	/*
 	 * Some platforms support more than the Arm SMMU architected maximum of
-	 * 128 stream matching groups. For unknown reasons, the additional
-	 * groups don't exhibit the same behavior as the architected registers,
-	 * so limit the groups to 128 until the behavior is fixed for the other
-	 * groups.
+	 * 128 stream matching groups. The additional registers appear to have
+	 * the same behavior as the architected registers in the hardware.
+	 * However, on some firmware versions, the hypervisor does not
+	 * correctly trap and emulate accesses to the additional registers,
+	 * resulting in unexpected behavior.
+	 *
+	 * If there are more than 128 groups, use the last reliable group to
+	 * detect if we need to apply the bypass quirk.
 	 */
-	if (smmu->num_mapping_groups > 128) {
-		dev_notice(smmu->dev, "\tLimiting the stream matching groups to 128\n");
-		smmu->num_mapping_groups = 128;
-	}
-
-	last_s2cr = ARM_SMMU_GR0_S2CR(smmu->num_mapping_groups - 1);
+	if (smmu->num_mapping_groups > 128)
+		last_s2cr = ARM_SMMU_GR0_S2CR(127);
+	else
+		last_s2cr = ARM_SMMU_GR0_S2CR(smmu->num_mapping_groups - 1);
 
 	/*
 	 * With some firmware versions writes to S2CR of type FAULT are
@@ -464,6 +466,11 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 
 		reg = FIELD_PREP(ARM_SMMU_CBAR_TYPE, CBAR_TYPE_S1_TRANS_S2_BYPASS);
 		arm_smmu_gr1_write(smmu, ARM_SMMU_GR1_CBAR(qsmmu->bypass_cbndx), reg);
+
+		if (smmu->num_mapping_groups > 128) {
+			dev_notice(smmu->dev, "\tLimiting the stream matching groups to 128\n");
+			smmu->num_mapping_groups = 128;
+		}
 	}
 
 	for (i = 0; i < smmu->num_mapping_groups; i++) {
-- 
2.51.0



