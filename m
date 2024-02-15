Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7EF137C3D;
	Thu, 15 Feb 2024 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708018036; cv=none; b=X2m+i/2qBGuDlOv7j7KH83N5pABZpN38OCVtID7NMa/evX50c2O/OR8wmoVwOopOSCgC/hf9xwyPQw/kcAQArsCZREHMsozbN9T/Mu/kHMZsMrwcJZRawDjTGb3lvl00XUIW8hVVGce/OAssbLdym+1hOEPHHaDv0SpvYPuhSMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708018036; c=relaxed/simple;
	bh=lWvCCrL0otxYkI2wF2GdFaV8HsB0kJrulPLEU4rda1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0ug1G3hTVHjxo4w7Go4UPLg+DP5DM/lg226IXHe7Hp37urn07zASI6e/RY7kQl30HRWcdgYkRSVWptFZyPgFXYKpiu233ndGxf8KVVFryV7cZd09u9OPJi0Tg89rWMuoBGnfs6FRvM/8FWJViQjJ+SqxiOO9fqASfv+C59AHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 877B51FB;
	Thu, 15 Feb 2024 09:27:54 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB0A13F766;
	Thu, 15 Feb 2024 09:27:11 -0800 (PST)
Message-ID: <2ca7f64e-a9e3-4d47-b04f-726c86223fd6@arm.com>
Date: Thu, 15 Feb 2024 17:27:09 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/17] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Content-Language: en-GB
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
 Moritz Fischer <moritzf@google.com>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
References: <2-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <2-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/02/2024 3:12 pm, Jason Gunthorpe wrote:
> This allows writing the flow of arm_smmu_write_strtab_ent() around abort
> and bypass domains more naturally.
> 
> Note that the core code no longer supplies NULL domains, though there is
> still a flow in the driver that end up in arm_smmu_write_strtab_ent() with
> NULL. A later patch will remove it.
> 
> Remove the duplicate calculation of the STE in arm_smmu_init_bypass_stes()
> and remove the force parameter. arm_smmu_rmr_install_bypass_ste() can now
> simply invoke arm_smmu_make_bypass_ste() directly.
> 
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 97 ++++++++++++---------
>   1 file changed, 55 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index f0b915567cbcdc..6123e5ad95822c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1498,6 +1498,24 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>   	}
>   }
>   
> +static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> +{
> +	memset(target, 0, sizeof(*target));
> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
> +}
> +
> +static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
> +{
> +	memset(target, 0, sizeof(*target));
> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS));
> +	target->data[1] = cpu_to_le64(
> +		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
> +}
> +
>   static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   				      struct arm_smmu_ste *dst)
>   {
> @@ -1508,37 +1526,31 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   	struct arm_smmu_domain *smmu_domain = master->domain;
>   	struct arm_smmu_ste target = {};
>   
> -	if (smmu_domain) {
> -		switch (smmu_domain->stage) {
> -		case ARM_SMMU_DOMAIN_S1:
> -			cd_table = &master->cd_table;
> -			break;
> -		case ARM_SMMU_DOMAIN_S2:
> -			s2_cfg = &smmu_domain->s2_cfg;
> -			break;
> -		default:
> -			break;
> -		}
> +	if (!smmu_domain) {
> +		if (disable_bypass)
> +			arm_smmu_make_abort_ste(&target);
> +		else
> +			arm_smmu_make_bypass_ste(&target);
> +		arm_smmu_write_ste(master, sid, dst, &target);
> +		return;
> +	}
> +
> +	switch (smmu_domain->stage) {
> +	case ARM_SMMU_DOMAIN_S1:
> +		cd_table = &master->cd_table;
> +		break;
> +	case ARM_SMMU_DOMAIN_S2:
> +		s2_cfg = &smmu_domain->s2_cfg;
> +		break;
> +	case ARM_SMMU_DOMAIN_BYPASS:
> +		arm_smmu_make_bypass_ste(&target);
> +		arm_smmu_write_ste(master, sid, dst, &target);
> +		return;
>   	}
>   
>   	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>   	val = STRTAB_STE_0_V;
>   
> -	/* Bypass/fault */
> -	if (!smmu_domain || !(cd_table || s2_cfg)) {
> -		if (!smmu_domain && disable_bypass)
> -			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
> -		else
> -			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
> -
> -		target.data[0] = cpu_to_le64(val);
> -		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
> -						STRTAB_STE_1_SHCFG_INCOMING));
> -		target.data[2] = 0; /* Nuke the VMID */
> -		arm_smmu_write_ste(master, sid, dst, &target);
> -		return;
> -	}
> -
>   	if (cd_table) {
>   		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
>   			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
> @@ -1583,22 +1595,20 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   	arm_smmu_write_ste(master, sid, dst, &target);
>   }
>   
> +/*
> + * This can safely directly manipulate the STE memory without a sync sequence
> + * because the STE table has not been installed in the SMMU yet.
> + */
>   static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,

This name is long out-of-date - if we're refreshing this area, please 
rename to something relevant to what it actually does, e.g. 
s/bypass/initial/.

Although frankly I also think that at this point we should just get rid 
of the disable_bypass parameter altogether - it's been almost entirely 
meaningless since default domain support was added, and any tenuous 
cases for wanting inital STEs to be bypass should probably be using RMRs 
now anyway.

Thanks,
Robin.

> -				      unsigned int nent, bool force)
> +				      unsigned int nent)
>   {
>   	unsigned int i;
> -	u64 val = STRTAB_STE_0_V;
> -
> -	if (disable_bypass && !force)
> -		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
> -	else
> -		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
>   
>   	for (i = 0; i < nent; ++i) {
> -		strtab->data[0] = cpu_to_le64(val);
> -		strtab->data[1] = cpu_to_le64(FIELD_PREP(
> -			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
> -		strtab->data[2] = 0;
> +		if (disable_bypass)
> +			arm_smmu_make_abort_ste(strtab);
> +		else
> +			arm_smmu_make_bypass_ste(strtab);
>   		strtab++;
>   	}
>   }
> @@ -1626,7 +1636,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>   		return -ENOMEM;
>   	}
>   
> -	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
> +	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
>   	arm_smmu_write_strtab_l1_desc(strtab, desc);
>   	return 0;
>   }
> @@ -3245,7 +3255,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
>   	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
>   	cfg->strtab_base_cfg = reg;
>   
> -	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
> +	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
>   	return 0;
>   }
>   
> @@ -3956,7 +3966,6 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
>   	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
>   
>   	list_for_each_entry(e, &rmr_list, list) {
> -		struct arm_smmu_ste *step;
>   		struct iommu_iort_rmr_data *rmr;
>   		int ret, i;
>   
> @@ -3969,8 +3978,12 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
>   				continue;
>   			}
>   
> -			step = arm_smmu_get_step_for_sid(smmu, rmr->sids[i]);
> -			arm_smmu_init_bypass_stes(step, 1, true);
> +			/*
> +			 * STE table is not programmed to HW, see
> +			 * arm_smmu_init_bypass_stes()
> +			 */
> +			arm_smmu_make_bypass_ste(
> +				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
>   		}
>   	}
>   
