Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2967271443
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940730; cv=none; b=DohK7RU7Yz4feXHuLYeYGrMzIyI1TlXxSkeo5uz2SWiZQcWrgTutGo37J/Zq//wFa/4HPBAiZ4m/Pbrk0LMqcPPYeRpxCwuwQiQZmemEwdQEkFv53fEKkMmTUOaXlmmX7zQIFr4nwEQ8u6vZCyqcgYpdJXIv+DyvE4cjKbpqjAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940730; c=relaxed/simple;
	bh=LcdgG4+Gg7m/VkDuQz2t2vEuVMXwcZ2putMBfgivwRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSXfWc9lR4bm1h9OiOliDbcfjwwR1BN9mdI7edSxqvpxzc6k+nQ6X8AdWVWv2RPtLkogHlFUjF6JWJD2r5RSWLPkrsGZU3jYKEd6XOKXdH3gKgps8332zydQ2EpcAyOD8X0S4I9OmmIMXlGR0DIm7QWyq4bx+3AkF6Ux1YpQkEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 637EE2247;
	Thu, 19 Mar 2026 10:18:42 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66DB3F778;
	Thu, 19 Mar 2026 10:18:46 -0700 (PDT)
Message-ID: <eb9c6eb6-bb81-42c5-927b-387454314843@arm.com>
Date: Thu, 19 Mar 2026 17:18:45 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
 <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
 <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
 <f37db924-dc65-432b-ae48-ddd986b3efd9@intel.com>
 <d4460f04-813f-4a6f-ad1f-6f2e5bb1c9fa@arm.com>
 <55a9461e-32f8-4665-905e-bc18b7201c7e@intel.com>
 <e7e480ed-4dee-4898-a47e-8730eea2dcde@arm.com>
 <06df6bde-6790-4320-bcf1-cad2ab3d473e@intel.com>
 <886f1287-c6cf-4162-bb2d-8b32c679990c@arm.com>
 <b00bb178-9de3-4baf-ad9a-c842054f71a7@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <b00bb178-9de3-4baf-ad9a-c842054f71a7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/19/26 16:18, Reinette Chatre wrote:
> Hi Ben,
> 
> On 3/19/26 2:53 AM, Ben Horgan wrote:
>> Hi Reinette,
>>
>> On 3/18/26 20:12, Reinette Chatre wrote:
>>> Hi Ben,
>>>
>>> On 3/18/26 10:10 AM, Ben Horgan wrote:
>>>> On 3/18/26 16:35, Reinette Chatre wrote:
[...]
>>
>> We've discussed two changes, one is adding a truncation message to last_cmd_status and the other
>> is carrying on after failure when allocating counters. Are you going to take these from here or would
>> you like patches from me?
> 
> Adding the truncation message to last_cmd_status seems to complement the other last_cmd_status
> improvements in this series. I'd be happy to create the patch and include it as part of this
> series.
> 
> I would like to confirm behavior when encountering error when allocating counters though:
> My previous assessment of rdtgroup_assign_cntr_event() callers was incomplete since it is also
> called with NULL domain when the user uses the "*=<assignment state>" syntax to mbm_L3_assignments.
> This is a different scenario from directory creation since it passes the error back to
> user space. While here it may also be ok to carry on after a counter could not be allocated in
> one domain I do think that user space should still learn via error return that not all allocations
> succeeded.

Thanks for pointing this out, I'd missed it too.

> 
> Even so, to answer your original question, please create the patches that change the allocation
> behavior. This seems to complement the work you are currently doing and would be easy for you to test
> (I do not have access to assignable mode hardware).

Ok, will do.

Thanks,

Ben

> 
> Thank you.
> 
> Reinette
> 

