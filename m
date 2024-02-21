Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109B37C083;
	Wed, 21 Feb 2024 13:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523372; cv=none; b=iqfPnrs/3jB8OTVJs7wFG/adObQJ+ReSdusX5dywr4SFtDfi1Twb7kNdHVzw36S3oPR2mEuHgG0FJS4GULWp40YCqmmhEIhI8owoTD9HHC9dL0crXTdxX2WeDr7QVb6fRIPqhDUnEBYrCVx0daOFu4+oGAseS/v8KeUWjvBjmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523372; c=relaxed/simple;
	bh=WltSHqwn2RjOETE3RzawhnVa3JzN/2/CUHNADi+ODq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFE0Zbn4MpgGP2qlEcemOcjZjK/vvtNG1+HQu72oaVCjS5obu5Kt77+tns7iQUYdxsuDjInXAqoJ9xdw+Ro8BjEAkJ2mO7ut79bc/B/DrBlm84xXgee7yhm0PUVqImQBmcf18rSDnrZ96wsKq4fk6IqN1Ap1WAKWeOZ3gXBNcHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNfaX91g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNfaX91g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90448C43390;
	Wed, 21 Feb 2024 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708523370;
	bh=WltSHqwn2RjOETE3RzawhnVa3JzN/2/CUHNADi+ODq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sNfaX91gBTlwQrZVFdJxEXRtbvdXmfnHk0aJdbjtrc40wjcTNo18ZsiVxyzlOnjPa
	 ySeEpanl6BmgEvBMme0zndXZwlKBsa/mcmAEDqZGQgeSWfBep0Dgsq84vcl8JRq2Xs
	 rNOLlCNwD1bqjr+gQtOID7zpnX8ZQTVttjx8X+pK4rr2Pid4azDRBHNOQZDHXU/SbU
	 wHEnaWmx4GL055hgboVLFL8F8A1iT5XfnaWuR6PCtAU8fUcrXZA0iJ73LbiD0r6hWi
	 pIvuiUDhh8uRrsDYwFaMXpb16ma1IMx1ipLx7t/d1+gELYClA187LiJwnUdNv5t24k
	 sBbPGd23mrg8Q==
Date: Wed, 21 Feb 2024 13:49:23 +0000
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
Message-ID: <20240221134923.GA7362@willie-the-truck>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215160135.GL1088888@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 15, 2024 at 12:01:35PM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 15, 2024 at 01:49:53PM +0000, Will Deacon wrote:
> > On Tue, Feb 06, 2024 at 11:12:38AM -0400, Jason Gunthorpe wrote:
> > > @@ -48,6 +48,21 @@ enum arm_smmu_msi_index {
> > >  	ARM_SMMU_MAX_MSIS,
> > >  };
> > >  
> > > +struct arm_smmu_entry_writer_ops;
> > > +struct arm_smmu_entry_writer {
> > > +	const struct arm_smmu_entry_writer_ops *ops;
> > > +	struct arm_smmu_master *master;
> > > +};
> > > +
> > > +struct arm_smmu_entry_writer_ops {
> > > +	unsigned int num_entry_qwords;
> > > +	__le64 v_bit;
> > > +	void (*get_used)(const __le64 *entry, __le64 *used);
> > > +	void (*sync)(struct arm_smmu_entry_writer *writer);
> > > +};
> > 
> > Can we avoid the indirection for now, please? I'm sure we'll want it later
> > when you extend this to CDs, but for the initial support it just makes it
> > more difficult to follow the flow. Should be a trivial thing to drop, I
> > hope.
> 
> We can.

Thanks.

> > I think it also means we don't have a "hitless" transition from
> > stage-2 translation -> bypass.
> 
> Hmm, I didn't notice that. The kunit passed:
> 
> [    0.511483] 1..1
> [    0.511510]     KTAP version 1
> [    0.511551]     # Subtest: arm-smmu-v3-kunit-test
> [    0.511592]     # module: arm_smmu_v3_test
> [    0.511594]     1..10
> [    0.511910]     ok 1 arm_smmu_v3_write_ste_test_bypass_to_abort
> [    0.512110]     ok 2 arm_smmu_v3_write_ste_test_abort_to_bypass
> [    0.512386]     ok 3 arm_smmu_v3_write_ste_test_cdtable_to_abort
> [    0.512631]     ok 4 arm_smmu_v3_write_ste_test_abort_to_cdtable
> [    0.512874]     ok 5 arm_smmu_v3_write_ste_test_cdtable_to_bypass
> [    0.513075]     ok 6 arm_smmu_v3_write_ste_test_bypass_to_cdtable
> [    0.513275]     ok 7 arm_smmu_v3_write_ste_test_cdtable_s1dss_change
> [    0.513466]     ok 8 arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass
> [    0.513672]     ok 9 arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass
> [    0.514148]     ok 10 arm_smmu_v3_write_ste_test_non_hitless
> 
> Which I see is because it did not test the S2 case...

Oops!

> > Additionally, it looks like there's an existing buglet here in that we
> > shouldn't set SHCFG if SMMU_IDR1.ATTR_TYPES_OVR == 0.
> 
> Ah because the spec says RES0.. I'll add these two into the pile of
> random stuff in part 3

I don't think this needs to wait until part 3, but it also doesn't need to
be part of your series. I'll make a note that we can improve this.

> > > +	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> > > +	switch (cfg) {
> > > +	case STRTAB_STE_0_CFG_ABORT:
> > > +	case STRTAB_STE_0_CFG_BYPASS:
> > > +		break;
> > > +	case STRTAB_STE_0_CFG_S1_TRANS:
> > > +		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> > > +					    STRTAB_STE_0_S1CTXPTR_MASK |
> > > +					    STRTAB_STE_0_S1CDMAX);
> > > +		used_bits[1] |=
> > > +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> > > +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> > > +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> > > +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> > > +		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> > > +		break;
> > > +	case STRTAB_STE_0_CFG_S2_TRANS:
> > > +		used_bits[1] |=
> > > +			cpu_to_le64(STRTAB_STE_1_EATS);
> > > +		used_bits[2] |=
> > > +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> > > +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> > > +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> > > +		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> > > +		break;
> > 
> > With SHCFG fixed, can we go a step further with this and simply identify
> > the live qwords directly, rather than on a field-by-field basis? I think
> > we should be able to do the same "hitless" transitions you want with the
> > coarser granularity.
> 
> Not naively, Michael's excellent unit test shows it.. My understanding
> of your idea was roughly thus:
> 
> void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> {
> 	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
> 
> 	used_bits[0] = U64_MAX;
> 	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> 		return;
> 
> 	/*
> 	 * See 13.5 Summary of attribute/permission configuration fields for the
> 	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
> 	 * and S2 only.
> 	 */
> 	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
> 	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
> 	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
> 	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> 		     STRTAB_STE_1_S1DSS_BYPASS))
> 		used_bits[1] |= U64_MAX;
> 
> 	used_bits[0] |= U64_MAX;
> 	switch (cfg) {
> 	case STRTAB_STE_0_CFG_ABORT:
> 	case STRTAB_STE_0_CFG_BYPASS:
> 		break;
> 	case STRTAB_STE_0_CFG_S1_TRANS:
> 		used_bits[0] |= U64_MAX;
> 		used_bits[1] |= U64_MAX;
> 		used_bits[2] |= U64_MAX;
> 		break;
> 	case STRTAB_STE_0_CFG_NESTED:
> 		used_bits[0] |= U64_MAX;
> 		used_bits[1] |= U64_MAX;
> 		fallthrough;
> 	case STRTAB_STE_0_CFG_S2_TRANS:
> 		used_bits[1] |= U64_MAX;
> 		used_bits[2] |= U64_MAX;
> 		used_bits[3] |= U64_MAX;
> 		break;

Very roughly, yes, although I'd go further and just return a bitmap of
used qwords instead of tracking these bits. Basically, we could have some
#defines saying which qwords are used by which configs, and then we can
simplify the algorithm while retaining the ability to reject updates
to qwords which we're not expecting.

> And the failures:

[...]

> BYPASS -> S1 requires changing overlapping bits in qword 1. The
> programming sequence would look like this:
> 
> start qw[1] = SHCFG_INCOMING
>       qw[1] = SHCFG_INCOMING | S1DSS
>       qw[0] = S1 mode
>       qw[1] = S1DSS
> 
> The two states are sharing qw[1] and BYPASS ignores all of it except
> SHCFG_INCOMING. Since bypass would have its qw[1] marked as used due
> to the SHCFG there is no way to express that it is not looking at the
> other bits.
> 
> We'd have to really start doing really hacky things like remove the
> SHCFG as a used field entirely - but I think if you do that you break
> the entire logic of the design and also go backwards to having
> programming that only works if STEs are constructed in certain ways.

I would actually like to remove SHCFG as a used field. If the encoding
was less whacky (i.e. if 0b00 always meant "use incoming"), then it would
be easy, but it shouldn't be too hard to work around that.

Then BYPASS doesn't need to worry about qword 1 at all.

Will
