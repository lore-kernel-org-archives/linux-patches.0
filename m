Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5131B6CF1;
	Wed, 12 Mar 2025 08:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741769711; cv=none; b=ufHJPabCJteXxC0pxCEAt5EwMgl5zjJ+rYAXMVSedwUuwCZsCDqMrt/6s3WK16sbnU7OVruiNK7Z4rH/RjvY32mZskc46uKQ+vMFxc8gHgvJ31DtzNFS9b/jgHyXp86BcBOqmOITSQkmj3rS6VlcnjSnnfx39TPvCu0u0ajhSRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741769711; c=relaxed/simple;
	bh=S1tFmuXwGba1cP+NtLc50X0fV+fYWhECovNzMFafSUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAjMbfSEVhjHsgbYEGOePH2P3o1yyB48X6P+/ho5cC300WHuKE6RGTNrz88ui6/8SrD/EIavTkgiJQDNSEkDdnoy+p1mqNRwSpPF8KNx3niPm7hpyQVkyvhKqJea+tZY7ykbltM9oZYMuZWqg4esAmUA2TMeUODpe3JKrcrDfOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkYlsS2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkYlsS2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADBEC4CEE3;
	Wed, 12 Mar 2025 08:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741769710;
	bh=S1tFmuXwGba1cP+NtLc50X0fV+fYWhECovNzMFafSUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkYlsS2w3Cs4I5KMVQgmx7RuT/R5QlhPnW2BCqDaUrJug92bdyIPPjCUYgZdk4T8g
	 3ztoLBveYNRQc1qw8jkyYyP3u7tP4wHmYlA7UFewk+N6N8n0xTpVqV8yzZowlwHpNJ
	 wuGRY1U0HTP7f+TUTAEXIMy0mDH1STSi9b+J0ieA=
Date: Wed, 12 Mar 2025 09:55:07 +0100
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
Message-ID: <2025031235-universal-volumes-a2ce@gregkh>
References: <20250213142440.609878115@linuxfoundation.org>
 <20250213142444.044525855@linuxfoundation.org>
 <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org>
 <2025031203-scoring-overpass-0e1a@gregkh>
 <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>
 <2025031218-cardboard-pushcart-4211@gregkh>
 <CAMj1kXG6HRbQG2XJk=-TOZpDsKMAeVZ0=JO=8KLZ0-YFu2v_tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG6HRbQG2XJk=-TOZpDsKMAeVZ0=JO=8KLZ0-YFu2v_tw@mail.gmail.com>

On Wed, Mar 12, 2025 at 09:31:47AM +0100, Ard Biesheuvel wrote:
> On Wed, 12 Mar 2025 at 09:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Mar 12, 2025 at 08:54:52AM +0100, Ard Biesheuvel wrote:
> > > On Wed, 12 Mar 2025 at 08:47, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Mar 11, 2025 at 04:45:26PM +0100, David Woodhouse wrote:
> > > > > On Thu, 2025-02-13 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > > > > > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > > > > >
> > > > > > ------------------
> > > > > >
> > > > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > > >
> > > > > > [ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]
> > > > > >
> > > > > > Now that the following fix:
> > > > > >
> > > > > >   d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables")
> > > > > >
> > > > > > stops kernel_ident_mapping_init() from scribbling over the end of a
> > > > > > 4KiB PGD by assuming the following 4KiB will be a userspace PGD,
> > > > > > there's no good reason for the kexec PGD to be part of a single
> > > > > > 8KiB allocation with the control_code_page.
> > > > > >
> > > > > > ( It's not clear that that was the reason for x86_64 kexec doing it that
> > > > > >   way in the first place either; there were no comments to that effect and
> > > > > >   it seems to have been the case even before PTI came along. It looks like
> > > > > >   it was just a happy accident which prevented memory corruption on kexec. )
> > > > > >
> > > > > > Either way, it definitely isn't needed now. Just allocate the PGD
> > > > > > separately on x86_64, like i386 already does.
> > > > >
> > > > > No objection (which is just as well given how late I am in replying)
> > > > > but I'm just not sure *why*. This doesn't fix a real bug; it's just a
> > > > > cleanup.
> > > > >
> > > > > Does this mean I should have written my original commit message better,
> > > > > to make it clearer that this *isn't* a bugfix?
> > > >
> > > > Yes, that's why it was picked up.
> > > >
> > >
> > > The patch has no fixes: tag and no cc:stable. The burden shouldn't be
> > > on the patch author to sprinkle enough of the right keywords over the
> > > commit log to convince the bot that this is not a suitable stable
> > > candidate, just because it happens to apply without conflicts.
> >
> > The burden is not there to do that, this came in from the AUTOSEL stuff.
> 
> Yeah, that is what I figured. Can we *please* stop doing stupid stuff
> like that for arch code, especially arch/x86, which is well looked
> after? (In my personal opinion, we should not be using AUTOSEL at all,
> but that seems to be a lost battle)
> 
> Especially for this patch in particular, which touches the kexec code,
> which is easy to break and difficult to fix. Whether the patch applies
> without breaking the build is entirely irrelevant (and even that seems
> a high bar for stable trees these days). Nobody should be touching any
> of that code without actually testing whether or not kexec still
> works.

Maintainers can ask for their portions of the kernel to be not included
in the AUTOSEL work, and many have, please see:
	https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list
for the current list of things that are excluded.

> > It was sent to everyone on Jan 26:
> >         https://lore.kernel.org/r/20250126150720.961959-3-sashal@kernel.org
> > so there was 1 1/2 weeks chance to say something before Sasha committed
> > it to the stable queue.  Then it was sent out again here in the -rc
> > releases for review, for anyone to object to.
> >
> 
> There should not be a need for people to object to something that no
> actual person ever suggested in the first place.
> 
> The only responsible way to use AUTOSEL is to make it opt-in rather
> than opt-out. And I object to the idea that it is ok for someone like
> Sasha to run a bot that generates lots of emails to lots of people,
> and put the burden on everyone else to spend actual time and mental
> effort to go over all those patches and decide whether or not they
> might the stable candidates, especially without any due diligence
> whatsoever regarding whether the resulting kernel still boots and runs
> correctly on a system that actually exercises the updated code.

That does not work at all.  The whole reason AUTOSEL is used is because
maintainers and developers are NOT tagging things that are bugfixes.  We
have whole subsystems that just don't do anything, and this is the only
way we can get fixes for that area included in stable kernels.

Again, we allow any subsystem to opt-out entirely from this if they so
desire, AND we allow many chances for a patch to be dropped, AND we
later allow anything to be reverted.  Heck, we have maintainers who just
don't want to deal with stable kernels at all, and that's fine, I'm not
going to impose that burden on them if they do not want to.  But in that
case, we will do spelunking through the tree to find stuff that affects
users.

If you look at the history of AUTOSEL, I think the number of real bugs
has shown that overall, it works really well.  Sure it will mess up at
times, we're all human, and all we can do then is to be sure to react
and fix the issue.

thanks,

greg k-h
