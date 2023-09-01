Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B01B3FF4
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 06:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693548294; x=1725084294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cft0NZX01jZWskmao0IZaX0TQTrymVnXyHFz/2cvU04=;
  b=BPsTeSuaLJaygSphHK6Byv0R72wFogtMgIH63ouu9gDDPABxeSgOryRo
   jEdKNhyoLgFovE2lRrIu1zb/MYay2SIogd7I3+MZjm6m4P+dSMgMFxLin
   aag/2XWE1IM0+5GTiOt1y8L9XIGKXW5pJzqssxIbSb3GYPPF7dcqhUq0q
   30gn8o9g+ZxTVbXHx1a8c9OFKEILTIVTynSDRSS2eRargG13iTNwl+ODc
   75GTTFgscAnN6GWv3n+KvdLmyOM+1k09PaMVgTabMmcMkEwWcKMqH9f3j
   e/ccyvOikQqlKV5kOG5XVknRL1tFIqzZV6gWg2l5N/2Qs7XqdzYSriaYD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="366372093"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="366372093"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 23:04:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="805310003"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="805310003"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 31 Aug 2023 23:04:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id 7DC2FDE; Fri,  1 Sep 2023 09:04:43 +0300 (EEST)
Date: Fri, 1 Sep 2023 09:04:43 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 2/3] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
Message-ID: <20230901060443.GU3465@black.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230831011405.3246849-3-swboyd@chromium.org>

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
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
