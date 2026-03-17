Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE1A3F7898
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767344; cv=none; b=Q69Imz0f/OWRQB/KZWilp0Sfdq+a794JqpkOA7YDPzxVHvS/k5ZVCyJixhmzEfAuvReIz0+EDzzSlfgQ86naHQFtTPx29sVRt9vYPfOyn//HSxhdZ5AUZr8YzTtVy4aW2UxW0n0S6S21MUX3c3zZoF4ilgAV0mJsnV3ozaXeiWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767344; c=relaxed/simple;
	bh=EyYB59klCIqvaKcLhRca+XnrHvZQ8qHkikXOxiyw19s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6j3RtjMeUw4bwCciJWop4Pz6kMxF6u8QsfjlEAi+ct89wijbETmNz0RxmTX3Iy2oZoBelIe18kdNqMpIk9A25kjKzi6w7I3LKz0IaAF7uIWNJRj4b/JbQsPKgh8R4xtxJw8KgZ2HKcyDpGGQaBN9f6vTbfft5Eui2CMm9x34F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D999B1477;
	Tue, 17 Mar 2026 10:08:55 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 485FF3F778;
	Tue, 17 Mar 2026 10:09:00 -0700 (PDT)
Message-ID: <bf676288-5404-4c63-bf9f-ce2382f7ae91@arm.com>
Date: Tue, 17 Mar 2026 17:08:59 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 06/11] fs/resctrl: Pass error reading event through to
 user space
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <6ceb56817d137bee96a5e4508657bf9080cb4acf.1772476561.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <6ceb56817d137bee96a5e4508657bf9080cb4acf.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/2/26 18:46, Reinette Chatre wrote:
> Reading of event data is managed through populating a struct rmid_read with
> properties of event needing to be read. This data is dispatched to an
> appropriate CPU and upon completion any error can be found in rmid_read::err,
> or on success the event data will be in rmid_read::val.
> 
> rmid_read::err is not updated in the unlikely scenario that the reading
> of the event was dispatched to a wrong CPU. If this ever occurs due to
> a bug in resctrl the user space read will return "success" but the data
> reported will be invalid.
> 
> Ensure accurate error reporting so that if there may be an issue with
> how resctrl picks a CPU it could be learned with an error to user space
> instead of silent failure.

Looks good to me. mon_event_count() won't discard the error as the same
cpu and domain choice is used for each __mon_event_count() call.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  fs/resctrl/monitor.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 421c70f96426..f1a08fdbdd61 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -453,8 +453,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	}
>  
>  	/* Reading a single domain, must be on a CPU in that domain. */
> -	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
> +	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask)) {
> +		rr->err = -EIO;
>  		return -EINVAL;
> +	}
>  	if (rr->is_mbm_cntr)
>  		rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
>  						 rr->evt->evtid, &tval);
> @@ -491,8 +493,10 @@ static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *r
>  	}
>  
>  	/* Summing domains that share a cache, must be on a CPU for that cache. */
> -	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> +	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map)) {
> +		rr->err = -EIO;
>  		return -EINVAL;
> +	}
>  
>  	/*
>  	 * Legacy files must report the sum of an event across all

