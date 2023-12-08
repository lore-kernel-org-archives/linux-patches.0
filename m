Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D6584FB
	for <patches@lists.linux.dev>; Fri,  8 Dec 2023 21:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWQ/jZGm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702072241; x=1733608241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lGTn+rBSOCG48Ab9NF0vjFUxQRip0d3DjXMPj7vFZzc=;
  b=LWQ/jZGmNCU2NdF0bV/LONBdFHhoDwJ0FyCOd2v4ClRR+Qrx4EyyEeUN
   15laNQcKVaryV4w7GVkFHHA9Aq7OixFv37er63YZEFGIV84+5WYv7wic7
   aXFTtiPaOaAeK6ds6siI7msKdpZaBnnl7H0xWRpuJYcFMY1teydO5Rdae
   CDxEL+/w1w7V28QhX69U/ulXzYrWM6nH+LXH2Cdas7JN/49jC+pzjGlcH
   ppM9mY0BCmDOJL+Ar2Tk1H0iNLt/8hL2ZicYOzNVo23vqxwTaATxUBgxH
   5/UEPg8+OFPKFW6YvZEHQqK8XE76AmRs9hmX6itnUWFBoQBUE51uuzGCT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="393335221"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="393335221"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 13:50:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="765621441"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="765621441"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 13:50:40 -0800
Date: Fri, 8 Dec 2023 13:50:38 -0800
From: Tony Luck <tony.luck@intel.com>
To: babu.moger@amd.com
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 1/3] x86/resctrl: Add mount option "mba_MBps_event"
Message-ID: <ZXOPrjoDZbJPrl/6@agluck-desk3>
References: <20231201214737.104444-1-tony.luck@intel.com>
 <20231207195613.153980-1-tony.luck@intel.com>
 <20231207195613.153980-2-tony.luck@intel.com>
 <7de1b242-e8cb-9968-876e-d3e311443b57@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7de1b242-e8cb-9968-876e-d3e311443b57@amd.com>

On Fri, Dec 08, 2023 at 12:29:18PM -0600, Moger, Babu wrote:
> Hi Tony,
> 
> On 12/7/2023 1:56 PM, Tony Luck wrote:
> > -static int set_mba_sc(bool mba_sc)
> > +static int set_mba_sc(bool mba_sc, enum resctrl_event_id mba_mbps_event)
> >   {
> >   	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> >   	u32 num_closid = resctrl_arch_get_num_closid(r);
> > @@ -2313,6 +2313,7 @@ static int set_mba_sc(bool mba_sc)
> >   		return -EINVAL;
> >   	r->membw.mba_sc = mba_sc;
> > +	r->membw.mba_mbps_event = mba_mbps_event;
> >   	list_for_each_entry(d, &r->domains, list) {
> >   		for (i = 0; i < num_closid; i++)
> > @@ -2445,13 +2446,14 @@ static void rdt_disable_ctx(void)
> >   {
> >   	resctrl_arch_set_cdp_enabled(RDT_RESOURCE_L3, false);
> >   	resctrl_arch_set_cdp_enabled(RDT_RESOURCE_L2, false);
> > -	set_mba_sc(false);
> > +	set_mba_sc(false, QOS_L3_MBM_LOCAL_EVENT_ID);
> 
> This is kind of miss leading. Why do you pass "QOS_L3_MBM_LOCAL_EVENT_ID"
> here?
> 
> If you move the following initialization to rdt_enable_ctx, then you don't
> need to pass the second argument.
> 
> r->membw.mba_mbps_event = mba_mbps_event;

Babu,

Yes. That was funky. I will drop the second argumen to set_mba_sc() and
move the initialization to rdt_enable_ctx()

Thnaks for the review.

-Tony
