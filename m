Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D482F26
	for <patches@lists.linux.dev>; Mon,  7 Feb 2022 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644261895; x=1675797895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YTkE16bRbtM/QCjMB4i8L08NqKl9kC1ypmwXVxbrkaI=;
  b=XcJHP2z7OgK+RBcvxibGtjdG7v9VKkfkk8WlOG8YZcMzj4sxlGq4/sDb
   tHtMuN3hUniqLzzW7HePndXuYO3YlT3WcChn6YknJ9GA2YgYmecorx7qF
   /rFN8JjKQ9QKG3WhxcMg+yfKxczhmCE4jx7StkezwctZ97QLnOLTzf3C0
   nbw3XDF5GbTc9eZVhy7Psdz0nv1/9ka3mV4Csr1oHJVrowNX+5dEZSv0E
   tdnTw34hkuGl6HhP8aPOVenDkJsXoWXGmja4lv8zxDxJOVATWJxzME3+H
   wEJhq1EMxmtI9/XemAXGDNNIvudNGP1yp1G7wCw7rog37xrOaZASvSWdu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248555718"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="248555718"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 11:24:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="525249808"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 11:24:54 -0800
Date: Mon, 7 Feb 2022 11:24:53 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jue Wang <juew@google.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <YgFyBRIOIquMI2ng@agluck-desk2.amr.corp.intel.com>
References: <20220207043640.2829295-1-juew@google.com>
 <YgFqiJOU5tZsHbY6@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgFqiJOU5tZsHbY6@zn.tnic>

On Mon, Feb 07, 2022 at 07:52:56PM +0100, Borislav Petkov wrote:
> And while you're working in Tony's request...
> 
> On Sun, Feb 06, 2022 at 08:36:40PM -0800, Jue Wang wrote:
> > diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> > index 5818b837fd4d..06001e3b2ff2 100644
> > --- a/arch/x86/kernel/cpu/mce/core.c
> > +++ b/arch/x86/kernel/cpu/mce/core.c
> > @@ -834,6 +834,57 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
> >  	m->cs = regs->cs;
> >  }
> >  
> > +static bool is_intel_srar(u64 mci_status)
> 
> You don't need this separate function - stick it all in quirk_skylake_repmov()

I suggested breaking it out as a helper to make the
code easier to read.

> 
> > +	return (mci_status &
> > +		(MCI_STATUS_VAL|MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN|
> > +		 MCI_STATUS_ADDRV|MCI_STATUS_MISCV|MCI_STATUS_PCC|
> > +		 MCI_STATUS_AR|MCI_STATUS_S)) ==
> > +		(MCI_STATUS_VAL|MCI_STATUS_UC|MCI_STATUS_EN|MCI_STATUS_ADDRV|
> > +		 MCI_STATUS_MISCV|MCI_STATUS_AR|MCI_STATUS_S);
> > +}
> > +
> > +/*
> > + * Disable fast string copy and return from the MCE handler upon the first SRAR
> > + * MCE on bank 1 due to a CPU erratum on Intel SKX/CLX/CPL CPUs.
> > + * The fast string copy instructions ("rep movs*") could consume an
> > + * uncorrectable memory error in the cache line _right after_ the
> > + * desired region to copy and raise an MCE with RIP pointing to the
> > + * instruction _after_ the "rep movs*".
> > + * This mitigation addresses the issue completely with the caveat of
> > + * performance degradation on the CPU affected. This is still better
> > + * than the OS crashes on MCEs raised on an irrelevant process due to
> > + * 'rep movs*' accesses in a kernel context (e.g., copy_page).
> > + * Since a host drain / fail-over usually starts right after the first
> > + * MCE is signaled, which results in VM migration or termination, the
> > + * performance degradation is a transient effect.
> > + *
> > + * Returns true when fast string copy on cpu should be disabled.
> > + */
> > +static bool quirk_skylake_repmov(void)
> > +{
> > +	/*
> > +	 * State that represents if an SRAR MCE has already signaled on the DCU bank.
> > +	 */
> > +	static DEFINE_PER_CPU(bool, srar_dcu_signaled);
> 
> What's that needed for?
> 
> If the MSR write below clears the CPUID bit, you clear the corresponding
> X86_FEATURE flag. And this test becomes a X86_FEATURE flag test:
> 
> 	if (this_cpu_has(X86_FEATURE_FSRM))

X86_FEATURE_FSRM is a different (but confusingly simlilar) feature.

The MSR is per-thread. So the write only disabled the fast string
operation on this one logical CPU. So the per-cpu srar_dcu_signaled
variable is just to avoid getting into a loop when this #MC isn't
because of a REP MOVS peeking at things it shouldn't.

> 
> I'd guess...
> 
> > +	if (unlikely(!__this_cpu_read(srar_dcu_signaled))) {
> > +		u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
> > +
> > +		if (is_intel_srar(mc1_status)) {
> > +			__this_cpu_write(srar_dcu_signaled, true);
> > +			msr_clear_bit(MSR_IA32_MISC_ENABLE,
> > +				      MSR_IA32_MISC_ENABLE_FAST_STRING_BIT);
> > +			mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
> > +			mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
> > +			pr_err("First SRAR MCE on DCU, CPU: %d, disable fast string copy.\n",
> 
> That error message can be understood probably only by a handful dozen of
> people on the planet. Is it write-only or is it supposed to be consumed
> by humans and if so, what would be the use case?

Maybe this would be more human friendly?

		pr_err("CPU%d: Performance now degraded after applying machine check workaround\n",
			smp_processor_id());

-Tony
