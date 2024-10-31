Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6443173;
	Thu, 31 Oct 2024 03:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345854; cv=none; b=Cc8OaotAhuSeJe44ZqaU6ybIPKc5dk5/iWbeBi6HiQNd2BBIyJSPqFHnPPopCTuooJ8PE9fcp0MRlTexEwWKk7Kr2YoUqKCYB7CpVmBVxTCbaJkg73f00Iy2d3ghd08Ubg80sSjyrrflOfc+tY7x6qDnMQyXhcfmnae8jHP/kpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345854; c=relaxed/simple;
	bh=nl24gnirAeRT6ICg5IzDTBd/x5bFHbr+jMPsT5ofn+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3jODeZbyBks0bI+v1OMT7chwEQtcx4cSfWeXgms+bPwUqeVqReBzL71UPjHIJOs5fxPDl74MmENyaBNeio4GgyAQNNUDc5lb0Uy8XfSDuYllg5YtDS75jX3jIQ1IquEWDZOlIRwyZfUu8XwsvdtwoaSTe2EmztLCTJ4+cGJHSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJq4yMTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJq4yMTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EE4C4CECE;
	Thu, 31 Oct 2024 03:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730345854;
	bh=nl24gnirAeRT6ICg5IzDTBd/x5bFHbr+jMPsT5ofn+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJq4yMTVr89KdBh8rJyEGqX2fuqDY7isRs1sKdolk+z4cqo0d9xaCgA11FRvHel11
	 083zHjEll0Ex/L2AwUx90ca7E83i7MsGRbtElFTDLO7Yqkjjkw4dDGsXrvcHorGQIE
	 TnyHcpA8ItfHkAK3+V2zgT2EAs4ac3GIUNhUKw1KFK9EYVn33AAyGgoOmDc4XwCOiT
	 DNGqlz5oXfFzPVdba7qjS++3bO6Ighr/zMXyKZSvtBOCU7Oz2fA5V9ZO5/zE8rYvRy
	 oiEBoIFk3g1/6Q9wstOnJzjQLx/P4sBrhzRlQVafcfcP/QzHNlAXyzypa08OrRmr28
	 qHHgPYjH+DJvA==
Date: Wed, 30 Oct 2024 20:37:31 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Naveen N Rao <naveen@kernel.org>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/2] kprobes: Fix __get_insn_slot() after __counted_by
 annotation
Message-ID: <20241031033731.GA2553234@thelio-3990X>
References: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
 <20241030-kprobes-fix-counted-by-annotation-v1-1-8f266001fad0@kernel.org>
 <20241031105827.08b362cf0dcf558f9cf59ad8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031105827.08b362cf0dcf558f9cf59ad8@kernel.org>

On Thu, Oct 31, 2024 at 10:58:27AM +0900, Masami Hiramatsu wrote:
> On Wed, 30 Oct 2024 09:14:48 -0700
> Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > Commit 0888460c9050 ("kprobes: Annotate structs with __counted_by()")
> > added a __counted_by annotation without adjusting the code for the
> > __counted_by requirements, resulting in a panic when UBSAN_BOUNDS and
> > FORTIFY_SOURCE are enabled:
> > 
> >   | memset: detected buffer overflow: 512 byte write of buffer size 0
> >   | WARNING: CPU: 0 PID: 1 at lib/string_helpers.c:1032 __fortify_report+0x64/0x80
> >   | Call Trace:
> >   |  __fortify_report+0x60/0x80 (unreliable)
> >   |  __fortify_panic+0x18/0x1c
> >   |  __get_insn_slot+0x33c/0x340
> > 
> > __counted_by requires that the counter be set before accessing the
> > flexible array but ->nused is not set until after ->slot_used is
> > accessed via memset(). Even if the current ->nused assignment were moved
> > up before memset(), the value of 1 would be incorrect because the entire
> > array is being accessed, not just one element.
> 
> Ah, I think I misunderstood the __counted_by(). If so, ->nused can be
> smaller than the accessing element of slot_used[]. I should revert it.
> The accessing index and ->nused should have no relationship.
> 
> for example, slots_per_page(c) is 10, and 10 kprobes are registered
> and then, the 1st and 2nd kprobes are unregistered. At this moment,
> ->nused is 8 but slot_used[9] is still used. To unregister this 10th
> kprobe, we have to access slot_used[9].

Ah, I totally missed that bit of the code, sorry about that. Thanks for
the explanation!

> So let's just revert the commit 0888460c9050.

Reverting that change sounds totally reasonable to me based on the
above. Will you take care of that?

For what it's worth, I think patch #2 should still be applicable, if you
are okay with that one.

Cheers,
Nathan
