Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9055E3CAA3A
	for <patches@lists.linux.dev>; Thu, 28 May 2026 10:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779965504; cv=none; b=WKfntwdcqTABvevmZQAhwbn2mx+Iwb7ulQ7ER9jdD8n7Ff9wyRFYleHSfpmk3pd00yY9x7nd+DDItddEW78pibuaKSANI+IPwfEt8c4N78M6XmEOTA7oA4Os10P5IV6hBu/yoPwUI/rWAZb9kHe3GhSeUWneNOGRFfs+SaITkz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779965504; c=relaxed/simple;
	bh=Sj45zY3ru6Hkoq9kObw932Ofn4nk/ldsNgk8nUPYBEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rU7UxPUw3MSSUAd5ZdxFF3CNNgaDgsoTaTRgbXqbFQ7lGtkSmhFtyA5xiT7XDf6Rv7f/GZ0WTf3cUV1B5O4O6CiGU467bz0lzKgI5X45mJZgzVj/pQCAzqsLVS4FSmZB0NAAbNFnxa4dv5MSQDU3/r8hFTydgszvwBuzvHq/vEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OkqdX/+3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OkqdX/+3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1A6D43F7;
	Thu, 28 May 2026 03:51:36 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFCDA3F905;
	Thu, 28 May 2026 03:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779965502; bh=Sj45zY3ru6Hkoq9kObw932Ofn4nk/ldsNgk8nUPYBEk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OkqdX/+31aLnE5A4THDrEh4JKd2tN4Zuyhqm7W9Ggr31pNJc3xXPgdE1S75P9rmR/
	 AReS2dKHAYfvGVyq7psO1v6peBsDMwMuI9onxPqenemvzzeIoHK/kiOmwP2Ye/dGtq
	 pkC18dVWLlc74sTQ285POTZ9GVIOOZ1CKRSzphis=
Message-ID: <3e53dddf-ca34-4746-b0ba-f5188193515c@arm.com>
Date: Thu, 28 May 2026 11:51:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v3 5/9] fs/resctrl: Prevent use-after-free in
 rdtgroup_kn_put()
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <f4e57df85e7aa7e6055b1765530bba900685045b.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <f4e57df85e7aa7e6055b1765530bba900685045b.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 5/22/26 20:15, Reinette Chatre wrote:
> A struct rdtgroup is reference counted via rdtgroup::waitcount. Callers
> that need the structure to remain valid across a sleep (while waiting on
> acquiring rdtgroup_mutex) take a reference with rdtgroup_kn_get() and
> release it with rdtgroup_kn_put(). The release path is intended to serve
> as the fallback freer: if the count drops to zero and the group has
> already been marked RDT_DELETED, rdtgroup_kn_put() frees the structure.
> The bulk teardown paths free_all_child_rdtgrp() and rmdir_all_sub()
> resulting from a resctrl directory remove or resctrl fs unmount act as
> the primary freer: they hold rdtgroup_mutex and free each rdtgroup whose
> waitcount is zero, otherwise they set RDT_DELETED and leave the freeing
> to the last waiter.
> 
> These two freers race. rdtgroup_kn_put() commits waitcount == 0 with
> atomic_dec_and_test() outside rdtgroup_mutex, then reads rdtgroup::flags.
> Between those two operations a concurrent caller of free_all_child_rdtgrp()
> or rmdir_all_sub() (which holds the mutex) can observe waitcount == 0 via
> atomic_read(), call rdtgroup_remove(), and kfree() the structure. The
> subsequent read of rdtgroup::flags in rdtgroup_kn_put() is then a
> use-after-free, and the structure may even be freed twice if the freed
> memory happens to satisfy the RDT_DELETED flag check.
> 
> Replace the bare atomic_dec_and_test() with atomic_dec_and_mutex_lock()
> so that the decrement-to-zero takes rdtgroup_mutex before the count
> becomes globally visible. The inspection of rdtgroup::flags then runs
> under the same mutex held by the bulk freers, making the two paths
> mutually exclusive. The common case where the count does not reach
> zero remains lock-free. Defer kernfs_unbreak_active_protection() until
> after the mutex is dropped since kernfs active protections functionally
> wrap rdtgroup_mutex. Remove resource group, which in turn drops its kernfs
> reference, after kernfs protection is restored.
> 
> Fixes: b8511ccc75c0 ("x86/resctrl: Fix use-after-free when deleting resource groups")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=1
> Assisted-by: GitHub_Copilot:gemini-3.1-pro
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Seems good to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

> ---
> Changes since V2:
> - New patch
> ---
>  fs/resctrl/rdtgroup.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index d323b515060b..6418395877cf 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2606,15 +2606,24 @@ static void rdtgroup_kn_get(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
>  
>  static void rdtgroup_kn_put(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
>  {
> -	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
> -	    (rdtgrp->flags & RDT_DELETED)) {
> +	bool needs_free;
> +
> +	if (!atomic_dec_and_mutex_lock(&rdtgrp->waitcount, &rdtgroup_mutex)) {
> +		kernfs_unbreak_active_protection(kn);
> +		return;
> +	}
> +
> +	needs_free = rdtgrp->flags & RDT_DELETED;
> +
> +	mutex_unlock(&rdtgroup_mutex);
> +
> +	kernfs_unbreak_active_protection(kn);
> +
> +	if (needs_free) {
>  		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
>  		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
>  			rdtgroup_pseudo_lock_remove(rdtgrp);
> -		kernfs_unbreak_active_protection(kn);
>  		rdtgroup_remove(rdtgrp);
> -	} else {
> -		kernfs_unbreak_active_protection(kn);
>  	}
>  }
>  

