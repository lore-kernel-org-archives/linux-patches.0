Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF540F727;
	Wed, 22 Jul 2026 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726569; cv=none; b=k9J/7NAZ2AVQEdEbpZT89rX2hMNdi0TEHqKnK6P3irz4lx7DBxSMrzNfjiGJZN5sszUHJfk4EW/u+apM7ATNRYxtBymn4KMSePAnXaCHh5FYRvBgABcQmHCV7I9FMyENy96wrkAkzXfWl6dtCiofHf8pwKO4mLAuLWCHPmtcufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726569; c=relaxed/simple;
	bh=cQ7o5OksMOIDcTYGMfTyLTes55s65dEwDvnzUwRSThg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OamQ/JH9t8Jfs9mvJc5djYOk9fdzZKF+s2Vf5JinK18TLnbVk32jwpIkgWh/N3YkXVtln85j26YpcPcPpH9YzcgBeYaEbrCqxEnLY63qf/Mvs8sgABaKizr9AdI7QgHPPZuhvRhwJ4a57ux9ZSmN24IS+s7/2EArxbgd/m20zhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgVYJRfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgVYJRfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB691F00A3D;
	Wed, 22 Jul 2026 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784726568;
	bh=VpNt+tuiOcbKXTovMfMRN1a9ejRXx2fUAqx5jWb3uDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GgVYJRfYdYfDg02GlGSxPu3ESka9T80a682dk1WKObZ/VT1+0DOajzOz56PZBGTV+
	 xKm+hi9Yew3AvTqq2pnWhf/bwrqsDBIi6D4Mtf4kCwjegXsuUiN331AfrEJuPV4w2+
	 D6i5hSVdx8e/cHAmxgwOh1hrB1hjns/3T0izky60=
Date: Wed, 22 Jul 2026 15:22:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>, sashiko-bot@kernel.org
Subject: Re: [PATCH 7.1 0931/2077] perf sched: Replace BUG_ON on invalid CPU
 with graceful skip
Message-ID: <2026072231-luckiness-salaried-9fbc@gregkh>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152614.777381844@linuxfoundation.org>
 <37827f3f-a0e6-4841-b54e-5784d5a8a705@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37827f3f-a0e6-4841-b54e-5784d5a8a705@kernel.org>

On Wed, Jul 22, 2026 at 07:25:43AM +0200, Jiri Slaby wrote:
> On 21. 07. 26, 17:10, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > [ Upstream commit 1e2c83f732deb329ebce23e26cbc482f4c4bf194 ]
> > 
> > latency_switch_event(), latency_runtime_event(), and map_switch_event()
> > use BUG_ON(cpu >= MAX_CPUS || cpu < 0) to validate the sample CPU.
> > When PERF_SAMPLE_CPU is absent from the sample type,
> > evsel__parse_sample() initializes sample->cpu to (u32)-1.  Casting
> > this to int yields -1, which triggers the BUG_ON and aborts perf sched.
> > 
> > The central CPU validation in perf_session__deliver_event() intentionally
> > preserves the (u32)-1 sentinel for downstream tools like perf script
> > and perf inject, so leaf callbacks must handle it themselves.
> > 
> > Replace the three BUG_ON calls with graceful skips using pr_warning(),
> > matching the existing pattern in process_sched_switch_event() and
> > process_sched_runtime_event() earlier in the same file.  Include the
> > file offset for cross-referencing with perf report -D.
> > 
> > Reported-by: sashiko-bot@kernel.org # Running on a local machine
> > Reviewed-by: Ian Rogers <irogers@google.com>
> > Assisted-by: Claude:claude-opus-4.6
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Stable-dep-of: 8cbca8a480e1 ("perf sched: Fix NULL dereference in latency_runtime_event")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   tools/perf/builtin-sched.c | 22 +++++++++++++++++++---
> >   1 file changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> > index c6a96d0dd77d94..adff5d40a15c95 100644
> > --- a/tools/perf/builtin-sched.c
> > +++ b/tools/perf/builtin-sched.c
> > @@ -1147,7 +1147,12 @@ static int latency_switch_event(struct perf_sched *sched,
> >   	int cpu = sample->cpu, err = -1;
> >   	s64 delta;
> > -	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
> > +	/* perf.data is untrusted input — CPU may be absent or corrupted */
> > +	if (cpu >= MAX_CPUS || cpu < 0) {
> > +		pr_warning("WARNING: at offset %#" PRIx64 ": out-of-bound sample CPU %d, skipping sample\n",
> > +			   sample->file_offset, cpu);
> 
> This needs:
> 7a490187f22b perf sample: Add file_offset field to struct perf_sample

Thanks, now added.

greg k-h
