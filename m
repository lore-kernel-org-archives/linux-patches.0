Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638173AD49F;
	Wed, 17 Dec 2025 10:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765967522; cv=none; b=ghICP1kkPbU+alPdZ8TZJVI/I16/PDpK7cgdkuIleWXX7/FQlIPS2d5Cu1aFVMhrmbgi5Mics1xM8FCZlvRhwusDkye6NTySP1XKvuH9v4af4I1WPlNEYw/hDWRNMFZvtW8kL6klE1Obop4Zw6HtR25CeRoCS5Jn0FrYhr0ry7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765967522; c=relaxed/simple;
	bh=UCpdYI2xy9pO8rqFnRI31eNttmHceN4lQTHzUBcE8zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grcf/HNbIMO+ZR3qtMH1nyYuOHBGLRxbKHTiNpnlXEDd57iNvgPi93RJryYupWYCWZS9iiOM/jut4s6OGypYyHXRih8p9EIDdrryfia9AqcGa0xAV7wDO4OxZ69xzuKE/qmwZvG6/sfPTbfg4Jt/9ZB+jPASWQnGa/uTvnpNDH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf6R2lhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf6R2lhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366D0C4CEF5;
	Wed, 17 Dec 2025 10:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765967521;
	bh=UCpdYI2xy9pO8rqFnRI31eNttmHceN4lQTHzUBcE8zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hf6R2lhKnP5DcNyl9yrV3nX4M7FyWVHiACbmCJwZVPIXyRax3LLbgWgX0f1xrRVlF
	 7nhb5xy2A/tcmgXBQGdUuQossYDQP+3hsz+TjW7R6JUp4vSpU/s2nMHEipe0xbwHCX
	 S4pZENIHk/45w369RO8QEA/osqy2E+WuURIrlSu8=
Date: Wed, 17 Dec 2025 11:31:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 215/614] perf annotate: Fix build with NO_SLANG=1
Message-ID: <2025121754-breeching-aftermost-d10a@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216111409.165603959@linuxfoundation.org>
 <25751506-e4df-4ae3-9ea8-4b2800146ba2@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25751506-e4df-4ae3-9ea8-4b2800146ba2@kernel.org>

On Wed, Dec 17, 2025 at 10:42:54AM +0100, Jiri Slaby wrote:
> On 16. 12. 25, 12:09, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Namhyung Kim <namhyung@kernel.org>
> > 
> > [ Upstream commit 0e6c07a3c30cdc4509fc5e7dc490d4cc6e5c241a ]
> > 
> > The recent change for perf c2c annotate broke build without slang
> > support like below.
> > 
> >    builtin-annotate.c: In function 'hists__find_annotations':
> >    builtin-annotate.c:522:73: error: 'NO_ADDR' undeclared (first use in this function); did you mean 'NR_ADDR'?
> >      522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
> >          |                                                                         ^~~~~~~
> >          |                                                                         NR_ADDR
> >    builtin-annotate.c:522:73: note: each undeclared identifier is reported only once for each function it appears in
> > 
> >    builtin-annotate.c:522:31: error: too many arguments to function 'hist_entry__tui_annotate'
> >      522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
> >          |                               ^~~~~~~~~~~~~~~~~~~~~~~~
> >    In file included from util/sort.h:6,
> >                     from builtin-annotate.c:28:
> >    util/hist.h:756:19: note: declared here
> >      756 | static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
> >          |                   ^~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > And I noticed that it missed to update the other side of #ifdef
> > HAVE_SLANG_SUPPORT.  Let's fix it.
> > 
> > Cc: Tianyou Li <tianyou.li@intel.com>
> > Fixes: cd3466cd2639783d ("perf c2c: Add annotation support to perf c2c report")
> 
> That fixes line ^^^ appears to be wrong, as now I see:
> builtin-annotate.c: In function ‘hists__find_annotations’:
> builtin-annotate.c:522:10: error: too few arguments to function
> ‘hist_entry__tui_annotate’
>     key = hist_entry__tui_annotate(he, evsel, NULL);
>           ^~~~~~~~~~~~~~~~~~~~~~~~
> In file included from util/sort.h:6:0,
>                  from builtin-annotate.c:28:
> util/hist.h:757:19: note: declared here
>  static inline int hist_entry__tui_annotate(struct hist_entry *he
> __maybe_unused,
>                    ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> 
> 
> Because in util/hist.h, we now have:
> int hist_entry__tui_annotate(struct hist_entry *he, struct evsel *evsel,
>                              struct hist_browser_timer *hbt);
> ...
> static inline int hist_entry__tui_annotate(struct hist_entry *he
> __maybe_unused,
>                                            struct evsel *evsel
> __maybe_unused,
>                                            struct hist_browser_timer *hbt
> __maybe_unused,
>                                            u64 al_addr __maybe_unused)
> {
>         return 0;
> }
> 
> 
> 
> Was it meant to be
> Fixes: ad83f3b7155d perf c2c annotate: Start from the contention line
> ?

Odd.  Either way it should not have been backported to 6.18.y as neither
of those are in that release (came out in 6.19-rc1.)

I'll go drop this commit from the queues, thanks!

greg k-h
