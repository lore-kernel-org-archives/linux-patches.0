Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20521EF0BB;
	Thu, 29 May 2025 07:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748505359; cv=none; b=mss3ZY2qjbUMhdcPYCSeT+6rfa7WEzkZQuke6xJtlO0LgHKbl+N4IyopcLxb+sfpuyFCuEdb/SRv3biOt7sfxSiBFdLSwvrqA4AU8125bJ4+R6HYQ0rJ3wmr7wjZ/W+QlMONFh1h7m/oxmufi65js584jcDpr8OuI51u9PTCicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748505359; c=relaxed/simple;
	bh=M1lYqml+OyELSjDi4T5mXAOPoDVNUs5tFw7Ug7Aq1R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAAZ+N/TfyLOrqY7Iyvv2scTnZrWuTdRNPc798fc3SiOLc2k0Uq4A/nSYkIFyAtNOLGZnnjQsADIemijMC3qd4/hfYk7pbbpikffw0F7z5U/Vlv7Ftjs36Bd2JLmHxK8XdmVtl7mXHuJpqql9dZBHmvZ2IIq7/I/QIIHwRAPlhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7QPY3vY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7QPY3vY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEEFC4CEE7;
	Thu, 29 May 2025 07:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748505359;
	bh=M1lYqml+OyELSjDi4T5mXAOPoDVNUs5tFw7Ug7Aq1R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N7QPY3vYl6/0JrvqhiiBu+03N6ar178+WdTcsr8l62fvRAFo1T3ej4TfwnwHxX6Ad
	 4wxIzNzz8kayfr99MU+xlRlz8NVwykfn3DXnF1KlvdywGLrnsv5qEfADGFTEqU4eOz
	 RBQlR5owkPAn5Mnyn5DJT9SbL4jsLvgVcnQ+wZtc=
Date: Thu, 29 May 2025 09:55:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 426/783] x86/boot: Disable stack protector for early
 boot code
Message-ID: <2025052912-snorkel-importer-1299@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162530.470565771@linuxfoundation.org>
 <CAMzpN2hwSXUybfvcas2X5213V=Ow+nqGqqurC_tjfCdb44aFfg@mail.gmail.com>
 <2025052945-squabble-romp-6304@gregkh>
 <CAMj1kXFCQ=q3O043q_Ub8aABHf5E31QrqmqJ3iYCCeLkx37pwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXFCQ=q3O043q_Ub8aABHf5E31QrqmqJ3iYCCeLkx37pwA@mail.gmail.com>

On Thu, May 29, 2025 at 08:59:37AM +0200, Ard Biesheuvel wrote:
> On Thu, 29 May 2025 at 08:34, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, May 28, 2025 at 01:52:16PM -0400, Brian Gerst wrote:
> > > On Tue, May 27, 2025 at 1:39 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Brian Gerst <brgerst@gmail.com>
> > > >
> > > > [ Upstream commit a9a76b38aaf577887103e3ebb41d70e6aa5a4b19 ]
> > > >
> > > > On 64-bit, this will prevent crashes when the canary access is changed
> > > > from %gs:40 to %gs:__stack_chk_guard(%rip).  RIP-relative addresses from
> > > > the identity-mapped early boot code will target the wrong address with
> > > > zero-based percpu.  KASLR could then shift that address to an unmapped
> > > > page causing a crash on boot.
> > > >
> > > > This early boot code runs well before user-space is active and does not
> > > > need stack protector enabled.
> > > >
> > > > Signed-off-by: Brian Gerst <brgerst@gmail.com>
> > > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > > > Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> > > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Link: https://lore.kernel.org/r/20250123190747.745588-4-brgerst@gmail.com
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  arch/x86/kernel/Makefile | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > > > index b43eb7e384eba..84cfa179802c3 100644
> > > > --- a/arch/x86/kernel/Makefile
> > > > +++ b/arch/x86/kernel/Makefile
> > > > @@ -44,6 +44,8 @@ KCOV_INSTRUMENT_unwind_orc.o                          := n
> > > >  KCOV_INSTRUMENT_unwind_frame.o                         := n
> > > >  KCOV_INSTRUMENT_unwind_guess.o                         := n
> > > >
> > > > +CFLAGS_head32.o := -fno-stack-protector
> > > > +CFLAGS_head64.o := -fno-stack-protector
> > > >  CFLAGS_irq.o := -I $(src)/../include/asm/trace
> > > >
> > > >  obj-y                  += head_$(BITS).o
> > > > --
> > > > 2.39.5
> > > >
> > > >
> > > >
> > >
> > > This doesn't need to be backported.  It's harmless, but not necessary
> > > without the rest of the stack protector changes.
> >
> > What specific changes?  I see stackprotector code in this, and the 6.12
> > tree, so what commit id does this "fix"?
> >
> 
> It does not fix anything. I already raised this with Sasha in response
> to one of his AUTOSEL spam bombs. [0]

That one was dropped, eventually, thanks.

> The first patch of the series in question bumped the minimum GCC
> version from 5.x to 8.1, so I am pretty sure it is out of scope for
> -stable.

Yes.

> Please stop backporting random shit via AUTOSEL. You keep saying that
> developers who don't care about -stable won't have to, but we are the
> ones having to make sense of the mess you have created when AUTOSEL
> picks one or two random changes out of a larger series. I don't think
> AUTOSEL should be used at all until we find a solution to that
> problem.

The "problem" is that AUTOSEL finds a LOT of real fixes that are needed
that no one has tagged for backporting.  So unless we have all
maintainers remember to properly tag patches, it's solving a real
issue (i.e. fixes in newer kernel releases for user-visable security and
"normal" bugs).

AUTOSEL has now been tweaked to describe _why_ it thinks the patch
should be backported, and that's in the email that is sent out.  See the
recent series that was sent yesterday for examples:
	https://lore.kernel.org/all/20250528215637.1983842-2-sashal@kernel.org/

And again, as always, if you do NOT want your subsystem or any specific
files to be considered by AUTOSEL, just let Sasha know and we will add
them to the "ignore" list.

thanks,

greg k-h
