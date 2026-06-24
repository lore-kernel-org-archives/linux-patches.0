Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716E82F8E81
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313507; cv=none; b=dXDWakEnSDwKukU0qANAbfPjRThwUiIAkrOkA6cZSH3Pbe7pcCTJD/qJdbOaqmPVmlHBSFz8a4LnGQrplFhwSff8FUIFPVfQzBDyG7fvwKeM9teO8o1LVUpMnzIkAcIO3tkAraeFVi+pYaJP6YMXXBxsQVmnFf1ljKPsFRpjJ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313507; c=relaxed/simple;
	bh=t/6bTMiWUaEV1IYOjK8N+ioKve+8nIP8GwG/6p2eaTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yli7//bv7zewgDv2YxZ8nQQdtGPeWZBJymlyXM1162Q05dm0WEr4+3d42N8Q683QEI5IPKF74MU4AsbARjfuPNZIjW8tl/0aZs7AS3MICy2UKYHdX2mPwzVfVsGYHjSIVIwDi4wNoNP5ZaGe+HRA/3LXiIlw8fmDgekT8+dnoJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q35MDHB4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q35MDHB4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 392592308;
	Wed, 24 Jun 2026 08:05:00 -0700 (PDT)
Received: from [10.1.25.171] (XHFQ2J9959-4.cambridge.arm.com [10.1.25.171])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 228DF3F905;
	Wed, 24 Jun 2026 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782313504; bh=t/6bTMiWUaEV1IYOjK8N+ioKve+8nIP8GwG/6p2eaTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q35MDHB4NR7gxpgq4eAorP8mtkFCyLvLaC/Od24ga5UC549ID02pnOqRcnH6WRw4y
	 VnXBa8D8vtzVB1X31ZHO7sAz9n5a5CeMqqgaSGy+h846vop4qVp5pdAvA41zoByrv1
	 2c2Jsp9lHo0JDLD48N/06IdttEj2eHmNG5YdxR8c=
Message-ID: <d2a633c8-496e-48e1-bfa0-a0fc75bd0a08@arm.com>
Date: Wed, 24 Jun 2026 16:05:01 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 337/522] arm64/mm: Enable batched TLB flush in
 unmap_hotplug_range()
To: Will Deacon <will@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, patches@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>, mark.rutland@arm.com
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145141.584613180@linuxfoundation.org>
 <b0d5836032ce3135bfc473f6bff791306d086925.camel@decadent.org.uk>
 <ajqXWqiAol6Shdd6@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <ajqXWqiAol6Shdd6@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/06/2026 15:25, Will Deacon wrote:
> On Sun, Jun 21, 2026 at 05:02:27PM +0200, Ben Hutchings wrote:
>> On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
>>> 6.1-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Anshuman Khandual <anshuman.khandual@arm.com>
>>>
>>> [ Upstream commit 48478b9f791376b4b89018d7afdfd06865498f65 ]
>> [...]
>>> @@ -949,15 +953,14 @@ static void unmap_hotplug_pmd_range(pud_
>>>  		WARN_ON(!pmd_present(pmd));
>>>  		if (pmd_sect(pmd)) {
>>>  			pmd_clear(pmdp);
>>> -
>>> -			/*
>>> -			 * One TLBI should be sufficient here as the PMD_SIZE
>>> -			 * range is mapped with a single block entry.
>>> -			 */
>>> -			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>>> -			if (free_mapped)
>>> +			if (free_mapped) {
>>> +				/* CONT blocks are not supported in the vmemmap */
>>> +				WARN_ON(pmd_cont(pmd));
>>> +				flush_tlb_kernel_range(addr, addr + PMD_SIZE);
>>
>> It wasn't clear to me from the commit message why this now adds PMD_SIZE
>> rather than PAGE_SIZE.  It seems like this change is fine for Linux
>> 6.13+ with a CPU that supports TLB range flushing, but otherwise results
>> in unnecessarily executing multiple TLB invalidations at intervals of
>> the base page size.
> 
> Hmm, the commit message also makes very little sense to me and so I don't
> understand why this patch has us doing multiple TLB invalidations when
> we run into a !cont, block mapping at the PMD level. The old comment
> (which this patch removes) should still apply afaict.
> 
> Anshuman, Ryan, any ideas what's going on here?

I think this change was probably my fault; Given the API is called
flush_tlb_kernel_range() it seemed like an abuse/hack to pretend we are only
flushing the first PAGE_SIZE of the range. But as I understand it, even if the
HW shatters a block mapping into multiple TLB entries, all of the entries
relating to the block mapping will be invalidated if just one of them intersects
the TLBI range/address. So it should be safe to reapply this hack.

Although ideally I think it would be better if this API took a stride argument;
then intent is clear.

What's the best way to handle this? Submit a patch for mainline that reverts
this part, then get it backported to stable (implying this current patch will
have been applied to stable)?

Thanks,
Ryan


> 
> Will

