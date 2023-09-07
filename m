Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F8ED7
	for <patches@lists.linux.dev>; Thu,  7 Sep 2023 05:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694064923; x=1725600923;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YydbqhJarc2vSKbDb2N/By/s4B0ANbgj0fmO0TLAQv8=;
  b=ZdMw/ZkDo2pWVJBOcA5OnlFHpSOV4UwvYYaYz0DwvVINj+CQmapgOHzE
   Df+USwalWP3PQe4wQiiIUw1uBxFzHePFS1EKf5Q8MMDKwZSqg64Fx0oFm
   4nZDJJKS3E0JhnivcNX8yPqLgJc5FnqtKJPeYluS0RdWZob6ts78MmhFJ
   /VZq/QGZHEszt244VLYDhgswUCIWz1UpVnylQvlegtzp+q9p2vkcgHQhg
   rmMOHVEveFr+fydxaNj6/4Zn89P2dxlxg5zCNDQjX+fAvCcivme2JcAsa
   RBRhqVAkdFqM5Yiwk64LHDz2C0nWD5SBj3DD41sp0XuPkxJXBaUS7NrjS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="463641388"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="463641388"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 22:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="865480969"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="865480969"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 06 Sep 2023 22:35:14 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id 17938177; Thu,  7 Sep 2023 08:35:13 +0300 (EEST)
Date: Thu, 7 Sep 2023 08:35:13 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
Message-ID: <20230907053513.GH1599918@black.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org>
 <20230906180944.2197111-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230906180944.2197111-2-swboyd@chromium.org>

On Wed, Sep 06, 2023 at 11:09:41AM -0700, Stephen Boyd wrote:
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
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Fixes: e7b7ab3847c9 ("platform/x86: intel_scu_ipc: Sleeping is fine when polling")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> This is sufficiently busy so I didn't add any tags from previous round.
> 
>  drivers/platform/x86/intel_scu_ipc.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
> index 6851d10d6582..b2a2de22b8ff 100644
> --- a/drivers/platform/x86/intel_scu_ipc.c
> +++ b/drivers/platform/x86/intel_scu_ipc.c
> @@ -232,18 +232,21 @@ static inline u32 ipc_data_readl(struct intel_scu_ipc_dev *scu, u32 offset)
>  static inline int busy_loop(struct intel_scu_ipc_dev *scu)
>  {
>  	unsigned long end = jiffies + IPC_TIMEOUT;
> +	u32 status;
>  
>  	do {
> -		u32 status;
> -
>  		status = ipc_read_status(scu);
>  		if (!(status & IPC_STATUS_BUSY))
> -			return (status & IPC_STATUS_ERR) ? -EIO : 0;
> +			goto not_busy;
>  
>  		usleep_range(50, 100);
>  	} while (time_before(jiffies, end));
>  
> -	return -ETIMEDOUT;
> +	status = ipc_read_status(scu);

Does the issue happen again if we get scheduled away here for a long
time? ;-)

Regardless, I'm fine with this as is but if you make any changes, I
would prefer see readl_busy_timeout() used here instead (as was in the
previous version).

> +	if (status & IPC_STATUS_BUSY)
> +		return -ETIMEDOUT;
> +not_busy:
> +	return (status & IPC_STATUS_ERR) ? -EIO : 0;
>  }
>  
>  /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
> -- 
> https://chromeos.dev
