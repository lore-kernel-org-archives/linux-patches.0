Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F65E2CA9;
	Thu,  3 Oct 2024 07:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727939838; cv=none; b=a2UmHYOQFcmj8FpjnVlnGo0UtFBYwf+mlOjwnEQuhxFIm5JhuxaRZ5kasnlebOBEBItRtm3LK2tMG9aYfH2lO5pMuOQiQ90gEGBbRTuk99mPCns9Cn82HrpXsCHlHEZohjgxCmJjg+2odrWRwvmro4t6UQmKqXb1krCEtTPzNx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727939838; c=relaxed/simple;
	bh=jiUtKBTWGvZ81mv/A6vT3mvhTtA9hU8cL1vqF/J1leQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2tb8iDjH5usI3ugeE13GAmPTCcrc252pP50MBPo0x+0FAo2wrhVdmlkfbgWRiUcoFeZULr7hj4lFjTyuq0hNDOvhDlsh451YiC/RszxHOGuVwl2MzkllGC7eV2N6jZhUagV1aQH7E/9BrcEolVyj0zzWNl82wAj52OwTqve8d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GACd6GO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GACd6GO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CB7C4CEC7;
	Thu,  3 Oct 2024 07:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727939838;
	bh=jiUtKBTWGvZ81mv/A6vT3mvhTtA9hU8cL1vqF/J1leQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GACd6GO9ElFw5OmjPfUGxqmC3l2xUoB3ubHxt9ZCM4LIDd/oBn4vKcVr4Ke8nLE20
	 w+Al2rKCHP1QpbjvC5ck6SkPS/U0IYBft/AZek0tMpIkmJRgUP9l4eXJO2RhfvAoYo
	 dGrLEvKsR5X1L49PYOZ0x5NK2bDaUOvxqbQDFBmw=
Date: Thu, 3 Oct 2024 09:17:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anne Macedo <retpolanne@posteo.net>,
	Changbin Du <changbin.du@huawei.com>,
	Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 247/538] perf callchain: Fix stitch LBR memory leaks
Message-ID: <2024100327-diploma-supply-8f63@gregkh>
References: <20241002125751.964700919@linuxfoundation.org>
 <20241002125802.002549697@linuxfoundation.org>
 <Zv1u7P2GlV6w7WJZ@tassilo>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv1u7P2GlV6w7WJZ@tassilo>

On Wed, Oct 02, 2024 at 09:03:56AM -0700, Andi Kleen wrote:
> On Wed, Oct 02, 2024 at 02:58:06PM +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ian Rogers <irogers@google.com>
> > 
> > [ Upstream commit 599c19397b17d197fc1184bbc950f163a292efc9 ]
> > 
> > The 'struct callchain_cursor_node' has a 'struct map_symbol' whose maps
> > and map members are reference counted. Ensure these values use a _get
> > routine to increment the reference counts and use map_symbol__exit() to
> > release the reference counts.
> > 
> > Do similar for 'struct thread's prev_lbr_cursor, but save the size of
> > the prev_lbr_cursor array so that it may be iterated.
> > 
> > Ensure that when stitch_nodes are placed on the free list the
> > map_symbols are exited.
> > 
> > Fix resolve_lbr_callchain_sample() by replacing list_replace_init() to
> > list_splice_init(), so the whole list is moved and nodes aren't leaked.
> > 
> > A reproduction of the memory leaks is possible with a leak sanitizer
> > build in the perf report command of:
> 
> IMHO this doesn't meet stable criteria. It's a theoretical problem
> that only causes noise in leak checker outputs, but doesn't actually
> affect any real user.  The memory is always freed on exit anyways.

Ok, now dropped from all queues, thanks for the review.

greg k-h
