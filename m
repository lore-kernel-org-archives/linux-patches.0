Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D60A2C0F83;
	Thu, 15 Jan 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499084; cv=none; b=ddBScxKoWKA5CNYb2YR/yes8m1prenL2scKbfUnTWGryp+MTjjP0KDAbXETMKCX9ohSXik9oEhfhY0LH0Jasv8aROdMG8D2vbHJnbvvK27eR6hAhi2+czzoPkgTFPMbAA8I6nUqDuAkZV2b98bUE2FzGNYcwCz6FNgje/mfn1aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499084; c=relaxed/simple;
	bh=t2NlCwQ/mOYSblTEclKx5XxybQqqQ1yDlJtXHd1sFIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmWxA+hCrpc4YJCOXKkjD63vxu3lbZYklvHHuhDX4+Go2bjeCudgrmfeqgrlyNy80ZmdY2bYGdVs0UVtnYYENE7ATP+N6zABoVpYSFFkDJQKZ7gSUzpooT/cjTX3AW1BrNjqpgmz74EmuPCVmPtWaIlJSa4ir3etLHRe5+RU+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NbJYs69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NbJYs69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAB0C116D0;
	Thu, 15 Jan 2026 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499084;
	bh=t2NlCwQ/mOYSblTEclKx5XxybQqqQ1yDlJtXHd1sFIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NbJYs69qHh38KhboIdeyRsjRs6p/9wORduykV2xOrg8G8ehV2ZNoFbX48nYNdqwt
	 hUzNpxwhCBs3BSLWN72esdf/lfgM4kEVqgIKHbPirsDTg9xKNVR8uLHvUmrgmWJHhA
	 ftMbwRpyWz1saa/PzEp/R/3ipf3hxnVoMHrMmA8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/451] iommu/arm-smmu-qcom: Enable use of all SMR groups when running bare-metal
Date: Thu, 15 Jan 2026 17:45:04 +0100
Message-ID: <20260115164234.644366525@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 91d9c4d98f39b..af1191a81e29a 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -48,17 +48,19 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 
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
@@ -81,6 +83,11 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 
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



