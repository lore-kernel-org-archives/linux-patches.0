Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650A8848D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 21:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694467049; x=1726003049;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OvOywvaVgqf7GXCTK6i+HE3r8bZumInwL/UZ2w6I2+s=;
  b=Avi1Ml0qTkQTeTZSyTVJj6ET6opFgyNvmviU+J0rES0YoOppbAbMjbG9
   w7P/Xc7k0dbZGeuwUwRVtporRu43w4K0nPhpfQgALJOGWAZ11hWl95e5j
   JWDQUJCrk2q+u+uMEE5jPM6bmw3hj4bKoCs0kbwEq/aJ2fI0Ylc6canW3
   WQSCKsgtrGOvLdXGmY+BGWiTRU5MfOoK2j7vnzrGtb4uwiTAcvm6ZTC+X
   UoTFFoXQqOUVgBQQdfmH9iF5IRLNuOpx4NGi0j1LSOVfAxR//zkv2tCyt
   pQhidlhhwpXenEVg9NXjhMjK5EfsAa1C3TANUgua5h831y5jPoje2lIne
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="409166245"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="409166245"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:17:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="720129941"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="720129941"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:17:25 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qfoHa-008QTA-1i;
	Tue, 12 Sep 2023 00:17:22 +0300
Date: Tue, 12 Sep 2023 00:17:22 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v3 1/4] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
Message-ID: <ZP+D4hlUXhAboFBJ@smile.fi.intel.com>
References: <20230911193937.302552-1-swboyd@chromium.org>
 <20230911193937.302552-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911193937.302552-2-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 11, 2023 at 12:39:33PM -0700, Stephen Boyd wrote:
> It's possible for the polling loop in busy_loop() to get scheduled away
> for a long time.
> 
>   status = ipc_read_status(scu); // status = IPC_STATUS_BUSY
>   <long time scheduled away>
>   if (!(status & IPC_STATUS_BUSY))
> 
> If this happens, then the status bit could change while the task is
> scheduled away and this function would never read the status again after
> timing out. Instead, the function will return -ETIMEDOUT when it's
> possible that scheduling didn't work out and the status bit was cleared.
> Bit polling code should always check the bit being polled one more time
> after the timeout in case this happens.
> 
> Fix this by reading the status once more after the while loop breaks.
> The read_poll_timeout() macro implements all of this, and it is
> shorter, so use that macro here to consolidate code and fix this.
> 
> There were some concerns with using read_poll_timeout() because it uses
> timekeeping, and timekeeping isn't running early on or during the late
> stages of system suspend or early stages of system resume, but an audit
> of the code concluded that this code isn't called during those times so
> it is safe to use the macro.

...

> +	err = read_poll_timeout(ipc_read_status, status, !(status & IPC_STATUS_BUSY),
> +				100, jiffies_to_usecs(IPC_TIMEOUT), false, scu);

Since "false" you probably can utilize readx_poll_timeout().

> +	if (err)
> +		return err;
>  
-- 
With Best Regards,
Andy Shevchenko


