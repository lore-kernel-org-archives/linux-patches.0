Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B0C4A29;
	Tue, 27 Feb 2024 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709038040; cv=none; b=UlibVyTJYk8y4pD6BoFG6KJuCbDn0sHVvCwcXyp2wtltGZ6f0q8NIEt9bwdSBuu7Vrg2Xt2RPrngyqDEbWO57fLus0qhS7f6SJXRiSi4TGgN4YNa6//jT5vqoN6RgZ03HAQUOOSptYCCXqco1Ikxh6AdVN6YJv87MLPyr/t+5gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709038040; c=relaxed/simple;
	bh=1sVJdJ5ZKn9MwtPQDpeJgFRGRy0J4p0JarZOYWE1rwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/ZKl2pKa+nMlLOcNGy9Y97+mYkST6uYjOuxfoE+KhqAd1HtAskUnhZY4zuOmN7C5ITA6UEdIbHhwc+6xNOa8f9VLhQnlbb9fN48kgnHfWi8c1dYXr8UryGO9dMGUZz6VOsGVHEin9anJotkNQm0F0trq0TpG7Arg5apRS0UunE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wn90QiED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wn90QiED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97D2C433F1;
	Tue, 27 Feb 2024 12:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709038039;
	bh=1sVJdJ5ZKn9MwtPQDpeJgFRGRy0J4p0JarZOYWE1rwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wn90QiEDUt4ikquMhOY0AKYfl1Djuo/BnnWryvS6axNSZLiTVel6wI5/Nl6vwuVpK
	 ERkKp8cLzVPHWtYyyt14OjU+Jjh+z1rAEw9NmDzRIfpeW5hm4hbojFET9sKrqEzdB2
	 yfMm9Q/kHoakQ/aw5JPSaVIsHgnfGFI2YDJ4WMajGi1g/8ELBfyDPnmB6WTb2E7yTW
	 EoNiirrFJF4oceYDpnQpLAMkIVQDFRgax5/QqmHHrr/4k/T1lXwg5m/krpUhixpqKt
	 ADuPH0LSKxAJlhnCQjqoBvfPRLRlqyCyDQSSrNDSpVeQUnjOiUuT/laiSJLIrcBP0t
	 0kDOwQ/JoHUVg==
Date: Tue, 27 Feb 2024 12:47:13 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240227124713.GB14089@willie-the-truck>
References: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 26, 2024 at 01:07:12PM -0400, Jason Gunthorpe wrote:
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 0ffb1cf17e0b2e..9805d989dafd79 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,6 +48,9 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> +static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> +				      ioasid_t sid);
> +
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>  	[EVTQ_MSI_INDEX] = {
>  		ARM_SMMU_EVTQ_IRQ_CFG0,
> @@ -971,6 +974,199 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
>  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  }
>  
> +/*
> + * Based on the value of ent report which bits of the STE the HW will access. It
> + * would be nice if this was complete according to the spec, but minimally it
> + * has to capture the bits this driver uses.
> + */
> +static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> +				  struct arm_smmu_ste *used_bits)
> +{
> +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]));
> +
> +	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
> +	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +		return;
> +
> +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> +
> +	/* S1 translates */
> +	if (cfg & BIT(0)) {
> +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> +						  STRTAB_STE_0_S1CTXPTR_MASK |
> +						  STRTAB_STE_0_S1CDMAX);
> +		used_bits->data[1] |=
> +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
> +				    STRTAB_STE_1_EATS);
> +		used_bits->data[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> +	}
> +
> +	/* S2 translates */
> +	if (cfg & BIT(1)) {
> +		used_bits->data[1] |=
> +			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> +		used_bits->data[2] |=
> +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> +		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +	}
> +
> +	if (cfg == STRTAB_STE_0_CFG_BYPASS)
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +}

I think this looks much nicer now that we've ironed out SHCFG, but I don't
understand why you've dropped it from the used_bits array for the
S1DSS=BYPASS case. It's still needed there, right?

Will
