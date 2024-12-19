Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988C2AD16;
	Thu, 19 Dec 2024 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734622824; cv=none; b=qhkHxazqhtllYBKwxKaFJgbiDKV+URMCMd5INLylzO+u/NCFFd3TuaCpNHHGom43k7QhCtAg6RMFzeP2rbQd5uetw4XqkOYuXtCHt37EbrkliPfHMA3yD/JfZOrNh9ZtOwsrQ+N+ZonkQuPFTAOZX5dql/tKmOrGyD8/b+HbSfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734622824; c=relaxed/simple;
	bh=hiyLSIy0R+lLjGHumh91w/ETdsFIyMu5MGQ0JGWj1+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+zwHiZGZQkOYoXEbTvIZr91106nYe//1+1tpMH0uGGK41MX5IgDCS4e1SAxAEiDkJFOB4pP2OELW9pvljaxOt2LTnw1/j029r6VRK4TQQhX4/IRYPP1pV4tBi3C1xXf5r21OxNOw5PnbpYn4ABxDxTzUtZjzNBZs+ID3HryAtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RihPjXsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RihPjXsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3070FC4CECE;
	Thu, 19 Dec 2024 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734622823;
	bh=hiyLSIy0R+lLjGHumh91w/ETdsFIyMu5MGQ0JGWj1+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RihPjXsCwGBJ6jahQSq44EeOy1cyJOLtMBltr0ZxIVdXj9VgFXcQBAYy+17rNhdwP
	 glS5mwu6IMXUksc0eFvbbzgkm8o6JFoZJPY1QGGpQDyn9vVYqYyE+BdgV/2r5FYpu9
	 /pz9XM4EpWn6dEDf01pTq3GrdeHN0n2XDfBTs/WU=
Date: Thu, 19 Dec 2024 16:40:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 6.12 168/172] x86/static-call: provide a way to do very
 early static-call updates
Message-ID: <2024121906-chubby-bobcat-132f@gregkh>
References: <20241217170546.209657098@linuxfoundation.org>
 <20241217170553.299136607@linuxfoundation.org>
 <bf593d44-c59e-4158-b2c6-112372ab45d1@kernel.org>
 <aec47f97-c59b-403a-bf2a-d8551e2ec6f9@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec47f97-c59b-403a-bf2a-d8551e2ec6f9@suse.com>

On Wed, Dec 18, 2024 at 09:53:24AM +0100, Jürgen Groß wrote:
> On 18.12.24 09:37, Jiri Slaby wrote:
> > On 17. 12. 24, 18:08, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Juergen Gross <jgross@suse.com>
> > > 
> > > commit 0ef8047b737d7480a5d4c46d956e97c190f13050 upstream.
> > > 
> > > Add static_call_update_early() for updating static-call targets in
> > > very early boot.
> > > 
> > > This will be needed for support of Xen guest type specific hypercall
> > > functions.
> > > 
> > > This is part of XSA-466 / CVE-2024-53241.
> > > 
> > > Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
> > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > Co-developed-by: Peter Zijlstra <peterz@infradead.org>
> > > Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   arch/x86/include/asm/static_call.h |   15 +++++++++++++++
> > >   arch/x86/include/asm/sync_core.h   |    6 +++---
> > >   arch/x86/kernel/static_call.c      |    9 +++++++++
> > >   include/linux/compiler.h           |   37 ++++++++++++++++++++++++++-----------
> > >   include/linux/static_call.h        |    1 +
> > >   kernel/static_call_inline.c        |    2 +-
> > >   6 files changed, 55 insertions(+), 15 deletions(-)
> > > 
> > > --- a/arch/x86/include/asm/static_call.h
> > > +++ b/arch/x86/include/asm/static_call.h
> > > @@ -65,4 +65,19 @@
> > >   extern bool __static_call_fixup(void *tramp, u8 op, void *dest);
> > > +extern void __static_call_update_early(void *tramp, void *func);
> > > +
> > > +#define static_call_update_early(name, _func)                \
> > > +({                                    \
> > > +    typeof(&STATIC_CALL_TRAMP(name)) __F = (_func);            \
> > > +    if (static_call_initialized) {                    \
> > > +        __static_call_update(&STATIC_CALL_KEY(name),        \
> > > +                     STATIC_CALL_TRAMP_ADDR(name), __F);\
> > > +    } else {                            \
> > > +        WRITE_ONCE(STATIC_CALL_KEY(name).func, _func);        \
> > > +        __static_call_update_early(STATIC_CALL_TRAMP_ADDR(name),\
> > > +                       __F);            \
> > > +    }                                \
> > > +})
> > ...
> > > --- a/kernel/static_call_inline.c
> > > +++ b/kernel/static_call_inline.c
> > > @@ -15,7 +15,7 @@ extern struct static_call_site __start_s
> > >   extern struct static_call_tramp_key __start_static_call_tramp_key[],
> > >                       __stop_static_call_tramp_key[];
> > > -static int static_call_initialized;
> > > +int static_call_initialized;
> > 
> > This breaks the build on i386:
> > > ld: arch/x86/xen/enlighten.o: in function `__xen_hypercall_setfunc':
> > > enlighten.c:(.noinstr.text+0x2a): undefined reference to
> > > `static_call_initialized'
> > > ld: enlighten.c:(.noinstr.text+0x62): undefined reference to
> > > `static_call_initialized'
> > > ld: arch/x86/kernel/static_call.o: in function `__static_call_update_early':
> > > static_call.c:(.noinstr.text+0x15): undefined reference to
> > > `static_call_initialized'
> > 
> > kernel/static_call_inline.c containing this `static_call_initialized` is
> > not built there as:
> > HAVE_STATIC_CALL_INLINE=n
> >   -> HAVE_OBJTOOL=n
> >      -> X86_64=n
> > 
> > This is broken in upstream too.
> 
> I've sent a fix already:
> 
> https://lore.kernel.org/lkml/20241218080228.9742-1-jgross@suse.com/T/#u

Thanks, I'll go queue that up (after fixing it up for the different
branches...)

greg k-h
