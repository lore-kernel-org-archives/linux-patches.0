Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770B6258A;
	Wed, 12 Mar 2025 08:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741767411; cv=none; b=AUrI0e4nxDIliXJvHhdHhp2Md2cdNgtOVBi1W5JhyD5eJ/m/ZOnffAc1ro8fkMdgOlbqLhamcQYGS/igV6Cp4PJ4f/R+AWJ7c0QsUAb+4mnGGKnQxC13wi5BJ0CXuSHE4FJP9bV2VF1UCvAAHCQXE14VsPID9UZbrXj2eLa4Bpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741767411; c=relaxed/simple;
	bh=FmGTZGIRqjGvdrftQ0Veuag8jsHp59rXe3Dsa4a1fqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GElvbkFJcymxGUwu8nlwbnOk785qz1YzOEIxvHb2yUokZuwoSCficHCu7VIFzEVgiIi19ESGKehVY2tLsZTPrlKRdqlFBqZZTUjLtcituBwr+T1KWzjrExtxMW1Bh+6lJ7AugKFrbRXf2RXoYQHZoCYO80Qdr2OG38bTDjZJ2BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTDniZ0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTDniZ0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A5EC4CEE3;
	Wed, 12 Mar 2025 08:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741767411;
	bh=FmGTZGIRqjGvdrftQ0Veuag8jsHp59rXe3Dsa4a1fqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JTDniZ0wC9kTNSO4rlM3+ehiisufYpCgu9Q3bwkIbrdYs4Gzdq/LRr3x3tPRIGAX+
	 spE7Dtnjth85zwa2jgRQOavRIvdVdbYLeK1D4SNaM/Tjw0y0WGCWvQUmyksR/wHeff
	 zr9bgiYAQuCHrC60eqg9PMnPnr4oSjmD+wCyu04s=
Date: Wed, 12 Mar 2025 09:16:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Ingo Molnar <mingo@kernel.org>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] [PATCH 6.13 089/443] x86/kexec: Allocate PGD for
 x86_64 transition page tables separately
Message-ID: <2025031218-cardboard-pushcart-4211@gregkh>
References: <20250213142440.609878115@linuxfoundation.org>
 <20250213142444.044525855@linuxfoundation.org>
 <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org>
 <2025031203-scoring-overpass-0e1a@gregkh>
 <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>

On Wed, Mar 12, 2025 at 08:54:52AM +0100, Ard Biesheuvel wrote:
> On Wed, 12 Mar 2025 at 08:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Mar 11, 2025 at 04:45:26PM +0100, David Woodhouse wrote:
> > > On Thu, 2025-02-13 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > > > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > >
> > > > [ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]
> > > >
> > > > Now that the following fix:
> > > >
> > > >   d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables")
> > > >
> > > > stops kernel_ident_mapping_init() from scribbling over the end of a
> > > > 4KiB PGD by assuming the following 4KiB will be a userspace PGD,
> > > > there's no good reason for the kexec PGD to be part of a single
> > > > 8KiB allocation with the control_code_page.
> > > >
> > > > ( It's not clear that that was the reason for x86_64 kexec doing it that
> > > >   way in the first place either; there were no comments to that effect and
> > > >   it seems to have been the case even before PTI came along. It looks like
> > > >   it was just a happy accident which prevented memory corruption on kexec. )
> > > >
> > > > Either way, it definitely isn't needed now. Just allocate the PGD
> > > > separately on x86_64, like i386 already does.
> > >
> > > No objection (which is just as well given how late I am in replying)
> > > but I'm just not sure *why*. This doesn't fix a real bug; it's just a
> > > cleanup.
> > >
> > > Does this mean I should have written my original commit message better,
> > > to make it clearer that this *isn't* a bugfix?
> >
> > Yes, that's why it was picked up.
> >
> 
> The patch has no fixes: tag and no cc:stable. The burden shouldn't be
> on the patch author to sprinkle enough of the right keywords over the
> commit log to convince the bot that this is not a suitable stable
> candidate, just because it happens to apply without conflicts.

The burden is not there to do that, this came in from the AUTOSEL stuff.
It was sent to everyone on Jan 26:
	https://lore.kernel.org/r/20250126150720.961959-3-sashal@kernel.org
so there was 1 1/2 weeks chance to say something before Sasha committed
it to the stable queue.  Then it was sent out again here in the -rc
releases for review, for anyone to object to.

So there was 3 different times someone could have said "no, this isn't
ok for stable inclusion" before it was merged.  And even if that's not
enough, I'll be glad to revert it if it wasn't ok to be merged at any
time afterward.

thanks,

greg k-h
