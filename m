Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A5D3B47F4
	for <patches@lists.linux.dev>; Thu, 28 May 2026 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961517; cv=none; b=D4qL61ry3x57kASk3bBcL+CA7zJs0buxngmopEW+eh/JLnBC1eNqnuCDFhxbiWO/GLjL0b0mDTdDqc3XnJhy8IpNGWq2aofS21msmistIzuRKd3HvUJjWkJRQ6bceqxCXBRILKOyhRPmkDsPCSK6insi0wUro0VtIOtapC/PFCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961517; c=relaxed/simple;
	bh=2+jrHg34eIu5U3k/jG2Te3FDNTExDs4/QByz4FxdiSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nvDcX4nNZUK0xNdFUx02Qa7iu8KFbIG45syGHf009Uw7aeNqC6P/7eQuD/egIVdTA8SdgOqxtXeCHVU/R+1DNBhq1M9JmMOBdKH++1EURS8DPwkgDlME1fUTgVtLlTWxDj9DPsGtKAXltZM19uAsLSJIPJ0GjN1xFBNkX5hLlzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XRDXVyOH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XRDXVyOH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA23743F7;
	Thu, 28 May 2026 02:45:08 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34F653F632;
	Thu, 28 May 2026 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779961513; bh=2+jrHg34eIu5U3k/jG2Te3FDNTExDs4/QByz4FxdiSA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XRDXVyOH7hhM8VjtzNn+41bzOsdVlXnumfLPcjIiULXDzFgitn6DcyK9RdJvAq2BG
	 mzzhfYZ5+b+om8sH45qmMADoJtZwPe6g/nkT3Vm7FTHMCIc0VQpk4Ji0ysNFHDJczF
	 0DepMUFKWMuVYdSURbS0yPMpEiSY4rrCqiuKqL+o=
Message-ID: <9db153ad-972c-4e48-95a2-50e3fccf453e@arm.com>
Date: Thu, 28 May 2026 10:45:09 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v3 3/9] fs/resctrl: Fix use-after-free during unmount
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 5/22/26 20:15, Reinette Chatre wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> During unmount or failure teardown all mon_data structures that contain
> monitoring event file private data are freed after which kernfs nodes are
> removed. However, the RDT_DELETED flag is never set for the statically
> allocated default resource group.
> 
> A concurrent reader of an event file associated with the default resource
> group may, after dropping kernfs active protection, block on rdtgroup_mutex
> while unmount proceeds to free the file private data and destroy the kernfs
> node without waiting for the reader.
> 
> When the mutex is released, the reader wakes up, observes that RDT_DELETED
> is not set for the default group, and dereferences the already-freed
> file private data.
> 
> Set RDT_DELETED for the default group unconditionally since the flag does
> not lead to free of this statically allocated group.
> 
> Do not allow a new resctrl mount if there are any waiters on default group
> of previous mount. A new mount will re-initialize the default group that
> would appear to waiters from previous mount as though the default group is
> accessible causing them to access the mon_data structures from the previous
> mount that have been removed.
> 
> Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since V2:
> - Rewrite changelog to not describe code as much.
> - Rework changelog to switch to "Reported-by/Closes".
> - Merge the duplicate rdtgroup_remove() comment with the function comment.
> - Fix changelog to not mention that RDT_DELETED flag is set conditionally.
> - Change "Fixes:" tag to point to commit that introduced dynamically
>   allocated mon_data this bug involves.
> ---
>  fs/resctrl/rdtgroup.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index f573db9e6e84..8a1457825919 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -585,14 +585,20 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
>   *
>   * On resource group creation via a mkdir, an extra kernfs_node reference is
>   * taken to ensure that the rdtgroup structure remains accessible for the
> - * rdtgroup_kn_unlock() calls where it is removed.
> + * rdtgroup_kn_unlock() calls where it is removed. The default group is
> + * statically allocated: it does not have an extra reference but will have
> + * RDT_DELETED set on unmount to support safe access to its associated files
> + * via rdtgroup_kn_lock_live/rdtgroup_kn_unlock().
>   *
> - * Drop the extra reference here, then free the rdtgroup structure.
> + * For all but the default group: drop the extra reference, then free the
> + * rdtgroup structure.
>   *
>   * Return: void
>   */
>  static void rdtgroup_remove(struct rdtgroup *rdtgrp)
>  {
> +	if (rdtgrp == &rdtgroup_default)
> +		return;
>  	kernfs_put(rdtgrp->kn);
>  	kfree(rdtgrp);
>  }
> @@ -2975,6 +2981,7 @@ static void resctrl_fs_teardown(void)
>  	mon_put_kn_priv();
>  	rdt_pseudo_lock_release();
>  	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
> +	rdtgroup_default.flags = RDT_DELETED;

Would it be better to use |= here?
I expect it's not functionally different but I'm unsure of the interaction with
RDT_DELETED_PLR and it seems best in general unless clearing other possible
flags is intended.

Thanks,

Ben

>  	closid_exit();
>  	schemata_list_destroy();
>  	rdtgroup_destroy_root();
> @@ -3000,6 +3007,12 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	/* Avoid races from pending operations from a previous mount */
> +	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>  	ret = setup_rmid_lru_list();
>  	if (ret)
>  		goto out;
> @@ -4275,6 +4288,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
>  
>  	ctx->kfc.root = rdt_root;
>  	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
> +	rdtgroup_default.flags = 0;
>  
>  	return 0;
>  }

