Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFC83CE49F
	for <patches@lists.linux.dev>; Mon, 16 Mar 2026 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683066; cv=none; b=ezVvCXcBMJIKEZWGWg6aP8VGMOVBs3fREObhpxOzeM3R+FNNGGgTYNqlf4EdkQ15IW1XOfTvSkWmzCIFlUa2vXdSosgLFDI6CzVk1FfrVOz5SCxXcetudAr0ufNZderjJR1y9psPrcDdoqZ5SofC6F+ItYccU4bNYBDiDwIcyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683066; c=relaxed/simple;
	bh=AoEkeqD/vB9Dy20Bqbyn1bQsTN5iJULikBCYkrMg9dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QZ1tNlNcb7cPrTPKGZS22gAY1Jt7CNeyID/DY/ogzwvU9oEE/1dV9U+0OZRpPF8qEDB5LGSqp7qHlTaLA8ro651Mf3D6adO6DhURZTOY5v8ZchCKtQKTQNFWedMIT48QZdYMfsxd9mcCKvZrfQnosxzslu7l10xUht4R7FQksLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 508721477;
	Mon, 16 Mar 2026 10:44:18 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AAC33F73B;
	Mon, 16 Mar 2026 10:44:22 -0700 (PDT)
Message-ID: <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
Date: Mon, 16 Mar 2026 17:44:20 +0000
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
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/2/26 18:46, Reinette Chatre wrote:
> Hi Everybody,
> 
> This is a collection of resctrl cleanups assembled together for convenience
> and simpler tracking. I'd be happy to split them up if it makes review and/or
> handling easier.
> 
> Summary of changes:
> 
> - Let resctrl pass stricter checks from various tools to provide a cleaner
>   baseline with the goal to promote healthier contributions:
>   - ./tools/docs/kernel-doc -Wall -v <files>
>   - Build with W=12
>   - ./scripts/coccicheck
>   - Static checkers
> 
> - Use accurate and consistent type for all uses of resource ID.
> 
> - In the unlikely scenario that resctrl picked a wrong CPU to read an event
>   from, pass the error through to user space instead of claiming to succeed
>   and returning a (wrong) result.
> 
> - Since inception of last_cmd_status feature there have been mismatches
>   between resctrl file operation failures and the contents of
>   info/last_cmd_status. This pattern keeps propagating with each new resctrl
>   feature. Establish a new baseline with a new pattern that ensures
>   info/last_cmd_status contains an accurate failure description that matches
>   the most recent resctrl file operation failure.
> 
One related issue I've just noticed is that when ABMC and mbm_assign_on_mkdir are
enabled the creation of MON/CTRL_MON directories may succeed but an error message
is written to last_cmd_status. E.g.

/sys/fs/resctrl# mkdir mon_groups/new5
/sys/fs/resctrl# cat info/last_cmd_status
Failed to allocate counter for mbm_total_bytes in domain 2

The failure is ignored, as expected, in rdt_assign_cntrs() but the last_cmd_status
is never cleared. I think this could be fixed by:

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 62edb464410a..396f17ed72c6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1260,6 +1260,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
                rdtgroup_assign_cntr_event(NULL, rdtgrp,
                                           &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
+
+       rdt_last_cmd_clear();
 }

Is this right thing to do? Let me know if you want a proper patch.


Thanks,

Ben
