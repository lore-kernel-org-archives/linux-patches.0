Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616077C
	for <patches@lists.linux.dev>; Tue, 15 Feb 2022 18:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644950564; x=1676486564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uq3mK2F4oBeJy49d6SR0mO9NdzovVt3JSrPgHEwNGYw=;
  b=hhigIk69JGLjRCDAHE7v/kEOZ7sVRSC/hx1fsu8IgUVJySdgA9RylvxY
   RTMz5XK4Cbfwc/s0Oo90/t4h+l8AyeKmMsiJtqf9cm0sPosA8xm0gsVBX
   7L0QJKbfkTY9WlGNJ8QBZvNSxE9pM/n/H4m98tdG8m7NobRroi7NCYJfP
   v3U3EYCFvzuqkGe40g8B1O4NqMhiZRkHXVenklyh/Ni4dt4LMGc4XZADt
   ZvOzEXRnTprMzLVjVrIlIovpG6H/CSmYkt4mXHqgNwdT3cW4Bq/z7Mtns
   iMKAKL+taeDnE9cnfg/XwcX516GH0N/7XO6Hv1KizL3KDuufLNd3gfJMd
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275003578"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="275003578"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 10:42:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="624957742"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 10:42:43 -0800
Date: Tue, 15 Feb 2022 10:42:42 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Jue Wang <juew@google.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <Ygv0IncyBA3pXR7Q@agluck-desk3.sc.intel.com>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208150945.266978-1-juew@google.com>

On Tue, Feb 08, 2022 at 07:09:45AM -0800, Jue Wang wrote:
> +static bool quirk_skylake_repmov(void)
> +{
> +	u64 mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
> +	u64 misc_enable = __rdmsr(MSR_IA32_MISC_ENABLE);
> +
> +	if ((mcgstatus & MCG_STATUS_LMCES) &&
> +	    unlikely(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
> +		u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
> +

Needs a comment that this big blob of logic is checking for a software
recoverable data fetch error.

> +		if ((mc1_status &
> +		     (MCI_STATUS_VAL|MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN|
> +		      MCI_STATUS_ADDRV|MCI_STATUS_MISCV|MCI_STATUS_PCC|
> +		      MCI_STATUS_AR|MCI_STATUS_S)) ==
> +		    (MCI_STATUS_VAL|MCI_STATUS_UC|MCI_STATUS_EN|MCI_STATUS_ADDRV|
> +		     MCI_STATUS_MISCV|MCI_STATUS_AR|MCI_STATUS_S)) {
> +			msr_clear_bit(MSR_IA32_MISC_ENABLE,
> +				      MSR_IA32_MISC_ENABLE_FAST_STRING_BIT);
> +			mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
> +			mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
> +			pr_err_once("Errata detected, disable fast string copy instructions.\n");
> +			return true;
> +		}
> +	}
> +	return false;
> +}

Otherwise:

Reviewed-by: Tony Luck <tony.luck@intel.com>

-Tony
