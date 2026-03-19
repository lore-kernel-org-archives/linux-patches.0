Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C8E378D6E
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 09:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773914009; cv=none; b=m/xZtUSRr0/NhEOWTGANvN522Ovc81k+sJKLDGsyES1K6HD6YGFfE/f1zCNM+/Cigyi2JIPRt3I2Jag3pH7qmyA8xExvE8RmhwFb2tRELI98c/XNdKSwIpUZQdevCdMYGwaCIqq+ogTEC3tyK3rqDSF4ImFXQX8I+gEu60mw6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773914009; c=relaxed/simple;
	bh=68K/dolBJAjjhPClcFbX1Lmez86cJ63gNMiW7YJMdWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxtqh+dvTkTc36fpWOGCMLU7HcTOy+nA7aiwHKkSmAhNUiB7iXsb9Q22xmLsR0pVOyG1Ut9pgqvFtYgNh088PTXii+9rXEexT+20d0ig10+HKwiakD40lmWafbru3XolhZzgWZAkLQSOqHhGbEsh5RNOc9YTJFvFc80gq1jDI4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49F571A25;
	Thu, 19 Mar 2026 02:53:14 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AEF63F7BD;
	Thu, 19 Mar 2026 02:53:18 -0700 (PDT)
Message-ID: <886f1287-c6cf-4162-bb2d-8b32c679990c@arm.com>
Date: Thu, 19 Mar 2026 09:53:16 +0000
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
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <06df6bde-6790-4320-bcf1-cad2ab3d473e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/18/26 20:12, Reinette Chatre wrote:
> Hi Ben,
> 
> On 3/18/26 10:10 AM, Ben Horgan wrote:
>> On 3/18/26 16:35, Reinette Chatre wrote:
> 
> 
>>> What resctrl could do in such scenario is to at least convey that some messages were
>>> dropped. Consider, for example:
>>>
>>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>>> index 5da305bd36c9..ea77fa6a38f7 100644
>>> --- a/fs/resctrl/rdtgroup.c
>>> +++ b/fs/resctrl/rdtgroup.c
>>> @@ -973,10 +973,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
>>>  
>>>  	mutex_lock(&rdtgroup_mutex);
>>>  	len = seq_buf_used(&last_cmd_status);
>>> -	if (len)
>>> +	if (len) {
>>>  		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
>>> -	else
>>> +		if (seq_buf_has_overflowed(&last_cmd_status))
>>> +			seq_puts(seq, "[truncated]\n");
>>> +	} else {
>>>  		seq_puts(seq, "ok\n");
>>> +	}
>>>  	mutex_unlock(&rdtgroup_mutex);
>>>  	return 0;
>>>  }
>>
>> Adding a truncation indication makes sense to me. Would it be good to reserve space in the
>> last_cmd_status_buf[] to ensure this can always be displayed? It looks like space could be
>> made by interacting with seq->size directly but I'm not sure if there is a cleaner way
>> to do it.
>>
> 
> Please note the distinction between the struct seq_file instance pointed to by seq and the 
> struct seq_buf instance last_cmd_status. The last_cmd_status seq_buf instance is backed by
> last_cmd_status_buf of 512 bytes which is printed to the seq_file instance seq that is
> backed by another buffer that starts out with size PAGE_SIZE. So, it looks to me
> like printing last_cmd_status_buf to the seq seq_file instance followed by "[truncated]\n"
> should fit by default? This should keep working even if last_cmd_status_buf size is

Thanks for the explanation. I had missed that distinction. I've just given your code a go with
some hacked in rdt_last_cmd_puts() calls and it behaves as you say.

We've discussed two changes, one is adding a truncation message to last_cmd_status and the other
is carrying on after failure when allocating counters. Are you going to take these from here or would
you like patches from me?

Thanks,

Ben

> increased since seq_read_iter() that calls this show() would just keep increasing the
> buffer backing the seq_file (up to a very large limit of MAX_RW_COUNT which is INT_MAX & PAGE_MASK)
> until it does fit.
> 
> Reinette

