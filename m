Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7D02D3A9D;
	Wed, 13 Aug 2025 07:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071217; cv=none; b=YwTbqhGn7CZUfSP19Q+Vav2aPRBmKcw/t6s+923fqoVLIX4BzsSQS8eJooC0z9rMfotYYccMGac+6yBsnEDHhfD6yKos2Jxq2kobV+yUu1of8pV7IHLZo2wZHzkZB0y94xB35jiQ3PKYhWAC4cNscEZKJR43w6Vpz7OrQ1a9/XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071217; c=relaxed/simple;
	bh=XepUDfhYpTbuHtkMJcbNRCzKfGqQ7NOTQa5B+qpZtCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnGtIa+1JpbM7xrMumPkei8ns26SjzerSk4gfda0aojOXikKFde5vp76ehkwP6irngjtYjyluwQUlUX/rf9NrLK5oV8iwSYC95DC8UdaOZUm6WnR67swLt69I0wckpDMC0jROu2woaJWbxPlwoxPZZBegRd5JdtQ6zsFBoULfRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWS0ZBK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWS0ZBK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DDFC4CEEB;
	Wed, 13 Aug 2025 07:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755071216;
	bh=XepUDfhYpTbuHtkMJcbNRCzKfGqQ7NOTQa5B+qpZtCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iWS0ZBK34j1ot1XqQGz+/c4icQilJN6CVHUeQkJo7QJYESJSKVG+x6sFLFtVQIoOt
	 d5ATDaOKivVml6aBuiONmKAKCejYbnVLbz5iLnxM0cDBLJou8ue1q6iDGa1ijQem1p
	 03pDylHRH9fitDGmIcGEMXPqNDE/T4BzdEi39M0Y=
Date: Wed, 13 Aug 2025 09:46:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 423/627] perf topdown: Use attribute to see an event
 is a topdown metic or slots
Message-ID: <2025081342-reproach-economist-6f5f@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173435.364948171@linuxfoundation.org>
 <a736a48f-4de2-4b93-9f9c-df1925c8b76b@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a736a48f-4de2-4b93-9f9c-df1925c8b76b@leemhuis.info>

On Wed, Aug 13, 2025 at 05:31:00AM +0200, Thorsten Leemhuis wrote:
> On 12.08.25 19:31, Greg Kroah-Hartman wrote:
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ian Rogers <irogers@google.com>
> > 
> > [ Upstream commit 5b546de9cc177936a3ed07d7d46ef072db4fdbab ]
> > 
> > The string comparisons were overly broad and could fire for the
> > incorrect PMU and events. Switch to using the config in the attribute
> > then add a perf test to confirm the attribute config values match
> > those of parsed events of that name and don't match others. This
> > exposed matches for slots events that shouldn't have matched as the
> > slots fixed counter event, such as topdown.slots_p.
> 
> This caused the following build error for me when building perf
> on Fedora x86_64:
> 
> arch/x86/tests/topdown.c: In function ‘event_cb’:
> arch/x86/tests/topdown.c:53:25: error: implicit declaration of function ‘pr_debug’ [-Wimplicit-function-declaration]
>    53 |                         pr_debug("Broken topdown information for '%s'\n", evsel__name(evsel));
>       |                         ^~~~~~~~
> make[6]: *** [/builddir/build/BUILD/kernel-6.16.1-build/kernel-6.16.1-rc1/linux-6.16.1-0.rc1.200.vanilla.fc42.x86_64/tools/build/Makefile.build:85: arch/x86/tests/topdown.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> 
> Reverting fixed the problem. Full log:
> https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable-rc/fedora-42-x86_64/09405663-stablerc-stablerc-releases/builder-live.log.gz
> 
> Ciao, Thorsten

Thanks, I've now deleted this patch from the queue.

greg k-h
