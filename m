Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB06920B20A
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741261761; cv=none; b=l8S3bXKxZZibL0QWYTU4TSBUa+aIkQ/UsoEjvJrW6v2Ug/qoKbZRzGv+ALd7aELmuR4c/A1YPW0oe/MFI4owetQnOdHBOCTiGlae9OuV10rIqb34D2/Pu3fojeQp5lNXPU0J0O6MT5qwLcCcvdMxe8H8hfUVmw2+hCJBjVwT/1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741261761; c=relaxed/simple;
	bh=m1P/y4a/XvnqZBu4wILmyVofP29nw9DtnMeA2zIrCdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aeodpKpA5+rJaCe0nQofKYD1Met7ILjmA4UKVYBh5RB4UBgAgN7s60sbZaxNgSt0RkH/XzC6YTXsKGcU0BVDqTdlZDJRbopR7OTleyMsnr7waaEuGbnbAXO2l1iXieuU2kHITfSYANHvdo7fG9pxOWp8SpCJ9fn9/LMKPNuy3YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1008D1007;
	Thu,  6 Mar 2025 03:49:31 -0800 (PST)
Received: from [10.1.37.172] (XHFQ2J9959.cambridge.arm.com [10.1.37.172])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B7743F66E;
	Thu,  6 Mar 2025 03:49:17 -0800 (PST)
Message-ID: <4d1cfbc1-0bae-4d3a-a3c5-fb3668b14ae6@arm.com>
Date: Thu, 6 Mar 2025 11:49:15 +0000
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174509.330888653@linuxfoundation.org>
 <ebf8b6fc-33b8-408b-aeac-96b8495753e6@kernel.org>
 <44400ac2-4c46-498c-a5d1-5a0441dd5571@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <44400ac2-4c46-498c-a5d1-5a0441dd5571@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/03/2025 08:08, Jiri Slaby wrote:
> On 06. 03. 25, 9:07, Jiri Slaby wrote:
>> On 05. 03. 25, 18:48, Greg Kroah-Hartman wrote:
>>> 6.13-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.
> ...
>>> @@ -401,13 +393,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
>>>   {
>>>       int ncontig;
>>>       size_t pgsize;
>>> -    pte_t orig_pte = __ptep_get(ptep);
>>> -
>>> -    if (!pte_cont(orig_pte))
>>> -        return __ptep_get_and_clear(mm, addr, ptep);
>>> -
>>> -    ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>> +    ncontig = num_contig_ptes(sz, &pgsize);
>>
>>
>> This fails to build:
>>
>> /usr/bin/gcc-current/gcc (SUSE Linux) 14.2.1 20250220 [revision
>> 9ffecde121af883b60bbe60d00425036bc873048]
>> /usr/bin/aarch64-suse-linux-gcc (SUSE Linux) 14.2.1 20250220 [revision
>> 9ffecde121af883b60bbe60d00425036bc873048]
>> run_oldconfig.sh --check... PASS
>> Build...                    FAIL
>> + make -j48 -s -C /dev/shm/kbuild/linux.34170/current ARCH=arm64 HOSTCC=gcc
>> CROSS_COMPILE=aarch64-suse-linux- clean
>> arch/arm64/mm/hugetlbpage.c:397:35: error: 'sz' undeclared (first use in this
>> function); did you mean 's8'?
>>        |                                   s8
>> arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is
>> reported only once for each function it appears in
>> make[4]: *** [scripts/Makefile.build:197: arch/arm64/mm/hugetlbpage.o] Error 1
> 
> It looks like the stable tree is missing this pre-req:
> commit 02410ac72ac3707936c07ede66e94360d0d65319
> Author: Ryan Roberts <ryan.roberts@arm.com>
> Date:   Wed Feb 26 12:06:51 2025 +0000
> 
>     mm: hugetlb: Add huge page size param to huge_ptep_get_and_clear()

Although this patch is marked for stable there was a conflict so it wasn't
applied. I'll try to get the backport done in the next few days.

Thanks,
Ryan

> 
> 
>>
>>>       return get_clear_contig(mm, addr, ptep, pgsize, ncontig);
>>>   }
>>>
>>>
>>>
>>
> 

