Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2D723A6
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694495101; x=1726031101;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=URkUofiEo6whfXpBDveK+XC9cE0isgPklL6xvqQGiL0=;
  b=aIKQOk+04AEMZW/7hBUDRPgc3JaXRy/bUXVkqQDsOMSk+b/o/gA5pMoU
   IneNgHhOk+yEt8AO39ILLY2+GWXXyeiH4Vukrse9DpZS89qCOhxG7oM7v
   yAZ+kfTVcsNvb2ghKKfvu8HyMcYDn1gLXmJfL+zT5LuXHFMeJ60g1OO0a
   uZ9INO0yodDrvWpQac2nOxXVeHtI6PY6gyJogBghW1bhczTF6NYai/rwv
   Y/FZxSro8/nBI6xgpBFQe3/L6A9ui/NmtoBeV/Poziq3ySfrKHTHxix5H
   GA8gWSzj3Y0Oe8CoHOaP929ZEI3H/glkU21gC02ZCU0WVG0n1CQV4FRtY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="409230832"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="409230832"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 22:05:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="778649730"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="778649730"
Received: from dkandpal-mobl1.amr.corp.intel.com (HELO [10.212.139.48]) ([10.212.139.48])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 22:05:00 -0700
Message-ID: <700f14f7-ae3d-410c-8b10-2a83221aba3c@linux.intel.com>
Date: Mon, 11 Sep 2023 22:04:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 platform-driver-x86@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Prashant Malani <pmalani@chromium.org>
References: <20230911193937.302552-1-swboyd@chromium.org>
 <20230911193937.302552-2-swboyd@chromium.org>
From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20230911193937.302552-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/11/2023 12:39 PM, Stephen Boyd wrote:
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
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Fixes: e7b7ab3847c9 ("platform/x86: intel_scu_ipc: Sleeping is fine when polling")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>


-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
