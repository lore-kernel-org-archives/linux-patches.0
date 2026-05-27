Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7B437B016
	for <patches@lists.linux.dev>; Wed, 27 May 2026 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895097; cv=none; b=JIT4KlTc63Jqh/ywO/KQzBcS+dRjxtAPSHINRfCfENoETtHjEBhRYvPcXm9/e7XC3ZB+F92oeHj3kbdqPyYJKi1PVMZfZ/Geh/hXfM6jzxxZhwSEdXHallcOK88hkD51XDM2CO8UK5Nb4xz7laCfpcUNgaKLG8YpoLRYQHstwZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895097; c=relaxed/simple;
	bh=BQYg53ygjSOMzD+WDkWiu6/0lIIBCO2C4GuCJEGoyz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tb/44yaD/i4bvJyzSefK++Ny+Sd/wCnsZaTr5Wc4DVavehp1K9URAbTpq2PAlWc71x42blRtt5n3lvuVDqiGLul4EOmWQ+8Jei45PqayTyYxAxuJecpGz37BkVryzdCsBr6ffbO7hOd5hPC/VAmckC/rm3dNFT6deNVDV2KAKRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mwV/RbOg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mwV/RbOg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBBF22A68;
	Wed, 27 May 2026 08:18:08 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95A843F632;
	Wed, 27 May 2026 08:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779895093; bh=BQYg53ygjSOMzD+WDkWiu6/0lIIBCO2C4GuCJEGoyz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mwV/RbOg7eAdPXgfFOqVt7iM4eSmwa4IkBi/CXsUSrRiIXMK1QQLU/3GNlbI41NoJ
	 TFgd06DIuLnfnxwHh0LZY32iFRd2008biQ7pa+NAewcp83c9cji89Z6p7Zum78hKOj
	 GtOX2dK4yn6XgVd0oW0g1QDXuapoq23GpR1jXHBg=
Message-ID: <5a5d5dd5-b66e-46b9-9f65-0a0da499e78a@arm.com>
Date: Wed, 27 May 2026 16:18:10 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v3 2/9] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <9ef75c3c853c29e5051c8915901d43edff011a1c.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <9ef75c3c853c29e5051c8915901d43edff011a1c.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 5/22/26 20:15, Reinette Chatre wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> If mkdir_mondata_all() or a subsequent call in rdt_get_tree() fails, the
> mon_data structures allocated by mon_get_kn_priv() are leaked.
> 
> Add mon_put_kn_priv() to the out_mongrp error path to free the mon_data
> structures.
> 
> Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Looks good to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

> ---
> Changes since V2:
> - Reword changelog.
> ---
>  fs/resctrl/rdtgroup.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 91922fe1ea08..f573db9e6e84 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3081,6 +3081,7 @@ static int rdt_get_tree(struct fs_context *fc)
>  		kernfs_remove(kn_mondata);
>  out_mongrp:
>  	if (resctrl_arch_mon_capable()) {
> +		mon_put_kn_priv();
>  		rdtgroup_unassign_cntrs(&rdtgroup_default);
>  		kernfs_remove(kn_mongrp);
>  	}

