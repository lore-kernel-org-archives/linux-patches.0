Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB08C11;
	Fri, 13 Sep 2024 19:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726256518; cv=none; b=SeIWtJv2x9hN+UHkSukDG+eXaAVR5Gf1CqZSieR7CMz+YNkWhPJ/Kop0RzZ/7zEcXv0cWE2dGgYDnA46qOtv5wKFoBs5J4WPpVKZ/cWZQ3TDmQmMhWwb7X6RMRvBJ3OUiKqf8i3bGKTrBdxacGW4VyA73LjUFt0eJadPAvOMEbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726256518; c=relaxed/simple;
	bh=X+xZJ2B1YUnFcRBHyymTV8kCYmdbI++oeoXCPuXzbE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6/IWM+9Y4wncLU/N1Yvr7apFzuiz6BeNV1qpHXBM0Z6zF3pOYbuRmh3LExUclMJ0eI5QIsK9bmTq2KAi2i67BhcWVNHXAyhR0UTKLr6tO177D/CLDvhz57SotDZ35dHwEOr+Yh6mJZVvUHeUehKCXdKnzHX2Ozv8Q7W3s1ymDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CigS4wlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CigS4wlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C925FC4CEC0;
	Fri, 13 Sep 2024 19:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726256517;
	bh=X+xZJ2B1YUnFcRBHyymTV8kCYmdbI++oeoXCPuXzbE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CigS4wlK3LvsDZEyxmTriGbXUjclLDRPo5W5zGCErZrbxK+KrgH2d2VYHjnKtUtFg
	 oNhPsilD2qVU0XIlEUi10mIXwPJ7bbJup1RalMOVRP5xag/sd9sq3jPIodN5pFWp1d
	 YFsOahGiYhlCh2/uTCWbl43E1T7y5uO1CGmlgIDwuyrYjOxI8nfED6rP5ABGGIvMq5
	 eQXcytyQ2C0DN6S87zR5aZw3EKwJixeCHjb1Un8PNPTuGsOZNySAvLQkKUyTmRUbac
	 47F49x2Vet8SZ17H3ATPfzE8OQcU4PcAjuCPBGe3ow8cqwYyWRO4aMroeOu29ODsW6
	 aSi/kmZ3NOnJQ==
Date: Fri, 13 Sep 2024 12:41:55 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/resctrl: Annotate __get_mem_config_intel() as __init
Message-ID: <20240913194155.GA4188687@thelio-3990X>
References: <20240822-x86-restctrl-get_mem_config_intel-init-v1-1-8b0a68a8731a@kernel.org>
 <fc49e252-6283-4a37-b4e8-bd329f326e68@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc49e252-6283-4a37-b4e8-bd329f326e68@intel.com>

Hi Reinette,

On Thu, Sep 12, 2024 at 03:33:09PM -0700, Reinette Chatre wrote:
> Apologies for the delay.

No worries, this is not super high priority (except when the section
mismatch warning is elevated to an error but that does not happen in too
many real world configurations).

> On 8/22/24 5:12 PM, Nathan Chancellor wrote:
> > After a recent LLVM change [1] that deduces __cold on functions that
> > only call cold code (such as __init functions), there is a section
> > mismatch warning from __get_mem_config_intel(), which got moved to
> > .text.unlikely. as a result of that optimization:
> > 
> >    WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
> > 
> > Mark __get_mem_config_intel() as __init as well since it is only called
> > from __init code, which clears up the warning.
> 
> It looks to me as though __rdt_get_mem_config_amd() may need the same __init
> treatment

It certainly looks like __init would be appropriate for
__rdt_get_mem_config_amd(), although there is no current risk of a
modpost warning like __get_mem_config_intel() because it does not call
any __init functions, which is really what triggered this warning.

> it is not clear to me why __get_mem_config_intel() would trigger
> such warning, but not __rdt_get_mem_config_amd()?

Based on my understanding of the LLVM change linked below my comment
here, __get_mem_config_intel() gets implicitly marked as __cold because
it unconditionally calls thread_throttle_mode_init(), which is __cold
through __init. If __get_mem_config_intel() does not get inlined into
its caller (which could happen if a compiler decides not to optimize
__cold code), that call to thread_throttle_mode_init() will appear to
come from the .text section, even though it will really be from
.init.text because __get_mem_config_intel() is only called from __init
functions.

__rdt_get_mem_config_amd() does not call any cold functions so it avoids
this problem altogether.

I can send a v2 with __init added to __rdt_get_mem_config_amd() if you
want, along with the style update you mention below. Just let me know
what you prefer based on my comments above.

Cheers,
Nathan

> > Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >   arch/x86/kernel/cpu/resctrl/core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 1930fce9dfe9..b28646f1d9d6 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -199,7 +199,7 @@ static inline bool rdt_get_mb_table(struct rdt_resource *r)
> >   	return false;
> >   }
> > -static bool __get_mem_config_intel(struct rdt_resource *r)
> > +static bool __init __get_mem_config_intel(struct rdt_resource *r)
> 
> Surely resctrl is not consistent in this regard but I understand from the coding style
> doc that storage class should precede the return type, so perhaps:
> 	static __init bool __get_mem_config_intel(struct rdt_resource *r)
> 
> We may need to follow this recommended style for this to be included.
> 
> >   {
> >   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> >   	union cpuid_0x10_3_eax eax;
> > 
> > ---
> > base-commit: 7424fc6b86c8980a87169e005f5cd4438d18efe6
> > change-id: 20240822-x86-restctrl-get_mem_config_intel-init-3af02a5130ba
> > 
> > Best regards,
> 
> Thank you very much.
> 
> Reinette
