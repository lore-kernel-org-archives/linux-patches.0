Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A40A171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EE2C433D2;
	Mon, 22 May 2023 19:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785284;
	bh=DaCZ2HVeQLtrgWMCB9lcS1+0OuyNAwP5R7TvfKVzG4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXAoTWXaSe0BBoB9USypbah6SeKSPjqu4DGSfAKQNEqsrdNbvCTJAGtdANmkVCVc/
	 PoP7dYI5OoeFZ12yt5WVF0EcoOy6UjYBn15Rk043nbdfegcaynobbPZcUUy6juucY2
	 sx2vGAQ6h3Zspuxj3BQeeLSALyaf72KAZo77shhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lepton Wu <lepton@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.3 343/364] iommu/arm-smmu-qcom: Fix missing adreno_smmus
Date: Mon, 22 May 2023 20:10:48 +0100
Message-Id: <20230522190421.369625012@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

commit e36ca2fad6bb4ef0603bdb5556578e9082fe0056 upstream.

When the special handling of qcom,adreno-smmu was moved into
qcom_smmu_create(), it was overlooked that we didn't have all the
required entries in qcom_smmu_impl_of_match.  So we stopped getting
adreno_smmu_priv on sc7180, breaking per-process pgtables.

Fixes: 30b912a03d91 ("iommu/arm-smmu-qcom: Move the qcom,adreno-smmu check into qcom_smmu_create")
Cc: <stable@vger.kernel.org>
Suggested-by: Lepton Wu <lepton@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/537357/
Link: https://lore.kernel.org/r/20230516222039.907690-1-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -517,6 +517,7 @@ static const struct of_device_id __maybe
 	{ .compatible = "qcom,qcm2290-smmu-500", .data = &qcom_smmu_500_impl0_data },
 	{ .compatible = "qcom,qdu1000-smmu-500", .data = &qcom_smmu_500_impl0_data  },
 	{ .compatible = "qcom,sc7180-smmu-500", .data = &qcom_smmu_500_impl0_data },
+	{ .compatible = "qcom,sc7180-smmu-v2", .data = &qcom_smmu_v2_data },
 	{ .compatible = "qcom,sc7280-smmu-500", .data = &qcom_smmu_500_impl0_data },
 	{ .compatible = "qcom,sc8180x-smmu-500", .data = &qcom_smmu_500_impl0_data },
 	{ .compatible = "qcom,sc8280xp-smmu-500", .data = &qcom_smmu_500_impl0_data },
@@ -561,5 +562,14 @@ struct arm_smmu_device *qcom_smmu_impl_i
 	if (match)
 		return qcom_smmu_create(smmu, match->data);
 
+	/*
+	 * If you hit this WARN_ON() you are missing an entry in the
+	 * qcom_smmu_impl_of_match[] table, and GPU per-process page-
+	 * tables will be broken.
+	 */
+	WARN(of_device_is_compatible(np, "qcom,adreno-smmu"),
+	     "Missing qcom_smmu_impl_of_match entry for: %s",
+	     dev_name(smmu->dev));
+
 	return smmu;
 }


