Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDA828C862;
	Wed,  7 May 2025 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746640812; cv=none; b=GQycDtgl1/TiTG4CCaBMUt7jKflDZGBLC5TZa/wuykSwRJOxLb4jjPq69vHLAcVIH57eHUtLcqALNPnuLBOs8vAelJvo6YJprK9HZkJg1TWGGL9GLem1FMMK3kTHX5aREt3i4c7+irA4/DSKAxvH1PPfXF4AtMByCbj6jKwP2sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746640812; c=relaxed/simple;
	bh=O9c4zHMMjar77PSV4nlSZq5tG5VfvUp5AHlm0Gab6vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cn9hgsHlKZ5MAnJtaJfhtUhDyCzb6Durya/wPt/mi+KKnOLYECjeEajdPEtk3dAGYv2MNZbzZd/8+HXTh1n4t+Gqa2iTfIeOtBzWIU6qnSBDOZmnOlSE8SStkXe5Tkplzeg4+xtIlZVJMfDS2cqPXLeK3Nw34Rb1nGZvnP+mY14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIL2Z/MT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIL2Z/MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF14C4CEE2;
	Wed,  7 May 2025 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746640810;
	bh=O9c4zHMMjar77PSV4nlSZq5tG5VfvUp5AHlm0Gab6vY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vIL2Z/MTTBN5AA+dfj/e5vNshsFvg/TvI3i/9hlDaVgujU3F76WXM/KdCs1DCG2TY
	 WXIN2AwyRBvzpfOk9g7vKXLCBqLMsuEW6P+Hs5CuNtlSIj3GEHzkc8Ho5+zsuh9v5U
	 TeQynncMmxg8hT4OTJEJlJun4Qq4l5QwxfUicsGk=
Date: Wed, 7 May 2025 20:00:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 102/311] sched/eevdf: Fix se->slice being set to
 U64_MAX and resulting crash
Message-ID: <2025050749-refill-overfill-20cb@gregkh>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161125.215831187@linuxfoundation.org>
 <aBubqcsiWmEK0NRg@telecaster>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBubqcsiWmEK0NRg@telecaster>

On Wed, May 07, 2025 at 10:43:05AM -0700, Omar Sandoval wrote:
> On Tue, Apr 29, 2025 at 06:38:59PM +0200, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > [ Upstream commit bbce3de72be56e4b5f68924b7da9630cc89aa1a8 ]
> > 
> > There is a code path in dequeue_entities() that can set the slice of a
> > sched_entity to U64_MAX, which sometimes results in a crash.
> > 
> > The offending case is when dequeue_entities() is called to dequeue a
> > delayed group entity, and then the entity's parent's dequeue is delayed.
> > In that case:
> > 
> > 1. In the if (entity_is_task(se)) else block at the beginning of
> >    dequeue_entities(), slice is set to
> >    cfs_rq_min_slice(group_cfs_rq(se)). If the entity was delayed, then
> >    it has no queued tasks, so cfs_rq_min_slice() returns U64_MAX.
> > 2. The first for_each_sched_entity() loop dequeues the entity.
> > 3. If the entity was its parent's only child, then the next iteration
> >    tries to dequeue the parent.
> > 4. If the parent's dequeue needs to be delayed, then it breaks from the
> >    first for_each_sched_entity() loop _without updating slice_.
> > 5. The second for_each_sched_entity() loop sets the parent's ->slice to
> >    the saved slice, which is still U64_MAX.
> > 
> > This throws off subsequent calculations with potentially catastrophic
> > results. A manifestation we saw in production was:
> > 
> > 6. In update_entity_lag(), se->slice is used to calculate limit, which
> >    ends up as a huge negative number.
> > 7. limit is used in se->vlag = clamp(vlag, -limit, limit). Because limit
> >    is negative, vlag > limit, so se->vlag is set to the same huge
> >    negative number.
> > 8. In place_entity(), se->vlag is scaled, which overflows and results in
> >    another huge (positive or negative) number.
> > 9. The adjusted lag is subtracted from se->vruntime, which increases or
> >    decreases se->vruntime by a huge number.
> > 10. pick_eevdf() calls entity_eligible()/vruntime_eligible(), which
> >     incorrectly returns false because the vruntime is so far from the
> >     other vruntimes on the queue, causing the
> >     (vruntime - cfs_rq->min_vruntime) * load calulation to overflow.
> > 11. Nothing appears to be eligible, so pick_eevdf() returns NULL.
> > 12. pick_next_entity() tries to dereference the return value of
> >     pick_eevdf() and crashes.
> > 
> > Dumping the cfs_rq states from the core dumps with drgn showed tell-tale
> > huge vruntime ranges and bogus vlag values, and I also traced se->slice
> > being set to U64_MAX on live systems (which was usually "benign" since
> > the rest of the runqueue needed to be in a particular state to crash).
> > 
> > Fix it in dequeue_entities() by always setting slice from the first
> > non-empty cfs_rq.
> > 
> > Fixes: aef6987d8954 ("sched/eevdf: Propagate min_slice up the cgroup hierarchy")
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Link: https://lkml.kernel.org/r/f0c2d1072be229e1bdddc73c0703919a8b00c652.1745570998.git.osandov@fb.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  kernel/sched/fair.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Hi,
> 
> I believe this fix should go in 6.12, too.

Great, can you submit a version that applies to 6.12.y?

thanks,

greg k-h
