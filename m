Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D78D4A9F
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647551041; x=1679087041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aqLKb0lzeehIgj2n+Ushux/OJw3chaW0zzjeh7+X/JE=;
  b=e3thnIDiYyafKNjpm9P8FKhPF49pSPVtZDg6GC/OKUvv1KEG8OB33xBb
   cdDw3oaSNBfVprUp0rSa+op2vZX7vwdlHhB3sTg9OfxAk/9zDGy/K0H65
   dwjHsSEDT2tnVkBURYY93TT12Q2fQGZoynddgQ+NhbnN5jeHefYV+U73n
   OH12gO4XiDZ0zGCNN03a5l2OnByGS1tVJ0CQ9Li2dtrvQ8Nra4TN3y94T
   YbXnRnXpEeVJog6lP0Mhr4f1Kl9DrMBbbDADiB3Eo5PJkeZ3s6Ar1z/Td
   S6znd5JeVVu9I/bCOX8RrufQJkMeUVHT5PpyflLp/3TF+Tsu4vfaE6cfP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="343417271"
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="343417271"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 14:04:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="614130522"
Received: from dshkut-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.132.229])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 14:04:00 -0700
Date: Thu, 17 Mar 2022 14:03:53 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 0/7] Revamped region creation
Message-ID: <20220317210353.2lye4orffr6rqu4v@intel.com>
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316230303.1813397-1-ben.widawsky@intel.com>

On 22-03-16 16:02:56, Ben Widawsky wrote:
> From: Ben Widawsky <ben@bwidawsk.net>
> 
> I will be on vacation all of next week so I'm trying to get this out now, even
> though I still need to go over the locking and lifetimes. I'm certain there are
> still issues there. I did want to start the discussion sooner rather than later
> around the ABI changes.
> 
> The major changes from this series are:
> - disambiguation of decoder types
> - endpoint decoders size and volatility must be set
> - regions are comprised of decoders instead of devices
> - device physical address space is now managed

Dan/all, I used gen_pool API to manage the device's address space. When I
originally authored the patches, I was under the impression that HDM decoders
could be sparsely enabled [1], which leads to the device physical address space
being sparsely populated. As it turns out, this is explicitly disallowed
(8.2.5.12.20). However, I need /some/ way to manage address space, and on third
thought, maybe it's worth it to just leave the gen_pool usage as is.

What are your thoughts? I think the resource APIs are a little klunky given that
we may not yet have sysram mapping for the HDM decoders in the current
programming model. Ranges are possibly usable. gen_pool provides a lot of
flexibility, but it is more complex (but the code is written).

[1]: Practically speaking, decoders can be sparsely enabled. If you set base ==
limit for a decoder it will decode 0 address space. This trick might be nice to
use later.
