Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241D2388377
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 02:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782354602; cv=none; b=gYdQqQiQfQPKlUuvD8rZPYQnxaS97otxX6pOmlTIcduJdwdBtDxtNCww196ip8WsdRAay6oyCJIycwg3N3TsHActlYnZgKuUHoaiQPIj0x8sl7hPXq8/L9yoJAnFvhrELaT8yvb6XmFWmI3D+2bCJ0pu7xpJJmbAz+YQXRuRUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782354602; c=relaxed/simple;
	bh=H4FgjilvRhDxaejSOs5jXTlNlpdPoqb31yfgAlihuI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UuIlR7rItWcQfxJ9Dao6rhwQtwNQI8MyTBJ9aSP0UyARMYtoJqgbIad8zV8+rbqp6Sx3tpdNzZUqcdFQwvzvX0kdOE+00HXkY2sz9jtug/idNLTK1ok3vZij13YxDrAbtjhG/ugH0sqWxpF8G2waYD9z5ECRlOWKcYfVwkmqBYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=giYOnuqR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="giYOnuqR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 719C72309;
	Wed, 24 Jun 2026 19:29:52 -0700 (PDT)
Received: from [10.164.18.48] (J09HK2D2RT.blr.arm.com [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE6E53F836;
	Wed, 24 Jun 2026 19:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782354597; bh=H4FgjilvRhDxaejSOs5jXTlNlpdPoqb31yfgAlihuI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=giYOnuqRdTISFy6hmWYZAGBzFNiE301udlj9j8E36XojIMm1id4IDbBt0Pz8fXMi+
	 lPks3QTwKXnd2PcNe+ZX+ft3eOkI9Mz0BwsIm2M8pVZLdSWoEim1eegI/oZYlyKXCU
	 8EfgGf/tcUo4PnBel4ckzDZ78lcKhuSctPtNojKI=
Message-ID: <b51f82ed-aa54-4c67-bcef-e59acd10c789@arm.com>
Date: Thu, 25 Jun 2026 07:59:51 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 337/522] arm64/mm: Enable batched TLB flush in
 unmap_hotplug_range()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, patches@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
 mark.rutland@arm.com
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145141.584613180@linuxfoundation.org>
 <b0d5836032ce3135bfc473f6bff791306d086925.camel@decadent.org.uk>
 <ajqXWqiAol6Shdd6@willie-the-truck>
 <d2a633c8-496e-48e1-bfa0-a0fc75bd0a08@arm.com>
 <2026062451-bluff-coherent-672d@gregkh>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <2026062451-bluff-coherent-672d@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 24/06/26 9:59 PM, Greg Kroah-Hartman wrote:
> On Wed, Jun 24, 2026 at 04:05:01PM +0100, Ryan Roberts wrote:
>> On 23/06/2026 15:25, Will Deacon wrote:
>>> On Sun, Jun 21, 2026 at 05:02:27PM +0200, Ben Hutchings wrote:
>>>> On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
>>>>> 6.1-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Anshuman Khandual <anshuman.khandual@arm.com>
>>>>>
>>>>> [ Upstream commit 48478b9f791376b4b89018d7afdfd06865498f65 ]
>>>> [...]
>>>>> @@ -949,15 +953,14 @@ static void unmap_hotplug_pmd_range(pud_
>>>>>  		WARN_ON(!pmd_present(pmd));
>>>>>  		if (pmd_sect(pmd)) {
>>>>>  			pmd_clear(pmdp);
>>>>> -
>>>>> -			/*
>>>>> -			 * One TLBI should be sufficient here as the PMD_SIZE
>>>>> -			 * range is mapped with a single block entry.
>>>>> -			 */
>>>>> -			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>>>>> -			if (free_mapped)
>>>>> +			if (free_mapped) {
>>>>> +				/* CONT blocks are not supported in the vmemmap */
>>>>> +				WARN_ON(pmd_cont(pmd));
>>>>> +				flush_tlb_kernel_range(addr, addr + PMD_SIZE);
>>>>
>>>> It wasn't clear to me from the commit message why this now adds PMD_SIZE
>>>> rather than PAGE_SIZE.  It seems like this change is fine for Linux
>>>> 6.13+ with a CPU that supports TLB range flushing, but otherwise results
>>>> in unnecessarily executing multiple TLB invalidations at intervals of
>>>> the base page size.
>>>
>>> Hmm, the commit message also makes very little sense to me and so I don't
>>> understand why this patch has us doing multiple TLB invalidations when
>>> we run into a !cont, block mapping at the PMD level. The old comment
>>> (which this patch removes) should still apply afaict.
>>>
>>> Anshuman, Ryan, any ideas what's going on here?
>>
>> I think this change was probably my fault; Given the API is called
>> flush_tlb_kernel_range() it seemed like an abuse/hack to pretend we are only
>> flushing the first PAGE_SIZE of the range. But as I understand it, even if the
>> HW shatters a block mapping into multiple TLB entries, all of the entries
>> relating to the block mapping will be invalidated if just one of them intersects
>> the TLBI range/address. So it should be safe to reapply this hack.
>>
>> Although ideally I think it would be better if this API took a stride argument;
>> then intent is clear.
>>
>> What's the best way to handle this? Submit a patch for mainline that reverts
>> this part, then get it backported to stable (implying this current patch will
>> have been applied to stable)?
> 
> yes, that's probably the best way.
Sure, will send out the change as suggested.
