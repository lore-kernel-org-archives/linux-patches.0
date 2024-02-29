Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1F063B9;
	Thu, 29 Feb 2024 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709224462; cv=none; b=Jw2C2mNQ1Ye7XyhZ2BWl5d0uENaCyCJ7+R+PDIc5p+GanwymSmeFkP0mQJ+t6ipgepfH3ymzDFudWw9sLSp40k1W6WGGxhSzFXiBATd2jdVprXhcaB7eaL4T8VuktqVFOM2VZmw18EbsB6jl0tHTcIzqVXws1mLni7VFiaIVIdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709224462; c=relaxed/simple;
	bh=oUDCxKw4IZbBjozLSmMzbFD3kMf1SFf5Pua5bQEOT2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l29c1sBbnUhopqSHtZ7dgt+E826A4bvZvDnV3gkPc8yVmi15GPJQxovm/0GhT1LRZR3R8Xp2373hVOlAIIUWAlfzEBnBXUkedtJOEvtSrybQr5aLn1AAdUJEMEGxG2ZxniKopKtpm5nA5d/eJdX5+DCsU54PAUjKaS+0uw5olKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAJbE37A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAJbE37A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2172C433F1;
	Thu, 29 Feb 2024 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709224462;
	bh=oUDCxKw4IZbBjozLSmMzbFD3kMf1SFf5Pua5bQEOT2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAJbE37AiPtEi4Xsr6V+9PY1UnBikaVvb7zVRPE+1F+SQFYUoE1OMWkF8Pm8gdPwj
	 x52ZSqY+V2QRmLG7QmXg3uxcTAORq8uC6E1aWSuQq5OwVLAEDVyt+HGukfZSje3hLY
	 BUFCMt8uRQ7jhEx4l7ZBycw9R+6g41SzWNQoyBzrtc7XOHlV1GUj3NzXD1QTu+vNDh
	 W3nICRRUyHAfAKGBf923cXXrHtLwAUfwApyTBQnES60y8y2w9PNw+Q1tJmWaMrB/xH
	 acmHS91S67n3GYsUAcAMvrN261zYZa0GeJchagF2Bgyy681Rt6GhB157Xe4SnsEg8o
	 uv0FfU7/GE/6A==
From: Will Deacon <will@kernel.org>
To: Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Jason Gunthorpe <jgg@nvidia.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Moritz Fischer <moritzf@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v6 00/16] Update SMMUv3 to the modern iommu API (part 1/3)
Date: Thu, 29 Feb 2024 16:34:13 +0000
Message-Id: <170921954415.3073552.7948276252050662200.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 26 Feb 2024 13:07:11 -0400, Jason Gunthorpe wrote:
> The SMMUv3 driver was originally written in 2015 when the iommu driver
> facing API looked quite different. The API has evolved, especially lately,
> and the driver has fallen behind.
> 
> This work aims to bring make the SMMUv3 driver the best IOMMU driver with
> the most comprehensive implementation of the API. After all parts it
> addresses:
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[01/16] iommu/arm-smmu-v3: Make STE programming independent of the callers
        https://git.kernel.org/will/c/ae91f6552c30
[02/16] iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
        https://git.kernel.org/will/c/12dacfb5b938
[03/16] iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into functions
        https://git.kernel.org/will/c/352bd64cd828
[04/16] iommu/arm-smmu-v3: Build the whole STE in arm_smmu_make_s2_domain_ste()
        https://git.kernel.org/will/c/d36464f40f29
[05/16] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
        https://git.kernel.org/will/c/d8cd200609cf
[06/16] iommu/arm-smmu-v3: Compute the STE only once for each master
        https://git.kernel.org/will/c/327e10b47ae9
[07/16] iommu/arm-smmu-v3: Do not change the STE twice during arm_smmu_attach_dev()
        https://git.kernel.org/will/c/8c73c32c83ce
[08/16] iommu/arm-smmu-v3: Put writing the context descriptor in the right order
        https://git.kernel.org/will/c/d2e053d73247
[09/16] iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
        https://git.kernel.org/will/c/d550ddc5b789
[10/16] iommu/arm-smmu-v3: Remove arm_smmu_master->domain
        https://git.kernel.org/will/c/1b50017d39f6
[11/16] iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
        https://git.kernel.org/will/c/ae91f6552c30
[12/16] iommu/arm-smmu-v3: Add a global static IDENTITY domain
        https://git.kernel.org/will/c/12dacfb5b938
[13/16] iommu/arm-smmu-v3: Add a global static BLOCKED domain
        https://git.kernel.org/will/c/352bd64cd828
[14/16] iommu/arm-smmu-v3: Use the identity/blocked domain during release
        https://git.kernel.org/will/c/d36464f40f29
[15/16] iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to finalize
        https://git.kernel.org/will/c/d8cd200609cf
[16/16] iommu/arm-smmu-v3: Convert to domain_alloc_paging()
        https://git.kernel.org/will/c/327e10b47ae9

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
