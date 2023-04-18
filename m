Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15718AFC3
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681842241; x=1713378241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pRPyD6+WTQL2wAAqK/kit61fm9+alLRGx6xYjjpFuI8=;
  b=YHUFm72uo4+wW98yg4dG/PLgkJ12ZS7xLu1Lu4sXZ/xgKZWLQA5QJbHW
   DyzCFLRfKJ9keDLtZhEmvnKSOb7yG10AsetN3ngS5MAEMe88mzRCId7Pi
   fGS6xzXF4FDRBVjwseYf9pMaI+Radc8tKvl5C4VKX4ZiogK1VI1KtjsYx
   uUwmv20EoJRKbeSyA+FV7Ec0wn0/clxhHD9jV8JB2ffJiic72Fq5ftjt2
   oiRLqO6YZkdGD8Ljngt6fZFhVmC6qtMb8bNUmBV1CxAoaWhnkhesRleUR
   7dud4DmrBeLN09rqDlp0lRJVA9f2CMCBD3vBWI1rMfV6/3qYQMiU8oSPo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="325587924"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="325587924"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 11:24:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="684696494"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="684696494"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 11:24:00 -0700
Date: Tue, 18 Apr 2023 11:23:58 -0700
From: Tony Luck <tony.luck@intel.com>
To: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/mce: Check that memory address is usable for recovery
Message-ID: <ZD7gPkfWQeEeEfBe@agluck-desk3.sc.intel.com>
References: <20230322005131.174499-1-tony.luck@intel.com>
 <a5d0c575-ba4f-1120-c7ee-bc37e8d40402@amd.com>
 <ZD7TBZex278dSYmc@agluck-desk3.sc.intel.com>
 <5f833d37-e961-73c4-3629-74884e8b6c59@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f833d37-e961-73c4-3629-74884e8b6c59@amd.com>

On Tue, Apr 18, 2023 at 01:51:37PM -0400, Yazen Ghannam wrote:
> I agree. And I think all these checks should be baked into the severity.
> We'll need additional, fine-grained severity levels though.
> 
> The "m.cs" and "m.kflags" checks could also be baked in.
> 
> Instead of just one AR severity:
> 	...
> 	MCE_AR_SEVERITY,
> 	MCE_PANIC_SEVERITY,
> 
> replace it with specific cases:
> 	...
> 	MCE_AR_USER_RECOV,
> 	MCE_AR_USER_KILL,
> 	MCE_AR_KERNEL_COPYIN,
> 	MCE_AR_KERNEL_RECOV,
> 	MCE_PANIC_SEVERITY,
> 
> Then the #MC handler can look like this:
> 
> 	if (worst < MCE_AR_USER_RECOV)
> 		goto out;
> 
> 	if (severity == MCE_AR_USER_RECOV)
> 		queue_task_work(&m, msg, kill_me_maybe);
> 
> 	if (severity == MCE_AR_USER_KILL)
> 		force_sig(SIGBUS);
> 
> 	if (severity == MCE_AR_KERNEL_COPYIN)
> 		queue_task_work(&m, msg, kill_me_never);
> 	
> 	if (severity == MCE_AR_KERNEL_RECOV) {
> 		if (!fixup_exception(regs, X86_TRAP_MC, 0, 0))
> 			mce_panic("Failed kernel mode recovery");
> 	}
> 
> I can take a shot at this if it seems reasonable.

That looks much cleaner. There may be some extra MCE_AR_KERNEL* options
in the future (I'd like someday to address COPYOUT when the corrupt
kernel data is in the page cache). But I don't think the number of cases
is going to explode into dozens of cases.

> What do you think?

Brave person ... you are going to have to tinker with
arch/x86/kernel/cpu/mce/severity.c !  Good luck.

-Tony
