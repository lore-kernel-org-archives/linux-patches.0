Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8252D9796
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 11:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746622; cv=none; b=QlY3gRANyoD3rsCKRTQiLAsaY6RlJue6o/QdckE6S8EoJjRWjIsGy/O/7KO/zDZsAHZ7C3gZBudUTPXUvwlYS6iQFolB5x48puDOj6RJyrH0wpcru8lwcXhlnMfRhNxW2JBeTDzSuPUnzIhW/wcaXOCLbpXwpJp9uT1VLUk/RKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746622; c=relaxed/simple;
	bh=Z4lrNx1Wq59985cW8k04tkALANwfunNLAlPDrkAZkZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iMDIrjsDb8A4uuDMLAOoq3i8NxQHz8BqEbbLr5U3sfq0zyjvpfi3PAP6Niib4MG/pnI22fBmmjOxuCoYd7vvVK2lw4LbbigoX8DrdWkynPUNRITejq2kdoF/9mxbpyUbIaSB7L6vumFSIpYgsjp8DV6BiQ0yJpLZK702XWXyW98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A23761477;
	Tue, 17 Mar 2026 04:23:34 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18FF33F778;
	Tue, 17 Mar 2026 04:23:38 -0700 (PDT)
Message-ID: <008ba74b-94b4-421a-8178-f7425d11bfec@arm.com>
Date: Tue, 17 Mar 2026 11:23:37 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/2/26 18:46, Reinette Chatre wrote:
> Every resctrl resource has a unique ID described by enum resctrl_res_level.
> enum resctrl_res_level is used in all resource ID initializations and all
> resource ID comparisons. All functions consuming the resource ID expects an
> enum resctrl_res_level. Of the four structures that contain a resource ID
> (struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
>  rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.
> 
> Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
> it obvious what values are valid, match the type everywhere this member is
> used, and obtain benefits from tools that can flag any enum misuse.
> 
> Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
> when a switch() on the resource ID does not handle all the resources and
> thus help flag which switch statements need an update when a new resource
> is added.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  include/linux/resctrl.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 006e57fd7ca5..48e95f273fb3 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -54,11 +54,11 @@ enum resctrl_res_level {
>  	RDT_RESOURCE_MBA,
>  	RDT_RESOURCE_SMBA,
>  	RDT_RESOURCE_PERF_PKG,
> -
> -	/* Must be the last */
> -	RDT_NUM_RESOURCES,
> +	/* Additions to enum need to update RDT_NUM_RESOURCES. */
>  };>
> +#define RDT_NUM_RESOURCES (RDT_RESOURCE_PERF_PKG + 1)

Would it be clearer to have RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG in the enum
and use RDT_RESOURCE_LAST instead of RDT_RESOURCE_PERF_PKG here?

Thanks,

Ben

> +
>  /**
>   * enum resctrl_conf_type - The type of configuration.
>   * @CDP_NONE:	No prioritisation, both code and data are controlled or monitored.
> @@ -319,7 +319,7 @@ struct resctrl_mon {
>   * @cdp_capable:	Is the CDP feature available on this resource
>   */
>  struct rdt_resource {
> -	int			rid;
> +	enum resctrl_res_level	rid;
>  	bool			alloc_capable;
>  	bool			mon_capable;
>  	enum resctrl_scope	ctrl_scope;

