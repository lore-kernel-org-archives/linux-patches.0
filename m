Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC6216F84F;
	Wed,  2 Oct 2024 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875801; cv=none; b=XaSv+xXMsazyHLJQ7mWpWQOp+q9Qd4hF5452ol6UmWvNge5yqlN6ndGZNp8CTlKTbPWIHmSA1tmRjSlSyLfUMOVfSotTf9VhX1B7sVpjtlIIfKNKYN7GIFbnTelOtJKrUuE0F1h1ZrlChF961fpiMQ1nle59sFOezOto6SkNmrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875801; c=relaxed/simple;
	bh=AZaRzDPi8jwmP0P12UoGPTj+3eISPS9qkHCAoI6ITeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQa6dw3GmiW55v+ky+T2e6ifsgemjUE7et3prYVcnoJC6epWl003MsTJqtWSZ223L8OZzUyrBA0MTK2/mB0ZXy8AIlY7zTFp5EjawU5HXTYKflwgaciJMUv0SonXNVgwNkWP9qaqnaABT7VWRLquX9sOFWSI6fC1Ox9A4udfFIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfEtQnrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfEtQnrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B5FC4CEC5;
	Wed,  2 Oct 2024 13:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875800;
	bh=AZaRzDPi8jwmP0P12UoGPTj+3eISPS9qkHCAoI6ITeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfEtQnrzlrvHivK143f86CCLYvV7TiWD6sX5PbSuEEuwklVGkrwJfCustUogcxWDG
	 0VQbsbX4z6Vkz61FPjEqcwuSQnluDxN0HElVU3aygXPbblWZPl1jGWIYJjICY0A/wQ
	 2xh6RxDwOzjS5fD+m00vzO888cJDXgv4+3jxkK5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 194/695] iommu/arm-smmu-qcom: Work around SDM845 Adreno SMMU w/ 16K pages
Date: Wed,  2 Oct 2024 14:53:12 +0200
Message-ID: <20241002125830.211308474@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 2d42d3ba443706c9164fa0bef4e5fd1c36bc1bd9 ]

SDM845's Adreno SMMU is unique in that it actually advertizes support
for 16K (and 32M) pages, which doesn't hold for newer SoCs.

This however, seems either broken in the hardware implementation, the
hypervisor middleware that abstracts the SMMU, or there's a bug in the
Linux kernel somewhere down the line that nobody managed to track down.

Booting SDM845 with 16K page sizes and drm/msm results in:

*** gpu fault: ttbr0=0000000000000000 iova=000100000000c000 dir=READ
type=TRANSLATION source=CP (0,0,0,0)

right after loading the firmware. The GPU then starts spitting out
illegal intstruction errors, as it's quite obvious that it got a
bogus pointer.

Moreover, it seems like this issue also concerns other implementations
of SMMUv2 on Qualcomm SoCs, such as the one on SC7180.

Hide 16K support on such instances to work around this.

Reported-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240824-topic-845_gpu_smmu-v2-1-a302b8acc052@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 19eb465c969f ("iommu/arm-smmu-qcom: apply num_context_bank fixes for SDM630 / SDM660")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index b981ff25a983d..087fb4f6f4d3d 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -345,6 +345,14 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 	return 0;
 }
 
+static int qcom_adreno_smmuv2_cfg_probe(struct arm_smmu_device *smmu)
+{
+	/* Support for 16K pages is advertised on some SoCs, but it doesn't seem to work */
+	smmu->features &= ~ARM_SMMU_FEAT_FMT_AARCH64_16K;
+
+	return 0;
+}
+
 static void qcom_smmu_write_s2cr(struct arm_smmu_device *smmu, int idx)
 {
 	struct arm_smmu_s2cr *s2cr = smmu->s2crs + idx;
@@ -443,6 +451,7 @@ static const struct arm_smmu_impl sdm845_smmu_500_impl = {
 
 static const struct arm_smmu_impl qcom_adreno_smmu_v2_impl = {
 	.init_context = qcom_adreno_smmu_init_context,
+	.cfg_probe = qcom_adreno_smmuv2_cfg_probe,
 	.def_domain_type = qcom_smmu_def_domain_type,
 	.alloc_context_bank = qcom_adreno_smmu_alloc_context_bank,
 	.write_sctlr = qcom_adreno_smmu_write_sctlr,
-- 
2.43.0



