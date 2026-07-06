Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2C941DEDC;
	Mon,  6 Jul 2026 18:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360825; cv=none; b=PZifeoz8p93X3RvSP2wANQTtNIGlB/H6KCbCEG4DtFQOVfEwkEkQO+4LcUURf5jj4SoOWnLGycbDpKce7z4urAMrAlXzXvtCbcPG+rcCWJhoFCklzdUXc52IGmDPcWuwKVoNhODgZeEvQgGJrG1Wbub1SvWXcjEHVFr4GfHvzxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360825; c=relaxed/simple;
	bh=qtDSU5VqrO2YQ6BYD4Wlp4Ajs+FbwG3JDQb1bjgiLDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qGpRmodIlLlF6En3eHdnxLsxHF1W1Fz46zkcTzxUUkeOWRUEOwIgBmfff4nqiSEDLsl1x/z+Vn4/D4YeYyVCgof7tChxj7Wrlb0RAxGW4iEFlNaogkZhLI4e9bg5yL1XdKEFoWUdQaJnOk39I9rBHqdwsMgv4zGc4OxhV5rJJa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GI91E1Li; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GI91E1Li"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 074C51AED;
	Mon,  6 Jul 2026 11:00:18 -0700 (PDT)
Received: from [10.57.82.104] (unknown [10.57.82.104])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B128F3F7B4;
	Mon,  6 Jul 2026 11:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783360822; bh=qtDSU5VqrO2YQ6BYD4Wlp4Ajs+FbwG3JDQb1bjgiLDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GI91E1LiIPux5O6odUFhu1WtiDzH712JQz5epv+X3eZxZ5cja6EtsRhh87zdp6UA2
	 p9qb2yNj+03wxh97Q3TbO/+/d13nu4nbKA8o0pObyMkWyLcDx9RgVnMNZYC8YqZtET
	 R1yv91B72mJ/CLVvlwFd0rliojXn8Rdu9IJhJPcc=
Message-ID: <f351b3ce-6488-4b8c-a28a-a3cb0b827750@arm.com>
Date: Mon, 6 Jul 2026 19:00:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Jean-Philippe Brucker <jpb@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Pranjal Shrivastava <praan@google.com>,
 Samiullah Khawaja <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>
References: <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-07-06 5:26 pm, Jason Gunthorpe wrote:
[...]
>   /*
> - * Generate a single range TLBI command covering [iova, iova+size). Sets
> + * Compute the TTL hint from leaf/table level bitmaps. 0 ttlt means no hint
> + * invalidate all levels.
> + */
> +static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
> +					 unsigned int tg)
> +{
> +	int ttl;
> +
> +	if (leaf_bitmap) {
> +		if (is_power_of_2(leaf_bitmap))
> +			ttl = 3 - (int)__ffs(leaf_bitmap);
> +		else
> +			ttl = 0;
> +
> +		if (table_bitmap) {
> +			int table_ttl = 3 - (int)__ffs(table_bitmap) + 1;
> +
> +			/*
> +			 * A RIL invalidation with !leaf_only clears out all
> +			 * table levels above the leaf level ttl only.
> +			 */
> +			if (table_ttl > ttl)
> +				ttl = 0;
> +		}
> +	} else if (table_bitmap) {
> +		ttl = 3 - (int)__ffs(table_bitmap) + 1;

Maybe I'm misunderstanding what table_bitmap represents, but whichever way:
- if this case means purely changes to table (i.e. non-leaf) PTEs 
themselves, then calculating any leaf level is pretty pointless.
- conversely if it means to an invalidate an entire table worth of leaf 
PTEs at once, then L1 tables could contain a mix of both L2 and L3 
leaves, so a single level is not necessarily sufficient.
- at best, if it's the latter but you'd be generating separate 
invalidations for each individual sub-table from the bottom up, such 
that there would only be exactly one table_bitmap level per 
invalidation, isn't that pretty inefficient?

> +	} else {
> +		/* Both bitmaps zero is not allowed */
> +		return 0;
> +	}
> +
> +	/* 16K granule, ARM TTL=1 is reserved (SMMUv3 F.b Section 4.4.1) */
> +	if (tg == 14 && ttl == 1)
> +		return 0;

It's reserved in the absence of LPA2, i.e. when DS=0 (side note, please 
refer to an up-to-date version of the architecture - F.b is pretty old 
by now) because the 16K format can only have L1 block entries when using 
52-bit VA. If between the caller and the code above we can calculate 
that a block entry exists where it cannot, then something is wrong and 
needs fixing properly.

> +	/* ARM levels -1 and 0 cannot be hinted */
> +	if (ttl <= 0 || ttl > 3)
> +		return 0;

Similarly, no format allows blocks at level -1, so again if that check 
ever did anything we'd already have bigger problems. In the remaining 
case, 4KB with 52-bit VA *does* permit blocks at level 0, but it should 
hopefully be obvious why that doesn't need special treatment here either...

Thanks,
Robin.

> +	return ttl;
> +}
