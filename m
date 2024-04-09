Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDAE127B5A;
	Tue,  9 Apr 2024 12:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712666416; cv=none; b=o5OSlicDZGyQDQljSxMJiww5NhyDxNBN80OqApnqMEev6eKHF9mPeN1yqrsMEYmbdcCO7KWJFoi5hxPEqODdTUnizs6F6e7e0DkSgKW0Tkiv2cN3CGlHodTYXN2UdYU4KSvP8m92x9A1r3kdA9YuFrQn5xWOb9/SqzLZzUFyB1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712666416; c=relaxed/simple;
	bh=+oqtJgeLiQ0pjuqUx6N0owLTORtI1+SJb+pgZb0B7B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLAPOV5HXbgrQif0N9OgR1nxlJmlj9JvgSrXfel/hcsErlmULIiZnI4uFFdYIDEQ1jbiLxMpixK69jsia8S7F4VdrtC3ohqoCztM/K0ndcLv2A7gbLUTjM6w7tPYwu+HtTISwjrBirz67NlNvcLFENBaL45+Lq0BNIrqDpxymy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opBd4bFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opBd4bFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EA3C433C7;
	Tue,  9 Apr 2024 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712666415;
	bh=+oqtJgeLiQ0pjuqUx6N0owLTORtI1+SJb+pgZb0B7B0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=opBd4bFwh1SvyD9npvzfIJPDVOAHXGngLOhXLea03J17iznEmmzHxE2lnLZtcJt8B
	 a41boBSXXEJyG56uPR3UHOofhMxlPobHi78QVSxTxlWjl6fVvlTlgqhiHlcuSqCjSn
	 CyvYeoyMcklfDuPuI5L+GzfxiFyNwRoXPQQU8tTfFM55XkpYy6N5GjzcIjSHjyx4jG
	 gwSHSkD0g2pyVMC6cpekwFGOnJBwqzWGwr0srnKJyTRzRuNPy7N7YWSHKcuC060jW3
	 PAPfhidyH3MDWoemddMDYEKQUCYdSTE6vVi5Z7PmByeGHfEedqvBxwZWIKG99jUz7d
	 xcXFNyRXjzhbQ==
Date: Tue, 9 Apr 2024 13:40:08 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>, Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 06/29] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <20240409124007.GA23088@willie-the-truck>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Mar 27, 2024 at 03:07:52PM -0300, Jason Gunthorpe wrote:
> Prepare to put the CD code into the same mechanism. Add an ops indirection
> around all the STE specific code and make the worker functions independent
> of the entry content being processed.
> 
> get_used and sync ops are provided to hook the correct code.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 170 ++++++++++++--------
>  1 file changed, 102 insertions(+), 68 deletions(-)

Any chance we can pull the STE testing stuff forward from Michael once
we have the entry writing ops indirection, please? It would be nice to
land that before adding the CD support, I think.

> @@ -1102,17 +1111,14 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
>   * V=0 process. This relies on the IGNORED behavior described in the
>   * specification.
>   */
> -static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
> -			       struct arm_smmu_ste *entry,
> -			       const struct arm_smmu_ste *target)
> +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> +				 __le64 *entry, const __le64 *target)
>  {
> -	unsigned int num_entry_qwords = ARRAY_SIZE(target->data);
> -	struct arm_smmu_device *smmu = master->smmu;
> -	struct arm_smmu_ste unused_update;
> +	__le64 unused_update[NUM_ENTRY_QWORDS];
>  	u8 used_qword_diff;
>  
>  	used_qword_diff =
> -		arm_smmu_entry_qword_diff(entry, target, &unused_update);
> +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
>  	if (hweight8(used_qword_diff) == 1) {
>  		/*
>  		 * Only one qword needs its used bits to be changed. This is a

nit: This comment (lost in the diff context) refers to STEs a couple of
times. Please update to e.g. "STE/CD".

Will
