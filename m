Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF113175A;
	Thu, 15 Feb 2024 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708005000; cv=none; b=n+v4JfJBmdBH58jiRnOBVjdKdEcI6D1cAClYI+4DmbfbecCHo/zuoyPAL3nVIeKFLhjELEy8je01QgBE+Xdmfm63wOJkIY4Edte0AzVuCC7mh3cRX6YS494YNllnZmKt1VDiAsFXJekcSxd3MuPLiK9jDWK6MX3DFk3RoJvrizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708005000; c=relaxed/simple;
	bh=BPsx6HPohDJ6rSCspeipzi590qL9h/shf0Xs+0e6IzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXhbHPNjCGeEhOD4Tq0AoMzwb3kG+7bmlCl8Jzm4coKn5igp5TS9ba15sHYhiT1pwmVMRJQIJSSfDSh453VTfrBXWD7mdrJROaOBcev5xPN7tkpbmtPAzEHYTECc9hcJXHY0J08M06IgaUMirYodJd1W1FI1BdqVHTyOt9wlg00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9eqwgcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9eqwgcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E716AC43390;
	Thu, 15 Feb 2024 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708004999;
	bh=BPsx6HPohDJ6rSCspeipzi590qL9h/shf0Xs+0e6IzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H9eqwgczN+4DD4O9zYilmjP7tRzpuH4bbbd/jgcvotZB0PmZ1v926jwXovnvwwDVU
	 r/yGueiE4nxheSLfIz7qp9FIY4f47tmUSEfgOfTWNCC4T7qoJW3HQYz8xAAX0rC5rF
	 TUCFLwy8Z4qV6mhUXZzXUep6FxhzSxYHe7sD9jx3SrKU8I3mUOCZ9pEmBJ6KEqxcpP
	 DVq27TNObXEPO3SYM3y0wfZ7Hms1zT3JeQYgmodTK+Z1rblbBc58De+2sGpQ3QiDQN
	 drIonniZ81crua9GLBO2jVLGUDoniBjZ2dnO8lb783rkwH6lOSn3gkFEvnich7PBCI
	 O9qct+qQqZsVg==
Date: Thu, 15 Feb 2024 13:49:53 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240215134952.GA690@willie-the-truck>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Tue, Feb 06, 2024 at 11:12:38AM -0400, Jason Gunthorpe wrote:
> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> been limited to only work correctly in certain scenarios that the caller
> must ensure. Generally the caller must put the STE into ABORT or BYPASS
> before attempting to program it to something else.

This is looking pretty good now, but I have a few comments inline.

>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 330 ++++++++++++++++----
>  1 file changed, 263 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 0ffb1cf17e0b2e..f0b915567cbcdc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,6 +48,21 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +	const struct arm_smmu_entry_writer_ops *ops;
> +	struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +	unsigned int num_entry_qwords;
> +	__le64 v_bit;
> +	void (*get_used)(const __le64 *entry, __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};

Can we avoid the indirection for now, please? I'm sure we'll want it later
when you extend this to CDs, but for the initial support it just makes it
more difficult to follow the flow. Should be a trivial thing to drop, I
hope.

> +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
>  {
> +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
> +
> +	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
> +	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +		return;
> +
> +	/*
> +	 * See 13.5 Summary of attribute/permission configuration fields for the
> +	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
> +	 * and S2 only.
> +	 */
> +	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
> +	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
> +	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
> +	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> +		     STRTAB_STE_1_S1DSS_BYPASS))
> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);

Huh, SHCFG is really getting in the way here, isn't it? I think it also
means we don't have a "hitless" transition from stage-2 translation ->
bypass. I'm inclined to leave it set to "use incoming" all the time; the
only difference I can see is if you have stage-2 translation and a
master emitting outer-shareable transactions, in which case they'd now
be outer-shareable instead of inner-shareable, which I think is harmless.

Additionally, it looks like there's an existing buglet here in that we
shouldn't set SHCFG if SMMU_IDR1.ATTR_TYPES_OVR == 0.

> +
> +	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> +	switch (cfg) {
> +	case STRTAB_STE_0_CFG_ABORT:
> +	case STRTAB_STE_0_CFG_BYPASS:
> +		break;
> +	case STRTAB_STE_0_CFG_S1_TRANS:
> +		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> +					    STRTAB_STE_0_S1CTXPTR_MASK |
> +					    STRTAB_STE_0_S1CDMAX);
> +		used_bits[1] |=
> +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> +		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> +		break;
> +	case STRTAB_STE_0_CFG_S2_TRANS:
> +		used_bits[1] |=
> +			cpu_to_le64(STRTAB_STE_1_EATS);
> +		used_bits[2] |=
> +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> +		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +		break;

With SHCFG fixed, can we go a step further with this and simply identify
the live qwords directly, rather than on a field-by-field basis? I think
we should be able to do the same "hitless" transitions you want with the
coarser granularity.

Will
