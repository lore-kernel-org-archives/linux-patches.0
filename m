Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817B0F516
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 06:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGRsTNvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F2AC433C8;
	Wed, 25 Oct 2023 06:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698213772;
	bh=BWocz7wrPKfbnq2oxxVcy2MLgNDyj+rVF5RLJ++1qAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hGRsTNvrheqr9/y9+LX+Lug/6SxLN+Yehvo7HT+qzS08HknJDHmhgjZzFy/j+xr6G
	 1Oa7Y8zvSKR8OaTkC+U0n2485v4Il00CRpz58Zo0FDNv9SJneVmuDmsDx+dXG1+gW3
	 1VIeWTcsD6UnXTq8qhyR72aO8dUDmXApr7WbuFfE=
Date: Wed, 25 Oct 2023 08:02:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: John Sperbeck <jsperbeck@google.com>
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev,
	peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 134/135] objtool/x86: Fixup frame-pointer vs rethunk
Message-ID: <2023102503-anteater-renderer-d02e@gregkh>
References: <20230824170617.074557800@linuxfoundation.org>
 <20230824170623.040455914@linuxfoundation.org>
 <2023102428-implicate-predict-0966@gregkh>
 <CAFNjLiWdyUzFpSSpfoPBjGRB4Eyhr=NH4TG0M0sydHTcUwvpxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFNjLiWdyUzFpSSpfoPBjGRB4Eyhr=NH4TG0M0sydHTcUwvpxg@mail.gmail.com>

On Tue, Oct 24, 2023 at 10:16:18PM -0700, John Sperbeck wrote:
> On Tue, Oct 24, 2023 at 11:12 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Oct 24, 2023 at 05:47:54PM +0000, John Sperbeck wrote:
> > > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Peter Zijlstra <peterz@infradead.org>
> > > >
> > > > commit dbf46008775516f7f25c95b7760041c286299783 upstream.
> > > >
> > > > For stack-validation of a frame-pointer build, objtool validates that
> > > > every CALL instruction is preceded by a frame-setup. The new SRSO
> > > > return thunks violate this with their RSB stuffing trickery.
> > > >
> > > > Extend the __fentry__ exception to also cover the embedded_insn case
> > > > used for this. This cures:
> > > >
> > > >   vmlinux.o: warning: objtool: srso_untrain_ret+0xd: call without frame pointer save/setup
> > > >
> > > > Fixes: 4ae68b26c3ab ("objtool/x86: Fix SRSO mess")
> > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> > > > Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > > Link: https://lore.kernel.org/r/20230816115921.GH980931@hirez.programming.kicks-ass.net
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  tools/objtool/check.c |   17 +++++++++++------
> > > >  1 file changed, 11 insertions(+), 6 deletions(-)
> > > >
> > > > --- a/tools/objtool/check.c
> > > > +++ b/tools/objtool/check.c
> > > > @@ -2079,12 +2079,17 @@ static int decode_sections(struct objtoo
> > > >     return 0;
> > > >  }
> > > >
> > > > -static bool is_fentry_call(struct instruction *insn)
> > > > +static bool is_special_call(struct instruction *insn)
> > > >  {
> > > > -   if (insn->type == INSN_CALL &&
> > > > -       insn->call_dest &&
> > > > -       insn->call_dest->fentry)
> > > > -           return true;
> > > > +   if (insn->type == INSN_CALL) {
> > > > +           struct symbol *dest = insn->call_dest;
> > > > +
> > > > +           if (!dest)
> > > > +                   return false;
> > > > +
> > > > +           if (dest->fentry)
> > > > +                   return true;
> > > > +   }
> > > >
> > > >     return false;
> > > >  }
> > > > @@ -2958,7 +2963,7 @@ static int validate_branch(struct objtoo
> > > >                     if (ret)
> > > >                             return ret;
> > > >
> > > > -                   if (!no_fp && func && !is_fentry_call(insn) &&
> > > > +                   if (!no_fp && func && !is_special_call(insn) &&
> > > >                         !has_valid_stack_frame(&state)) {
> > > >                             WARN_FUNC("call without frame pointer save/setup",
> > > >                                       sec, insn->offset);
> > > >
> > > >
> > > >
> > >
> > > We still see the 'srso_untrain_ret+0xd: call without frame pointer save/setup' warning with v5.15.136.  It looks like the backport might be incomplete.  Is this additional change needed?
> > >
> > > diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> > > index 36ad0b6b94a9..c3bb96e5bfa6 100644
> > > --- a/tools/objtool/check.c
> > > +++ b/tools/objtool/check.c
> > > @@ -2202,7 +2202,7 @@ static bool is_special_call(struct instruction *insn)
> > >               if (!dest)
> > >                       return false;
> > >
> > > -             if (dest->fentry)
> > > +             if (dest->fentry || dest->embedded_insn)
> > >                       return true;
> > >       }
> > >
> >
> > Possibly, I remember this was a pain to backport.  Can you try this and
> > see?  If so, can you send a working and tested patch?
> >
> > thanks,
> >
> > greg k-h
> 
> I think I can do that.  What's the process for a patch that would only
> go to certain stable branches?

Send it to use and say "This only applies to X and Y", there are loads
of examples on the stable mailing list of this happening all the time.

thanks,

greg k-h
