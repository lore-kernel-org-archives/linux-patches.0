Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B09208989
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741265978; cv=none; b=Cf2Pmgtjo//YRR4VNZFGXxLstaxnXevPqkwE5d+rmjW/HlHD1dNIoO0IlRuIamHyqn6vuHbCpu7c98TAz6QKt7cQcoNO1BnvNESyITN/+bMViHXUAlk8mfEljqqAchjLFwRc3bptdTLta4V31Hd3EA0tEhrSuF9mmWpjC19mO0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741265978; c=relaxed/simple;
	bh=7RGkC1EA/BY2z3r6W0VYoi6BmXWbjQm19otvJOoWWBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G2OcnWrKPsfOySLc0g7Jnk9vsUXaZMLt5Yn2YiJwaOeonURbPHQWMxHQ00saNPnTP+AQse6NHVApvK4/T8R/wcBeYZyAN/92Y/dg9kpb/dY24iYfGGJOm5RgEOYmYgWLXCf6W9o6+hyEfEoCcNoUwp2p7EFTKA83FjstBOBN+So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 065081007;
	Thu,  6 Mar 2025 04:59:49 -0800 (PST)
Received: from [10.1.37.172] (XHFQ2J9959.cambridge.arm.com [10.1.37.172])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 286653F673;
	Thu,  6 Mar 2025 04:59:35 -0800 (PST)
Message-ID: <cec0e878-8f2e-47eb-a055-091b1a984a16@arm.com>
Date: Thu, 6 Mar 2025 12:59:33 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 100/157] arm64: hugetlb: Fix
 huge_ptep_get_and_clear() for non-present ptes
Content-Language: en-GB
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174509.330888653@linuxfoundation.org>
 <ebf8b6fc-33b8-408b-aeac-96b8495753e6@kernel.org>
 <44400ac2-4c46-498c-a5d1-5a0441dd5571@kernel.org>
 <4d1cfbc1-0bae-4d3a-a3c5-fb3668b14ae6@arm.com>
 <2025030612-polio-handclasp-49f8@gregkh>
 <cf893fad-7978-4290-9e86-93aeb5accbfb@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <cf893fad-7978-4290-9e86-93aeb5accbfb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/03/2025 12:03, Jiri Slaby wrote:
> On 06. 03. 25, 12:57, Greg Kroah-Hartman wrote:
>> On Thu, Mar 06, 2025 at 11:49:15AM +0000, Ryan Roberts wrote:
>>> On 06/03/2025 08:08, Jiri Slaby wrote:
>>>> On 06. 03. 25, 9:07, Jiri Slaby wrote:
>>>>> On 05. 03. 25, 18:48, Greg Kroah-Hartman wrote:
>>>>>> 6.13-stable review patch.  If anyone has any objections, please let me know.
>>>>>>
>>>>>> ------------------
>>>>>>
>>>>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>
>>>>>> commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.
>>>> ...
>>>>>> @@ -401,13 +393,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
>>>>>>    {
>>>>>>        int ncontig;
>>>>>>        size_t pgsize;
>>>>>> -    pte_t orig_pte = __ptep_get(ptep);
>>>>>> -
>>>>>> -    if (!pte_cont(orig_pte))
>>>>>> -        return __ptep_get_and_clear(mm, addr, ptep);
>>>>>> -
>>>>>> -    ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>>>>> +    ncontig = num_contig_ptes(sz, &pgsize);
>>>>>
>>>>>
>>>>> This fails to build:
>>>>>
>>>>> /usr/bin/gcc-current/gcc (SUSE Linux) 14.2.1 20250220 [revision
>>>>> 9ffecde121af883b60bbe60d00425036bc873048]
>>>>> /usr/bin/aarch64-suse-linux-gcc (SUSE Linux) 14.2.1 20250220 [revision
>>>>> 9ffecde121af883b60bbe60d00425036bc873048]
>>>>> run_oldconfig.sh --check... PASS
>>>>> Build...                    FAIL
>>>>> + make -j48 -s -C /dev/shm/kbuild/linux.34170/current ARCH=arm64 HOSTCC=gcc
>>>>> CROSS_COMPILE=aarch64-suse-linux- clean
>>>>> arch/arm64/mm/hugetlbpage.c:397:35: error: 'sz' undeclared (first use in this
>>>>> function); did you mean 's8'?
>>>>>         |                                   s8
>>>>> arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is
>>>>> reported only once for each function it appears in
>>>>> make[4]: *** [scripts/Makefile.build:197: arch/arm64/mm/hugetlbpage.o] Error 1
>>>>
>>>> It looks like the stable tree is missing this pre-req:
>>>> commit 02410ac72ac3707936c07ede66e94360d0d65319
>>>> Author: Ryan Roberts <ryan.roberts@arm.com>
>>>> Date:   Wed Feb 26 12:06:51 2025 +0000
>>>>
>>>>      mm: hugetlb: Add huge page size param to huge_ptep_get_and_clear()
>>>
>>> Although this patch is marked for stable there was a conflict so it wasn't
>>> applied. I'll try to get the backport done in the next few days.
>>
>> I'll just drop this one now, can you send me the backports for both of
>> these when they are ready?
> 
> FWIW, the series were three patches, not sure if later "101/157] arm64: hugetlb:
> Fix flush_hugetlb_tlb_range() invalidation level" is affected when either of the
> two discussed here is not present...

No, that one is independent and can remain.

> 
> So perhaps drop both 100+101/157 for now?
> 
> thanks,

