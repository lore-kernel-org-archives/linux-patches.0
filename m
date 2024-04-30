Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23A217B4F7;
	Tue, 30 Apr 2024 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497512; cv=none; b=KD2xvla1WQshGhxQdp1kUsTzUHh9CAz+3ICIdZdl6IwB7CqX9eXWoJ4Ur5cM0tni3YxwFC4JOqMMqdT1TcDRUoIa/g6MMur2asEG+myY3KLUmRP62GcigL7cGRxt0osiVOv3RnHEedSoowYyfebtEibylS/HHIYYHAwBH2HyKps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497512; c=relaxed/simple;
	bh=ekvSe16ZEAis2EeYG0FbxMmTzOneckdxbOseR0s1uH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0xjZXc96odO8ua7tMSn0o4XbRv1bT/G4ux1S7Mv2U4hAb32+SEkaH56q++9K6xg622/IVo9ESs5l72RJyIuJXw9fsYH2bRDYiI80Hf3GPYoA4FcyyHEuD0OE3+vL4yfx0iqoNpg8WoNbcjUuTntuaSl1dUyV5+F7Bggn+LlYzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pew/xl1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pew/xl1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A8CC2BBFC;
	Tue, 30 Apr 2024 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714497511;
	bh=ekvSe16ZEAis2EeYG0FbxMmTzOneckdxbOseR0s1uH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pew/xl1OwH2pHeOsWNRx94UPEXeoE/RTYXRvlO4/uip7KBICjy+Jzukb+lwFzlvb7
	 IXvslCAzTWF0WXRUcL2vxY92IfFtANne2E/Tom/mM+lRTw4gF6JIKALpTngMS+lOBs
	 cIrjD+ixJNlhKuwwvIQmX0e1VowOaCrEqd15OQZUduSVIUEk0fwPAbrlHuV5Vs6AJQ
	 EHh4L61S8lnyptAq8vGYIvewCce6lN2X2VaWDGXRd86NWNUMn9thdez4f53V6wkFmy
	 H/6Pt0QW5pTuSsPuyH5jiZ/46ezfIk0lhHrTQD9mF2bAmWuhMRI8XrPQNd0xii3t+F
	 xfLYTjjiN5DyQ==
Date: Tue, 30 Apr 2024 18:18:25 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v8 0/9] Make the SMMUv3 CD logic match the new STE design
 (part 2a/3)
Message-ID: <20240430171825.GA14557@willie-the-truck>
References: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Tue, Apr 23, 2024 at 10:14:05AM -0300, Jason Gunthorpe wrote:
> This is split out from the larger part two which aimes to rework the PASID
> related code.
> 
> No new functionality is introduced in theses commits, it just reorganizes
> the CD logic to follow the same design of the new STE logic using make
> functions and a single programming flow without leaking details to
> callers.
> 
> CD does not have as strong a need for this as STE, but all the code exists
> and continuing with the same pattern makes for fewer things to understand
> inside the driver.
> 
> The following PASID code makes use of this to rethread how the CD
> programming works to take a caller created struct arm_smmu_cd and then
> stick whatever that is into the live CD entry. This allows the actual
> PASID and CD logic to be general and then the PAGING and SVA domain types
> can sit on top of it.
> 
> There are four kinds of CDs:
>  - Blocking (ie cleared)
>  - S1 PAGING
>  - SVA
>  - SVA with a released MM (all fault)
> 
> The last two have to transition hitlessly.
> 
> v8:
>  - Remove ops->v_bit and just use entry[0] = 0
>  - Revise commit messages
>  - Revise comment in arm_smmu_get_cd_used()
>  - Move hunks removing code from arm_smmu_write_ctx_desc() earlier for
>    clarity
>  - Consistently avoid CTXDESC_SPLIT and remove the macro
>  - Don't check master->stall_enabled for the STALL_FORCE mm release
>  - Fixup rand config failures on the kunit
>  - Use VISIBLE_IF_KUNIT
>  - Move more mock structs to .data to avoid stack frame size warnings

I think Mostafa left some comments on patch 2 of your v7 after you had
posted the v8. Please could you spin a v9 with that addressed so I start
picking things up?

Cheers,

Will
