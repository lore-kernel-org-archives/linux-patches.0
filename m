Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ADC12B156;
	Thu, 15 Feb 2024 11:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707997103; cv=none; b=JBS6MeJsr4hP1Av7cV6Y+gwjyk69vwHEI5on51Cv+fVmXZd4OmZgdBOKCRLLVGE3F+Omj8zHiSkhIfqLD+vTZBCgj2dTF2k2cpqlnSHcCBn+QOe/3sLSuVCF70C4pKC8UCIFPKblhytqSIlGOMAdudq1g8PicUiPUw0rUfkfRAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707997103; c=relaxed/simple;
	bh=SgvG+BJ3dc2XvuTcerJOhEJL0tzbVcPJsktzW8HdRfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAFv8j68xyd+q5H+PN8HyHoFtp6P5IT1dxWJFmwNtTzh5bcgMBISiTLARM3B5iQ615LWE2WGKVXryJxMaMbOULclzqEWiQ366BbOoKMUpyHLdftX3TGRZiDD2rc64n5Us3jBmjxV4IsrgPUfsgCM7xkgQwG/Fz2mJ2wzfCm8Ecw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+wpJ3UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+wpJ3UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26076C433F1;
	Thu, 15 Feb 2024 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707997102;
	bh=SgvG+BJ3dc2XvuTcerJOhEJL0tzbVcPJsktzW8HdRfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S+wpJ3UMZITcrZiGv3favlVUsjbnFKFaka0mTg3KsmT/c3lztnhWPN3IEikUO+5mC
	 mk2PlhQzsOy4ieibRNESWWOCeblN6OfDt6NtNIc2h6FYwQQ/opiPxLlkMzS5ka4Po0
	 IJxkvZez55lCSWDBZJzPeaWX2cmZSUUxNgSMyav0EnnfMcumnHDGLE2OfCztAxY2JC
	 RLyUV9uKjOYsSTFyUeaSeWEpGeAh+yjVSca/ljq7XEcXXYI0/vk6R0PR7e2AnkEAdX
	 NYKBb+8WnBTmrDUFl/bYBP+P3M/vKpPyERLXWVz/eBbhwDIU3kEHFyeMqYpw1ZM/Vx
	 Pn47R5Yoo1BSw==
Date: Thu, 15 Feb 2024 11:38:17 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240215113816.GA358@willie-the-truck>
References: <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
 <20240213125456.GA28844@willie-the-truck>
 <20240213133045.GA989297@nvidia.com>
 <20240213135627.GD28926@willie-the-truck>
 <20240213140033.GB989297@nvidia.com>
 <20240214170030.GB31927@willie-the-truck>
 <20240214190954.GI1088888@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214190954.GI1088888@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 14, 2024 at 03:09:54PM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 14, 2024 at 05:00:30PM +0000, Will Deacon wrote:
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 0ffb1cf17e0b..e48f2b46f25e 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1019,7 +1019,10 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> >  	WRITE_ONCE(*dst, cpu_to_le64(val));
> >  }
> >  
> > -static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> > +static __le64 *
> > +__arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid,
> > +		      int (*cd_alloc)(struct arm_smmu_device *,
> > +				      struct arm_smmu_l1_ctx_desc *))
> >  {
> >  	__le64 *l1ptr;
> >  	unsigned int idx;
> > @@ -1033,7 +1036,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> >  	idx = ssid >> CTXDESC_SPLIT;
> >  	l1_desc = &cd_table->l1_desc[idx];
> >  	if (!l1_desc->l2ptr) {
> > -		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> > +		if (!cd_alloc || cd_alloc(smmu, l1_desc))
> >  			return NULL;
> >  
> >  		l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
> > @@ -1045,6 +1048,19 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> >  	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
> >  }
> >  
> > +static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
> > +{
> > +	return __arm_smmu_get_cd_ptr(master, ssid, NULL);
> > +}
> 
> I think this will break arm_smmu_write_ctx_desc() which requires
> allocation behavior to install the SSID0 in a two level table?

Ah yes, you're quite right. We'd need to add the allocation to
arm_smmu_attach_dev() as well.

> > +int arm_smmu_init_cd_table(struct arm_smmu_master *master, int ssid)
> > +{
> > +	if (!__arm_smmu_get_cd_ptr(master, ssid, arm_smmu_alloc_cd_leaf_table))
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> 
> And this does not compose well with the rest of where we are going. At
> the end there are 7 calls to arm_smmu_get_cd_ptr(), all need
> allocation except for two (clear and mmu notifier release)
> 
> Better to add a noalloc version. Also 'bool noalloc' would be clearer
> than a function pointer without obfuscating the control flow.
> 
> Also I don't think this should go to -rc, it is not fixing any
> bug. The preallocation is enough. Making more clarity for this
> confused code is a nice to have at best.
> 
> How about this instead as a -next patch:
> 
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -288,10 +288,11 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
>  
>  /* Allocate or get existing MMU notifier for this {domain, mm} pair */
>  static struct arm_smmu_mmu_notifier *
> -arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
> +arm_smmu_mmu_notifier_get(struct arm_smmu_master *true_master,
> +                         struct arm_smmu_domain *smmu_domain,
>                           struct mm_struct *mm)
>  {
> -       int ret;
> +       int ret = 0;
>         unsigned long flags;
>         struct arm_smmu_ctx_desc *cd;
>         struct arm_smmu_mmu_notifier *smmu_mn;
> @@ -327,8 +328,15 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
>  
>         spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>         list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> -               ret = arm_smmu_write_ctx_desc(master, mm_get_enqcmd_pasid(mm),
> -                                             cd);
> +               /*
> +                * A limitation of the current SVA code requires the RID
> +                * smmu_domain to be unique to the actual master.
> +                */
> +               if (WARN_ON(master != true_master))
> +                       ret = -EINVAL;
> +               if (!ret)
> +                       ret = arm_smmu_write_ctx_desc(
> +                               master, mm_get_enqcmd_pasid(mm), cd);
>                 if (ret) {
>                         list_for_each_entry_from_reverse(
>                                 master, &smmu_domain->devices, domain_head)
> @@ -398,7 +406,7 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
>  
>         bond->mm = mm;
>  
> -       bond->smmu_mn = arm_smmu_mmu_notifier_get(smmu_domain, mm);
> +       bond->smmu_mn = arm_smmu_mmu_notifier_get(master, smmu_domain, mm);
>         if (IS_ERR(bond->smmu_mn)) {
>                 ret = PTR_ERR(bond->smmu_mn);
>                 goto err_free_bond;

This is what I originally had in mind, but for some reason I thought you
weren't happy with it. Mind if I fold it into your -rc patch? I'd really
like them to go in together.

Will
