Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE8C1422B6;
	Tue,  2 Jul 2024 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719909953; cv=none; b=H1o3icQ2aOA5cXbpI2QN7ObzpMldg61eseFaEPzccfWRu64Wx7ThG1xlFIfdc82wYJLAPwAx6XNqyYsCVxIrvs7BkpqV6StfOELLLgoId+3nsLcLR/cVo77BW/P8HKoFpJIzwkBlqrIASS9/ZghvTKGSKlA9rod2v6YvvZ6MSsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719909953; c=relaxed/simple;
	bh=wN7nLr5g8OWfLd9JxjThm58AuieO0Be3KqXojcePWpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKfpu6ZqRt4M3cwHwd+FcJm+TrGZe8ihAa3g9s+tjWS0M/fliQIpKx7c5lcbl1YMQsAjEXjaakGXXi9C+NKL/cST9nadXRDV47MTwrWT527BQ4G1zjw0EhzipokG1qrer9uxwwJIKO9Fcxv+MkDjczhJZn5V0eKT6Pwnnw6sep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTMDNtGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTMDNtGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023E8C4AF0A;
	Tue,  2 Jul 2024 08:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719909952;
	bh=wN7nLr5g8OWfLd9JxjThm58AuieO0Be3KqXojcePWpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uTMDNtGmnChj3KkoSO6BUXXo+bY4wkZHzMrQPFixdXl8j89nXxDBdbidvO1Jl+pFU
	 xJ/3qV3jOBVBqsZX/Yxdcj097r/4LjIctETJYWWEXkqSwJlpMBvZUT8sUqn+SWyeQw
	 WOo4J0lZX93rwLdzjrK0BWwGB7AxUePzDE8JmbUI=
Date: Tue, 2 Jul 2024 10:45:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dave Airlie <airlied@gmail.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	tursulin@ursulin.net, Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <2024070214-postcard-unfrosted-4bd7@gregkh>
References: <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
 <2024061946-salvaging-tying-a320@gregkh>
 <ZnqyFRf9zPa4kfwL@intel.com>
 <2024062502-corporate-manned-1201@gregkh>
 <87ed8ldwjv.fsf@intel.com>
 <2024062537-panorama-sled-3025@gregkh>
 <ZnsUKiEiZEACancl@intel.com>
 <2024062517-elderly-rocky-cb20@gregkh>
 <wouigp72ijw5yoc534fg6zdgniyzw4ph54z5c75geizsyj67ud@tmvbqkflcbsf>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <wouigp72ijw5yoc534fg6zdgniyzw4ph54z5c75geizsyj67ud@tmvbqkflcbsf>

On Thu, Jun 27, 2024 at 06:32:37PM -0500, Lucas De Marchi wrote:
> On Tue, Jun 25, 2024 at 10:12:05PM GMT, Greg Kroah-Hartman wrote:
> > On Tue, Jun 25, 2024 at 03:02:02PM -0400, Rodrigo Vivi wrote:
> > > > > >> >
> > > > > >> > > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> > > > > >> >
> > > > > >> > Would help out here, but it doesn't.
> > > > > >>
> > > > > >> I wonder if there would be a way of automate this on stable scripts
> > > > > >> to avoid attempting a cherry pick that is already there.
> > > > > >
> > > > > > Please tell me how to do so.
> > > > > >
> > > > > >> But I do understand that any change like this would cause a 'latency'
> > > > > >> on the scripts and slow down everything.
> > > > > >
> > > > > > Depends, I already put a huge latency on drm stable patches because of
> > > > > > this mess.  And I see few, if any, actual backports for when I report
> > > > > > FAILED stable patches, so what is going to get slower than it currently
> > > > > > is?
> > > 
> > > My thought was on the stable scripts doing something like that.
> > > 
> > > For each candidate commit, check if it has the tag line
> > > (cherry picked from commit <original-hash>)
> > 
> > Right there, that fails with how the drm tree works.  So you are going
> > to have to come up with something else for how to check this.  Or fix
> > your process to make this work.
> > 
> > Look at the commits tagged for stable in the -rc1 merge window.  They
> > don't have the "cherry picked" wording as they were not cherry picked!
> > They were the "originals" that were cherry picked from.
> > 
> > > if so, then something like:
> > >  if git rev-parse --quiet --verify <original-hash> || \
> > >     git log --grep="cherry picked from commit <original-hash> -E --oneline >/dev/null; then
> > >             echo "One version of this patch is already in tree. Skipping..."
> > > 	    # send-email?!
> > >         else
> > >             #attempt to apply the candidate commit...
> > > 
> > > > > > Normally you all tag these cherry-picks as such.  You didn't do that
> > > > > > here or either place, so there was no way for anyone to know.  Please
> > > > > > fix that.
> > > 
> > > I'm afraid this is not accurate. Our tooling is taking care of that for us.
> > 
> > Then your tooling needs to be fixed.
> > 
> > > > > To be fair, this one seems to have been an accident. The same commit was
> > > > > cherry-picked to *two* different branches by two different people
> > > > > [1][2], and this is something we try not to do. Any cherry-picks should
> > > > > go to one tree only, it's checked by our scripts, but it's not race free
> > > > > when two people are doing this roughly at the same time.
> > > 
> > > Also I don't believe there's anything wrong here. It was a coincidence on
> > > the timing, but one is
> > > drm-xe-next-fixes-2024-05-09-1
> > > and the other
> > > drm-xe-fixes-2024-05-09
> > > 
> > > both maintained by different people at that time.
> > > 
> > > >
> > > > any cherry-pick SHOULD have the git id referenced when they are
> > > > cherry-picked, that's what the id is there for.  Please always do that.
> > > 
> > > Original commit hash is 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de
> > > 50aec9665e0b ("drm/xe: Use ordered WQ for G2H handler")
> > 
> > And that's not in Linus's tree.
> > 
> > > drm-xe-next-fixes-2024-05-09-1
> > > has commit 2d9c72f676e6 ("drm/xe: Use ordered WQ for G2H handler")
> > > which contains:
> > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> > > Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > > 
> > > drm-xe-fixes-2024-05-09
> > > has commit c002bfe644a2 ("drm/xe: Use ordered WQ for G2H handler")
> > > which contains:
> > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> > > Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> > 
> > Ok, but again, the original is not in Linus's tree.
> 
> current workflow is:
> 
> All patches go to drm-xe-next which may be targeting the next kernel
> release or the next->next. Then the fixes (and less frequently, other
> commits which are not important here) are cherry-picked by maintainers
> to the current or next kernel release. In other words, the cherry-pick
> always targets a version 1 less than the original patch.

That's fine, as long as that cherry-pick references the git id of the
original one.  Which did not happen here, and does NOT happen at all for
all drm branches (like AMD right now).

> couple of issues I see:
> 
> 1) original commit not being in Linus's tree
> 
> If you are traversing the branch and you have a "Fixes: XXXX" where XXXX
> is from a previous release, you will most likely see the "cherry picked
> from <original>" *before* the <original> commit showing up in that tree.
> 
> Examples looking at the most recent fixes in Linus's tree with
> 
> 	$ git rev-parse origin/master
> 	6d6444ba82053c716fb5ac83346202659023044e
> 
> 	$ git log --format="%h %s%n%(trailers)" -n3 --grep "^Fixes:" \
> 		6d6444ba82053c716fb5ac83346202659023044e \
> 		-- drivers/gpu/drm/xe
> 
> d21d44dbdde8 in v6.10-rc5, fixes aef4eb7c7dec from v6.9
> but f0ccd2d805e55e12b430d5d6b9acd9f891af455e is not in any tag.
> 
> 2470b141bfae in v6.10-rc4, fixes 975e4a3795d4 from v6.8
> but 6800e63cf97bae62bca56d8e691544540d945f53 is not in any tag.
> 
> cd554e1e118a in v6.10-rc4, fixes 0698ff57bf32 from v6.10-rc3
> but b321cb83a375bcc18cd0a4b62bdeaf6905cca769 is not in any tag.
> 
> Without a change in the workflow, I don't think you can rely on the
> original commit hash being present in Linus's tree, unless you wait one
> entire kernel release cycle.

Which you obviously do not want me to do as you wanted that fix in the
tree sooner.

So this is a pain, but I'm kind of used to it by now as you all seem to
like this workflow for whatever reason...

> 2) Duplicate commits with "cherry picked from ... "
> 
> This only happened because it was cherry-picked in 2 branches, both for
> current and for next kernel releases. This can only happen during the
> last rcN as drm-xe-next-fixes is only used there.
> 
> I think (2) is easier to fix: we should really add more checks in dim
> to avoid that:  if a commit is a candidate to drm-xe-fixes it should
> never be a candidate to drm-xe-next-fixes.

Please fix.

> As for (1), I don't see how it could be fixed without a workflow change.
> That would require committers to add the commits to the right branch
> rather than relying on maintainers to cherry-pick them to the -fixes
> branch after they are merged in drm-xe-next.  What dim could do is to
> automate that for the committer and figure out the branch by itself
> based on the 2 commit hashes.
> 
> For all the above I used drm-xe-* as example, but it applies to
> drm-intel-* too.
> 
> Without the fix to (2) and workflow change from (1), this situation can be
> avoided from the -stable scripts by checking if the commit or any
> cherry-pick thereof is already in the stable tree:
> 
> 	git merge-base --is-ancestor $original_commit HEAD
> 	git log -n1 --grep "^(cherry picked from commit $original_commit)"
> 
> the second search is very expensive though.... probably need to find a
> way to limit the search space.

That's still a major pain, as is your current workflow.  So until you
all fix this up, I will continue to complain as the existing way drm
patches flow into stable trees is a major pain which causes me to dread
looking at them every time.

greg k-h
