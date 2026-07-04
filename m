Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B66286AC;
	Sat,  4 Jul 2026 06:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783147614; cv=none; b=Me+Rgwyb1+PlxcyrU5IgvOVmEhs0m06zXJoGntkHH9xdM58skLxVjI4yzNUFBa+zbgun5mW/RBwyWa3o5SsmzZlwOuvZSCy09LY1s+jiWmABiZVFpEoZkmB9WtlVhvBrCPhAD2q4NYE2qlclqeXMMJgbD4Prp+Ld1Tciu/AaWug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783147614; c=relaxed/simple;
	bh=WPfod3Imm4mPuPJSFT0zRmUVNDu+36cxMNyKu61vNWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LU0s/76iIMSR9RRchExENjo23twoFH5rFPAfYGShYKiAOip1d5QhhfUAbG/mgenwUMEhC7fXRWa2BNFcwLksZAE2X5h4kdJbvrXxMTazaLt6fEVWGDbJf9yL2nOB0qlPzYMGIpAvi0SbKPx6ILsPnAMvZztggPVkf28xjkt2/Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pG+KwwTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pG+KwwTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAF11F000E9;
	Sat,  4 Jul 2026 06:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783147612;
	bh=9TOuqSXNUInmQ1xYncPDaJauGMXqonPCn+zmjYjvWPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pG+KwwTJ8hJ29uqlAkdbpOxbm3W2vvfuMaYNCemF4BVf2R2gjzQi41ZXLHKhRH6Jc
	 SCzLfhcEJsIuxdEW/yrB9gVKWPSUgvj6s3cjXP5n49Sm2re4t0PaUBH3+7ik66WYv/
	 lY2+oXaQFAz/xzHRa/PBv9LPm2EpUiPMI4onfT8w=
Date: Sat, 4 Jul 2026 08:45:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 6.18 044/108] block: invalidate cached plug timestamp
 after task switch
Message-ID: <2026070416-bannister-charred-76c4@gregkh>
References: <20260703123236.3139759-1-usama.arif@linux.dev>
 <2026070315-stable-reply-0015@kernel.org>
 <eeec321a-fd07-408b-9d64-c4d65ec92935@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeec321a-fd07-408b-9d64-c4d65ec92935@kernel.dk>

On Fri, Jul 03, 2026 at 08:35:46PM -0600, Jens Axboe wrote:
> On 7/3/26 8:05 PM, Sasha Levin wrote:
> > On Thu, Jul 03, 2026 at 05:32:35AM -0700, Usama Arif wrote:
> >> It looks like this patch was backported, but the preceding patch [1]
> >> in the series was not bacported to the stable branches. Both this and its
> >> prerequisite have the same Fixes tag.
> >> Not having the prerequisite will result in a NULL derefernce.
> >> Could we please add [1] to the stable branches?
> > 
> > Now queued the prerequisite fd38b75c4b43 ("kernel/fork: clear PF_BLOCK_TS
> > in copy_process()") for 7.1.y, 6.18.y, and 6.12.y, thanks!
> 
> This is a problem. Can some light be shed on why only 1 patch of the 2
> got applied? This could lead to big problems, which seems to be the
> case for this one in fact.

This is on me, I only took a "subset" of the patches tagged for stable
for this round of releases as I was facing a huge backlog of stuff
(everyone loves to wait for -rc1 for cc: stable fixes), combined with me
having travelled for 6 weeks straight for conferences which didn't allow
me a ton of time to do stable kernel work to keep on top of the pile.

The patch wasn't lost, and is still in my queue to process (along with
748 other patches) it just wasn't obvious that there was a dependancy
and that I had to take them both in order, that's on me, sorry.  This is
also why we have review, to catch things when I do something stupid like
this :)

> A Depends-on could be used here, but it's pretty hard for a submitter
> to do that, as the sha isn't known before it goes into the maintainers
> tree.

Agreed, that wouldn't really work, and isn't normally needed.

But again, maybe trying to get patches that are cc: stable into Linus
_before_ -rc1 is better?  Hey, I can dream...

thanks,

greg k-h
