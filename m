Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D129453
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690380631; x=1721916631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/MDgNGkVeaPDA3kkMNG+Ho9/GQxRTUSTwqG0wzLJTZk=;
  b=Sk0ZmT6mVbc7+nbfdOps/DUFU+QvZehbypJ+I2DQywaqHqlZDRN2erXe
   dSyzpumk9NstK4iUwXxJ/FcDIwdgCdYOrYXmpDdCckbUwuHrnGU/keSjb
   G+AEmdsuUV8nYcU9xmO2EnkAPMlDQFZbq9PXLYGcO+aHV2o0Lv4xaRUm0
   PNA3GW+C+SDQzvJ9zGOd6154CPWLgjOrp675jy3NlgE6lnSjjAf0JS0ci
   F0z6QxMVB6BIjowoiVpCTHu94D940sM6h9CnWcCSvcN5oM1dDcMr+uBQ0
   qNI3OEpRp2EoVlUB4TpoQs/e0v9dqA/u/aVoZIIujH10uRh+I4wScwnGu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="368045559"
X-IronPort-AV: E=Sophos;i="6.01,232,1684825200"; 
   d="scan'208";a="368045559"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 07:10:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="900441006"
X-IronPort-AV: E=Sophos;i="6.01,232,1684825200"; 
   d="scan'208";a="900441006"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 07:10:29 -0700
Date: Wed, 26 Jul 2023 07:10:28 -0700
From: Tony Luck <tony.luck@intel.com>
To: Drew Fustini <dfustini@baylibre.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 0/7] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <ZMEpVBO5dGxtBzfy@agluck-desk3>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <20230722190740.326190-1-tony.luck@intel.com>
 <ZMCOvMfROYhQEFXo@x1>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMCOvMfROYhQEFXo@x1>

On Tue, Jul 25, 2023 at 08:10:52PM -0700, Drew Fustini wrote:
> I think that the resctrl interface for RISC-V CBQRI could also benefit
> from separate domain lists for control and monitoring.
> 
> For example, the bandwidth controller QoS register [1] interface allows
> a device to implement both bandwidth usage monitoring and bandwidth
> allocation. The resctrl proof-of-concept [2] had to awkwardly create two
> domains for each memory controller in our example SoC, one that would
> contain the MBA resource and one that would contain the L3 resource to
> represent MBM files like local_bytes.
> 
> This resulted in a very odd looking schemata that would be hard to the
> user to understand:
> 
>   # cat /sys/fs/resctrl/schemata
>   MB:4=  80;6=  80;8=  80
>   L2:0=0fff;1=0fff
>   L3:2=ffff;3=0000;5=0000;7=0000
> 
> Where:
> 
>   Domain 0 is L2 cache controller 0 capacity allocation
>   Domain 1 is L2 cache controller 1 capacity allocation
>   Domain 2 is L3 cache controller capacity allocation
> 
>   Domain 4 is Memory controller 0 bandwidth allocation
>   Domain 6 is Memory controller 1 bandwidth allocation
>   Domain 8 is Memory controller 2 bandwidth allocation
> 
>   Domain 3 is Memory controller 0 bandwidth monitoring
>   Domain 5 is Memory controller 1 bandwidth monitoring
>   Domain 7 is Memory controller 2 bandwidth monitoring
> 
> But there is no value of having the domains created for the purposes of
> bandwidth monitoring in schemata.

There's certainly no value in exposing those domain numbers
in the schemata file. There should also be some way for users
to decode the ids. On x86 the "id" is exposed in sysfs. Though
the user does need to work to get all the details:

$ cat /sys/devices/system/cpu/cpu36/cache/index3/level
3
$ cat /sys/devices/system/cpu/cpu36/cache/index3/id
1
$ cat /sys/devices/system/cpu/cpu36/cache/index3/shared_cpu_list
36-71,108-143

This shows the L3 cachce with id "1" is shared by CPUs 36-71,108-143

X86 also has independent domain numbers for each resource. So the
L2 ones count 0, 1, 2, ... and so do the L3 ones: 0, 1, 2 and the
MBA ones: 0, 1, 2

That fits well with the /sys decoding ... but maybe your approach of
not repeating domain numbers across different resources is less
confusing?

Note that in my resctrl re-write where each resource is handled by
a separate loadable module it may be hard for you to keep the unique
domain scheme as resource modules are unaware of each other. Though
perhaps its just an arch specific hook to provide domain numbers.

> I've not yet fully understood how the new approach in this patch series
> could help the situation for CBQRI, but I thought I would mention that
> separate lists for control and monitoring might be useful.

Good. It's nice to know there's potentially another use case for
this split besides SNC.

-Tony
