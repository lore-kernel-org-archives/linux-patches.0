Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D4963A
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690057280; x=1721593280;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w3wkQwxgDff1pIzMxFu0mHCGE5IrK6AXlVJ/ZMqnjZA=;
  b=XeLTy1KDeyONeLg3Hr5XZs2/pNSE2RmABfZJPBLJJJQQ9IdXZ8H0hpK+
   GvCzJRSFiw3pTsW2rsCbjDW2P7/t4Z6ovTS4Y01e1rs0RIN/bqX85FWv2
   ItzTr9d7UxCjN4EU3r5ZzTri2EpouKcy/4w/PG6RdA82DuJnJ+W4liaWj
   JO9oUsZKSYS8htJ7wjopnHbELad5mLN6o1m7NQOrFB8Xk0+PBMw0ibhFw
   f9qVSBWoPGMy6rQFOSJOpZ9Rtz4mvGyD4ligYnYpdUksR5DkouJewRHBJ
   HGPSELDdAwRLPIxxvM9JEuT8VjpRmVLpXpv2IyA8KYUhFGcKbD7s5C5Y7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10779"; a="453599900"
X-IronPort-AV: E=Sophos;i="6.01,224,1684825200"; 
   d="scan'208";a="453599900"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2023 13:21:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10779"; a="815378869"
X-IronPort-AV: E=Sophos;i="6.01,224,1684825200"; 
   d="scan'208";a="815378869"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2023 13:21:19 -0700
Date: Sat, 22 Jul 2023 13:21:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v3 0/8] x86/resctrl: Add support for Sub-NUMA cluster
 (SNC) systems
Message-ID: <ZLw6PpPV5H546VSJ@agluck-desk3>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <TYAPR01MB6330A4EB3633B791939EA45E8B39A@TYAPR01MB6330.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB6330A4EB3633B791939EA45E8B39A@TYAPR01MB6330.jpnprd01.prod.outlook.com>

On Wed, Jul 19, 2023 at 02:43:20AM +0000, Shaopeng Tan (Fujitsu) wrote:
> Hi tony,
> 
> I ran selftest/resctrl in my environment,
> the test result is "not ok".
> 
> Processer in my environment:
> Intel(R) Xeon(R) Gold 6254 CPU @ 3.10GHz
> 
> kernel:
> $ uname -r
> 6.5.0-rc1+
> 
> Result :
> Sub-NUMA enable:
> xxx@xxx:~/linux_v6.5_rc1l$ sudo make -C tools/testing/selftests/resctrl run_tests
> make: Entering directory '/.../tools/testing/selftests/resctrl'

I see most tests pass. Just one fail on my most recent run with the
v4 patch series:

# # Fail: Check MBA diff within 5% for schemata 10
# # avg_diff_per: 7%
# # avg_bw_imc: 883
# # avg_bw_resc: 815
# # Fail: Check schemata change using MBA

But just missed the 5% target by a small amount,
not the near total failures that you see.

I wonder if there is a cross-SNC node memory
allocation issue.  Can you try running the test
bound to a CPU in one node:

$ taskset -c 1 sudo make -C tools/testing/selftests/resctrl run_tests

Try with different "-c" arguments to bind to different nodes. Do you
see different results on differnt nodes?

-Tony
