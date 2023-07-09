Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E134847F
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 13:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E3AC433C7;
	Sun,  9 Jul 2023 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688909543;
	bh=rwLzNnh9Owt1yY3HyQ3Mn9+3wPadnenSGXlnaindEMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RgjitRhDY8bMW8OnFuLn+MQsk4YRdo/u3XvUDSbrNrl3m3lCGtVC49M+yNJQotML6
	 CIUO/oikaUPkiegeP3ow2K7GbIJGbE69lGzhq4PSbWx8mqQxHjJGx8hjWHuqrLmZNu
	 eN3+2F6jlzgfvjiSSOeOOaA8kzfNtSlMbzBlApnw=
Date: Sun, 9 Jul 2023 15:32:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
	Jacob Young <jacobly.alt@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.4 7/8] fork: lock VMAs of the parent process when
 forking
Message-ID: <2023070904-customer-concise-e6fe@gregkh>
References: <20230709111345.297026264@linuxfoundation.org>
 <20230709111345.516444847@linuxfoundation.org>
 <c783f635-f839-638c-5e32-ef923be432ad@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c783f635-f839-638c-5e32-ef923be432ad@leemhuis.info>

On Sun, Jul 09, 2023 at 02:39:00PM +0200, Thorsten Leemhuis wrote:
> On 09.07.23 13:14, Greg Kroah-Hartman wrote:
> > From: Suren Baghdasaryan <surenb@google.com>
> > 
> > commit 2b4f3b4987b56365b981f44a7e843efa5b6619b9 upstream.
> > 
> > Patch series "Avoid memory corruption caused by per-VMA locks", v4.
> > 
> > A memory corruption was reported in [1] with bisection pointing to the
> > patch [2] enabling per-VMA locks for x86.  Based on the reproducer
> > provided in [1] we suspect this is caused by the lack of VMA locking while
> > forking a child process.
> > [...]
> 
> Question from someone that is neither a C nor a git expert -- and thus
> might say something totally stupid below (and thus maybe should not have
> sent this mail at all).
> 
> But I have to wonder: is adding this patch to stable necessary given
> patch 8/8?
> 
> FWIW, this change looks like this:
> 
> > ---
> >  kernel/fork.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -662,6 +662,12 @@ static __latent_entropy int dup_mmap(str
> >  		retval = -EINTR;
> >  		goto fail_uprobe_end;
> >  	}
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +	/* Disallow any page faults before calling flush_cache_dup_mm */
> > +	for_each_vma(old_vmi, mpnt)
> > +		vma_start_write(mpnt);
> > +	vma_iter_set(&old_vmi, 0);
> > +#endif
> >  	flush_cache_dup_mm(oldmm);
> >  	uprobe_dup_mmap(oldmm, mm);
> >  	/*
> 
> But when I look at kernel/fork.c in mainline I can't see this bit. I
> also only see Linus' change (e.g. patch 8/8 in this series) when I look at
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/kernel/fork.c

Look at 946c6b59c56d ("Merge tag 'mm-hotfixes-stable-2023-07-08-10-43'
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")

Where Linus manually dropped those #ifdefs.

Hm, I'll leave them for now in 6.4.y as that is "safer", but if Suren
feels comfortable, I'll gladly take a patch from him to drop them in the
6.4.y tree as well.

thanks,

greg k-h
