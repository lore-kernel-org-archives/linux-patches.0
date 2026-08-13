Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252EE38239F;
	Thu, 13 Aug 2026 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641967; cv=none; b=ToJkAYD/MdBy6AcNWEI5UZGs6ZUFlXYBAowMf96jwiDWOp0p+LU5yaEsSr42vVRbby6cEHWMOtDaGAI/lmsOpwFfoaxhmkaVyELnfEoxr91KTzgtDP3y9sQA+YRuWBNLAJg7U0jkqHIR1QEdxJidXzjIqToggHNsxHCiTqM+XJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641967; c=relaxed/simple;
	bh=0qNjRcWOrWIUhU03ffUrB4IIh2/akNK5dYV6ljcH4Do=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s24zJKgsnrE56WwDVsLGRncuCbhzGs3/jpJfK8YUWHB1TgS27dED0Ee7igs6KvuKIh8QyScAwOX2xkYte0z7n4dnVMOSPTf0DcSTh1kNdLSbaGfYf/8H4INJ+QTUah0pp1aF8MUAuMF/CWgaAth3gNyaXdFlKsI2ELjMX6ZpUys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tppK8Bum; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tppK8Bum"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEB6B1596;
	Thu, 13 Aug 2026 10:25:58 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03D7F3F632;
	Thu, 13 Aug 2026 10:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786641962; bh=0qNjRcWOrWIUhU03ffUrB4IIh2/akNK5dYV6ljcH4Do=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tppK8BumBPAbrAfRQmCD3DCnY1uqqULHCNqKQeWBbH8qhRpmhLdqwzu5s+lWT8N/3
	 ieLFKhQNJpl4hvpIV4Szo/WxIXLEwgjqh3ev/ObpOBF1O4am5HbfRJx/KURkrzwPK0
	 wArlBaOws2E/82N8w7tnISG2yYTUQQgd6k3IFVSw=
Message-ID: <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
Date: Thu, 13 Aug 2026 18:25:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation for
 latency
To: Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Jean-Philippe Brucker <jpb@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 David Matlack <dmatlack@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Pranjal Shrivastava <praan@google.com>,
 Samiullah Khawaja <skhawaja@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com> <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com> <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <an3ew9xbnLe1dr5g@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/08/2026 4:12 pm, Mostafa Saleh wrote:
> On Thu, Aug 13, 2026 at 11:13:20AM -0300, Jason Gunthorpe wrote:
>>
>>> Sorry I lost track of this thread and I just saw v4.
>>>
>>> In the mobile space, I haven't seen an SMMUv3 that does not support
>>> RIL.
>>
>> Oh? That's very surprising, AFAIK none of our embedded chips support it
>> yet.. Even the server chips are only just getting it. Are you sure?
> 
> Yes, SMMUv3 is getting more and more common in moblie HW (opposed to
> custom SoC IOMMUs). Devices that I have seen in the market in the
> last couple of years have RIL. For example Pixel-10 which is currently
> getting upstreamed. Also, I have a mini desktop with QCOM X1 which
> have RIL.
> 
> The only SMMUv3 I have seen without RIL, is an old morello board I
> have.

Arm MMU-600 is in a few embedded parts - Rockchip RK3588, some of the TI 
Keystone 3s IIRC - but indeed it's mostly all over the first couple of 
generations of Neoverse stuff - Ampere Altra, AWS Graviton2 and so on. 
Similarly the ThunderX2 and early HiSilicon SMMUs also predate RIL, but 
those whole machines are all probably old enough now to no longer be 
widely used.

Arm implementations from MMU-700 onward all support RIL - MMU-700 itself 
was again more of a server-focused design (it's quite big), but has 
found its way into at least some embedded/mobile SoCs; MMU L1 is the 
first design targeted directly at client systems, so we should be seeing 
more of that as time goes on.

>> I gather it wasn't even available in ARM IP until recently ish?

If you'd consider 2019 recent ;)

>>> However, I have seen workloads that are really sensitive to translation
>>> latency (display, camera...). And I'd be concerned about those
>>> regressing.
>>
>> Yes, those exist, but again, they are already facing these problems if
>> running without RIL.
> 
> Yes, but my point is that those typically support RIL and that change
> regresses them.

Not even that - the main concern is over-invalidation of adjacent in-use 
buffers due to rounding up; non-RIL absolutely does not have that issue 
and never has.

>> And, for the common case of putting something into a carve out region
>> it is not so likely even an expanded RIL will intersect with a
>> reserved IOVA that has a high alignment.
> 
> Not necessarily, those devices can run with a small IOVA space to
> reduce the page table walk length making IOVAs quite close.
> 
>>
>> At least the things we have built are calibrated to handle a TLB
>> reload occasionally. The isochronous TLB's are not even sized to be
>> never-miss for all cases because things like 4k media require such a
>> large amount of IOVA the area cost is too high.
>>
>> While others can do something else you are reaching into a pretty
>> narrow condition to hit a problem:
>>   - HW that must have a never-miss TLB to work
> 
> I am not saying that, but we shouldn't over invalidate TLBs either
> when it is easy to avoid that.
> 
>>   - HW that doesn't have a carve out, or has a badly aligned carve out
> 
> I do not think a carveout will help. But it's a very strong constraint
> to enforce carveout on all devices specially media which are quite
> complex and composite by nature.
> 
>>   - A SMMU that has RIL (non RIL is already worse)
> 
> This regression only impacts RIL, otherwise it does not matter.
> 
>>   - A non-isochronos workload that regularly exceeds the RIL/single
>>     expansion thresholds
>>   - Unlucky IOVA allocation that places isochronous near other
>>     workloads in the IOVA space.
>>
> 
> It is not just luck, it depends on the IOVA space and access patterns
> of the device.
> 
>>> There is a clear trade-off here as you mentioned with TLBI latency,
>>> would it be make sense to make that behviour configurable from a
>>> module param?
>>
>> I think it makes sense for a driver to indicate to the core code that
>> it needs isochronous and we can do more global things like change how
>> single works as well. Having an isochronous flag on the domain, for
>> example, would be a good overall direction.
> 
> But according to what? It makes sense to optimize server chips,
> but that should not cause over-invalidation regressions on other
> hardware.
> 
>>
>> I'm inclined to leave this as is and let someone come with a specific
>> problematic HW, rather that try to badly guess without much
>> information if it might popssibly be a problem.
>>
> 
> It's not really a guess, I mentioned some examples above, that I
> have seen problems of translation latencies on them.
> 
> And why not the other way around:
> - Which uses cases can't handle few RIL commands?
> - Why those drivers does not unmap memory with a granule/IOVA fitting
>    to RIL?
> - Why those systems does not use FQ domains in the first place?

Note that with RIL, even precise invalidation should only actually need 
at most two commands (excepting absurd off-the-scale sizes) - the trick 
is to consider that they can overlap.

Conversely though, if we really did have a demonstrable need to minimise 
the number of commands issued then we should probably also not bother 
with the TTL hint nor splitting leaf ranges from non-leaf, such that we 
can gather pretty much any unmap into a single command.

This is probably something we'll end up wanting some kind of tunable 
behaviour for, given that SMMUv3 hardware is going to be spanning an 
increasingly wide range of use-cases with increasingly opposing 
requirements - it's certainly more than just "hypervisor or not". For 
now, though, I'm also not buying a dubious latency argument based on 
apparently no real-world data other than "I think"...

Thanks,
Robin.
