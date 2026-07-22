Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A956D21A434;
	Wed, 22 Jul 2026 13:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726267; cv=none; b=jX3e06JUks56wVRbGo4QMuzl+MYVRkwSrfhjaRAl3E964TfgorzJiSulbOWDXKwELjfg3BudrZF4nDwcFTNDYlkJQBAOyvz/Q2DiiHb0PprrZ0wA4gguZ4ZZnVeD4mBtztTZMQ3fxnm7qO0Sbqgi+hzb22biMHVU5XBYTHNEKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726267; c=relaxed/simple;
	bh=n+C3nsxbf9yMQ6/LudLUOcoxXmAx7s6MTjgjm6A3j0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avqDRPSpyHNh7pAa804e4wQsR1mXqI5wftBVHNxMLsD3VJaXbj0UAa1/75HMRw0JROZN2rCX1jlVd3cnmLwqonSueNiZMmEs0nsKNG4gSQk9bU3O0ahjS2hUHEGWy07RmO/sdinx2T5qtPHpReIQVxH3t4ioZ5FyJ2Z5guSJoNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gN4HTmCe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gN4HTmCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EC11F000E9;
	Wed, 22 Jul 2026 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784726266;
	bh=EC0udGI2RqcVB9zbCoJ1fg0rO6lhcK7QIOt/+3u5B0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gN4HTmCeJZzDe82bFrdu6lQWLRKMOS6g6x26pQLpOgAKzFv9JE3A07PTM75pRlJpE
	 ZQ6Gin0vG6kx+ii6BDI6/A+3nbV6jULEsnpM2NXZF8FXjKgavvUba7arySoLWFE0UE
	 PTwh+SpobwXcmh2gH3/hoefWK2LWkBZD8SzKEJ2g=
Date: Wed, 22 Jul 2026 15:17:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Zecheng Li <zli94@ncsu.edu>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.1 0837/2077] perf libdw: Fix libdw API contract
 violations and memory leaks
Message-ID: <2026072230-quintet-retold-b316@gregkh>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152612.529845867@linuxfoundation.org>
 <f71375d0-a863-4704-af03-a2bba5a9e85e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f71375d0-a863-4704-af03-a2bba5a9e85e@kernel.org>

On Wed, Jul 22, 2026 at 07:27:22AM +0200, Jiri Slaby wrote:
> On 21. 07. 26, 17:08, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ian Rogers <irogers@google.com>
> > 
> > [ Upstream commit 9c6d535ddb794fb540c3b142ab1d7416d469c1de ]
> 
> 
> > @@ -162,11 +181,29 @@ int libdw__addr2line(u64 addr, char **file, unsigned int *line_nr,
> >   			.leaf_srcline = srcline_from_fileline(src ?: "<unknown>", lineno),
> >   		};
> > +		if (!args.leaf_srcline) {
> > +			if (file && *file) {
> > +				free(*file);
> > +				*file = NULL;
> > +			}
> > +			return 0;
> > +		}
> > +
> >   		/* Walk from the parent down to the leaf. */
> > -		cu_walk_functions_at(cudie, addr, libdw_a2l_cb, &args);
> > +		if (cudie)
> > +			cu_walk_functions_at(cudie, addr, libdw_a2l_cb, &args);
> >   		if (!args.leaf_srcline_used)
> >   			free(args.leaf_srcline);
> > +
> > +		if (args.err) {
> > +			if (file && *file) {
> > +				free(*file);
> > +				*file = NULL;
> > +			}
> > +			inline_node__clear_frames(node);
> 
> This one needs:
> 674dea094ef6 perf srcline: Introduce inline_node__clear_frames()

Now fixed up, thanks.

greg k-h
