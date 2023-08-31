Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B511722
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693490305; x=1725026305;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HglTuLoHbYLIfAQzy82eLjJIMlyaJ7UjkVVkzK1ra54=;
  b=ThEwHzBRRkBz6Xyn/Q2GebXhYINAEPbZFYRSeK+agzqM1Xg2trFbFSTO
   25l0k1RwhCbBFEGNy1hF4lBqBi4B/r9mXuttQ/w+qzjY1Mlr6IyHaLz9c
   CNgHyZ4JPHQGHy6GWE8TsvdfR+m3C4gXX0A68u+AbiUCxWJxWg/Z90F8f
   oNjmAFB7bzUIb9Yq73zR3QItxPH0C0x0pxyQ79ErxsXGqS/CDIdP81mhL
   44P3Ncs9gpcpBppR4cKwYFnJL/wYRRwOu8UpS9zBSpJl7+56sj+i7MtC6
   ij0gT/PlMVxdweb0RuoMSWl3JptYvzcNxo2m52fjFmtUOuzR5ilDwuWgL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="355450945"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="355450945"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 06:58:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="805002182"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="805002182"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 06:58:21 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qbiBe-005P1x-29;
	Thu, 31 Aug 2023 16:58:18 +0300
Date: Thu, 31 Aug 2023 16:58:18 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 2/3] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
Message-ID: <ZPCcevAt4CwCADe2@smile.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831011405.3246849-3-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Aug 30, 2023 at 06:14:02PM -0700, Stephen Boyd wrote:
> It's possible for the completion in ipc_wait_for_interrupt() to timeout,
> simply because the interrupt was delayed in being processed. A timeout
> in itself is not an error. This driver should check the status register
> upon a timeout to ensure that scheduling or interrupt processing delays
> don't affect the outcome of the IPC return value.
> 
>  CPU0                                                   SCU
>  ----                                                   ---
>  ipc_wait_for_interrupt()
>   wait_for_completion_timeout(&scu->cmd_complete)
>   [TIMEOUT]                                             status[IPC_BUSY]=0
> 
> Fix this problem by reading the status bit in all cases, regardless of
> the timeout. If the completion times out, we'll assume the problem was
> that the IPC_BUSY bit was still set, but if the status bit is cleared in
> the meantime we know that we hit some scheduling delay and we should
> just check the error bit.

Makes sense, thanks for fixing this!
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Also see below.

...

>  /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */

Not sure if this comment needs to be updated / amended.

...

>  	status = ipc_read_status(scu);
> -	if (status & IPC_STATUS_ERR)
> -		return -EIO;
> +	if (!(status & IPC_STATUS_BUSY))
> +		err = (status & IPC_STATUS_ERR) ? -EIO : 0;
>  
> -	return 0;
> +	return err;

I would write it as:

	status = ipc_read_status(scu);
	if (status & IPC_STATUS_BUSY)
		return 0;
	if (status & IPC_STATUS_ERR)
		return -EIO;

	return 0;

Also would be good, in case you are not doing it yet, to use --patience when
formatting your patches.

-- 
With Best Regards,
Andy Shevchenko


