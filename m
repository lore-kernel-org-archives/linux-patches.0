Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE8711706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B9CC433C8;
	Mon, 11 Sep 2023 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443915;
	bh=fktS4vv5nKA85dUZuPFDYsPZYPMLwfhHbAdCnOXscA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsvkRsPwZ5bsmzStu32A+I4hpGzf28CNsQFx4UBm/oz+yOzCWC4NGibbxmLbu80MG
	 6PhEcVXvw7sewy08ou8yyrQCBZig9B06+H4VAXiIYu6n5HWOqqWxvfxpg0Ons0gTRl
	 jfobO1r8gezzhG0ZeVG45yJsbLLWtx4SpGDlvxHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 545/737] iommu/qcom: Disable and reset context bank before programming
Date: Mon, 11 Sep 2023 15:46:44 +0200
Message-ID: <20230911134705.785257082@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 9f3fef23d9b5a858a6e6d5f478bb1b6b76265e76 ]

Writing	the new	TTBRs, TCRs and MAIRs on a previously enabled
context bank may trigger a context fault, resulting in firmware
driven AP resets: change the domain initialization programming
sequence to disable the context bank(s) and to also clear the
related fault address (CB_FAR) and fault status (CB_FSR)
registers before writing new values to TTBR0/1, TCR/TCR2, MAIR0/1.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230622092742.74819-4-angelogioacchino.delregno@collabora.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index a503ed758ec30..3e551ca6afdb9 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -273,6 +273,13 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
 			ctx->secure_init = true;
 		}
 
+		/* Disable context bank before programming */
+		iommu_writel(ctx, ARM_SMMU_CB_SCTLR, 0);
+
+		/* Clear context bank fault address fault status registers */
+		iommu_writel(ctx, ARM_SMMU_CB_FAR, 0);
+		iommu_writel(ctx, ARM_SMMU_CB_FSR, ARM_SMMU_FSR_FAULT);
+
 		/* TTBRs */
 		iommu_writeq(ctx, ARM_SMMU_CB_TTBR0,
 				pgtbl_cfg.arm_lpae_s1_cfg.ttbr |
-- 
2.40.1



