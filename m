Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563FB33F397
	for <patches@lists.linux.dev>; Wed, 26 Nov 2025 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764176180; cv=none; b=gA8+yJ4lbzM37xSwydhVS5xuFL5rjgMS/BiMwJVTDIqE7ANsZyfflUcl+6Gan/YPoZuHf9iQwWBZRStPYWvNzd7IQgGpUGpDQmoY2S6NJTWmVVMWqh1yzquAdalcYC0BUd1CFdPNYRV3PyyL/rQnYGueDOY8Mb5RsZSqryO0F78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764176180; c=relaxed/simple;
	bh=++ZtB/K1Mk/I0zej5vRfG6UaoC4ZKRQ/u7W0qsollWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5gH9YWkX2KiVtkRE6Ruw2VkPbvLq7e48Y8wDFxV3iIzEMYvXaPvWyuQ8Cvn5hf4MNNjrhswRBWMSjRn6OigwYXPhOYnI3VRYvH/4IS6U8HcPiuC+hpessaDKC31RmuVNZlR/hNf2b/WkmAFNeCxu/nVohw42FW7Bs+hqsSEYzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5552F168F;
	Wed, 26 Nov 2025 08:56:10 -0800 (PST)
Received: from [10.57.42.217] (unknown [10.57.42.217])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ED9A3F66E;
	Wed, 26 Nov 2025 08:56:16 -0800 (PST)
Message-ID: <af62a882-1b14-4491-a456-5fd3040d02d6@arm.com>
Date: Wed, 26 Nov 2025 16:57:04 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 051/529] sched/pelt: Avoid underestimation of task
 utilization
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
 Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar
 <mingo@kernel.org>, John Stultz <jstultz@google.com>
References: <20251121130230.985163914@linuxfoundation.org>
 <20251121130232.828187990@linuxfoundation.org>
Content-Language: en-US
From: Lukasz Luba <lukasz.luba@arm.com>
In-Reply-To: <20251121130232.828187990@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 11/21/25 13:05, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

No objections, just for history linking...


> 
> ------------------
> 
> From: Vincent Guittot <vincent.guittot@linaro.org>
> 
> commit 50181c0cff31281b9f1071575ffba8a102375ece upstream.
> 
> Lukasz Luba reported that a thread's util_est can significantly decrease as
> a result of sharing the CPU with other threads.
> 
> The use case can be easily reproduced with a periodic task TA that runs 1ms
> and sleeps 100us. When the task is alone on the CPU, its max utilization and
> its util_est is around 888. If another similar task starts to run on the
> same CPU, TA will have to share the CPU runtime and its maximum utilization
> will decrease around half the CPU capacity (512) then TA's util_est will
> follow this new maximum trend which is only the result of sharing the CPU
> with others tasks.
> 
> Such situation can be detected with runnable_avg wich is close or
> equal to util_avg when TA is alone, but increases above util_avg when TA
> shares the CPU with other threads and wait on the runqueue.
> 
> [ We prefer an util_est that overestimate rather than under estimate
>    because in 1st case we will not provide enough performance to the
>    task which will remain under-provisioned, whereas in the other case we
>    will create some idle time which will enable to reduce contention and
>    as a result reduces the util_est so the overestimate will be transient
>    whereas the underestimate will remain. ]
> 
> [ mingo: Refined the changelog, added comments from the LKML discussion. ]
> 
> Reported-by: Lukasz Luba <lukasz.luba@arm.com>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/lkml/CAKfTPtDd-HhF-YiNTtL9i5k0PfJbF819Yxu4YquzfXgwi7voyw@mail.gmail.com/#t
> Link: https://lore.kernel.org/r/20231122140119.472110-1-vincent.guittot@linaro.org
> Cc: Hongyan Xia <hongyan.xia2@arm.com>
> Cc: John Stultz <jstultz@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/sched/fair.c |   13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4836,6 +4836,11 @@ static inline unsigned long task_util(st
>   	return READ_ONCE(p->se.avg.util_avg);
>   }
>   
> +static inline unsigned long task_runnable(struct task_struct *p)
> +{
> +	return READ_ONCE(p->se.avg.runnable_avg);
> +}
> +
>   static inline unsigned long _task_util_est(struct task_struct *p)
>   {
>   	struct util_est ue = READ_ONCE(p->se.avg.util_est);
> @@ -4955,6 +4960,14 @@ static inline void util_est_update(struc
>   		return;
>   
>   	/*
> +	 * To avoid underestimate of task utilization, skip updates of EWMA if
> +	 * we cannot grant that thread got all CPU time it wanted.
> +	 */
> +	if ((ue.enqueued + UTIL_EST_MARGIN) < task_runnable(p))
> +		goto done;
> +
> +
> +	/*
>   	 * Update Task's estimated utilization
>   	 *
>   	 * When *p completes an activation we can consolidate another sample
> 
> 


I've pointed ChromeOS folks to this patch backport. They have tested
the patch in their 6.6 kernel and posted the results (speedometer 2.1)
- which are really good [1].

I thought it would be worth to link this here as well.

Regards,
Lukasz

[1] 
https://lore.kernel.org/lkml/CAKchOA31NGBWMdeSjky7MwOjU=dYmHVLbE7uUQHUXSZOzUHUeA@mail.gmail.com/
