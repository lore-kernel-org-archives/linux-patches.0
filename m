Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E103171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03BFC433D2;
	Mon, 22 May 2023 19:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783031;
	bh=bEhwPFSgAYO/aqAW7KRCo0ZzgXMoNX9Suxcuu8HfMqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIkl4h7uJzEMhK7eS/tg66vRhgruSn7MX2mu0efzcHK34kJ2ljYuxrWJpdbhvBWvQ
	 RV6KjjKY4CDEHCIx1CX8GUxBh9eaFlUznuiUWgeFuFEV58VHSf7m/sDAdl01/EIzqX
	 21M3QbkHSahAXJNT151mxEx0Awg/PuGY7UUbGs4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/203] iommu/arm-smmu-qcom: Limit the SMR groups to 128
Date: Mon, 22 May 2023 20:08:33 +0100
Message-Id: <20230522190357.451383912@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 12261134732689b7e30c59db9978f81230965181 ]

Some platforms support more than 128 stream matching groups than what is
defined by the ARM SMMU architecture specification. But due to some unknown
reasons, those additional groups don't exhibit the same behavior as the
architecture supported ones.

For instance, the additional groups will not detect the quirky behavior of
some firmware versions intercepting writes to S2CR register, thus skipping
the quirk implemented in the driver and causing boot crash.

So let's limit the groups to 128 for now until the issue with those groups
are fixed and issue a notice to users in that case.

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20230327080029.11584-1-manivannan.sadhasivam@linaro.org
[will: Reworded the comment slightly]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index c998960495b4e..50453d38400c5 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -247,12 +247,26 @@ static int qcom_smmu_init_context(struct arm_smmu_domain *smmu_domain,
 
 static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 {
-	unsigned int last_s2cr = ARM_SMMU_GR0_S2CR(smmu->num_mapping_groups - 1);
 	struct qcom_smmu *qsmmu = to_qcom_smmu(smmu);
+	unsigned int last_s2cr;
 	u32 reg;
 	u32 smr;
 	int i;
 
+	/*
+	 * Some platforms support more than the Arm SMMU architected maximum of
+	 * 128 stream matching groups. For unknown reasons, the additional
+	 * groups don't exhibit the same behavior as the architected registers,
+	 * so limit the groups to 128 until the behavior is fixed for the other
+	 * groups.
+	 */
+	if (smmu->num_mapping_groups > 128) {
+		dev_notice(smmu->dev, "\tLimiting the stream matching groups to 128\n");
+		smmu->num_mapping_groups = 128;
+	}
+
+	last_s2cr = ARM_SMMU_GR0_S2CR(smmu->num_mapping_groups - 1);
+
 	/*
 	 * With some firmware versions writes to S2CR of type FAULT are
 	 * ignored, and writing BYPASS will end up written as FAULT in the
-- 
2.39.2



