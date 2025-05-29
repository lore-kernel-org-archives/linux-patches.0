Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB82550D0;
	Thu, 29 May 2025 06:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748500454; cv=none; b=NUCmJ4MTXJSXfjLeuODuIfVCgmDpJhyMWsKX+X7UG/Or42lbSPKDUr6ymZmKmnJ9leju1Me8DDUiAOl4Q5aoc5mywEZQX7Ere0a2c2fBa/NJeX9URJnrTusmTkeCeM/bd7gO+Wo/khzuOm/+2aJemX7fETD+sHiWtVjHBhAt7q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748500454; c=relaxed/simple;
	bh=jPXnV/GmrjuvGJ+yT7bOTWgocTVuwOXAwKsmzosSDgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IBW9e2m8/ZeK4f10BPPvR+71aN7igS52aaglKF7Hl/eWTvtjZNxMvCH7DP6b1oZuBzX30sNYSaLYfM1FTnQdCYFryBxmdvtzRTEs5+7nhwtfT+FrVz4mJDnqyHuXvdZeD9HVUHCKdd9vm8o6uniLy+dYSTM0/4YhM56vgGhGSV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygbW36zM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygbW36zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B35EC4CEEA;
	Thu, 29 May 2025 06:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748500454;
	bh=jPXnV/GmrjuvGJ+yT7bOTWgocTVuwOXAwKsmzosSDgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ygbW36zMZzJvQHb4nesmpWDtGVwsayeKkusn4zQXt9mXfHYoOuDhVQ660kKAhAloX
	 RVMY+n/hM6AwWyMUS3hM9PjNw6q/gTwtUMZUnlfgcnxLJLl+TIr9fLO0AUWz0qQXcf
	 kXt6rnxFXD6c5RRISw7ze8Cdmif7y1TdF/8OboI0=
Date: Thu, 29 May 2025 08:34:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 426/783] x86/boot: Disable stack protector for early
 boot code
Message-ID: <2025052945-squabble-romp-6304@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162530.470565771@linuxfoundation.org>
 <CAMzpN2hwSXUybfvcas2X5213V=Ow+nqGqqurC_tjfCdb44aFfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMzpN2hwSXUybfvcas2X5213V=Ow+nqGqqurC_tjfCdb44aFfg@mail.gmail.com>

On Wed, May 28, 2025 at 01:52:16PM -0400, Brian Gerst wrote:
> On Tue, May 27, 2025 at 1:39 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Brian Gerst <brgerst@gmail.com>
> >
> > [ Upstream commit a9a76b38aaf577887103e3ebb41d70e6aa5a4b19 ]
> >
> > On 64-bit, this will prevent crashes when the canary access is changed
> > from %gs:40 to %gs:__stack_chk_guard(%rip).  RIP-relative addresses from
> > the identity-mapped early boot code will target the wrong address with
> > zero-based percpu.  KASLR could then shift that address to an unmapped
> > page causing a crash on boot.
> >
> > This early boot code runs well before user-space is active and does not
> > need stack protector enabled.
> >
> > Signed-off-by: Brian Gerst <brgerst@gmail.com>
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Link: https://lore.kernel.org/r/20250123190747.745588-4-brgerst@gmail.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/x86/kernel/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index b43eb7e384eba..84cfa179802c3 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -44,6 +44,8 @@ KCOV_INSTRUMENT_unwind_orc.o                          := n
> >  KCOV_INSTRUMENT_unwind_frame.o                         := n
> >  KCOV_INSTRUMENT_unwind_guess.o                         := n
> >
> > +CFLAGS_head32.o := -fno-stack-protector
> > +CFLAGS_head64.o := -fno-stack-protector
> >  CFLAGS_irq.o := -I $(src)/../include/asm/trace
> >
> >  obj-y                  += head_$(BITS).o
> > --
> > 2.39.5
> >
> >
> >
> 
> This doesn't need to be backported.  It's harmless, but not necessary
> without the rest of the stack protector changes.

What specific changes?  I see stackprotector code in this, and the 6.12
tree, so what commit id does this "fix"?

thanks,

greg k-h
