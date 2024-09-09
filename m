Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFD814D6FE;
	Mon,  9 Sep 2024 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725898568; cv=none; b=lRBq3Fsh8aJGk8+mqbthA8ZmSCh+wifXa++1TB666UbCUBV6bdU+qQSfrkpzdnjUqtrAcSRg7kCiWS5YsZshMUDpVdjbnlayg0zIK3iT5zB1X2IwGq148CqIBqlhzNGf+DUkrY8BuUYwxH7LzLyL/a+foqWCtCiLlqkX4rloEpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725898568; c=relaxed/simple;
	bh=eovoPXc7aEQEHLLu97GHHuv31EVw6+SkozIo9mYcwDA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=di/kC6Yx/iXPsofq7Lpl5ExEGrEJpHLUqfHtyfZu4EkhVpyHKJlD2VDTTiXXlwSD8azevWzzFJ3XihitMq4ytOxR/OztSDwbHXjDsNMlZCcVEzNspdqYjWN0py0C3Pnp2c23S4F+Bb6GzMQw/P+M4o9AW3D8a3jVTj1fz7+Np9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XmunNZBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XmunNZBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A85C4CEC5;
	Mon,  9 Sep 2024 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725898567;
	bh=eovoPXc7aEQEHLLu97GHHuv31EVw6+SkozIo9mYcwDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmunNZBKk0u7X9JO4E1WQ/4X0VG0TkfK0N6vHscKClCYOjVunXQnRmMTtoFJ5iNSh
	 6eKpY7oTjFi4b/ViBXr/NEBRxQG+wZw3ACCn2VTrjE26I8eJipmpBwMyGHxNxjTzUs
	 zhaYxA2ipCvv+Fiqwjdc+zCIsu3iIScprCTMMjF8DvuEfn77OGA0kTehiNCRCfGjav
	 nFMdo5vl8gpa/bNhTPMniN5rZbwhOVdQIzBi0h8I6NPHHHQRdA2ghPRI/zyeONDzYL
	 RQlG61QrQRPVNigzpE+LC6/4cnl0xAsq6uDDnSHZH0o5TcfXtCagkuA3EiBU4ZDRa4
	 nteDA9GHsnHMQ==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 0/8] Tidy some minor things in the stream table/cd table area
Date: Mon,  9 Sep 2024 17:15:46 +0100
Message-Id: <172589323615.3415769.3962371038080294067.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 06 Sep 2024 12:47:47 -0300, Jason Gunthorpe wrote:
> Will pointed out that two places referring to the CD/STE struct did not
> get the new types. While auditing this code a few more oddities were
> noticed. Based on a feedback from Mostafa and Nicolin a few more things
> were fixed up too
> 
> - Use types for all the HW structures everywhere even for the L1
>   descriptors that are just a single 8 bytes. This helps with clarity of
>   what everthing is pointing at
> - Use indexing helpers for the STE/CD two level calculations
> - Use sizeof(struct X) instead of open coded math on constants. The sizeof
>   naturally follows the type of the related variable in almost all cases
> - Remove redundant dma_addr_t's and save some memory
> - Remove redundant devm usage
> - Use the modern rbtree API
> 
> [...]

Thanks Jason, I like the look of this a lot more now.

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/8] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
      https://git.kernel.org/will/c/ce410410f1a7
[2/8] iommu/arm-smmu-v3: Add types for each level of the 2 level stream table
      https://git.kernel.org/will/c/abb4f9d323a8
[3/8] iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
      https://git.kernel.org/will/c/85196f54743d
[4/8] iommu/arm-smmu-v3: Remove strtab_base/cfg
      https://git.kernel.org/will/c/8c153ef95697
[5/8] iommu/arm-smmu-v3: Do not use devm for the cd table allocations
      https://git.kernel.org/will/c/47b2de35cab2
[6/8] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
      https://git.kernel.org/will/c/c0a25a96dee9
[7/8] iommu/arm-smmu-v3: Add types for each level of the CD table
      https://git.kernel.org/will/c/7c567eb1e1d2
[8/8] iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg
      https://git.kernel.org/will/c/e3b1be2e73db

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
