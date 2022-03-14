Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278DB7469
	for <patches@lists.linux.dev>; Mon, 14 Mar 2022 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647299441; x=1678835441;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6C9nVg8jyii5VHo88KHjPTiSG9eWD7pgA09gtw2HDFo=;
  b=jEwZxrEfIf05DlStg76STg/DAdW7/O0afI/6gKTm2Nig4fPjGYI64VT1
   Zw//z0svAo56j7waYtTAkGe21xsjgj9VdzPfC76kjhjP3JvNtFuMG57rp
   mburW8kROVvCMr4RCZfbug/P+qTGdUEpWdAkfuAEtLtRYHUbnfTanmubd
   368DM3pzbsvSrJUtI13RYQRP78ZuR/o7Nd5FtnW7281wX8PE64XdSFxZF
   yDta0if+JqHEodXdIm+Ek4EO8BM9DQiwKq/YEXxyNqbfPRhEVStK5j3NZ
   8Nn6C08DfDQOtLtiBkDATlk9mBki1kpWbx8IoHnm6OGRTAffLkTReX1aN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="316886597"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="316886597"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 16:10:40 -0700
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="598096916"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 16:10:40 -0700
Date: Mon, 14 Mar 2022 16:10:39 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jithu Joseph <jithu.joseph@intel.com>, hdegoede@redhat.com,
	markgross@kernel.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, corbet@lwn.net, andriy.shevchenko@linux.intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 00/10] Introduce In Field Scan driver
Message-ID: <Yi/Lb5laEki0JHft@agluck-desk3.sc.intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <Yh59rOIH24X+6GyI@kroah.com>
 <Yh5+om/Nr06V0+Qj@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh5+om/Nr06V0+Qj@kroah.com>

On Tue, Mar 01, 2022 at 09:14:26PM +0100, Greg KH wrote:
> On Tue, Mar 01, 2022 at 09:10:20PM +0100, Greg KH wrote:
> > On Tue, Mar 01, 2022 at 11:54:47AM -0800, Jithu Joseph wrote:
> > > Note to Maintainers:
> > > Requesting x86 Maintainers to take a look at patch01 as it
> > > touches arch/x86 portion of the kernel. Also would like to guide them
> > > to patch07 which sets up hotplug notifiers and creates kthreads.
> > > 
> > > Patch 2/10 - Adds Documentation. Requesting Documentation maintainer to review it.
> > > 
> > > Requesting Greg KH to review the sysfs changes added by patch08.
> > 
> > "RFC" means you are not comfortable submitting the changes yet, so you
> > don't need my review at this point in time.  Become confident in your
> > changes before asking for others to review the code please.
> 
> Hint, it needs work, sysfs_emit() for one thing, lack of reference
> counting on your cpu objects is another...

Greg,

Thanks for the comments. They triggered a bunch of internal
re-thinking of the interface.  One idea that has some traction
(Credit/Blame: Dan Williams) is to:

1) Don't put anything in /sys/devices/system/cpu/*
2) Driver creates some info/control files in its own
   corner of /sys/devices/.../ifs
3) No per-cpu files ... run a test with:
   # echo ${cpu} > /sys/devices/.../ifs/run_test
4) No test result files.
   When tests complete they report using uevents

Using uevent to report means that we can easily have
mutiple parts to the result (pass/fail/incomplete status, as well
as diagnostic details about the reason for the failure,
or why the test was not completed).

This seems a novel use of uevent ... is it OK, or is is abuse?

Thanks

-Tony
