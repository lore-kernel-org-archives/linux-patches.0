Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C8633C9
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 11:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876CEC433D2;
	Fri, 17 Mar 2023 11:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679053881;
	bh=EzVToRfdITg9u3nsfi0iMokgGQHKFv6SIwK3/2KDthY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzGhBj2cq6QRZXZnXXd7tw4Jqpm1h1G9P95NySR0oBzoAAqgJqJIKcW/rRF8MkgTD
	 y+DSCwzELoUQVjuXiK62u8/NgLSlIDrYcBpihffs7I4uuioETREJ5UMGIRZBKC76Io
	 e4NK9S71zQ5GxlaiIdIiBxtmW0+NPIUiSu70/UPb7CezMpofuSuaa9cx1RGXWrZcMT
	 KglfRemiunf7s7inHoCd+iwZMbiF3ctfchfI+f86/y5NBahFpVBSMdno46ejpGfUrq
	 f/RZIZUfSX4BLNBskbBkkHLVSVhMtBmBTV8ewt4zY17Iuy/NYBIieughKRtyiZMA1+
	 C3mdsewfKhWrQ==
Date: Fri, 17 Mar 2023 13:51:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-doc@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: Re: [PATCH v2 3/6] mm, pagemap: remove SLOB and SLQB from comments
 and documentation
Message-ID: <ZBRUKdaAfBMcSWzD@kernel.org>
References: <20230317104307.29328-1-vbabka@suse.cz>
 <20230317104307.29328-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317104307.29328-4-vbabka@suse.cz>

On Fri, Mar 17, 2023 at 11:43:04AM +0100, Vlastimil Babka wrote:
> SLOB has been removed and SLQB never merged, so remove their mentions
> from comments and documentation of pagemap.
> 
> In stable_page_flags() also correct an outdated comment mentioning that
> PageBuddy() means a page->_refcount of -1, and remove compound_head()
> from the PageSlab() call, as that's already implicitly there thanks to
> PF_NO_TAIL.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>

Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>

> ---
>  Documentation/admin-guide/mm/pagemap.rst | 6 +++---
>  fs/proc/page.c                           | 9 ++++-----
>  2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index b5f970dc91e7..c8f380271cad 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -91,9 +91,9 @@ Short descriptions to the page flags
>     The page is being locked for exclusive access, e.g. by undergoing read/write
>     IO.
>  7 - SLAB
> -   The page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator.
> -   When compound page is used, SLUB/SLQB will only set this flag on the head
> -   page; SLOB will not flag it at all.
> +   The page is managed by the SLAB/SLUB kernel memory allocator.
> +   When compound page is used, either will only set this flag on the head
> +   page.
>  10 - BUDDY
>      A free memory block managed by the buddy system allocator.
>      The buddy system organizes free memory in blocks of various orders.
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 6249c347809a..195b077c0fac 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -125,7 +125,7 @@ u64 stable_page_flags(struct page *page)
>  	/*
>  	 * pseudo flags for the well known (anonymous) memory mapped pages
>  	 *
> -	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
> +	 * Note that page->_mapcount is overloaded in SLAB, so the
>  	 * simple test in page_mapped() is not enough.
>  	 */
>  	if (!PageSlab(page) && page_mapped(page))
> @@ -165,9 +165,8 @@ u64 stable_page_flags(struct page *page)
>  
>  
>  	/*
> -	 * Caveats on high order pages: page->_refcount will only be set
> -	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
> -	 * SLOB won't set PG_slab at all on compound pages.
> +	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
> +	 * on the head page.
>  	 */
>  	if (PageBuddy(page))
>  		u |= 1 << KPF_BUDDY;
> @@ -185,7 +184,7 @@ u64 stable_page_flags(struct page *page)
>  	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
>  
>  	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
> -	if (PageTail(page) && PageSlab(compound_head(page)))
> +	if (PageTail(page) && PageSlab(page))
>  		u |= 1 << KPF_SLAB;
>  
>  	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
> -- 
> 2.39.2
> 

-- 
Sincerely yours,
Mike.
