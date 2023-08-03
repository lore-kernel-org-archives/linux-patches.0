Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019ED63BC;
	Thu,  3 Aug 2023 18:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B82C433C8;
	Thu,  3 Aug 2023 18:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691089040;
	bh=nN9RdtMuoDd4BD4OQl9XyjQwduTf3ta0lGqm9Vxh4KQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HPYn2pVmAphcPEpAJXGdDTYA7do39vTJQkvqiYp2ELqMboQWxzOh3k0BCIjEuVzgV
	 FmPGXmWBa31A1Z4bJTbmDiCqpP3YcREdbLhOYpFFkKYoxUHHMBfOfnLsUCpiHIMNJ4
	 +/kvP4uVanX5VWycEZKyKXHe+HeT5bHpOd7ezDOZk++i9WezxeHRuq40IiQf9xmHVK
	 /fZAwmWqvpXzWiPjYmEStznNW1PjK6iJbFzFt+M4qMDA2BuGP526VQ4NYMwCRiISnx
	 ABfjTKjurAmj5+njMsYMmkJfL19g4YbZM3a48pHf4S1ZBF+yI6rQze/ve9+3T5kISM
	 /annht/cjjyZw==
Date: Thu, 3 Aug 2023 11:57:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, samitolvanen@google.com,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] mISDN: Update parameter type of dsp_cmx_send()
Message-ID: <20230803185718.GA2864317@dev-arch.thelio-3990X>
References: <20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org>
 <202308021255.9A6328D@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202308021255.9A6328D@keescook>

On Wed, Aug 02, 2023 at 12:59:12PM -0700, Kees Cook wrote:
> On Wed, Aug 02, 2023 at 10:40:29AM -0700, Nathan Chancellor wrote:
> > When booting a kernel with CONFIG_MISDN_DSP=y and CONFIG_CFI_CLANG=y,
> > there is a failure when dsp_cmx_send() is called indirectly from
> > call_timer_fn():
> > 
> >   [    0.371412] CFI failure at call_timer_fn+0x2f/0x150 (target: dsp_cmx_send+0x0/0x530; expected type: 0x92ada1e9)
> > 
> > The function pointer prototype that call_timer_fn() expects is
> > 
> >   void (*fn)(struct timer_list *)
> > 
> > whereas dsp_cmx_send() has a parameter type of 'void *', which causes
> > the control flow integrity checks to fail because the parameter types do
> > not match.
> > 
> > Change dsp_cmx_send()'s parameter type to be 'struct timer_list' to
> > match the expected prototype. The argument is unused anyways, so this
> > has no functional change, aside from avoiding the CFI failure.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202308020936.58787e6c-oliver.sang@intel.com
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > I am not sure if there is an appropriate fixes tag for this, I see this
> > area was modified by commit e313ac12eb13 ("mISDN: Convert timers to use
> > timer_setup()") but I don't think it was the original source of the
> > issue. It could also be commit cf68fffb66d6 ("add support for Clang
> > CFI") but I think that just exposes the problem/makes it fatal.
> 
> Oh man. I missed one! How did I miss that one? I think "Fixes:
> e313ac12eb13" is the most correct. That was the patch that went through
> trying to fix all the prototypes, and _did_ fix all the _other_ prototypes
> in there.

Sounds reasonable to me. netdev folks, if you intend to take this, do
you want a v2 or can you pick it up with

Fixes: e313ac12eb13 ("mISDN: Convert timers to use timer_setup()")

added on top?

> Thanks for the patch!
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> > 
> > Also not sure who should take this or how soon it should go in, I'll let
> > that to maintainers to figure out :)
> 
> If no one speaks up, I'll snag it, but since this got aimed at netdev, I
> suspect someone may pick it up. :)

Sounds good, I do see it in the netdev patchwork, so we can watch it at
least.

Cheers,
Nathan
