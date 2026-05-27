Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A2D260580;
	Wed, 27 May 2026 05:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779859713; cv=none; b=E1N57Juf0obdlArS0aMA3KedaoujUxw0hdW7F3l5JK7o4a1Rl/Qao0Rm9a8qyIaGkfzj53AAIAwtLEI+f2z8mC9lkpVQl+/K3b1tOkFr3P9XEMiZ285dJuGZsgtTDY46igWka01PIJzHKI5sYcvdvSV5BmuXbpIcHjou8lz+szI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779859713; c=relaxed/simple;
	bh=PjTMWRlJeQw5Ke6pFnWaZg7ScFpeTF7S13zW2MGMlDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RULDpVXB021y3JxhWuFgIzpxBDxa6YWre6ICpS2qBXcW+PSO2S5X8goKU2pAoSAz6AcYnNLzD6pMBv/uGea0yg2UlN8Ql54ad+akRFQ1pBWmiLbHHlPaSxMZ68li5yNxyvdBON8OEDrZJmRyqEsjDOttsmgmTuscOJUnioXtLvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRjFZP+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRjFZP+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F9A1F000E9;
	Wed, 27 May 2026 05:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779859712;
	bh=1oRK91M2AE5vw24zyqUHcYd4TgAAiNpwniq3+hY0AUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRjFZP+09nqM5rcAZ1qURBF2oPz0NkNqLtn+wVac7m8+jYlwyKyFCY/I6UzorE3DW
	 aYThWYa8P6bD7+t+H95bCesedgi4plK/dDY2xsschmEbYqZxHOWGWbjS/nhYO1vhEB
	 VY/iaLzL6PyukngrDlsEEJd44tKTjmBL5rShPt4lujQgGLvOfD6W8yn2W1J/LaOze4
	 pNsunmnFBB5W3DJ/lFOovFL8P4mm0E5slN03ldGgW99a2p+Dt3Xb7X5Z65WUmxRx6/
	 FvifADD0h0XHkPC/wQO9WFUZyO07RINGSwlVgo+S7n/ShHnaPDY4NL3Yqg9DW5mjtF
	 ms26YulVIz70A==
Date: Tue, 26 May 2026 22:28:29 -0700
From: Namhyung Kim <namhyung@kernel.org>
To: Tyler Stachecki <stachecki.tyler@gmail.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>, Sasha Levin <sashal@kernel.org>,
	regressions@lists.linux.dev
Subject: Re: [PATCH 6.12 375/666] perf tool_pmu: Factor tool events into
 their own PMU
Message-ID: <ahaA_cDtjyA7d731@google.com>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162119.375577583@linuxfoundation.org>
 <ahMPWN_PZlQLisk4@eldamar.lan>
 <ahYq/YrKZ+PjCh2W@luigi.stachecki.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahYq/YrKZ+PjCh2W@luigi.stachecki.net>

Hello,

On Tue, May 26, 2026 at 07:21:33PM -0400, Tyler Stachecki wrote:
> On Sun, May 24, 2026 at 04:46:48PM +0200, Salvatore Bonaccorso wrote:
> > hi Greg, 
> > On Wed, May 20, 2026 at 06:19:46PM +0200, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Ian Rogers <irogers@google.com>
> > > 
> > > [ Upstream commit 240505b2d0adcdc8fd018117e88dc27b09734735 ]
> > > 
> > > Rather than treat tool events as a special kind of event, create a
> > > tool only PMU where the events/aliases match the existing
> > > duration_time, user_time and system_time events. Remove special
> > > parsing and printing support for the tool events, but add function
> > > calls for when PMU functions are called on a tool_pmu.
> > > 
> > > Move the tool PMU code in evsel into tool_pmu.c to better encapsulate
> > > the tool event behavior in that file.
> > 
> > While building now a complete set of packages for Debian for 6.12.91
> > where perf tools are included as well, I noticed that now the builds
> > fails. In fact in v6.12.91 
> > 
> > $ cd tools
> > $ LC_ALL=C.UTF-8 ARCH=x86 make perf
> > 
> > fails with:
> > 
> > [...]
> >   CC      util/stat.o
> > util/tool_pmu.c: In function ‘tool_pmu__config_term’:
> > util/tool_pmu.c:62:49: error: implicit declaration of function ‘parse_events__term_type_str’; did you mean ‘parse_events_term__str’? [-Wimplicit-function-declaration]
> >    62 |                                                 parse_events__term_type_str(term->type_term),
> >       |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                                                 parse_events_term__str
> > util/tool_pmu.c:61:79: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
> >    61 |                                                 "unexpected tool event term (%s) %s",
> >       |                                                                              ~^
> >       |                                                                               |
> >       |                                                                               char *
> >       |                                                                              %d
> >    62 |                                                 parse_events__term_type_str(term->type_term),
> >       |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                                                 |
> >       |                                                 int
> > cc1: all warnings being treated as errors
> >   CC      util/stat-shadow.o
> >   LD      util/hisi-ptt-decoder/perf-util-in.o
> >   CC      util/stat-display.o
> > make[5]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: util/tool_pmu.o] Error 1
> > make[5]: *** Waiting for unfinished jobs....
> >   CC      util/perf_api_probe.o
> >   LD      util/perf-regs-arch/perf-util-in.o
> > util/cgroup.c: In function ‘evlist__expand_cgroup’:
> > util/cgroup.c:498:32: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
> >   498 |                         if (pos->first_wildcard_match)
> >       |                                ^~
> > util/cgroup.c:499:38: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
> >   499 |                                 evsel->first_wildcard_match = pos->first_wildcard_match->priv;
> >       |                                      ^~
> > util/cgroup.c:499:66: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
> >   499 |                                 evsel->first_wildcard_match = pos->first_wildcard_match->priv;
> >       |                                                                  ^~
> > make[5]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: util/cgroup.o] Error 1
> >   LD      util/arm-spe-decoder/perf-util-in.o
> >   LD      ui/browsers/perf-ui-in.o
> >   LD      tests/workloads/perf-test-in.o
> >   LD      ui/perf-ui-in.o
> >   LD      perf-ui-in.o
> >   AR      libperf-ui.a
> >   LD      tests/perf-test-in.o
> >   LD      perf-test-in.o
> >   AR      libperf-test.a
> >   LD      util/scripting-engines/perf-util-in.o
> >   LD      util/intel-pt-decoder/perf-util-in.o
> >   LD      perf-in.o
> > make[4]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:162: util] Error 2
> > make[3]: *** [Makefile.perf:789: perf-util-in.o] Error 2
> > make[3]: *** Waiting for unfinished jobs....
> >   CC      pmu-events/pmu-events.o
> >   LD      pmu-events/pmu-events-in.o
> > make[2]: *** [Makefile.perf:292: sub-make] Error 2
> > make[1]: *** [Makefile:76: all] Error 2
> > make: *** [Makefile:93: perf] Error 2
> > 
> > Regards,
> > Salvatore
> 
> Second this - moreover, because of the other commits introduced in tools/perf
> as of 6.12.91, it's not possible to revert just this one commit without other
> conflicts.

I don't think it's meant to be in the stable tree.  Maybe need to drop
this and later patches depend on it.

Thanks,
Namhyung

