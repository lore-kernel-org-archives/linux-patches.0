Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D30B1CF284;
	Wed,  2 Oct 2024 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875798; cv=none; b=lY/nd+0RCUCvAdywLJpXEsqwS3WUpFMlCPH/X0KOqUwpGYzrf8Mkv7rXr5UocFgPppv3agNELiyxj7flv2cMfgSDXayggJZfFyfHmBNXat7IsXKwMTWkq6RKV/JrMRP759h9QLeF4ti6cDDpx2vFZOTnjkF7kCqlsRxz4FgzldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875798; c=relaxed/simple;
	bh=QAn4w3qA4zAZLjjlzIqgo74qvxcGDOe0EeZn3+GGY3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXSXFhSElTrXmbvkRWuljw8JcUrFB7qBXbzuzi14UPd/1RN/M5nV8nELN9zGctwjNW9ar5A/jzsxjpsCkdmQV/NKHhy8xhJH4OqweuCobnz8jkCAMw4IrLFKWASqoE0K8WJDmzyc6XvJqHBBFtuJyFtkvs9iaGdV/iZ7P1yv7dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr3cQeY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr3cQeY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B19FC4CEC5;
	Wed,  2 Oct 2024 13:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875797;
	bh=QAn4w3qA4zAZLjjlzIqgo74qvxcGDOe0EeZn3+GGY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr3cQeY5rkLCPp38U4Wcdp5GbCMkyKFtSyVRx/segN4O4b8GH5G3MuW7pDC4zJhNT
	 cSL4UN+fA7avbKeZEmDF15TEixeK4fK1nP3UxvGEsto0FThxHzIepnhbeMoy3R2bGm
	 1av2i2Vvz7FIHomHu7EneSmyL4p4JtGSgGC9k6HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 193/695] iommu/arm-smmu-qcom: hide last LPASS SMMU context bank from linux
Date: Wed,  2 Oct 2024 14:53:11 +0200
Message-ID: <20241002125830.172431253@linuxfoundation.org>
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

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit 3a8990b8a778219327c5f8ecf10b5d81377b925a ]

On qcom msm8998, writing to the last context bank of lpass_q6_smmu
(base address 0x05100000) produces a system freeze & reboot.

The hardware/hypervisor reports 13 context banks for the LPASS SMMU
on msm8998, but only the first 12 are accessible...
Override the number of context banks

[    2.546101] arm-smmu 5100000.iommu: probing hardware configuration...
[    2.552439] arm-smmu 5100000.iommu: SMMUv2 with:
[    2.558945] arm-smmu 5100000.iommu: 	stage 1 translation
[    2.563627] arm-smmu 5100000.iommu: 	address translation ops
[    2.568923] arm-smmu 5100000.iommu: 	non-coherent table walk
[    2.574566] arm-smmu 5100000.iommu: 	(IDR0.CTTW overridden by FW configuration)
[    2.580220] arm-smmu 5100000.iommu: 	stream matching with 12 register groups
[    2.587263] arm-smmu 5100000.iommu: 	13 context banks (0 stage-2 only)
[    2.614447] arm-smmu 5100000.iommu: 	Supported page sizes: 0x63315000
[    2.621358] arm-smmu 5100000.iommu: 	Stage-1: 36-bit VA -> 36-bit IPA
[    2.627772] arm-smmu 5100000.iommu: 	preserved 0 boot mappings

Specifically, the crashes occur here:

	qsmmu->bypass_cbndx = smmu->num_context_banks - 1;
	arm_smmu_cb_write(smmu, qsmmu->bypass_cbndx, ARM_SMMU_CB_SCTLR, 0);

and here:

	arm_smmu_write_context_bank(smmu, i);
	arm_smmu_cb_write(smmu, i, ARM_SMMU_CB_FSR, ARM_SMMU_CB_FSR_FAULT);

It is likely that FW reserves the last context bank for its own use,
thus a simple work-around is: DON'T USE IT in Linux.

If we decrease the number of context banks, last one will be "hidden".

Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20240820-smmu-v3-1-2f71483b00ec@freebox.fr
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 19eb465c969f ("iommu/arm-smmu-qcom: apply num_context_bank fixes for SDM630 / SDM660")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 36c6b36ad4ff7..b981ff25a983d 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -282,6 +282,13 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 	u32 smr;
 	int i;
 
+	/*
+	 * MSM8998 LPASS SMMU reports 13 context banks, but accessing
+	 * the last context bank crashes the system.
+	 */
+	if (of_device_is_compatible(smmu->dev->of_node, "qcom,msm8998-smmu-v2") && smmu->num_context_banks == 13)
+		smmu->num_context_banks = 12;
+
 	/*
 	 * Some platforms support more than the Arm SMMU architected maximum of
 	 * 128 stream matching groups. For unknown reasons, the additional
-- 
2.43.0



