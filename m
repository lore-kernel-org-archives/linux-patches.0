Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C9F3B9949;
	Wed, 24 Jun 2026 09:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293840; cv=none; b=X3HASNwlqXSjGVBywFgsQNJKpeL2m4wTcARRLB5h4OZi4wSV7u97Gvr679OnPv5sjBPb6/4AZ/Pyk7RW79zukQ2izh1PbL7uKFuasZlt489/jhkNXrYFckL1PCWXGTmAaEXzgxeshVVxk+xzmH7KAagVBvs2s9AQB+eClGDu49c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293840; c=relaxed/simple;
	bh=tv9J4EnWkXedhmAx7yiXQV2KAa48b/rZoQTPFjRZRLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idea0MFGdUBgmS/yefq4la3Sy2H9ZmwlCSVBMSyd2ic5rYZAfSLznPUzhHKuMbLqQzuKS9mAuwOE6Eks13uu7Viza3Ul8WFdq4E5sfto7oP6cgsdjdLfJNZldw253PLqozw1nPqVRAoHsXIujmGlpAYzP7to5i5Me04jUIUA+PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03O5kptM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03O5kptM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5E51F000E9;
	Wed, 24 Jun 2026 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782293834;
	bh=IRC3d8HiCXbhLck/u1YUWijHs/FB+fBPFMejEZTkaJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=03O5kptMlXN+XIIfTFw5XK17h3jEjzC0ucbYKlFdtACuBxA8Y+P4zJP1Z/atUc4gq
	 n+HK7VLDhmHklk6yQxNeaD6USWZVJwL07gG2qv9zUDzEUq1BUcEhxaSBu+jbEuc47J
	 7X45T3Sp3TXLwUWU1iGDKNsfx+PdaHNu9VxvcyVg=
Date: Wed, 24 Jun 2026 11:36:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: iklatzco <iklatzco@gmail.com>, 00107082 <00107082@163.com>,
	patches <patches@lists.linux.dev>, peterz <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
	"yeoreum.yun" <yeoreum.yun@arm.com>
Subject: Re: perf: Fix dangling cgroup pointer in cpuctx
Message-ID: <2026062414-spry-reflux-1cd4@gregkh>
References: <20260616145120.525872058@linuxfoundation.org>
 <20260624080310.2502480-1-guanwentao@uniontech.com>
 <2026062455-obtrusive-sandbox-d6d1@gregkh>
 <tencent_62A2AD8F12114EBC582137F1@qq.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_62A2AD8F12114EBC582137F1@qq.com>

On Wed, Jun 24, 2026 at 05:27:56PM +0800, Wentao Guan wrote:
> Hello,
> 
> orginal patch commit 3b7a34aebbdf2a4b7295205bf0c654294283ec82,
> perf: Fix dangling cgroup pointer in cpuctx delete
> 'event->pending_disable = 1;' in __perf_remove_from_context(),
> but the backport commit ae1ada0af16249a3ed15e33fa6719a6a2f96f537 did not.
> 
> [context different]
> 25,26c19,20
> <  kernel/events/core.c | 16 ++++------------
> <  1 file changed, 4 insertions(+), 12 deletions(-)
> ---
> >  kernel/events/core.c | 21 ++++++---------------
> >  1 file changed, 6 insertions(+), 15 deletions(-)
> 29c23
> < index 0ac83fc1cb5e3..132524d0297cb 100644
> ---
> > index 1cc98b9b3c0b4..d78608323916f 100644
> 32c26
> < @@ -2056,18 +2056,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
> ---
> > @@ -2120,18 +2120,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
> 51c45,51
> < @@ -2401,6 +2389,10 @@ __perf_remove_from_context(struct perf_event *event,
> ---
> > @@ -2488,11 +2476,14 @@ __perf_remove_from_context(struct perf_event *event,
> >               state = PERF_EVENT_STATE_EXIT;
> >       if (flags & DETACH_REVOKE)
> >               state = PERF_EVENT_STATE_REVOKED;
> > -     if (flags & DETACH_DEAD) {
> > -             event->pending_disable = 1;
> > +     if (flags & DETACH_DEAD)
> 53c53,54
> <       }
> ---
> > -     }

I'm sorry, but I can't understand un-unified diffs, and diffs of diffs
are a whole other level of toughness....  If you feel something was
backported incorrectly, can you provide a patch to fix it up?

thanks,

greg k-h
