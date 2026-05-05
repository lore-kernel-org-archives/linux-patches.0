Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7C943DA5A;
	Tue,  5 May 2026 10:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777975593; cv=none; b=YDcV0Kqbba+Fry/cw6JkQhsiBec2012SvwBF7+dD2j0/VIiOnJ/RVj2M2eIknNIR3DCPm1DjoTjTAMVZqHUHFApuYzENdiT9hOg/aJ0LWwQmtHFchsN4bzU1Qxbi7te2CX7OJbgvyoqHHS+30EgQvUO/ah/QGYAuXNxHM/huKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777975593; c=relaxed/simple;
	bh=wzLQgJjSiPhRjigSSvezEABMSxogdoDgLiTjYxVj200=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eP7JSIYq1sq57K+U39m55f0STcGWg9pYObjL4u6QWCPVic60HzVYRbEr4Yc7CkxW6X3aph8DbWSfe40Hfx162vqTa3dm/VeJxkVcgRv9ipN/N+bIQ1+i8jPzsdV6o//2866JSteWL58xK34iM/JhM+8DuYaVBX5nKeoBo6bk0wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+Ggn4fR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+Ggn4fR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569EDC2BCF7;
	Tue,  5 May 2026 10:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777975592;
	bh=wzLQgJjSiPhRjigSSvezEABMSxogdoDgLiTjYxVj200=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h+Ggn4fR87rDutg//Ll3pwLe/AtKyiwcXEazrPURIcYrikF3nE5kFNLZtm6NIrDm0
	 W/oT8OMqFe0a6wMfFgRpWo3x+g3dGZO/UjF0gzCxazs1q6KW59Xc6LGpchp1QUklti
	 pjCvRdUvtNyVXFuN1ehVjaR0/OUyIU+CbOvmQ3Uo=
Date: Tue, 5 May 2026 12:06:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>, Corey Minyard <corey@minyard.net>
Subject: Re: [PATCH 7.0 073/307] ipmi:ssif: Clean up kthread on errors
Message-ID: <2026050523-blandness-calibrate-93c5@gregkh>
References: <20260504135142.814938198@linuxfoundation.org>
 <20260504135145.562837603@linuxfoundation.org>
 <2bdd7732-e20d-4d67-8f3e-2b9a9a791edf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bdd7732-e20d-4d67-8f3e-2b9a9a791edf@kernel.org>

On Tue, May 05, 2026 at 11:10:29AM +0200, Jiri Slaby wrote:
> On 04. 05. 26, 15:49, Greg Kroah-Hartman wrote:
> > 7.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Corey Minyard <corey@minyard.net>
> > 
> > commit 75c486cb1bcaa1a3ec3a6438498176a3a4998ae4 upstream.
> > 
> > If an error occurs after the ssif kthread is created, but before the
> > main IPMI code starts the ssif interface, the ssif kthread will not
> > be stopped.
> > 
> > So make sure the kthread is stopped on an error condition if it is
> > running.
> > 
> > Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")
> > Reported-by: Li Xiao <<252270051@hdu.edu.cn>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Li Xiao <252270051@hdu.edu.cn>
> > Signed-off-by: Corey Minyard <corey@minyard.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/char/ipmi/ipmi_ssif.c |   13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/char/ipmi/ipmi_ssif.c
> > +++ b/drivers/char/ipmi/ipmi_ssif.c
> > @@ -1268,8 +1268,10 @@ static void shutdown_ssif(void *send_inf
> >   	ssif_info->stopping = true;
> >   	timer_delete_sync(&ssif_info->watch_timer);
> >   	timer_delete_sync(&ssif_info->retry_timer);
> > -	if (ssif_info->thread)
> > +	if (ssif_info->thread) {
> >   		kthread_stop(ssif_info->thread);
> > +		ssif_info->thread = NULL;
> > +	}
> >   }
> >   static void ssif_remove(struct i2c_client *client)
> > @@ -1916,6 +1918,15 @@ static int ssif_probe(struct i2c_client
> >    out:
> >   	if (rv) {
> > +		/*
> > +		 * If ipmi_register_smi() starts the interface, it will
> > +		 * call shutdown and that will free the thread and set
> > +		 * it to NULL.  Otherwise it must be freed here.
> > +		 */
> > +		if (ssif_info->thread) {
> 
> This 'if' reportedly needs:
> commit a8aebe93a4938c0ca1941eeaae821738f869be3d
> Author: Corey Minyard <corey@minyard.net>
> Date:   Tue Apr 21 06:50:22 2026 -0500
> 
>     ipmi:ssif: NULL thread on error
> 

Thanks, now queued up.

greg k-h
