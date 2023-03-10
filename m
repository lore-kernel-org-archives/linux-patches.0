Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A10FD516
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 17:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678469456; x=1710005456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=r5sCe+bXJxE3gAbet8BVS3dL7duJqreakgvTk5MI2+0=;
  b=JmAf6S+nSAuUd1mTqqh++PdV3lpMoGizSdjoOpW5UU1y0JDqqYjsqGfh
   RtJ3oTaqJJb3/EQlzQuakGYmqU0wIagrY6sK72Bzog2F3EftZeCyjXmNv
   N84SO3Q1N+9Y3UFtQXSZ5LXZp8r3KBo29RdvdWGI8yVLOoDrzamyRTeFE
   pDQ1eYKdNRVdA+QB399xpiWGxcw0V9eLHgHzE3v5QtBx7m8bU9ksBbylK
   mItRJSMZraxNlVMquN8UuFBDpeJRFzSJ649qu9/aA1J27F/vJo59aYRSY
   K6WK7VcGxzX+7mi3EHOx8jT8CGHKqI26jZrLXHjigFFueLmpqf+CbUy4r
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="399382444"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="399382444"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 09:30:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="852003050"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="852003050"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 09:30:55 -0800
Date: Fri, 10 Mar 2023 09:30:54 -0800
From: Tony Luck <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev,
	tony.luck@intel.com
Subject: Re: [PATCH 7/7] x86/resctrl: Determine if Sub-NUMA Cluster is
 enabled and initialize.
Message-ID: <ZAtpTl+um3nbCOz8@agluck-desk3.sc.intel.com>
References: <20230126184157.27626-1-tony.luck@intel.com>
 <20230126184157.27626-8-tony.luck@intel.com>
 <CALPaoCgnOWLdEqKtonNeq+d_Fj0yr3Y7tgwwmAHmuhL5xBhqyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoCgnOWLdEqKtonNeq+d_Fj0yr3Y7tgwwmAHmuhL5xBhqyg@mail.gmail.com>

On Mon, Feb 27, 2023 at 02:30:38PM +0100, Peter Newman wrote:
> Hi Tony,
> 
> On Thu, Jan 26, 2023 at 7:42 PM Tony Luck <tony.luck@intel.com> wrote:
> > +static __init int find_snc_ways(void)
> > +{
> > +       unsigned long *node_caches;
> > +       int cpu, node, ret;
> > +
> > +       node_caches = kcalloc(BITS_TO_LONGS(nr_node_ids), sizeof(*node_caches), GFP_KERNEL);
> > +       if (!node_caches)
> > +               return 1;
> > +
> > +       cpus_read_lock();
> > +       for_each_node(node) {
> 
> Someone tried this patch on a machine with a CPU-less node...
> 
> We need to check for this:
> 
> +               if (cpumask_empty(cpumask_of_node(node)))
> +                       continue;
> 
> > +               cpu = cpumask_first(cpumask_of_node(node));
> > +               set_bit(get_cpu_cacheinfo_id(cpu, 3), node_caches);
> > +       }
> > +       cpus_read_unlock();

Peter,

Tell me more about your CPU-less nodes.  Your fix avoids a bad
pointer reference (because cpumask_first() returns cpu >= nr_cpu_ids
for an empty bitmask).

But now I'm worried about whether I have the right values in the
formula:

	nr_node_ids / bitmap_weight(node_caches, nr_node_ids);

This fix avoids counting the L3 from a non-existent CPU, but still
counts the node in the numerator.

Is your CPU-less node a full (non-SNC) node? Like this:

          Socket 0                 Socket 1
    +--------------------+  +--------------------+
    |          .         |  |          .         |
    |  SNC 0.0 . SNC 0.1 |  |  zero    . zero    |
    |          .         |  |  CPUs    . CPUs    |
    |          .         |  |          .         |
    |          .         |  |          .         |
    +--------------------+  +--------------------+
    |      L3 Cache      |  |      L3 Cache      |
    +--------------------+  +--------------------+

I could fix this case by counting how many CPU-less
nodes I find, and reducing the numerator (the denominator
didn't count the L3 cache from socket 1 because there
are no CPUs there)

	(nr_node_ids - n_empty_nodes) / bitmap_weight(node_caches, nr_node_ids);

	=> 2 / 1

But that won't work if your CPU-less node is an SNC node
and the other SNC node in the same socket does have some
CPUs:

          Socket 0                 Socket 1
    +--------------------+  +--------------------+
    |          .         |  |          .         |
    |  SNC 0.0 . SNC 0.1 |  |  zero    . SNC 1.1 |
    |          .         |  |  CPUs    .         |
    |          .         |  |          .         |
    |          .         |  |          .         |
    +--------------------+  +--------------------+
    |      L3 Cache      |  |      L3 Cache      |
    +--------------------+  +--------------------+

This would get 3 / 2 ... i.e. I should still count the
empty node because its cache was counted by its SNC
buddy.

-Tony
