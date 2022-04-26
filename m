Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5084F33C1
	for <patches@lists.linux.dev>; Tue, 26 Apr 2022 23:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651017195; x=1682553195;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=khnX1ty93jUwk1ufPotG1fbs/K/3Ddf4V9dX4JV7/uw=;
  b=eHd5B5oqZcY35BkRW5lYt/xQk9rvVXdY4niHUJk4sm1/+xQ2FktRnOTc
   GOsr8Qgpsb9/NyV2TjseGXUMeYHm5P8mrCUhPpLGTiKzcXgvMeNoOA50e
   EA+iv3xduB8sVOR2oXj+VYs/12TIC3zqT0dX/C23VvhiS/9jefImN2DoS
   vl1JcjpqhS019IBIDF4f0s8pbCn4JdGqTNCfYaNLef6FMJdBee2j6VXbO
   m5a0f/fU88ztjEPRBKw0b89y9u17YBMpodLtb7Pn44H7JVed4lBE5/ZmX
   c09uMzQYYp6OoB+tsMbbnyImTxCXopfJIFewaNVWky8CrNBYnloAYJlqT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="290908491"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="290908491"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 16:53:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="660942056"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 16:53:14 -0700
Date: Tue, 26 Apr 2022 16:53:13 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v4 09/10] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Message-ID: <YmiF6Rsy04pUHVQo@agluck-desk3.sc.intel.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
 <20220422200219.2843823-1-tony.luck@intel.com>
 <20220422200219.2843823-10-tony.luck@intel.com>
 <20220425105251.3f5e8021@gandalf.local.home>
 <1752057af33e4eb28bcea0fd75e44048@intel.com>
 <20220425214928.2aac3391@gandalf.local.home>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220425214928.2aac3391@gandalf.local.home>

On Mon, Apr 25, 2022 at 09:49:28PM -0400, Steven Rostedt wrote:
> On Mon, 25 Apr 2022 16:49:35 +0000
> "Luck, Tony" <tony.luck@intel.com> wrote:
> 
> > I see two paths:
> > 
> > 1) Create a new user friendly trace point for each new scan mode.
> > 2) Just provide a generic one that dumps both the 64-bit WRMSR and RDMSR values.
> > 
> > Q: Are trace points "expensive" in some way ... so better to just have one than three?
> >      Or are the cheap enough that decoding for the user is an OK thing?
> 
> Yes, they are expensive as each TRACE_EVENT() can add a few KB of text and
> data. But you can add a DECLARE_EVENT_CLASS() and then add "printk"
> differences that are less memory heavy.
> 
> See DEFINE_EVENT_PRINT().

I looked at the examples in samples/trace_events/trace-events-sample.h
and tried to use this. But I'm doing something wrong because the
compiler barfs on something defined but not used.

Maybe my problem is the TP_printk() in the DECLARE_EVENT_CLASS() that
is over-ridden by DEFINE_EVENT_PRINT(). I wasn't at all sure what to
put here ... or how to use the base tracepoint that doesn't have the
printk() over-ridden.

I think I need my class to just save both the u64 values to the trace
buffer. Then the different trace points will extract the bits they want
and print in a user friendly way. While this increases space used in
the trace buffer, these events are not crazy high frequency. Usually 
one or two events per core with a gap 30 minutes or more between tests.

In my ".c" file the tracepoint looks like this using the name from
DEFINE_EVENT_PRINT(), and now passing the full u64 values:

	trace_ifs_status_saf(activate.data, status.data);

and my #include file looks like this:

----------------------------------------------
/* SPDX-License-Identifier: GPL-2.0 */
#undef TRACE_SYSTEM
#define TRACE_SYSTEM intel_ifs

#if !defined(_TRACE_IFS_H) || defined(TRACE_HEADER_MULTI_READ)
#define _TRACE_IFS_H

#include <linux/ktime.h>
#include <linux/tracepoint.h>

DECLARE_EVENT_CLASS(ifs_status,

	TP_PROTO(u64 activate, u64 status),

	TP_ARGS(activate, status),

	TP_STRUCT__entry(
		__field(	u64,	activate	)
		__field(	u64,	status		)
	),

	TP_fast_assign(
		__entry->activate = activate;
		__entry->status	= status;
	),

	TP_printk("activate: %llx status: %llx",
		__entry->activate,
		__entry->status)
);

DEFINE_EVENT_PRINT(ifs_status, ifs_status_saf,
	TP_PROTO(u64 activate, u64 status),
	TP_ARGS(activate, status),
	TP_printk("start: %.2x, stop: %.2x, status: %llx",
		((union ifs_scan *)&(__entry->activate))->start,
		((union ifs_scan *)&(__entry->activate))->stop,
		__entry->status)
);

#endif /* _TRACE_IFS_H */

/* This part must be outside protection */
#include <trace/define_trace.h>
-----------------------------------------------------

GCC messages:


  CC [M]  drivers/platform/x86/intel/ifs/runtest.o
In file included from /home/agluck/GIT/mywork/include/trace/define_trace.h:102,
                 from /home/agluck/GIT/mywork/include/trace/events/intel_ifs.h:44,
                 from /home/agluck/GIT/mywork/drivers/platform/x86/intel/ifs/runtest.c:27:
/home/agluck/GIT/mywork/include/trace/trace_events.h:426:13: warning: ‘print_fmt_ifs_status’ defined but not used [-Wunused-variable]
  426 | static char print_fmt_##call[] = print;                                 \
      |             ^~~~~~~~~~
/home/agluck/GIT/mywork/include/trace/events/intel_ifs.h:11:1: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   11 | DECLARE_EVENT_CLASS(ifs_status,
      | ^~~~~~~~~~~~~~~~~~~
In file included from /home/agluck/GIT/mywork/include/trace/define_trace.h:102,
                 from /home/agluck/GIT/mywork/include/trace/events/intel_ifs.h:44,
                 from /home/agluck/GIT/mywork/drivers/platform/x86/intel/ifs/runtest.c:27:
/home/agluck/GIT/mywork/include/trace/trace_events.h:207:37: warning: ‘trace_event_type_funcs_ifs_status’ defined but not used [-Wunused-variable]
  207 | static struct trace_event_functions trace_event_type_funcs_##call = {   \
      |                                     ^~~~~~~~~~~~~~~~~~~~~~~
/home/agluck/GIT/mywork/include/trace/events/intel_ifs.h:11:1: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   11 | DECLARE_EVENT_CLASS(ifs_status,
      | ^~~~~~~~~~~~~~~~~~~
make[1]: Leaving directory '/home/agluck/GIT/mywork/build/ifsv5-rc1'

-Tony
