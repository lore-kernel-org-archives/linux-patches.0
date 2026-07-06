Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB46D434E2D;
	Mon,  6 Jul 2026 09:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783331724; cv=none; b=GP4eU75diBfaZi/ScY1yBGzqGzVqqySZ/NhVv1O87XesJ6XqXBa73tLFF99pWAxK4Ugqu1UjPXlI2w4bp4GVNRAEiCduL+JXBZILd+yt/eXALt4pQ3wIrmElpNxz2l1d4uU0XghLlrqyYYSGlTZaqrny5Aug7NGiWoFa/KKfkFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783331724; c=relaxed/simple;
	bh=7qyE8KFzlMjSavnMZbgNRi88hnOZs9oUGZigj3qYO4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2seUxRw+p17VNH+EO4hSIqiGstViagVppVEcJu1NPPh/Nh96IAGYo1JoV6lDIWQYAuDZK275biwAVscuT1WrieHcqyBf3zC0IcJpRlEwLJ3jMy42SizcGnw36DGhHD9btYX8YL+udatw427rPykY0Ybjh34vRm2bnLjS3Whpc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xpFS1IN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xpFS1IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231F91F000E9;
	Mon,  6 Jul 2026 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783331720;
	bh=GzALhhwRCQKIE7qtAONdErn8cP6bKjR2i23MTfiTzqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1xpFS1IN+A0+8hpZ7lL8HSvPuGh1rwf6nHFXrNUx+lKdhvu0WM/Uw0bkHPP0j3EYG
	 LseddGHKm0uZsiS+4yhLit88zsQSuEmW635VMw7qs2m/PxVIauH7fW1HpmzjEj+hWB
	 GDCMC9c/IERc/GXqC1BAoNOJOT9Nq31jCdn66nLI=
Date: Mon, 6 Jul 2026 11:55:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 6.18 044/108] block: invalidate cached plug timestamp
 after task switch
Message-ID: <2026070659-mousy-gesture-d651@gregkh>
References: <20260703123236.3139759-1-usama.arif@linux.dev>
 <2026070315-stable-reply-0015@kernel.org>
 <eeec321a-fd07-408b-9d64-c4d65ec92935@kernel.dk>
 <2026070416-bannister-charred-76c4@gregkh>
 <4a05f7e4-d831-4696-8d34-7e976839b4b2@kernel.dk>
 <2026070536-showroom-unlit-4f84@gregkh>
 <6504fee2-a8e2-4cc6-ac60-524160710842@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6504fee2-a8e2-4cc6-ac60-524160710842@kernel.dk>

On Sun, Jul 05, 2026 at 05:05:38PM -0600, Jens Axboe wrote:
> On 7/5/26 3:03 AM, Greg Kroah-Hartman wrote:
> > On Sat, Jul 04, 2026 at 06:41:07AM -0600, Jens Axboe wrote:
> >> On 7/4/26 12:45 AM, Greg Kroah-Hartman wrote:
> >>> On Fri, Jul 03, 2026 at 08:35:46PM -0600, Jens Axboe wrote:
> >>>> On 7/3/26 8:05 PM, Sasha Levin wrote:
> >>>>> On Thu, Jul 03, 2026 at 05:32:35AM -0700, Usama Arif wrote:
> >>>>>> It looks like this patch was backported, but the preceding patch [1]
> >>>>>> in the series was not bacported to the stable branches. Both this and its
> >>>>>> prerequisite have the same Fixes tag.
> >>>>>> Not having the prerequisite will result in a NULL derefernce.
> >>>>>> Could we please add [1] to the stable branches?
> >>>>>
> >>>>> Now queued the prerequisite fd38b75c4b43 ("kernel/fork: clear PF_BLOCK_TS
> >>>>> in copy_process()") for 7.1.y, 6.18.y, and 6.12.y, thanks!
> >>>>
> >>>> This is a problem. Can some light be shed on why only 1 patch of the 2
> >>>> got applied? This could lead to big problems, which seems to be the
> >>>> case for this one in fact.
> >>>
> >>> This is on me, I only took a "subset" of the patches tagged for stable
> >>> for this round of releases as I was facing a huge backlog of stuff
> >>> (everyone loves to wait for -rc1 for cc: stable fixes), combined with me
> >>> having travelled for 6 weeks straight for conferences which didn't allow
> >>> me a ton of time to do stable kernel work to keep on top of the pile.
> >>>
> >>> The patch wasn't lost, and is still in my queue to process (along with
> >>> 748 other patches) it just wasn't obvious that there was a dependancy
> >>> and that I had to take them both in order, that's on me, sorry.  This is
> >>
> >> At least this one would've been avoided if patches marked as fixing the
> >> same upstream commit would never get split. Which does seem like a
> >> (very) sane default! Particularly when they are part of the same
> >> posting, it's not like they landed at separate times.
> > 
> > I have never considered searching to show which patches say they fix the
> > same commit.  Next time I do a "not all of the patches at once" I will
> > do that.  As this hasn't come up in the past before, because normally I
> > can keep on top of the flood, it shouldn't be something we have to
> > institute very often.
> 
> I think the relationships are probably a bit loser than "fixes the same
> commit", could also be things like "these two patches fix commits in the
> same original series". Actually something that would be ideal to just
> have an LLM vet, with some basic rules, honed down the line? Stable is
> important to me, but it does feel a bit fast and lose sometimes, some
> more process (and particularly automated process) might not be a bad
> idea?

Again, normally this isn't an issue as we can keep on top of the patch
feed, but for this release, I didn't, and had to pick/choose what to
include in the tree.  So adding additional stuff to our process that
normally will not be used might not be a good use of our time :)

thanks,

greg k-h
