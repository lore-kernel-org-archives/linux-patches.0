Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139CF1D2F79;
	Wed,  2 Oct 2024 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879486; cv=none; b=JotvRPVHHH7mJy9uPSksMks5gSgUNoY8hrykalveZwS6951QaYVvjh0snXg7MO7ADHZaIyGvVcwTK1CIBKIwCq42LWj/RFtDgl/ndNXGA9QxJ6PJc2x4M+qSRR3x4P2iJjwaH6/qUIH3L5ar5gKWX3IM2Mbef1KNDyfZ8c//VG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879486; c=relaxed/simple;
	bh=vdUslJE0kLMv5O4MeysQSmZVp1JmxdV/mM0gpHK50zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDDwnlVDKpcu+uFL6+SO2hK7qE98+bb729ub+hvv0l9acwW5J8LHayKcBwIu/xgiYeaDdl/BMG+of5yOkh5XplrG1+KFXYW/sTJvILWx6Ak/9/m9V6WlR9ApJVkHDviylg1yNzuZypEqNGIDqernDhZlVGdfw/RYdzD+OwYUQ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXk8+KZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXk8+KZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C17C4CEC5;
	Wed,  2 Oct 2024 14:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879486;
	bh=vdUslJE0kLMv5O4MeysQSmZVp1JmxdV/mM0gpHK50zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXk8+KZ1PEIJN5x8EtfbCoOnR5OPyyKLbILKEh4f5y1+uI7HTd9YcfJQzlS6KNL93
	 WKS6Rf/a66Vj6McOSrHq5xSfGYZipyRcEzF1OZGV5Tgq5vW6aYrL+9U3qXaiQD9fhY
	 jBmIy6YLM0kpA1bV7u6Gsq1mUuIBd527km3/TYEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/538] iommu/arm-smmu-qcom: apply num_context_bank fixes for SDM630 / SDM660
Date: Wed,  2 Oct 2024 14:56:15 +0200
Message-ID: <20241002125757.609507752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 19eb465c969f3d6ed1b98506d3e470e863b41e16 ]

The Qualcomm SDM630 / SDM660 platform requires the same kind of
workaround as MSM8998: some IOMMUs have context banks reserved by
firmware / TZ, touching those banks resets the board.

Apply the num_context_bank workaround to those two SMMU devices in order
to allow them to be used by Linux.

Fixes: b812834b5329 ("iommu: arm-smmu-qcom: Add sdm630/msm8998 compatibles for qcom quirks")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20240907-sdm660-wifi-v1-1-e316055142f8@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index db2092d5af5eb..d491589360197 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -282,8 +282,15 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 	 * MSM8998 LPASS SMMU reports 13 context banks, but accessing
 	 * the last context bank crashes the system.
 	 */
-	if (of_device_is_compatible(smmu->dev->of_node, "qcom,msm8998-smmu-v2") && smmu->num_context_banks == 13)
+	if (of_device_is_compatible(smmu->dev->of_node, "qcom,msm8998-smmu-v2") &&
+	    smmu->num_context_banks == 13) {
 		smmu->num_context_banks = 12;
+	} else if (of_device_is_compatible(smmu->dev->of_node, "qcom,sdm630-smmu-v2")) {
+		if (smmu->num_context_banks == 21) /* SDM630 / SDM660 A2NOC SMMU */
+			smmu->num_context_banks = 7;
+		else if (smmu->num_context_banks == 14) /* SDM630 / SDM660 LPASS SMMU */
+			smmu->num_context_banks = 13;
+	}
 
 	/*
 	 * Some platforms support more than the Arm SMMU architected maximum of
@@ -346,6 +353,11 @@ static int qcom_adreno_smmuv2_cfg_probe(struct arm_smmu_device *smmu)
 	/* Support for 16K pages is advertised on some SoCs, but it doesn't seem to work */
 	smmu->features &= ~ARM_SMMU_FEAT_FMT_AARCH64_16K;
 
+	/* TZ protects several last context banks, hide them from Linux */
+	if (of_device_is_compatible(smmu->dev->of_node, "qcom,sdm630-smmu-v2") &&
+	    smmu->num_context_banks == 5)
+		smmu->num_context_banks = 2;
+
 	return 0;
 }
 
-- 
2.43.0



