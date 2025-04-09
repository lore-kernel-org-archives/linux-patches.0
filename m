Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A362AEE1;
	Wed,  9 Apr 2025 07:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185442; cv=none; b=Xp5M/Brh8hwek/qbmnFlOcX8JMM4YNS6TDUFhIb51jqODtYiXF8C5YkPsi6ji63W3JqGUD/zdDfiroN4gJ9ThXQWHR9NrUo5F/u1ehlfk46c7pdNVaVrr7hiVxcOkJOCHKlFvNgPgLT24vhNgvQtVOvq8lSCGJfxmMYcwvaBSyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185442; c=relaxed/simple;
	bh=TtbpCc8DRkcTAuJAo329Om+qIhhpsNt6eeOcCm/oEfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmYLoWvOjL3RPbKf5yqOfNxaVM2VqG2Yu5RrAkZ65jzDf4gJPLJXFGLUHWTf1DNVURYEWcMMTdY3kRcTgoLgzYFwDT2d20eujYlLlSEthZteFF68MwVYAV3tqwxH0X441WHpxRRWZWRc7UQGlDOAcn20KC6ecTGtrC+NIZJr3Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qimhs4Lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qimhs4Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383ECC4CEE3;
	Wed,  9 Apr 2025 07:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744185441;
	bh=TtbpCc8DRkcTAuJAo329Om+qIhhpsNt6eeOcCm/oEfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qimhs4LuXv1rNph4pH5vDGa1vfFBfigrC+LfqIf9+OAMTv5F4RJLSn3fU4pvzHSEb
	 r2lp/U4oIhCbDyt0U3Fczca4BTvh6hnqkkf5N7cS2nBbLouHN0a1C2dEYNd+NDLBZz
	 +1F9tV/U7zgnD0+IPmjJnFmCZTXSvU02Xti4BRJA=
Date: Wed, 9 Apr 2025 09:55:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH 6.14 708/731] tracing: Ensure module defining synth event
 cannot be unloaded while tracing
Message-ID: <2025040902-daybed-barber-d743@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104930.740570814@linuxfoundation.org>
 <78fdcb36-fac7-4894-923b-b88268568e7b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78fdcb36-fac7-4894-923b-b88268568e7b@kernel.org>

On Wed, Apr 09, 2025 at 09:06:43AM +0200, Jiri Slaby wrote:
> On 08. 04. 25, 12:50, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Douglas Raillard <douglas.raillard@arm.com>
> > 
> > commit 21581dd4e7ff6c07d0ab577e3c32b13a74b31522 upstream.
> > 
> > Currently, using synth_event_delete() will fail if the event is being
> > used (tracing in progress), but that is normally done in the module exit
> > function. At that stage, failing is problematic as returning a non-zero
> > status means the module will become locked (impossible to unload or
> > reload again).
> > 
> > Instead, ensure the module exit function does not get called in the
> > first place by increasing the module refcnt when the event is enabled.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Fixes: 35ca5207c2d11 ("tracing: Add synthetic event command generation functions")
> > Link: https://lore.kernel.org/20250318180906.226841-1-douglas.raillard@arm.com
> > Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
> > Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   kernel/trace/trace_events_synth.c |   30 +++++++++++++++++++++++++++++-
> >   1 file changed, 29 insertions(+), 1 deletion(-)
> > 
> > --- a/kernel/trace/trace_events_synth.c
> > +++ b/kernel/trace/trace_events_synth.c
> > @@ -852,6 +852,34 @@ static struct trace_event_fields synth_e
> >   	{}
> >   };
> > +static int synth_event_reg(struct trace_event_call *call,
> > +		    enum trace_reg type, void *data)
> > +{
> > +	struct synth_event *event = container_of(call, struct synth_event, call);
> > +
> > +	switch (type) {
> > +	case TRACE_REG_REGISTER:
> > +	case TRACE_REG_PERF_REGISTER:
> 
> Breaks build and needs:
>   8eb151864273 tracing: Do not use PERF enums when perf is not defined

Argh, my tools should have caught this, what went wrong...  Ah, my
fault, ugh, let me go find ALL of the "fixes for the fixes" that I
missed for all of these releases...

thanks!

greg k-h
