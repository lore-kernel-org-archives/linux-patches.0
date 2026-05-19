Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA423EA974;
	Tue, 19 May 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204232; cv=none; b=fb++FhlZUVn/GqM+3O/dYZ2ItvSc+cjbEcfaDxkzABfGdTjlC1froqLsuJ/Eux82mUgyb2c1K2QNizOUyCcF6sgbO7hBVNvjmBERSiQyogYlp4OwcnrDzCj17XA3/vh41xTM2X0OJJPcp4wpiZrYrcLFDQe02enZJx2p5pkN4Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204232; c=relaxed/simple;
	bh=EcYgGA7+qxpGDVJn+BOWyz9F6ILNNr7DE0ak3LTgO3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/ATJq1PsiRP/i+uRNTlQuY+Uk8Mh/MHXzWIGs7JvEjnQLo0lDHcdK5Ca3ccWWFk5O5gP7txTvNoftz01rdQqTcgov4S1ZKGHijNRUFhIpNHx4x1sKxSmdNwm67iSSnt+BswjZ6FBgB2wmdSCpwQKFzgRc3cSOUNxmhPoSLfgNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwVnXFU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwVnXFU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD92C2BCB3;
	Tue, 19 May 2026 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204232;
	bh=EcYgGA7+qxpGDVJn+BOWyz9F6ILNNr7DE0ak3LTgO3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwVnXFU0sfkq9f5+QC+fiz9RkLgBmIu78FNEThTdjkRihuLffFJD+bjCOtRBBF4Tu
	 qxYaQo0oLYzphwHooYty8/w2PUsj1WdRBUvmEBBXfjxLnmEAB9EK1Ic3faW9h1aInA
	 SFvHAdif9+B8ooFvTohsIEQxdi1UFiZdejEOiL2KpBp42+qJuTVxndR19UVRpKEMpC
	 5SYqYaNnlO9Oh2WR6rmfXVCkGzupA4IdHJiCa/suAhYyKPzFRRrJ6xT7kxBTCOpEgc
	 ZKQNncFlTuZXJlLCvCu4UUILTCsK57QB7AA8xF8XkmIzWOdVh1K+1oWeimhB7aboX4
	 roEEhF26lB/YQ==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/9] Remove SMMUv3 struct arm_smmu_cmdq_ent
Date: Tue, 19 May 2026 16:22:58 +0100
Message-ID: <177919957385.1012282.14787407041669291032.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 13 May 2026 20:57:39 -0300, Jason Gunthorpe wrote:
> [ This is part of the patch pile to move SMMUv3 over to the generic page
> table:
> 1) Introduction of new gather items and RISCV usage
>   https://patch.msgid.link/r/0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com
> 2) Remove SMMUv3 struct arm_smmu_cmdq_ent
> 3) Organize the SMMUv3 invalidation flow so iommupt can use it
> 4) Use the generic iommu page table for SMMUv3
> 
> [...]

Applied to iommu (arm/smmu/updates), thanks!

[1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to represent the HW format command
      https://git.kernel.org/iommu/c/bf00a29234a4
[2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq selection functions
      https://git.kernel.org/iommu/c/f59c5b6858d8
[3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq submission functions
      https://git.kernel.org/iommu/c/d455e3a7bf0a
[4/9] iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch cmds to struct arm_smmu_cmd
      https://git.kernel.org/iommu/c/27e02ca61552
[5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from arm_smmu_cmdq_build_cmd()
      https://git.kernel.org/iommu/c/c5758947cb7b
[6/9] iommu/arm-smmu-v3: Directly encode simple commands
      https://git.kernel.org/iommu/c/6e771be45e8a
[7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
      https://git.kernel.org/iommu/c/2eedb906f9c6
[8/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_SYNC
      https://git.kernel.org/iommu/c/c3f84707ad4f
[9/9] iommu/arm-smmu-v3: Directly encode TLBI commands
      https://git.kernel.org/iommu/c/be0d0b858861

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
