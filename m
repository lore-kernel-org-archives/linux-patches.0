Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411433B4E8F;
	Tue,  3 Mar 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553404; cv=none; b=pUUgaUkx9g3fhPXyhKPTINU14MoQKuVg6cHYrW6jKKYLR8hurud7F+clFhVg+ny28dKMPZQ2+4yiBY/HdmQJsTJxu1tYCcFGmvUi0D0yMk5IC2IZP0cu1UfHLZhHJ4XfhZzA378lPpCC12g8Q31IF+nrmPx9BiDQ7iTbKN6pAsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553404; c=relaxed/simple;
	bh=WFUnFr4evtmCzH8JW6blMP6xP61XMvgyDaCg/e7985E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OEI55kMrDpLckb6/CTgiDhgA+bn5RQ9btCrpWxPoTZXwtdPsfe0NqnfN4HwLMf7UyUNtR/nKwgXs6QCo+FfrQCIuTSP4LqqqOTEAIDqxIpzUnZz+6qosL+FJR9t2+Am6JYwx9K5JbT9I4MdhzS1BEBUtP5UBKRC12qg/tk3pZhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BCC5339;
	Tue,  3 Mar 2026 07:56:36 -0800 (PST)
Received: from [10.57.56.165] (unknown [10.57.56.165])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 862BC3F73B;
	Tue,  3 Mar 2026 07:56:40 -0800 (PST)
Message-ID: <ed985e72-dbfe-4d60-b5f1-581ba58e3c18@arm.com>
Date: Tue, 3 Mar 2026 15:56:38 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
References: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
 <13e28ac2-a4d6-466a-aef2-7b3d7d9167bd@arm.com>
 <20260303130420.GB972761@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260303130420.GB972761@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-03 1:04 pm, Jason Gunthorpe wrote:
> On Tue, Mar 03, 2026 at 12:53:28PM +0000, Robin Murphy wrote:
> 
>>> Further, there are several callers that can trigger empty gathers,
>>> especially in unusual conditions. For example iommu_map_nosync() will call
>>> a 0 size unmap on some error paths. Also in VFIO, iommupt and other
>>> places.
>>
>> My instinct is still to tidy up the 0-length unmap case(s), but I guess
>> iommu_iotlb_sync() is itself also a public API where being more robust
>> against erroneous usage is no bad thing.
> 
> I also wanted to do that but found enough problematic cases I lost
> confidence I could reliably catch them all..

I reckon an early "if (!size) return 0;" in iommu_unmap() would suffice 
to cover the internal error cleanup paths and most careless external 
users. However if we don't trust iommu_unmap_fast() users to always do 
the right thing either then we want this check in iommu_iotlb_sync() 
anyway, at which point the iommu_unmap() check would really only serve 
to skip a bit more unnecessary work on error cleanup paths, and do we 
really care about optimising errors? Hence I'm satisfied that this patch 
does in fact seem to be the best option.

>>> -	if (domain->ops->iotlb_sync)
>>> +	if (domain->ops->iotlb_sync &&
>>> +	    likely(iotlb_gather->start < iotlb_gather->end))
>>
>> Elsewhere we just use "gather->end != 0" as the "non-empty" condition; how
>> concerned are we about defending against more-intentionally malformed
>> gathers here?
> 
> I choose this deliberately to protect the driver, a malformed gather
> that is 0 sized, or negative sized looks like it will have Weird
> Things happen in drivers.
> 
> We could further classify the < and WARN_ON the malformed cases, but I
> don't want to pass negative sized gathers into drivers. We'd probably
> also have to de-inline the function if more is added. Do you have a
> preference?

No, that's fine, I just wanted to confirm the intent - this isn't a 
place where we should need to be concerned about micro-optimising to 
maybe save a load and an extra ALU op or two, just that I don't think 
it's worth doing any more than strictly necessary for our own 
robustness. Thus there's no need to change the check in 
iommu_iotlb_gather_is_disjoint() either, as that now just serves to skip 
the redundant reinitialisation of an already-empty gather, which is 
justifiably a different thing from the actual validity-of-sync condition 
anyway.

Cheers,
Robin.
