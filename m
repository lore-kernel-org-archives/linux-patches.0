Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B6053A5;
	Thu, 29 Sep 2022 16:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FDCC433D6;
	Thu, 29 Sep 2022 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664470402;
	bh=OTCJDDYmogsWoBsRnQwhGbY0Cu0/Bl2M4UiySUYJ8gU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qR9F3j97WWgZnCrPk0dLVer0gHaXTYv55tRkVfNOyJMbhUhe4Fk0GBw28xacW6ogD
	 iqJ0UuB7VHQnoAQhhDaIxxQiiBUcA+xHoRiMz+92WDgoN51UeP0v4uy7Fp4ne6sFzh
	 tfHwZ13qMAm5zQwA9yZJfJU7VGNZH7S6wzAIvo4PM2UpTHCSQrAZXPHVVh/EQfdiUc
	 Thj+MiMAG3/y7/lA06QcBuMN9GrZKOsv2Y45eufyMuBRMiwRtOGAeazreAmfwyn6R/
	 jLyXZjF0If4UGZZ+XRo4vmLcEzdVXVkl+EHR3ZXRRrz9q4TZDvRY3yem0CHaCUwl+b
	 9tKBAqSKgYaSQ==
Date: Thu, 29 Sep 2022 09:53:19 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
	Tom Rix <trix@redhat.com>, intel-gfx@lists.freedesktop.org,
	Nick Desaulniers <ndesaulniers@google.com>, patches@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix CFI violations in gt_sysfs
Message-ID: <YzXNf859huM45MdK@dev-arch.thelio-3990X>
References: <20220922195127.2607496-1-nathan@kernel.org>
 <202209232143.172BCCDC4@keescook>
 <Yy/bglnYjnFfjDDI@dev-arch.thelio-3990X>
 <YzXL6v3VAVUMiYO0@ashyti-mobl2.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzXL6v3VAVUMiYO0@ashyti-mobl2.lan>

On Thu, Sep 29, 2022 at 06:46:34PM +0200, Andi Shyti wrote:
> Hi Nathan,
> 
> thanks for this refactoring... looks good even though i would
> have split it in more patches as this is doing quite many things.

Right, sorry about that :/ I initially thought the problem was much
simpler and the diff was more reasonable before I truly saw what was
happening and by that point, trying to break things apart felt like
navigating a mine field. I will definitely keep that in mind for the
future though.

> But I will not be stubborn, I understand that it's not trivial to
> have things split. I will give my r-b for now but I will check it
> again before applying it as it's very easy to get tangled-up in
> between all those defines:
> 
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Appreciate it! I don't have access to some of the hardware that is
special cased in this code so I definitely would not mind some
additional eyes and testing for this change.

> For now I'm quite surprised to see how easily our CI gives green
> lights :-P
> 
> On Sat, Sep 24, 2022 at 09:39:30PM -0700, Nathan Chancellor wrote:
> > On Fri, Sep 23, 2022 at 09:57:47PM -0700, Kees Cook wrote:
> > > On Thu, Sep 22, 2022 at 12:51:27PM -0700, Nathan Chancellor wrote:
> > > > [...]
> > > > To make everything work properly, adjust certain functions to match the
> > > > type of the ->show() and ->store() members in 'struct kobj_attribute'.
> > > > Add a macro to generate functions for that can be called via both
> > > > dev_attr_{show,store}() or kobj_attr_{show,store}() so that they can be
> > > > called through both kobject locations without violating kCFI and adjust
> > > > the attribute groups to account for this.
> > > 
> > > This was quite a roller coaster! I think the solution looks good, even
> > > if I'm suspicious of the original design that has the same stuff
> > > available twice in different places. (I have a dim memory of rdma
> > > needing a refactoring like this too?)
> > 
> > Right, I noticed this comment in intel_gt_sysfs_register() once I fully
> > saw what was going on:
> > 
> > 	/*
> > 	 * We need to make things right with the
> > 	 * ABI compatibility. The files were originally
> > 	 * generated under the parent directory.
> > 	 *
> > 	 * We generate the files only for gt 0
> > 	 * to avoid duplicates.
> > 	 */
> > 
> > Makes it seem like there will be userspace breakage if these files do
> > not exist? I figured this was the cleanest solution within those
> > parameters.
> 
> i915 went multi-gt (multitile) so that some interfaces, like the
> power management files, have effect only on one of the tiles.
> This means that we needed to move some of the files inside the
> newly created gt0/gt1 directory.
> 
> But, because some of those files are part of an ABI
> specification, we can't simply transfer them from the original
> position so that we needed to make a "hard" copy (actually the
> original files now take the role of affecting all the GTs instead
> of only one).
> 
> The complexity of this file comes from the necessity of
> minimizing code duplication, otherwise we could have had two
> perfectly identical files (which looking at the final result it
> wouldn't have been a completely bad idea after all).
> 
> Thanks again, will let you know when I will get this into our
> branch.

Ah, that all makes sense, good to know that this solution will allow all
of that to continue to work.

If there are any issues or further comments, I am happy to follow up in
whatever way I need to. Thanks again for the review and tentative
acceptance!

Cheers,
Nathan
