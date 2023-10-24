Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF0224F1
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTyvjis5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7E4C433C8;
	Tue, 24 Oct 2023 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698171165;
	bh=CMEc/k93CnBJjRjqaUC3AM7SntceEQlg2PsE+PtOh+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iTyvjis5MbmJRPk5QcNVts7cJAgLI/550EfntDPl2nWFriuq+rGp+DW+/iq0MAh/3
	 I4RM08YOPh9vcPXMXlXcj8HSef3PGcK3NqQgFv0LqC8HQsJ6mqWe6iqfV3w9gLPnT3
	 2I5He2D++CZ9aJH4mLA8Owuw1UAeyYg2d0iE9Us0=
Date: Tue, 24 Oct 2023 20:12:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: John Sperbeck <jsperbeck@google.com>
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev,
	peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 134/135] objtool/x86: Fixup frame-pointer vs rethunk
Message-ID: <2023102428-implicate-predict-0966@gregkh>
References: <20230824170617.074557800@linuxfoundation.org>
 <20230824170623.040455914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824170623.040455914@linuxfoundation.org>

On Tue, Oct 24, 2023 at 05:47:54PM +0000, John Sperbeck wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > commit dbf46008775516f7f25c95b7760041c286299783 upstream.
> > 
> > For stack-validation of a frame-pointer build, objtool validates that
> > every CALL instruction is preceded by a frame-setup. The new SRSO
> > return thunks violate this with their RSB stuffing trickery.
> > 
> > Extend the __fentry__ exception to also cover the embedded_insn case
> > used for this. This cures:
> > 
> >   vmlinux.o: warning: objtool: srso_untrain_ret+0xd: call without frame pointer save/setup
> > 
> > Fixes: 4ae68b26c3ab ("objtool/x86: Fix SRSO mess")
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> > Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Link: https://lore.kernel.org/r/20230816115921.GH980931@hirez.programming.kicks-ass.net
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  tools/objtool/check.c |   17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> > 
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -2079,12 +2079,17 @@ static int decode_sections(struct objtoo
> >  	return 0;
> >  }
> >  
> > -static bool is_fentry_call(struct instruction *insn)
> > +static bool is_special_call(struct instruction *insn)
> >  {
> > -	if (insn->type == INSN_CALL &&
> > -	    insn->call_dest &&
> > -	    insn->call_dest->fentry)
> > -		return true;
> > +	if (insn->type == INSN_CALL) {
> > +		struct symbol *dest = insn->call_dest;
> > +
> > +		if (!dest)
> > +			return false;
> > +
> > +		if (dest->fentry)
> > +			return true;
> > +	}
> >  
> >  	return false;
> >  }
> > @@ -2958,7 +2963,7 @@ static int validate_branch(struct objtoo
> >  			if (ret)
> >  				return ret;
> >  
> > -			if (!no_fp && func && !is_fentry_call(insn) &&
> > +			if (!no_fp && func && !is_special_call(insn) &&
> >  			    !has_valid_stack_frame(&state)) {
> >  				WARN_FUNC("call without frame pointer save/setup",
> >  					  sec, insn->offset);
> > 
> > 
> > 
> 
> We still see the 'srso_untrain_ret+0xd: call without frame pointer save/setup' warning with v5.15.136.  It looks like the backport might be incomplete.  Is this additional change needed?
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 36ad0b6b94a9..c3bb96e5bfa6 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2202,7 +2202,7 @@ static bool is_special_call(struct instruction *insn)
>  		if (!dest)
>  			return false;
>  
> -		if (dest->fentry)
> +		if (dest->fentry || dest->embedded_insn)
>  			return true;
>  	}
>  

Possibly, I remember this was a pain to backport.  Can you try this and
see?  If so, can you send a working and tested patch?

thanks,

greg k-h
