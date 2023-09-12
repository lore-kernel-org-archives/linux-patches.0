Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C258B168BC
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694494910; x=1726030910;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CvDsWCO+be1IG+Rmf778MqHKB3/nXOhC4fYb3fHGuY4=;
  b=XgtUWf9JuJYSLHOcvoMyUo+yg8/gr2Q4+JzFdZNyMQyCntPz4HVIV8OO
   2826yQId916whkzBaU2CiM7XqoGGMf4Br1nzblrvgufwWa4sfWDtCoqqv
   aCBvJHZVf2usGF6ax/ovWd16l64cf3/+fLzlkfMSTwrPY3VarPsyk5BbW
   sF7BlQpyWAKVy6PcEkVcAMIoMcm1fwascu6Vh+3FJrkPQyuqMeF27k0AN
   Ij01Egmuk3zeJySki79yKnROk0Z+e/ljbjHouOtI9sDpyIsNlCv3mgaHi
   NNK69Y83QsF566ZaI4I5IM5e9NlU1CbiezW4Csov2ze4a7UCcnsnilQfV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="375605515"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="375605515"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 22:01:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="693356452"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="693356452"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 11 Sep 2023 22:01:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id 5AEF4248; Tue, 12 Sep 2023 08:01:45 +0300 (EEST)
Date: Tue, 12 Sep 2023 08:01:45 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH v3 4/4] platform/x86: intel_scu_ipc: Fail IPC send if
 still busy
Message-ID: <20230912050145.GC1599918@black.fi.intel.com>
References: <20230911193937.302552-1-swboyd@chromium.org>
 <20230911193937.302552-5-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230911193937.302552-5-swboyd@chromium.org>

On Mon, Sep 11, 2023 at 12:39:36PM -0700, Stephen Boyd wrote:
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
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
