Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AB34C97;
	Tue, 28 May 2024 11:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716897523; cv=none; b=Auolt+LdTLITLbQTW9kQvYjRLox+0WLzF0aFaP7Q9ZHLonFPPrhCEMqxE206XBDKto25C3xFlBzfpnQqewJqUgbSKmSLWAL1Yzb01Z+hK4WNuQ95iXlMZI8bwo7d51g1OTWMCOf1Ko9jYQ2wfR7mG4+5PmBfMS/T16fOqZhfvVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716897523; c=relaxed/simple;
	bh=W54KWxQHpl3PzZqGGkYBStAUFhc0S0djsvP/O0XlSK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlEVQ1gCMKPyJn6J8rJA4e2K3QZ0xW3Dk79OLOzBVutHG+L7Ad5lHkcuvC6MlaazpK7YxJ3gU725IpxW+kcuv6AfZb1rhakPhrBF6r+HN57mZY3RObk7ce41xbPrSoQkNKuUN6ibobIujPmxWKMtKIIe8dy12r6LguYu8XyWmCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=BBd5r2JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BBd5r2JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2213EC3277B;
	Tue, 28 May 2024 11:58:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BBd5r2JU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1716897519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nGuYm96JeVQ572oVGzlcjPq4VFKf/Vijj/WoTvzHM4=;
	b=BBd5r2JU+wTLYuKr/OgX741kfjittztnF44jNI14mS6It+Nwu2Y9/Txm1p+DHjYld+XIT+
	pZnU3NwQ63QIXeTPIWlHcjlScEvjm585blL9k4uWD6hq4O23VKef3x3W6EGzd5PMuaKqxI
	CbexsMfOf1RhN+VIvELm7JiuZfpNt38=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dfd12217 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 28 May 2024 11:58:38 +0000 (UTC)
Date: Tue, 28 May 2024 13:58:35 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: David Hildenbrand <dhildenb@redhat.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-mm@kvack.org
Subject: Re: [PATCH v15 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
Message-ID: <ZlXG69UxJVKd_7h4@zx2c4.com>
References: <20240521111958.2384173-1-Jason@zx2c4.com>
 <20240521111958.2384173-2-Jason@zx2c4.com>
 <2c943e16-e8f1-4311-b707-1be94d883948@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2c943e16-e8f1-4311-b707-1be94d883948@redhat.com>

On Mon, May 27, 2024 at 03:34:33PM +0200, David Hildenbrand wrote:
> 
> 
> Am 21.05.24 um 13:18 schrieb Jason A. Donenfeld:
> > The vDSO getrandom() implementation works with a buffer allocated with a
> > new system call that has certain requirements:
> > 
> > - It shouldn't be written to core dumps.
> >    * Easy: VM_DONTDUMP.
> > - It should be zeroed on fork.
> >    * Easy: VM_WIPEONFORK.
> > 
> > - It shouldn't be written to swap.
> >    * Uh-oh: mlock is rlimited.
> >    * Uh-oh: mlock isn't inherited by forks.
> > 
> > - It shouldn't reserve actual memory, but it also shouldn't crash when
> >    page faulting in memory if none is available
> >    * Uh-oh: MAP_NORESERVE respects vm.overcommit_memory=2.
> >    * Uh-oh: VM_NORESERVE means segfaults.
> > 
> > It turns out that the vDSO getrandom() function has three really nice
> > characteristics that we can exploit to solve this problem:
> > 
> > 1) Due to being wiped during fork(), the vDSO code is already robust to
> >     having the contents of the pages it reads zeroed out midway through
> >     the function's execution.
> > 
> > 2) In the absolute worst case of whatever contingency we're coding for,
> >     we have the option to fallback to the getrandom() syscall, and
> >     everything is fine.
> > 
> > 3) The buffers the function uses are only ever useful for a maximum of
> >     60 seconds -- a sort of cache, rather than a long term allocation.
> > 
> > These characteristics mean that we can introduce VM_DROPPABLE, which
> > has the following semantics:
> > 
> > a) It never is written out to swap.
> > b) Under memory pressure, mm can just drop the pages (so that they're
> >     zero when read back again).
> > c) If there's not enough memory to service a page fault, it's not fatal.
> > d) It is inherited by fork.
> > e) It doesn't count against the mlock budget, since nothing is locked.
> > 
> > This is fairly simple to implement, with the one snag that we have to
> > use 64-bit VM_* flags, but this shouldn't be a problem, since the only
> > consumers will probably be 64-bit anyway.
> > 
> > This way, allocations used by vDSO getrandom() can use:
> > 
> >      VM_DROPPABLE | VM_DONTDUMP | VM_WIPEONFORK | VM_NORESERVE
> > 
> > And there will be no problem with OOMing, crashing on overcommitment,
> > using memory when not in use, not wiping on fork(), coredumps, or
> > writing out to swap.
> > 
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >   fs/proc/task_mmu.c             | 3 +++
> >   include/linux/mm.h             | 8 ++++++++
> >   include/trace/events/mmflags.h | 7 +++++++
> >   mm/Kconfig                     | 3 +++
> >   mm/memory.c                    | 4 ++++
> >   mm/mempolicy.c                 | 3 +++
> >   mm/mprotect.c                  | 2 +-
> >   mm/rmap.c                      | 5 +++--
> >   8 files changed, 32 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index e5a5f015ff03..b5a59e57bde1 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -706,6 +706,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >   #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
> >   #ifdef CONFIG_X86_USER_SHADOW_STACK
> >   		[ilog2(VM_SHADOW_STACK)] = "ss",
> > +#endif
> > +#ifdef CONFIG_NEED_VM_DROPPABLE
> > +		[ilog2(VM_DROPPABLE)]	= "dp",
> >   #endif
> >   	};
> >   	size_t i;
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 9849dfda44d4..5978cb4cc21c 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -321,12 +321,14 @@ extern unsigned int kobjsize(const void *objp);
> >   #define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
> >   #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
> >   #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
> > +#define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
> >   #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
> >   #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
> >   #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
> >   #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
> >   #define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
> >   #define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
> > +#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
> >   #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
> >   
> >   #ifdef CONFIG_ARCH_HAS_PKEYS
> > @@ -357,6 +359,12 @@ extern unsigned int kobjsize(const void *objp);
> >   # define VM_SHADOW_STACK	VM_NONE
> >   #endif
> >   
> > +#ifdef CONFIG_NEED_VM_DROPPABLE
> > +# define VM_DROPPABLE		VM_HIGH_ARCH_6
> > +#else
> > +# define VM_DROPPABLE		VM_NONE
> > +#endif
> > +
> >   #if defined(CONFIG_X86)
> >   # define VM_PAT		VM_ARCH_1	/* PAT reserves whole VMA at once (x86) */
> >   #elif defined(CONFIG_PPC)
> > diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> > index e46d6e82765e..fab7848df50a 100644
> > --- a/include/trace/events/mmflags.h
> > +++ b/include/trace/events/mmflags.h
> > @@ -165,6 +165,12 @@ IF_HAVE_PG_ARCH_X(arch_3)
> >   # define IF_HAVE_UFFD_MINOR(flag, name)
> >   #endif
> >   
> > +#ifdef CONFIG_NEED_VM_DROPPABLE
> > +# define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
> > +#else
> > +# define IF_HAVE_VM_DROPPABLE(flag, name)
> > +#endif
> > +
> >   #define __def_vmaflag_names						\
> >   	{VM_READ,			"read"		},		\
> >   	{VM_WRITE,			"write"		},		\
> > @@ -197,6 +203,7 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
> >   	{VM_MIXEDMAP,			"mixedmap"	},		\
> >   	{VM_HUGEPAGE,			"hugepage"	},		\
> >   	{VM_NOHUGEPAGE,			"nohugepage"	},		\
> > +IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
> >   	{VM_MERGEABLE,			"mergeable"	}		\
> >   
> >   #define show_vma_flags(flags)						\
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index b4cb45255a54..6cd65ea4b3ad 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1056,6 +1056,9 @@ config ARCH_USES_HIGH_VMA_FLAGS
> >   	bool
> >   config ARCH_HAS_PKEYS
> >   	bool
> > +config NEED_VM_DROPPABLE
> > +	select ARCH_USES_HIGH_VMA_FLAGS
> > +	bool
> >   
> >   config ARCH_USES_PG_ARCH_X
> >   	bool
> > diff --git a/mm/memory.c b/mm/memory.c
> > index b5453b86ec4b..57b03fc73159 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
> >   
> >   	lru_gen_exit_fault();
> >   
> > +	/* If the mapping is droppable, then errors due to OOM aren't fatal. */
> > +	if (vma->vm_flags & VM_DROPPABLE)
> > +		ret &= ~VM_FAULT_OOM;
> > +
> >   	if (flags & FAULT_FLAG_USER) {
> >   		mem_cgroup_exit_user_fault();
> >   		/*
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index aec756ae5637..a66289f1d931 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2300,6 +2300,9 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
> >   	pgoff_t ilx;
> >   	struct page *page;
> >   
> > +	if (vma->vm_flags & VM_DROPPABLE)
> > +		gfp |= __GFP_NOWARN | __GFP_NORETRY;
> > +
> >   	pol = get_vma_policy(vma, addr, order, &ilx);
> >   	page = alloc_pages_mpol_noprof(gfp | __GFP_COMP, order,
> >   				       pol, ilx, numa_node_id());
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 94878c39ee32..88ff3ecc08a1 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -622,7 +622,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >   				may_expand_vm(mm, oldflags, nrpages))
> >   			return -ENOMEM;
> >   		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|VM_HUGETLB|
> > -						VM_SHARED|VM_NORESERVE))) {
> > +				  VM_SHARED|VM_NORESERVE|VM_DROPPABLE))) {
> >   			charged = nrpages;
> >   			if (security_vm_enough_memory_mm(mm, charged))
> >   				return -ENOMEM;
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index e8fc5ecb59b2..f23b9f796aae 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1397,7 +1397,8 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
> >   	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
> >   	VM_BUG_ON_VMA(address < vma->vm_start ||
> >   			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
> > -	__folio_set_swapbacked(folio);
> > +	if (!(vma->vm_flags & VM_DROPPABLE))
> > +		__folio_set_swapbacked(folio);
> >   	__folio_set_anon(folio, vma, address, true);
> >   
> >   	if (likely(!folio_test_large(folio))) {
> > @@ -1841,7 +1842,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >   				 * plus the rmap(s) (dropped by discard:).
> >   				 */
> >   				if (ref_count == 1 + map_count &&
> > -				    !folio_test_dirty(folio)) {
> > +				    (!folio_test_dirty(folio) || (vma->vm_flags & VM_DROPPABLE))) {
> >   					dec_mm_counter(mm, MM_ANONPAGES);
> >   					goto discard;
> >   				}
> 
> If there is any unexpected temporary folio reference (ref_count != 1 + 
> map_count), you'll end up calling folio_set_swapbacked() and the next swapout 
> round will write that folio to swap.

Thanks, nice call. I'll guard the re-setting of folio_set_swapbacked()
in that case.

Jason
