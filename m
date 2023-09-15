Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F198510964
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 13:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694785751; x=1726321751;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=4IcYhwjz5QUsOTeYLbkK5pEmiuhen3zjH9p2Ck1k6DY=;
  b=cEpY9tcgvPE8tXZrVrT97w6qShJrqoLbENFd7f8D7SBH8lrw0dLztWPM
   a45vyU5raUZ7ykRaanz1w7ib7jy4vSfUTBa9Ijq7CT6j52TjbQG59YmVh
   Q3bz4g7Slvt6Gg4kfqmSzHtnK7J0n6lI/jkaLTELCB/ugLD+MChkgrRhX
   xtpk+H1LT8sk5dueUdHXlEetgpBXltRU3fd5+J0r1gez7K8zsygK0R4jz
   yjZcuyGTewIenxusITSGm21X42DgQ30C23btlHewWWO+vPm7YYfyYBFBp
   7iqWhNxPCrYfVsvAF/sZ5zIAemAecIo92SMxDj/3wO1WvMt3iftosfChW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="465613857"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="465613857"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 06:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="694726004"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="694726004"
Received: from srdoo-mobl1.ger.corp.intel.com ([10.252.38.99])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 06:49:06 -0700
Date: Fri, 15 Sep 2023 16:49:04 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
cc: Mika Westerberg <mika.westerberg@linux.intel.com>, 
    Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
    platform-driver-x86@vger.kernel.org, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
    Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
    Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v4 2/4] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
In-Reply-To: <20230913212723.3055315-3-swboyd@chromium.org>
Message-ID: <2bd9b7e2-a558-305b-bfd9-e64c28b6303d@linux.intel.com>
References: <20230913212723.3055315-1-swboyd@chromium.org> <20230913212723.3055315-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 13 Sep 2023, Stephen Boyd wrote:

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
>   [TIMEOUT]                                             status[IPC_STATUS_BUSY]=0
> 
> Fix this problem by reading the status bit in all cases, regardless of
> the timeout. If the completion times out, we'll assume the problem was
> that the IPC_STATUS_BUSY bit was still set, but if the status bit is
> cleared in the meantime we know that we hit some scheduling delay and we
> should just check the error bit.

Hi,

I don't understand the intent here. What prevents IPC_STATUS_BUSY from 
changing right after you've read it in ipc_read_status(scu)? Doesn't that 
end you exactly into the same situation where the returned value is stale 
so I cannot see how this fixes anything, at best it just plays around the 
race window that seems to still be there after this fix?

-- 
 i.


> Cc: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/platform/x86/intel_scu_ipc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
> index 4c774ee8bb1b..299c15312acb 100644
> --- a/drivers/platform/x86/intel_scu_ipc.c
> +++ b/drivers/platform/x86/intel_scu_ipc.c
> @@ -248,10 +248,12 @@ static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
>  {
>  	int status;
>  
> -	if (!wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT))
> -		return -ETIMEDOUT;
> +	wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT);
>  
>  	status = ipc_read_status(scu);
> +	if (status & IPC_STATUS_BUSY)
> +		return -ETIMEDOUT;
> +
>  	if (status & IPC_STATUS_ERR)
>  		return -EIO;
>  
> 
