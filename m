Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E9E138C
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694494851; x=1726030851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gQCqTAEYQL/pkOw8sp0WLX0nuh/gNZ5sLDu8CpvEilQ=;
  b=VEJyisadzm02KtB2/Ov0yqBjRV/jcBdKz6/PGIL8K30ElP9AfU7+mkvJ
   BOfwHsecqZVsXmP3flJICGlTICHvfHKfphJlISmZH+9feNRYfSjnpeAKj
   2TctCXccFueaASbeM4i6mSTuJxaD7oBx+hPC/5Z+5BDJYqDhaE/9WV7Oa
   m93WQgI9dDAHZ9ngbWEIfU8kNBhoGM+MakfIRMWPc++igCdoFcOCci7lo
   0dkbW2TK4CG6PWBojgx+SyoWGuOgg/+yxhZAQ/7lBdnCmIwxt1ywdYz1n
   1rEMgSaDGO6RWYy5zgT5oTd89XMxs0CTvhEBbE+8DEKFu/SS1Opnq2K5/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="409230168"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="409230168"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 22:00:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="858637789"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="858637789"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 11 Sep 2023 22:00:47 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id EFC82248; Tue, 12 Sep 2023 08:00:45 +0300 (EEST)
Date: Tue, 12 Sep 2023 08:00:45 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v3 2/4] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
Message-ID: <20230912050045.GA1599918@black.fi.intel.com>
References: <20230911193937.302552-1-swboyd@chromium.org>
 <20230911193937.302552-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230911193937.302552-3-swboyd@chromium.org>

On Mon, Sep 11, 2023 at 12:39:34PM -0700, Stephen Boyd wrote:
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
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
