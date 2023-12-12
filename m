Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4812A7765B;
	Tue, 12 Dec 2023 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZvxvHGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC153C433C7;
	Tue, 12 Dec 2023 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702398239;
	bh=N0YmmaPyPHajCi7Js8VUkU8lZscCx1Z3LEh9ObmNJEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GZvxvHGMzD2IIvqekKK+8Kb5nnpZy/d+JSwmW2ve9Cwkblr3KvjmHQhH06fmhDcIa
	 EybIxvmVTJNYZoCaAicDoVJVs1WOEAKhgR7QtUo6KpMeKC+prINe2+l4TK2qQ99Qvz
	 8DCm+DH27pZYrBxaRp8HJKpz8aBABgfGVIoceSNlQ5sehXDUZl8BSMyqAn6NvWn1lE
	 IS0thKG1hYrg3hzZ08QglVZEbGrUGPg/I5jKSHTFWW++qyXTggBSXX/SBxWl+j4Avv
	 GBN0VtwzMmB2voUSuVFBOlK3x7NEZprE+At3V6I7fAjcpk+jd/mPCw4bF27IcC7A7A
	 H8Oc3tNooJsFg==
Date: Tue, 12 Dec 2023 16:23:53 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 04/19] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20231212162353.GA29871@willie-the-truck>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Tue, Dec 05, 2023 at 03:14:36PM -0400, Jason Gunthorpe wrote:
> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> been limited to only work correctly in certain scenarios that the caller
> must ensure. Generally the caller must put the STE into ABORT or BYPASS
> before attempting to program it to something else.
> 
> The next patches/series are going to start removing some of this logic
> from the callers, and add more complex state combinations than currently.
> 
> Thus, consolidate all the complexity here. Callers do not have to care
> about what STE transition they are doing, this function will handle
> everything optimally.
> 
> Revise arm_smmu_write_strtab_ent() so it algorithmically computes the
> required programming sequence to avoid creating an incoherent 'torn' STE
> in the HW caches. The update algorithm follows the same design that the
> driver already uses: it is safe to change bits that HW doesn't currently
> use and then do a single 64 bit update, with sync's in between.
> 
> The basic idea is to express in a bitmask what bits the HW is actually
> using based on the V and CFG bits. Based on that mask we know what STE
> changes are safe and which are disruptive. We can count how many 64 bit
> QWORDS need a disruptive update and know if a step with V=0 is required.
> 
> This gives two basic flows through the algorithm.
> 
> If only a single 64 bit quantity needs disruptive replacement:
>  - Write the target value into all currently unused bits
>  - Write the single 64 bit quantity
>  - Zero the remaining different bits
> 
> If multiple 64 bit quantities need disruptive replacement then do:
>  - Write V=0 to QWORD 0
>  - Write the entire STE except QWORD 0
>  - Write QWORD 0
> 
> With HW flushes at each step, that can be skipped if the STE didn't change
> in that step.
> 
> At this point it generates the same sequence of updates as the current
> code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
> extra sync (this seems to be an existing bug).

This is certainly very clever, but at the same time I can't help but feel
that it's slightly over-engineered to solve the general case, whereas I'm
struggling to see why such a level of complexity is necessary.

In the comment, you say:

> + * In the most general case we can make any update in three steps:
> + *  - Disrupting the entry (V=0)
> + *  - Fill now unused bits, all bits except V
> + *  - Make valid (V=1), single 64 bit store
> + *
> + * However this disrupts the HW while it is happening. There are several
> + * interesting cases where a STE/CD can be updated without disturbing the HW
> + * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
> + * because the used bits don't intersect. We can detect this by calculating how
> + * many 64 bit values need update after adjusting the unused bits and skip the
> + * V=0 process.

Please can you spell out these "interesting cases"? For cases where we're
changing CONFIG, I'd have thought it would be perfectly fine to go via an
invalid STE. What am I missing?

Generally, I like where the later patches in the series take things, but
I'd really like to reduce the complexity of the strtab updating code to
what is absolutely required.

I've left some minor comments on the code below, but I'd really like to
see this whole thing simplified if possible.

> + */
> +static bool arm_smmu_write_entry_step(__le64 *cur, const __le64 *cur_used,
> +				      const __le64 *target,
> +				      const __le64 *target_used, __le64 *step,
> +				      __le64 v_bit,
> +				      unsigned int len)
> +{
> +	u8 step_used_diff = 0;
> +	u8 step_change = 0;
> +	unsigned int i;
> +
> +	/*
> +	 * Compute a step that has all the bits currently unused by HW set to
> +	 * their target values.
> +	 */

Well, ok, I do have a cosmetic nit here: using 'step' for both "STE pointer"
and "incremental change" is perhaps, err, a step too far ;)

> +	for (i = 0; i != len; i++) {
> +		step[i] = (cur[i] & cur_used[i]) | (target[i] & ~cur_used[i]);

Isn't 'cur[i] & cur_used[i]' always cur[i]?

> +		if (cur[i] != step[i])
> +			step_change |= 1 << i;
> +		/*
> +		 * Each bit indicates if the step is incorrect compared to the
> +		 * target, considering only the used bits in the target
> +		 */
> +		if ((step[i] & target_used[i]) != (target[i] & target_used[i]))
> +			step_used_diff |= 1 << i;
> +	}
> +
> +	if (hweight8(step_used_diff) > 1) {
> +		/*
> +		 * More than 1 qword is mismatched, this cannot be done without
> +		 * a break. Clear the V bit and go again.
> +		 */
> +		step[0] &= ~v_bit;
> +	} else if (!step_change && step_used_diff) {
> +		/*
> +		 * Have exactly one critical qword, all the other qwords are set
> +		 * correctly, so we can set this qword now.
> +		 */
> +		i = ffs(step_used_diff) - 1;
> +		step[i] = target[i];
> +	} else if (!step_change) {
> +		/* cur == target, so all done */
> +		if (memcmp(cur, target, len * sizeof(*cur)) == 0)
> +			return true;
> +
> +		/*
> +		 * All the used HW bits match, but unused bits are different.
> +		 * Set them as well. Technically this isn't necessary but it
> +		 * brings the entry to the full target state, so if there are
> +		 * bugs in the mask calculation this will obscure them.
> +		 */
> +		memcpy(step, target, len * sizeof(*step));

Bah, I'm not a huge fan of this sort of defensive programming. I'd prefer
to propagate the error rather than quietly try to cover it up.

> +/*
> + * Based on the value of ent report which bits of the STE the HW will access. It
> + * would be nice if this was complete according to the spec, but minimally it
> + * has to capture the bits this driver uses.
> + */
> +static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> +				  struct arm_smmu_ste *used_bits)
> +{
> +	memset(used_bits, 0, sizeof(*used_bits));
> +
> +	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
> +	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +		return;
> +
> +	/*
> +	 * If S1 is enabled S1DSS is valid, see 13.5 Summary of
> +	 * attribute/permission configuration fields for the SHCFG behavior.
> +	 */
> +	if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0])) & 1 &&
> +	    FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent->data[1])) ==
> +		    STRTAB_STE_1_S1DSS_BYPASS)
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +
> +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> +	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]))) {
> +	case STRTAB_STE_0_CFG_ABORT:
> +		break;
> +	case STRTAB_STE_0_CFG_BYPASS:
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +		break;
> +	case STRTAB_STE_0_CFG_S1_TRANS:
> +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> +						  STRTAB_STE_0_S1CTXPTR_MASK |
> +						  STRTAB_STE_0_S1CDMAX);
> +		used_bits->data[1] |=
> +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> +		break;
> +	case STRTAB_STE_0_CFG_S2_TRANS:
> +		used_bits->data[1] |=
> +			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> +		used_bits->data[2] |=
> +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> +		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +		break;

I think this is going to be a pain to maintain :/

> +static bool arm_smmu_write_ste_step(struct arm_smmu_ste *cur,
> +				    const struct arm_smmu_ste *target,
> +				    const struct arm_smmu_ste *target_used)
> +{
> +	struct arm_smmu_ste cur_used;
> +	struct arm_smmu_ste step;
> +
> +	arm_smmu_get_ste_used(cur, &cur_used);
> +	return arm_smmu_write_entry_step(cur->data, cur_used.data, target->data,
> +					 target_used->data, step.data,
> +					 cpu_to_le64(STRTAB_STE_0_V),
> +					 ARRAY_SIZE(cur->data));
> +}
> +
> +static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
> +			       struct arm_smmu_ste *ste,
> +			       const struct arm_smmu_ste *target)
> +{
> +	struct arm_smmu_ste target_used;
> +	int i;
> +
> +	arm_smmu_get_ste_used(target, &target_used);
> +	/* Masks in arm_smmu_get_ste_used() are up to date */
> +	for (i = 0; i != ARRAY_SIZE(target->data); i++)
> +		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);

That's a runtime cost on every single STE update for what would be a driver
bug.

> +
> +	while (true) {
> +		if (arm_smmu_write_ste_step(ste, target, &target_used))
> +			break;
> +		arm_smmu_sync_ste_for_sid(smmu, sid);
> +	}

This really should be bounded...

Will
