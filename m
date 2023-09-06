Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E9D6131
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694008693; x=1725544693;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2WWHRUyg9p2ZSwhYGZ7eiU78qxzL0KM29diRxubyLdk=;
  b=QJo2oG3MxDQ325wecdZdYFcdItRWVSYIwqLMhYvF6v0FZ/06GZfz3Jgl
   +RH2ZDxFoudZAFG0aRVSSmfop5KOfB62B+75/EGTtjQtS0l9bxzwowT89
   HN7XdC4jSMrdPaZDVEL08Odd6QpIyTlr+7ee4mTc7HynrbUvZ2/xcv+GE
   KsMgneKf08x63TTXhntUl/afZqF32wmKQYVtUw+YvHMmh2pB4axHWrBxx
   hSP02fmFPcpdr9M/z7pDaUiBuscO+hkUirqDzE/pwfT57bvR5tgtcJMrK
   85gYhkmG8qivw7DiUcei2qa89Zcr4S5V2i8OJ1NXSQ/5PVgSIGqR7SGRU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="357382155"
X-IronPort-AV: E=Sophos;i="6.02,232,1688454000"; 
   d="scan'208";a="357382155"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 06:58:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="741558602"
X-IronPort-AV: E=Sophos;i="6.02,232,1688454000"; 
   d="scan'208";a="741558602"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 06:58:08 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qdt2j-006xPT-07;
	Wed, 06 Sep 2023 16:58:05 +0300
Date: Wed, 6 Sep 2023 16:58:04 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 1/3] platform/x86: intel_scu_ipc: Check status after
 timeouts in busy_loop()
Message-ID: <ZPiFbDWeUV99YE50@smile.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-2-swboyd@chromium.org>
 <ZPCbSse3J6ksZwJa@smile.fi.intel.com>
 <CAE-0n52wAqsmm4cs6JX2W2G10VxjLzocXVmF9c_GC+52Fi4djQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n52wAqsmm4cs6JX2W2G10VxjLzocXVmF9c_GC+52Fi4djQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Sep 05, 2023 at 05:24:29PM -0500, Stephen Boyd wrote:
> Quoting Andy Shevchenko (2023-08-31 06:53:14)
> > On Wed, Aug 30, 2023 at 06:14:01PM -0700, Stephen Boyd wrote:
> > > It's possible for the polling loop in busy_loop() to get scheduled away
> > > for a long time.
> > >
> > >   status = ipc_read_status(scu);
> > >   <long time scheduled away>
> > >   if (!(status & IPC_STATUS_BUSY))
> > >
> > > If this happens, then the status bit could change and this function
> > > would never test it again after checking the jiffies against the timeout
> > > limit. Polling code should check the condition one more time after the
> > > timeout in case this happens.
> > >
> > > The read_poll_timeout() helper implements this logic, and is shorter, so
> > > simply use that helper here.
> >
> > I don't remember by heart, but on some older Intel hardware this might have
> > been called during early stages where ktime() is not functional yet.
> >
> > Is this still a case here?
> 
> I have no idea if that happens in early stages.

I briefly browsed the current tree and it seems it's not the case.

> What about
> suspend/resume though? I suppose timekeeping could be suspended in that
> case, so we can't really check anything with ktime.

Hmm... SCU itself is running all the time I think. The timekeeping depends on
the platform, but is it really the case? I dunno.

> I can rework this patch to simply recheck the busy bit so that we don't
> have to figure out if the code is called early or from suspend paths.

Yeah, probably we can do this and leave this nice cleanup in place.

-- 
With Best Regards,
Andy Shevchenko


