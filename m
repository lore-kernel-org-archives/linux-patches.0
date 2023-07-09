Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4547F
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 20:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36751C433C7;
	Sun,  9 Jul 2023 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688935222;
	bh=bSBXScpQWcIYO/vOzohwlFpd5i6Ux9Hst0tZxUo+O3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uagZ08FGTUn+dSuMOyud83ue+PZTcWcs9xWqMxMk0VpjFTFyLWcZx2gv6xgbI+vNx
	 Qi99ie7SPlDtZGBgjZh5zcb6kE5iZYNh8dLJLau7osM+8Lf5HdpoHh2ZigWrYE5fez
	 MZhi/sHxYnXhDlMrFFKEpqn81fYky5YjapluZSHs=
Date: Sun, 9 Jul 2023 22:40:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, David Hildenbrand <david@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
	Jacob Young <jacobly.alt@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.4 7/8] fork: lock VMAs of the parent process when
 forking
Message-ID: <2023070915-preformed-comprised-9d47@gregkh>
References: <20230709111345.297026264@linuxfoundation.org>
 <20230709111345.516444847@linuxfoundation.org>
 <c783f635-f839-638c-5e32-ef923be432ad@leemhuis.info>
 <2023070904-customer-concise-e6fe@gregkh>
 <CAJuCfpFfc7tvv9CPMx=1b=X-1foiDZ+0bXkVUsFekWB_zNUnLw@mail.gmail.com>
 <2023070931-conjuror-dweeb-bb4b@gregkh>
 <CAJuCfpHgq_2sZVw7Vv9TuNgBHLO_9f_KAmQ73kFY+093GdMfRg@mail.gmail.com>
 <CAJuCfpGjXWYzUFdje=ZvTxFmTR5NoXAhXO4y5ZEEsFAihbZpYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGjXWYzUFdje=ZvTxFmTR5NoXAhXO4y5ZEEsFAihbZpYg@mail.gmail.com>

On Sun, Jul 09, 2023 at 08:24:29PM +0000, Suren Baghdasaryan wrote:
> On Sun, Jul 9, 2023 at 7:53 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Sun, Jul 9, 2023 at 7:48 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sun, Jul 09, 2023 at 09:04:09AM -0700, Suren Baghdasaryan wrote:
> > > > On Sun, Jul 9, 2023 at 6:32 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Sun, Jul 09, 2023 at 02:39:00PM +0200, Thorsten Leemhuis wrote:
> > > > > > On 09.07.23 13:14, Greg Kroah-Hartman wrote:
> > > > > > > From: Suren Baghdasaryan <surenb@google.com>
> > > > > > >
> > > > > > > commit 2b4f3b4987b56365b981f44a7e843efa5b6619b9 upstream.
> > > > > > >
> > > > > > > Patch series "Avoid memory corruption caused by per-VMA locks", v4.
> > > > > > >
> > > > > > > A memory corruption was reported in [1] with bisection pointing to the
> > > > > > > patch [2] enabling per-VMA locks for x86.  Based on the reproducer
> > > > > > > provided in [1] we suspect this is caused by the lack of VMA locking while
> > > > > > > forking a child process.
> > > > > > > [...]
> > > > > >
> > > > > > Question from someone that is neither a C nor a git expert -- and thus
> > > > > > might say something totally stupid below (and thus maybe should not have
> > > > > > sent this mail at all).
> > > > > >
> > > > > > But I have to wonder: is adding this patch to stable necessary given
> > > > > > patch 8/8?
> > > > > >
> > > > > > FWIW, this change looks like this:
> > > > > >
> > > > > > > ---
> > > > > > >  kernel/fork.c |    6 ++++++
> > > > > > >  1 file changed, 6 insertions(+)
> > > > > > >
> > > > > > > --- a/kernel/fork.c
> > > > > > > +++ b/kernel/fork.c
> > > > > > > @@ -662,6 +662,12 @@ static __latent_entropy int dup_mmap(str
> > > > > > >             retval = -EINTR;
> > > > > > >             goto fail_uprobe_end;
> > > > > > >     }
> > > > > > > +#ifdef CONFIG_PER_VMA_LOCK
> > > > > > > +   /* Disallow any page faults before calling flush_cache_dup_mm */
> > > > > > > +   for_each_vma(old_vmi, mpnt)
> > > > > > > +           vma_start_write(mpnt);
> > > > > > > +   vma_iter_set(&old_vmi, 0);
> > > > > > > +#endif
> > > > > > >     flush_cache_dup_mm(oldmm);
> > > > > > >     uprobe_dup_mmap(oldmm, mm);
> > > > > > >     /*
> > > > > >
> > > > > > But when I look at kernel/fork.c in mainline I can't see this bit. I
> > > > > > also only see Linus' change (e.g. patch 8/8 in this series) when I look at
> > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/kernel/fork.c
> > > > >
> > > > > Look at 946c6b59c56d ("Merge tag 'mm-hotfixes-stable-2023-07-08-10-43'
> > > > > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")
> > > > >
> > > > > Where Linus manually dropped those #ifdefs.
> > > > >
> > > > > Hm, I'll leave them for now in 6.4.y as that is "safer", but if Suren
> > > > > feels comfortable, I'll gladly take a patch from him to drop them in the
> > > > > 6.4.y tree as well.
> > > >
> > > > Hi Greg,
> > > > Give me a couple hours to get back to my computer. Linus took a
> > > > different version of this patch and changed the description quite a
> > > > bit. Once I'm home I can send you the patchset that was merged into
> > > > his tree. Also let me know if you want to disable CONFIG_PER_VMA_LOCK
> > > > in the stable branch (the patch called "[PATCH 6.4 1/8] mm: disable
> > > > CONFIG_PER_VMA_LOCK until its fixed" which Linus did not take AFAIKT).
> > >
> > > No rush, you can do this on Monday.
> > >
> > > I took the patches that Linus added to his tree already into the stable
> > > 6.4.y tree, and it's in the -rc release I pushed out a few hours ago.
> >
> > I just checked your stable master branch and it's perfectly in sync
> > with Linus' tree.
> >
> > >
> > > So if you want to look at the -rc release, that would be great, the full
> > > list of patches can be seen here:
> > >         https://lore.kernel.org/r/20230709111345.297026264@linuxfoundation.org
> >
> > Let me sync git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > to see what's happening there.
> 
> Ok, I'm looking at the linux-6.4.y branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> 
> This patch is not needed (obsolete):
> 32d458fa68fe ("fork: lock VMAs of the parent process when forking")

Ok, I can drop that.

> Patch fb49c455323f ("fork: lock VMAs of the parent process when
> forking, again") can be renamed into "fork: lock VMAs of the parent
> process when forking" as its original.

Yes, I had to rename it, git doesn't like patches with identical names.

> Patch 11eaf9aa0699 ("mm: disable CONFIG_PER_VMA_LOCK until its fixed")
> was removed in Linus' tree, see comment in
> 946c6b59c56dc6e7d8364a8959cb36bf6d10bc37 saying: "The merge undoes the
> disabling of the CONFIG_PER_VMA_LOCK feature, since it was all
> hopefully fixed in mainline.". Unless you want to keep
> CONFIG_PER_VMA_LOCK disabled in the stable tree, that patch should
> also be dropped.

Ok, let me drop this too.

I'll push out a -rc2 with these changes, let me go work on it now...

thanks,

gre gk-h
