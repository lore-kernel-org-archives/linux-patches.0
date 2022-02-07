Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDCC2C80
	for <patches@lists.linux.dev>; Mon,  7 Feb 2022 18:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644258224; x=1675794224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iEthWzhLhgfla9mBgcMk3I3im8SSm2ybD3uCeC+OHOg=;
  b=ULX3gBPW1NhRz2pyeCAdOfYrfAI/UaOiLYGMcPJvGHP8j/RR9/CNANz4
   3ooOEPe5F+Peq/Cr2qZi2w3pyNFW3JXtVUUEwASpRws8FxDu/zG6+9eAo
   umlBXROAPBCZUBz/ZkZMYO/P2scypfMQ/s5qMAU1fOhXn0Hte5R76o1Kn
   w3HPgIkifimonTh2mwlvLOFa/wClRtKdW0Ixm+d0rMWmvmjYQKsBp0apP
   RWEnBPzKU26E16cjGRzKF8XnIvX9HeRhSyQIpJXkN1U97ADLN7wKOzxoO
   eG5eVTgIyMYtR+9Qu5d3bRUeVTY5yJTJiun9rAFcqbd9ohM+R827UiJ65
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10250"; a="312077411"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="312077411"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 10:23:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="484514992"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 10:23:43 -0800
Date: Mon, 7 Feb 2022 10:23:42 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Jue Wang <juew@google.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <YgFjrmFuc/b+0OCE@agluck-desk2.amr.corp.intel.com>
References: <20220207043640.2829295-1-juew@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207043640.2829295-1-juew@google.com>

On Sun, Feb 06, 2022 at 08:36:40PM -0800, Jue Wang wrote:
> +static bool quirk_skylake_repmov(void)
> +{
> +	/*
> +	 * State that represents if an SRAR MCE has already signaled on the DCU bank.
> +	 */
> +	static DEFINE_PER_CPU(bool, srar_dcu_signaled);
> +
> +	if (unlikely(!__this_cpu_read(srar_dcu_signaled))) {
> +		u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));

Jue,

When I reviewed this for you off-list, I didn't notice that you
dropped the test for mcgstatus & MCG_STATUS_LMCES as part of
moving to a helper function and expanding the test for more
bits in mc1_status.

I think that test still is still important ... knowing that this is
a *local* machine check before making decision based on just what this
CPU observes makes this a bit more robust.

> +
> +		if (is_intel_srar(mc1_status)) {
> +			__this_cpu_write(srar_dcu_signaled, true);
> +			msr_clear_bit(MSR_IA32_MISC_ENABLE,
> +				      MSR_IA32_MISC_ENABLE_FAST_STRING_BIT);
> +			mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
> +			mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
> +			pr_err("First SRAR MCE on DCU, CPU: %d, disable fast string copy.\n",
> +			       smp_processor_id());
> +			return true;
> +		}
> +	}
> +	return false;
> +}

-Tony
