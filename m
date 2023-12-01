Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1608441B
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aMgsU3lA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701391041; x=1732927041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OAXgylAvqbL36kLJ778XRMQl7eMkZD8otzMFMN2gudo=;
  b=aMgsU3lAvmPK5cN8FqeBtBSGREDwmZ43rq2+TJd0exknsnbHyuuca3qn
   PL4KhHKBCX5UUGv8Wf9i98t/ZVHSizm5OJqIkIvOWEo2jF+wwY1EuUS24
   Drx3tgGhPcWO+r7J5tf0moPpF9u7qGX8xyjOyabv7VPWGCJDKapfyfAgc
   pnntDaU4LrCG2s1g1B148H+Se1V/Xiovu1PdVwEYjI1PXmTHySFCjQB36
   BnbGtHzAtQc0CxnJOYeThAPkfqB00wqr4r7DWfTjC37HOztCuGeJ4iRcB
   AsyAPPIJkDtD9b/M1T1c/i9gev598X1qiXN2JNNC5VeWrppx+ZF41ezT1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="311716"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="311716"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 16:37:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="839984290"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="839984290"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 16:37:20 -0800
Date: Thu, 30 Nov 2023 16:37:19 -0800
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fam Zheng <fam@euphon.net>, Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: Re: [PATCH v12 7/8] x86/resctrl: Sub NUMA Cluster detection and
 enable
Message-ID: <ZWkqv+egQuph03Bm@agluck-desk3>
References: <20231109230915.73600-1-tony.luck@intel.com>
 <20231130003418.89964-1-tony.luck@intel.com>
 <20231130003418.89964-8-tony.luck@intel.com>
 <ZWjOBw0Ygyw226Cc@dell>
 <ZWj3NdI/qLNOgyg0@agluck-desk3>
 <1c1a16a5-f235-4179-9d0f-1556e11d9c11@intel.com>
 <ZWkQBwwtSae4nGgH@agluck-desk3>
 <5078f930-e56e-45b5-9df3-99e88c0858dd@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5078f930-e56e-45b5-9df3-99e88c0858dd@intel.com>

On Thu, Nov 30, 2023 at 03:40:52PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/30/2023 2:43 PM, Tony Luck wrote:
> > On Thu, Nov 30, 2023 at 01:47:10PM -0800, Reinette Chatre wrote:
> 
> ...
> 
> >>>  	if (!x86_match_cpu(snc_cpu_ids))
> >>>  		return 1;
> >>
> >> I understand and welcome this change as motivated by robustness. Apart
> >> from that, with this being a model specific feature for this particular
> >> group of systems, it it not clear to me in which scenarios this could
> >> run on a system where a present CPU does not have access to L3 cache.
> > 
> > Agreed that on these systems there should always be an L3 cache. Should
> > I drop the check for "-1"?
> 
> Please do keep it. I welcome the additional robustness. The static checker I
> tried did not complain about this but I expect that it is something that
> could trigger checks.
> 
> > 
> >>>  
> >>> -	node_caches = bitmap_zalloc(nr_node_ids, GFP_KERNEL);
> >>> +	node_caches = bitmap_zalloc(num_online_cpus(), GFP_KERNEL);
> >>
> >> Please do take care to take new bitmap size into account in all
> >> places. From what I can tell there is a later bitmap_weight() call that
> >> still uses nr_node_ids as size.
> > 
> > Oops. I was also using num_online_cpus() before cpus_read_lock(), so
> > things could theoretically change before the bitmap_weight() call.
> > I switched to using num_present_cpus() in both places.
> 
> Thanks for catching this. I am not sure if num_present_cpus() is the right
> choice. I found its comment to say "If HOTPLUG is enabled, then cpu_present_mask
> varies dynamically ...". num_possible_cpus() seems more appropriate when looking

I can size the bitmask based on num_possible_cpus().

> for something that does not change while not holding the hotplug lock. Reading its
> description more closely also makes me wonder if the later
> 	num_online_cpus() != num_present_cpus()
> should also maybe be 
> 	num_online_cpus() != num_possible_cpus() ?
> It seems to more closely match the intention.

This seems problematic. On a system that does support physical CPU
hotplug num_possible_cpus() may be some very large number. Reserving
space for CPUs that can be added later. None of those CPUs can be online
(obviously!). So this test would fail on such a system.

> >>>  	if (!node_caches)
> >>>  		return 1;
> >>>  
> >>> @@ -1072,10 +1073,13 @@ static __init int snc_get_config(void)
> >>>  
> >>>  	for_each_node(node) {
> >>>  		cpu = cpumask_first(cpumask_of_node(node));
> >>> -		if (cpu < nr_cpu_ids)
> >>> -			set_bit(get_cpu_cacheinfo_id(cpu, 3), node_caches);
> >>> -		else
> >>> +		if (cpu < nr_cpu_ids) {
> >>> +			cache_id = get_cpu_cacheinfo_id(cpu, 3);
> >>> +			if (cache_id != -1)
> >>> +				set_bit(cache_id, node_caches);
> >>> +		} else {
> >>>  			mem_only_nodes++;
> >>> +		}
> >>>  	}
> >>>  	cpus_read_unlock();
> >>>  
> >>
> >> Could this code be made even more robust by checking the computed
> >> snc_nodes_per_l3_cache against the limited actually possible values?
> >> Forcing it to 1 if something went wrong?
> > 
> > Added a couple of extra sanity checks. See updated incremental patch
> > below.
> 
> Thank you very much. The additional checks look good to me.
> 
> Reinette

Thanks for looking at this. I'm applying changes to my local tree. I'll
give folks a little more time to find additonal issues in v12 and post
v13 next week.

-Tony
