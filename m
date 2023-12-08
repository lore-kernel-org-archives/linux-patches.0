Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F13734541
	for <patches@lists.linux.dev>; Fri,  8 Dec 2023 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JCJJXLk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702072660; x=1733608660;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lHqrEpBiJ0PDgr+GI2M9OtrUkO104s4VptIFq7uLSKs=;
  b=JCJJXLk5ZzOzhyLY1XONKytR8l0NEtH5ygmw96SkzzC6AiX8PUknOLCa
   TeIBXTkEBTb+aXczDJWHRK7r/qN3x5zA3OSW18unkW8e7X4oUmIE5/TgJ
   R72r9O8t8ukURVY0aRw7wQeaeI0tUAK/amv4ZnvR12O/6FbHWsJW19mF4
   fnmc8Sg17+80QMrqx6VBKoBX2dA6jHSgem+cnydL/oPDz2LHHE9xbpm9R
   KUj8ZhkDltFnPYbFELqhL8vjQF4fD67jZA+Qkk6q63Z83JF4EI411PCQK
   aJSz7EiquRCZ0NxrNZ7WDZwKO32jnzb2zZ6CP1JaPbfmVCN7fH6ZYedMv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10918"; a="425599491"
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="425599491"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 13:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,261,1695711600"; 
   d="scan'208";a="20239542"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2023 13:57:35 -0800
Date: Fri, 8 Dec 2023 13:57:33 -0800
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
Subject: Re: [PATCH v6 1/3] x86/resctrl: Add mount option "mba_MBps_event"
Message-ID: <ZXORTTIUKWXOsd9p@agluck-desk3>
References: <20231201214737.104444-1-tony.luck@intel.com>
 <20231207195613.153980-1-tony.luck@intel.com>
 <20231207195613.153980-2-tony.luck@intel.com>
 <CALPaoCji1yzfkA=tms3LhYMvRB+wSJQM3qzPKrHNEa7a+KduTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoCji1yzfkA=tms3LhYMvRB+wSJQM3qzPKrHNEa7a+KduTA@mail.gmail.com>

On Fri, Dec 08, 2023 at 10:17:08AM -0800, Peter Newman wrote:
> Hi Tony,
> 
> On Thu, Dec 7, 2023 at 11:56 AM Tony Luck <tony.luck@intel.com> wrote:
> >
> > The MBA Software Controller(mba_sc) is a feedback loop that uses
> > measurements of local memory bandwidth to adjust MBA throttling levels
> > to keep workloads in a resctrl group within a target bandwidth set in
> > the schemata file.
> >
> > Users may want to use total memory bandwidth instead of local to handle
> > workloads that have poor NUMA localization.
> >
> > Add a new mount option "mba_MBps_event={event_name}" where event_name
> > is one of "mbm_Local_bytes" or "mbm_total_bytes" that allows a user to
> 
> It's "mbm_local_bytes" in the matching logic later on.

Clearly my left hand operating the shift key is not well synchronized
with my right hand moving from "_" to "l".

Will fix.

> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index a4f1aa15f0a2..8b9b8f664324 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -58,7 +58,8 @@ struct rdt_fs_context {
> >         struct kernfs_fs_context        kfc;
> >         bool                            enable_cdpl2;
> >         bool                            enable_cdpl3;
> > -       bool                            enable_mba_mbps;
> > +       bool                            enable_mba_mbps_local;
> > +       bool                            enable_mba_mbps_total;
> >         bool                            enable_debug;
> >  };
> >
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index f136ac046851..d9e590f1cbc3 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -431,9 +431,10 @@ static int __mon_event_count(u32 rmid, struct rmid_read *rr)
> >   */
> >  static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
> >  {
> > -       struct mbm_state *m = &rr->d->mbm_local[rmid];
> >         u64 cur_bw, bytes, cur_bytes;
> > +       struct mbm_state *m;
> >
> > +       m = get_mbm_state(rr->d, rmid, rr->evtid);
> 
> WARN_ON(m == NULL) since we assume the caller has confirmed rr->evtid
> is an MBM event?

Will add this WARN_ON (though I'll write "WARN_ON(!m);" rather than "== NULL").
> 
> >         cur_bytes = rr->val;
> >         bytes = cur_bytes - m->prev_bw_bytes;
> >         m->prev_bw_bytes = cur_bytes;
> > @@ -521,19 +522,21 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
> >         u32 closid, rmid, cur_msr_val, new_msr_val;
> >         struct mbm_state *pmbm_data, *cmbm_data;
> >         u32 cur_bw, delta_bw, user_bw;
> > +       enum resctrl_event_id evt_id;
> >         struct rdt_resource *r_mba;
> >         struct rdt_domain *dom_mba;
> >         struct list_head *head;
> >         struct rdtgroup *entry;
> >
> > -       if (!is_mbm_local_enabled())
> > +       if (!is_mbm_enabled())
> >                 return;
> >
> >         r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> > +       evt_id = r_mba->membw.mba_mbps_event;
> >
> >         closid = rgrp->closid;
> >         rmid = rgrp->mon.rmid;
> > -       pmbm_data = &dom_mbm->mbm_local[rmid];
> > +       pmbm_data = get_mbm_state(dom_mbm, rmid, evt_id);
> 
> One defensive WARN_ON((!pmbm_data) for this function to ensure evt_id
> is valid for this call and the ones in the loop below?

Will add this. And the WARN_ON(!cmbm_data); in the loop.

> > @@ -2466,8 +2468,12 @@ static int rdt_enable_ctx(struct rdt_fs_context *ctx)
> >                         goto out_cdpl2;
> >         }
> >
> > -       if (ctx->enable_mba_mbps) {
> > -               ret = set_mba_sc(true);
> > +       if (ctx->enable_mba_mbps_local || ctx->enable_mba_mbps_total) {
> > +               if (ctx->enable_mba_mbps_total)
> > +                       mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
> > +               else
> > +                       mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> 
> Total takes precedence over local when the user picks both.

Harmless ... but see below.

> > +               ret = set_mba_sc(true, mba_mbps_event);
> >                 if (ret)
> >                         goto out_cdpl3;
> >         }
> > @@ -2683,15 +2689,17 @@ enum rdt_param {
> >         Opt_cdp,
> >         Opt_cdpl2,
> >         Opt_mba_mbps,
> > +       Opt_mba_mbps_event,
> >         Opt_debug,
> >         nr__rdt_params
> >  };
> >
> >  static const struct fs_parameter_spec rdt_fs_parameters[] = {
> > -       fsparam_flag("cdp",             Opt_cdp),
> > -       fsparam_flag("cdpl2",           Opt_cdpl2),
> > -       fsparam_flag("mba_MBps",        Opt_mba_mbps),
> > -       fsparam_flag("debug",           Opt_debug),
> > +       fsparam_flag("cdp",                     Opt_cdp),
> > +       fsparam_flag("cdpl2",                   Opt_cdpl2),
> > +       fsparam_flag("mba_MBps",                Opt_mba_mbps),
> > +       fsparam_string("mba_MBps_event",        Opt_mba_mbps_event),
> > +       fsparam_flag("debug",                   Opt_debug),
> >         {}
> >  };
> >
> > @@ -2715,7 +2723,25 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
> >         case Opt_mba_mbps:
> >                 if (!supports_mba_mbps())
> >                         return -EINVAL;
> > -               ctx->enable_mba_mbps = true;
> > +               if (is_mbm_local_enabled())
> > +                       ctx->enable_mba_mbps_local = true;
> > +               else
> > +                       return -EINVAL;
> > +               return 0;
> > +       case Opt_mba_mbps_event:
> > +               if (!supports_mba_mbps())
> > +                       return -EINVAL;
> > +               if (!strcmp("mbm_local_bytes", param->string)) {
> > +                       if (!is_mbm_local_enabled())
> > +                               return -EINVAL;
> > +                       ctx->enable_mba_mbps_local = true;
> > +               } else if (!strcmp("mbm_total_bytes", param->string)) {
> > +                       if (!is_mbm_total_enabled())
> > +                               return -EINVAL;
> > +                       ctx->enable_mba_mbps_total = true;
> > +               } else {
> > +                       return -EINVAL;
> 
> It looks like if I pass
> "mba_MBps_event=mbm_total_bytes,mba_MBps_event=mbm_local_bytes" I can
> set both flags true.

That's going to be confusing. I'll add code to stop the user from
passing both options.

> > --
> > 2.41.0
> >
> 
> Consider the setting-both-events quirk and a little bit of defensive
> programming for get_mbm_data() returning NULL.
> 
> Assuming the case of "Local" is fixed in the commit message:
> 
> Reviewed-by: Peter Newman <peternewman@google.com>

Thanks for reviewing, and for the tags for parts 2 & 3.

-Tony
