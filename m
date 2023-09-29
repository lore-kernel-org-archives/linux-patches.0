Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5B520F9
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 20:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696018907; x=1727554907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bvppsW8w/SZogF5ijdNbZ+Z5nbrwIwzbhRFXCXCD3R0=;
  b=eiEiMrw66g0t8MP/dKH1SbYjwx1L1URKEB9C6Cui3L0RWSbxcJJA8DBM
   QhNdcqQ0U8KYABM9C+8hFC0XiyxVmkZPYjrWexqsbRYpsIIggLIuPcHyX
   HJpsD6xWcCEh+ItwbWl6K2pQZUmJ3pVwUl+pFYvoH9sTPai82ERmUqdm3
   3NZCbhrga0YdzhCj2YquKxfySY8TMQhSGyfD4vVXs23VZMCG/kB9K7th9
   iQj9i1DS/9wzqWYjvUUoWpGhRm5hPp2YrOtMmpHNvdnmTQO2pT1Tsd2w5
   e49y/RffnrPrpqQ2jkIRgrgQezdKCXHXERxMEKwSQXwG2SkA1CH/qfFEM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="372713239"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="372713239"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 11:38:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="1081014613"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="1081014613"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 11:38:40 -0700
Date: Fri, 29 Sep 2023 11:38:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 1/8] x86/resctrl: Prepare for new domain scope
Message-ID: <ZRcZrwm3b+XLDLty@agluck-desk3>
References: <20230829234426.64421-1-tony.luck@intel.com>
 <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-2-tony.luck@intel.com>
 <CALPaoChB5ryT96ZZBQb6+3=xO+A0uR-ToN0TWqUjLJ7bgi==Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoChB5ryT96ZZBQb6+3=xO+A0uR-ToN0TWqUjLJ7bgi==Rg@mail.gmail.com>

On Fri, Sep 29, 2023 at 02:09:42PM +0200, Peter Newman wrote:
> Hi Tony,
> 
> On Thu, Sep 28, 2023 at 9:14 PM Tony Luck <tony.luck@intel.com> wrote:
> >
> > Resctrl resources operate on subsets of CPUs in the system with the
> > defining attribute of each subset being an instance of a particular
> > level of cache. E.g. all CPUs sharing an L3 cache would be part of the
> > same domain.
> >
> > In preparation for features that are scoped at the NUMA node level
> > change the code from explicit references to "cache_level" to a more
> > generic scope. At this point the only options for this scope are groups
> > of CPUs that share an L2 cache or L3 cache.
> >
> > Provide a more detailed warning message if a domain id cannot be found
> > when adding a CPU. Just check and silent return if the domain id can't
> > be found when removing a CPU.
> >
> > No functional change.
> 
> I see a number of diagnostic checks added below. Are you sure there's
> no functional change?

Those checks should be for "can't happen" cases where some "scope" that
isn't attached to a cache_level somehow made its way down to a routine
that is only expecting cache scoped.

But I'll remove the "No functional change" from the commit. comment.
> 
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> > index 8f559eeae08e..8c5f932bc00b 100644
> > --- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> > +++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> > @@ -292,10 +292,14 @@ static void pseudo_lock_region_clear(struct pseudo_lock_region *plr)
> >   */
> >  static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
> >  {
> > +       int scope = plr->s->res->scope;
> >         struct cpu_cacheinfo *ci;
> >         int ret;
> >         int i;
> >
> > +       if (WARN_ON_ONCE(scope != RESCTRL_L2_CACHE && scope != RESCTRL_L3_CACHE))
> > +               return -ENODEV;
> 
> Functional change?
> 
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > index 725344048f85..1cf2b36f5bf8 100644
> > --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > @@ -1345,10 +1345,13 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
> >         unsigned int size = 0;
> >         int num_b, i;
> >
> > +       if (WARN_ON_ONCE(r->scope != RESCTRL_L2_CACHE && r->scope != RESCTRL_L3_CACHE))
> > +               return -EINVAL;
> 
> This function returns unsigned int. That's a huge region!

I wondered for a bit what value to return for this "can't happen" case
and initially went with an error code.  But the function can already
fail (in ways that won't happen) and in that case the return is "0".

I'l update to return 0 here too.

> -Peter

Thanks for the review.

-Tony
