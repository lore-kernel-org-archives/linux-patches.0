Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59D811707
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 14:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693490886; x=1725026886;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b1giQg6JZeac/5i+rnklAmY2c37piEGAdmDhQDDAAyA=;
  b=I+Woeh1ngA7agpmS0Ub0PBwz6zJfJMApJYsIpaAe81KmPJYho382N+3U
   HFOZjCLOyu73RGriiH+3E2RkL2Dk6xWNp4NdBvhYPYbo+pI6JNdi3xUz3
   qYSkzvap6NURv/NRrItcS+B1Mzdas6dQdrh56dN08oONaGV4FHzD1qyOc
   EGR5JmVbdGWQq+/zStoDFjobAYixoR/72bTVy/Mg+o50ay7Jql3CtpIkR
   K/noEBvPdm+WU81bjpsck0aJuocT5uhXsxm1Ko7Rpf5xE+51d7IsBvyIk
   FNLF1ASDJk+QzIR6AeRpiNnnMqjpt6doiCG4EMF8dJ2K1mqKzwg5juZwm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="462323504"
X-IronPort-AV: E=Sophos;i="6.02,217,1688454000"; 
   d="scan'208";a="462323504"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 07:07:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="809645901"
X-IronPort-AV: E=Sophos;i="6.02,217,1688454000"; 
   d="scan'208";a="809645901"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 07:07:29 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qbiKU-005P9q-1J;
	Thu, 31 Aug 2023 17:07:26 +0300
Date: Thu, 31 Aug 2023 17:07:26 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 3/3] platform/x86: intel_scu_ipc: Fail IPC send if still
 busy
Message-ID: <ZPCenoPp/SDesUek@smile.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-4-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831011405.3246849-4-swboyd@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Aug 30, 2023 at 06:14:03PM -0700, Stephen Boyd wrote:
> It's possible for interrupts to get significantly delayed to the point
> that callers of intel_scu_ipc_dev_command() and friends can call the
> function once, hit a timeout, and call it again while the interrupt
> still hasn't been processed. This driver will get seriously confused if
> the interrupt is finally processed after the second IPC has been sent
> with ipc_command(). It won't know which IPC has been completed. This
> could be quite disastrous if calling code assumes something has happened
> upon return from intel_scu_ipc_dev_simple_command() when it actually
> hasn't.
> 
> Let's avoid this scenario by simply returning -EBUSY in this case.
> Hopefully higher layers will know to back off or fail gracefully when
> this happens. It's all highly unlikely anyway, but it's better to be
> correct here as we have no way to know which IPC the status register is
> telling us about if we send a second IPC while the previous IPC is still
> processing.

> +static bool intel_scu_ipc_busy(struct intel_scu_ipc_dev *scu)

static int ?

> +{
> +	u8 status;
> +
> +	status = ipc_read_status(scu);
> +	if (status & IPC_STATUS_BUSY) {

> +		dev_err(&scu->dev, "device is busy\n");

1. Wouldn't it exaggerate the logs? Shouldn't be rate limited?
2. OTOH if we return -EBUSY directly from here, do we need this at all?

> +		return true;
> +	}
> +
> +	return false;
> +}

-- 
With Best Regards,
Andy Shevchenko


