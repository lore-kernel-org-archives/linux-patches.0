Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A4119B3FF;
	Tue, 15 Oct 2024 11:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993557; cv=none; b=OosSt/dPJ9ewnDlVKjZ1cLqdKoD+XjqZWqJg5iJoUBDUlHdzJ+SVfroBQBS3PwNyiIsX5nDPoF3/HcGeE5Dj8P94NNZQp4SuUrJ1+xSoJNdjPMIxhHA+bTEHut20kBYw4cRWzVYXF3nlnhXNlP5TJLTcAqN4Vw2CmIqPYhNT3Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993557; c=relaxed/simple;
	bh=nIsIsKQmdKZ2QIxFLjJJO9DodOvXIgc4GJtxEF6NmdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWmQq4Wj5TjMsXXrIXXZrtMNIAri3VeBTqwMA2qKJJEYVON6JxP1223jttEBVQTmq57MM97qzZ0KzsdVxJUrSBJNQzhsYWWH4hoLvj9GAQTeJ2TEyz3sDbGDQaYINwEQXsvZ8ImvC4vfp7gpvhFJC5tMNLjukwnRN8jgJlSEaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBtDF0qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBtDF0qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F66C4CEC6;
	Tue, 15 Oct 2024 11:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993557;
	bh=nIsIsKQmdKZ2QIxFLjJJO9DodOvXIgc4GJtxEF6NmdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBtDF0qQEdsQj6qOkJhCWjXVNrrbu5yRCaN/CfVoI4d3u/kDGBxufhWoJ4AWLeO3R
	 lSKZf8rH/Wep79v078iZ+LC4bbDlUdjfR38HvRBO4p/tbL7pA4Wul+mIBmRZBdVhZd
	 6KXgtdJpicUJzduRV2Bd9GHtWh7THBhv1a9q/Tu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/691] iommu/arm-smmu-qcom: hide last LPASS SMMU context bank from linux
Date: Tue, 15 Oct 2024 13:26:34 +0200
Message-ID: <20241015112458.050543392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 272c9b35c9f0e..da249140ed2a1 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -254,6 +254,13 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
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



