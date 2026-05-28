Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EC23A7F66
	for <patches@lists.linux.dev>; Thu, 28 May 2026 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779963075; cv=none; b=gjo3Bi4tj+8EIsZ7RWSfkNR1MU4M28VWF+SdiNWKrQqMAtnBLbzTaDN29VxHf7QNdDepZqpAsvspkpXfcCWpDqQW6fJdZM5TAqBAZqn2TjXCh1C1DFlqktwee2GfNuQ1mo/W/pV+b9GYApVCLvwLYRjP6/uLYGsNw/GmVU1+16I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779963075; c=relaxed/simple;
	bh=g1qB1lXM9CGbTo86hG28M4E1PbyD2MzDtAY7BqWm8VA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mce0/74SRlhdd25wN5EaIx7HWVPISf3uBTuxQoChFaRbbw+P7hRV0rf2rLHMgwZQ60pcxJnUj1GBbP5wzon1YDrDolsshoFZGK39nkYefXG253W7pvI3dLtgMZ2MwH5UgRGvmJh8b2xaOaKczvx4peyifVkU/DY8t4L2tJTE1C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=edjT/rwt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="edjT/rwt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4592C43F7;
	Thu, 28 May 2026 03:11:08 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE9B33F905;
	Thu, 28 May 2026 03:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779963073; bh=g1qB1lXM9CGbTo86hG28M4E1PbyD2MzDtAY7BqWm8VA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=edjT/rwt577ERKA5U0VTReS9ruZcsnEhgQhXtU7qL9QRPmy8oZt/6PCik6rGAINuL
	 ubtT5lnHNxAB5ZpAlWbM+1bEBv+/zDN4Zq+1DMwctCxrVREXlZGPnz3MxRgi2fqpfF
	 zq06bYl6aea/WMWZa//J/3ZKSZ/ke0q61pbROoFg=
Message-ID: <64debbf6-753c-40d9-adf4-9a937a8294c9@arm.com>
Date: Thu, 28 May 2026 11:11:09 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v3 4/9] fs/resctrl: Fix deadlock for errors during mount
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 5/22/26 20:15, Reinette Chatre wrote:
> rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
> superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
> the same thread before the call returns.  rdt_kill_sb() unconditionally
> attempts to acquire rdtgroup_mutex and deadlock occurs.
> 
> Move the call to kernfs_get_tree() outside of locks. If kernfs_get_tree()
> fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb() has already
> been called and no further cleanup is needed.
> 
> Add an extra hold in this error path on rdtgroup_default.kn to defend against
> other races destroying the root which is then dereferenced in kernfs_kill_sb()
> 
> Add resctrl_unmount() helper to keep code consistent between the
> rdt_get_tree() failure path and a normal unmount.
> 
> Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Looks good to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

