Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03383FF4
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 06:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693548399; x=1725084399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5zXm/ilGbvaTMhT7HjwnoHc9furUVXGdEvbQQYm3oTY=;
  b=eZostM0UyaKDQ4+ly9YjXwfLajjAL7Wzl2Mv/hd6iuUhdPX41U1NsgHy
   PuJU2E2DFTISnqjwBrN+e1Be+urRICfmDn9povSYbV9ImGhJqHeeBKM8T
   BipvJNG4FQD6V0OJymHx+rsgxp/Csou48/YuLYbpQpTWYH2cSQ40UPOHE
   ix9ngZQLc1SLMie71PNk5xarD9EWe6wY1dWDeNhs/Mcc1IdkRSBS0wqDw
   Iq9Hq1ufG2BQwQzXSnzHSYgwcc9LQK9Vo3t+eWjfIc7N8NGIsctCH+ouJ
   IUyjKDBi4tgJMW1VmCVJGjytZy1gCGMfzQao5Tt0/EDC0GEvu8JJ9i2IB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="361168133"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="361168133"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 23:06:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="1070612442"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="1070612442"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2023 23:06:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id BDE26DE; Fri,  1 Sep 2023 09:06:33 +0300 (EEST)
Date: Fri, 1 Sep 2023 09:06:33 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 3/3] platform/x86: intel_scu_ipc: Fail IPC send if still
 busy
Message-ID: <20230901060633.GV3465@black.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-4-swboyd@chromium.org>
 <ZPCenoPp/SDesUek@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZPCenoPp/SDesUek@smile.fi.intel.com>

On Thu, Aug 31, 2023 at 05:07:26PM +0300, Andy Shevchenko wrote:
> On Wed, Aug 30, 2023 at 06:14:03PM -0700, Stephen Boyd wrote:
> > It's possible for interrupts to get significantly delayed to the point
> > that callers of intel_scu_ipc_dev_command() and friends can call the
> > function once, hit a timeout, and call it again while the interrupt
> > still hasn't been processed. This driver will get seriously confused if
> > the interrupt is finally processed after the second IPC has been sent
> > with ipc_command(). It won't know which IPC has been completed. This
> > could be quite disastrous if calling code assumes something has happened
> > upon return from intel_scu_ipc_dev_simple_command() when it actually
> > hasn't.
> > 
> > Let's avoid this scenario by simply returning -EBUSY in this case.
> > Hopefully higher layers will know to back off or fail gracefully when
> > this happens. It's all highly unlikely anyway, but it's better to be
> > correct here as we have no way to know which IPC the status register is
> > telling us about if we send a second IPC while the previous IPC is still
> > processing.
> 
> > +static bool intel_scu_ipc_busy(struct intel_scu_ipc_dev *scu)
> 
> static int ?
> 
> > +{
> > +	u8 status;
> > +
> > +	status = ipc_read_status(scu);
> > +	if (status & IPC_STATUS_BUSY) {
> 
> > +		dev_err(&scu->dev, "device is busy\n");
> 
> 1. Wouldn't it exaggerate the logs? Shouldn't be rate limited?
> 2. OTOH if we return -EBUSY directly from here, do we need this at all?

Agree w/ returning -EBUSY here and dropping the dev_err() (or using
dev_dbg()).
