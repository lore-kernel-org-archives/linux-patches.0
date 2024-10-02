Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6A41D27BA;
	Wed,  2 Oct 2024 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877733; cv=none; b=R22K85eKOBf+IXxltya1BZe+49+hn7tMzokTTayAEsKB1VLfXZ1Mue7ShliBP9aGw4zcJlCqWbGSv2xxqK8IERxiVayGv+pHIt5Y27RXnunLZBWm1f5lQjyCcQe4iTkQ03t/t/yRRuolvI+74Uhi1vurDk72kESpiWikG31bgdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877733; c=relaxed/simple;
	bh=0Tb7uPf6+HwDJCwkZoBFfSy9HR8FH7EgbBMrc6rUQHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRKsCn0l+lcnurPHUXebgZ/T+p2oXNvZa1a2CrFP2GQOMGrMIRk85gfUVSPvYsQzdrZHlieiNlZRvW/q5C3wEcHtuiEEBybkToV4uQK+62oiEOtPoS7EA4AC9qQ2K7XMn7w+K3tHviOg5Y98vhOlid1ppIRuz0zz4kPWgtb6uBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TcFp7Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TcFp7Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B2CC4CEC2;
	Wed,  2 Oct 2024 14:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877733;
	bh=0Tb7uPf6+HwDJCwkZoBFfSy9HR8FH7EgbBMrc6rUQHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TcFp7Knc4qBgbO7E6emAXiWojkpZgVBpZMvVG0AOV3MXhZHwAvURM8Yx2E6tk4xk
	 0TtGX8OXHE/JN3mS7zSHMeZg4w9u3i5fLF/+La2fhZtLXz6DYOJ5w5yGqNyq54cxnd
	 kZYfukUyqEkx0r5BQUj3evfBribaT2RL8X+ZuSw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 176/634] iommu/arm-smmu-qcom: Work around SDM845 Adreno SMMU w/ 16K pages
Date: Wed,  2 Oct 2024 14:54:36 +0200
Message-ID: <20241002125818.055475775@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8bc71449aabc3..eff090b1f4fc7 100644
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



