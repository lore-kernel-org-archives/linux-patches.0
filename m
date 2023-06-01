Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250AE47017;
	Thu,  1 Jun 2023 18:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E854FC433EF;
	Thu,  1 Jun 2023 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685643532;
	bh=/pASa9nYu0GQ6X+4TGm6dsvrDfwDZ84co19JC4bfX/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zzz8x779rci/K4PmAn5tV9wPzZKfQLkoeR9XIFYcEemkcUe3zBFqr4gP6ar2K3ZL6
	 P7xh7ugxWXobjq21GjLofnOIkP9cZg9i3lIzk16L0KjNN+PfxcbddjJW38cpCpzjTN
	 7u8rHTrR2t0wT+FxL4/7P9cYKCYxYeRuSTC9wxpA3tJt0a9FkW9N5Om7H5nf7RPPRU
	 7RfxB84DZt1MnPhZq6sLD9+4ctbszfKnUe5zlHxHjRTs6tyowv08o0MtetYDW/4vVY
	 iFNnPUMHvcQIpSypAcPXSKg30UaxreFNvUH1AdyXdYw/qcJlgT8EOC5U90TenX8jGZ
	 w/m/gPWP6J7uw==
Date: Thu, 1 Jun 2023 11:18:49 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org,
	vitaly.wool@konsulko.com, ndesaulniers@google.com, trix@redhat.com,
	nphamcs@gmail.com, linux-mm@kvack.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] zswap: Avoid uninitialized use of ret in
 zswap_frontswap_store()
Message-ID: <20230601181849.GA1528196@dev-arch.thelio-3990X>
References: <20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org>
 <CAJD7tkYZxbEyP6-yjcobws_6Cvjib9c9YnBQRBjhwrK3KaHs7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJD7tkYZxbEyP6-yjcobws_6Cvjib9c9YnBQRBjhwrK3KaHs7A@mail.gmail.com>

On Thu, Jun 01, 2023 at 11:09:48AM -0700, Yosry Ahmed wrote:
> On Thu, Jun 1, 2023 at 8:26 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Clang warns:
> >
> >   mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
> >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   mm/zswap.c:1327:9: note: uninitialized use occurs here
> >    1327 |         return ret;
> >         |                ^~~
> >   mm/zswap.c:1183:2: note: remove the 'if' if its condition is always false
> >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    1184 |                 goto reject;
> >         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence this warning
> >    1158 |         int ret;
> >         |                ^
> >         |                 = 0
> >   1 error generated.
> >
> > Set ret to -EINVAL, which seems to best match the situation the comment
> > mentions and matches an earlier bailout due to an unsupported type or
> > situation.
> 
> Shouldn't this be -ENOMEM? I think this was the error code returned in
> this situation before 6804144bf1cf.

Sure, I can update this to be -ENOMEM if that is appropriate. I am not
sure it actually matters though, since as far as I can tell, this
function is only called via the ->store() call in __frontswap_store(),
which is only called by frontswap_store(), which in turn is only called by
swap_writepage() and its return value is only checked against 0, no
other error values. I could be missing a macro call though.

If I should send a v2, please let me know.

Cheers,
Nathan

> > Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
> > Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  mm/zswap.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index cff93643a6ab..e8313e2f5807 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
> >          * local cgroup limits.
> >          */
> >         objcg = get_obj_cgroup_from_page(page);
> > -       if (objcg && !obj_cgroup_may_zswap(objcg))
> > +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > +               ret = -EINVAL;
> >                 goto reject;
> > +       }
> >
> >         /* reclaim space if needed */
> >         if (zswap_is_full()) {
> >
> > ---
> > base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
> > change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff4247ed
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
> >
