Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C73EDAA8;
	Wed, 16 Sep 2026 06:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541717; cv=none; b=lmKBIVpCY3nGnDwk6c/Jvc0knvLGnP0QAWBWKqZPqNVXDOviIS3sc3/466ndtXEwDRRR5hXJH7lXIzKhmeT1w8EmyO8b76/uQud55lG+dNqKd96VfMEwAq72AxEDfaHfD26Y+oWZWYGMyEqoi1cOXxRnXD6TYLDJh75KhyWZ1A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541717; c=relaxed/simple;
	bh=P9v54+ui7QhSMAmAfRAibu6qJoLwMlVEd7oYRK/IATc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SanacLe6phFirmkXcA6AuICerHsOTzCE8V2AP3yLNxefuG6w3NHEcXtHrjX7o/npe1kj7OAkmsHufVggfizMHiCYJ+ryiCHHeRlLi4JG+a7pg205fMdgbQNqs+oERpcv8d2x/kNc3HgWm+nNsuBxt0Ce8A5eN0DPMW9Efdm54bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frpeuUsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frpeuUsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16E41F000FF;
	Wed, 16 Sep 2026 06:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789541715;
	bh=mjUupbzWSCsUc3Eo8gNXqz1Xz3FacDGQ5/FZ+4ZSKDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=frpeuUslxgp2PTA7GclDK0aUI1pGLWawLCPXJqawnvvGZ08hWZo9arsldHXpALopC
	 9Y92CwSAZI5XMxb5mZTfo+c9BURPyX8IkLEmcTLDgkDQ3cpJ4JbJ0IUorad4alt6jj
	 E9Kals9TPzFEby1SFV1KiWlBcZrZ3t5JdOSaJ/LU=
Date: Wed, 16 Sep 2026 08:53:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Zi Yan <ziy@nvidia.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 0069/1376] mm/mempolicy: fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
Message-ID: <2026091606-tuition-language-fa09@gregkh>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065609.097044562@linuxfoundation.org>
 <f80a9a46-930b-4c62-81b4-20cca6726e84@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f80a9a46-930b-4c62-81b4-20cca6726e84@oracle.com>

On Wed, Sep 16, 2026 at 12:04:22PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 12/09/26 12:11 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > commit 540e583b66d6402bf556fde5e53c817a54c1afe5 upstream.
> > 
> > syzbot reported a sleeping function called from invalid context splat in
> > bucket_table_alloc().
> > 
> > When rhashtable_insert_slow() rehashes the table under rcu_read_lock(), it
> > calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).  If the bucket
> > table allocation uses vmalloc, __vmalloc_node_range_noprof() invokes
> > vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with the
> > passed GFP_ATOMIC flags.
> > 
> > If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
> > alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
> > GFP_KERNEL when allocating the temporary weights array, triggering a
> > might_alloc() splat in atomic/RCU contexts.
> > 
> > Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
> > zone modifiers like __GFP_HIGHMEM) received by
> > alloc_pages_bulk_weighted_interleave() to kmalloc() instead of hardcoding
> > GFP_KERNEL.  Since the weights buffer is immediately initialized in full,
> > kmalloc() is sufficient.
> > 
> > Link: https://lore.kernel.org/20260821170407.3721004-1-edumazet@google.com
> > Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
> > Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> > Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Byungchul Park <byungchul@sk.com>
> > Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
> > Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Cc: Matthew Brost <matthew.brost@intel.com>
> > Cc: Rakie Kim <rakie.kim@sk.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   mm/mempolicy.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2438,7 +2438,7 @@ static unsigned long alloc_pages_bulk_ar
> >   	prev_node = node;
> >   	/* create a local copy of node weights to operate on outside rcu */
> > -	weights = kzalloc(nr_node_ids, GFP_KERNEL);
> > +	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
> 
> 
> I ran an AI-assisted backport review and I have checked the issue.
> 
> The patch correctly propagates the caller's GFP reclaim flags, but it
> also changes the 6.12 scratch allocation from kzalloc() to kmalloc().
> Upstream does that only after e341f9c3c841 initializes every weight
> through the new auto-tuning state. That change is absent from 6.12.
> 
> On this branch, a NULL iw_table is the normal default. The copy is
> skipped, and the code reads each uninitialized byte before converting
> only zero values to weight one.
> 
> Upstream code after e341f9c3c841:
> 
>     state = rcu_dereference(wi_state);
>     if (state)
>             memcpy(weights, state->iw_table,
>                    nr_node_ids * sizeof(u8));
>     else
>             for (i = 0; i < nr_node_ids; i++)
>                     weights[i] = 1;
> 
> Downstream 6.12.y code:
> 
>     table = rcu_dereference(iw_table);
>     if (table)
>             memcpy(weights, table, nr_node_ids);
> 
> The downstream NULL-table path leaves every byte uninitialized.
> 
> I suggest retaining the GFP fix but changing the allocation to
> kzalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK). Thoughts?

Sounds correct, good catch.  Can you send a patch to do this?

thanks,

greg k-h
