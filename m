Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B556226561A
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767591; cv=none; b=h1/EdEARySeE8BdWR6fUtV21yKB6n1yl0tcPvMu3wuwTVINogbS3gs5DEAZzxd/LoBRnOIlGlobUAuRUi3+r/ZwN/IWz3xMuZsAxPPQvKs39La2xKVZe/PMAjjIsuqTdWAxxRYGtKo+DZRjPri3XkHzOu+uruXrjOKWA9uBnXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767591; c=relaxed/simple;
	bh=TB50MSoAFmUwo0wLkKhA0xXd3Sq/iDrmOtT8MPw7Q+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0r4nekCTF/jjkoRULOwCfKx5oXRDN7Q8A9EuunDIWDR4/tKFSBVyzef3AdRb3M/3CCrCKkWi2Eb4h4l0Wd63b5zaQrmsmjyyxKMQGzbt/ubFSSJG0C0f8oQU58mYdsTW+stHGHfOvHUo8j6AMRUFsDXixbUinZj03KF5Co/3R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C7AC1477;
	Tue, 17 Mar 2026 10:13:04 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E04A3F778;
	Tue, 17 Mar 2026 10:13:08 -0700 (PDT)
Message-ID: <26291ece-b2a2-4207-b9e8-a0697e8e478d@arm.com>
Date: Tue, 17 Mar 2026 17:13:06 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 07/11] fs/resctrl: Add last_cmd_status support for writes
 to max_threshold_occupancy
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <b3faaf0daf235ed1d95cec3b879afc6d12cc7010.1772476561.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <b3faaf0daf235ed1d95cec3b879afc6d12cc7010.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/2/26 18:46, Reinette Chatre wrote:
> info/last_cmd_status is intended to contain more information if a write to
> any resctrl file fails. Writes to max_threshold_occupancy did not receive
> last_cmd_status support during initial last_cmd_status enabling. Add it now.

All looks sensible to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  fs/resctrl/rdtgroup.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 3c9508fc558d..933f6ae26d59 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1238,16 +1238,27 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
>  	unsigned int bytes;
>  	int ret;
>  
> +	mutex_lock(&rdtgroup_mutex);
> +	rdt_last_cmd_clear();
> +
>  	ret = kstrtouint(buf, 0, &bytes);
> -	if (ret)
> -		return ret;
> +	if (ret) {
> +		rdt_last_cmd_puts("Invalid input\n");
> +		goto out_unlock;
> +	}
>  
> -	if (bytes > resctrl_rmid_realloc_limit)
> -		return -EINVAL;
> +	if (bytes > resctrl_rmid_realloc_limit) {
> +		rdt_last_cmd_printf("Exceeds limit (before adjustment) of %u bytes\n",
> +				    resctrl_rmid_realloc_limit);
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
>  
>  	resctrl_rmid_realloc_threshold = resctrl_arch_round_mon_val(bytes);
>  
> -	return nbytes;
> +out_unlock:
> +	mutex_unlock(&rdtgroup_mutex);
> +	return ret ?: nbytes;
>  }
>  
>  /*

