Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF17D168
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:43:11 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id a11so16874561qkh.13
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dDleZ4Lfyk2bTm2KE7iij6QxWvLTX00muEXEWoCAFGw=;
        b=iToBXoZPyX1HmEjRD9DYcj8MEGHopo9xF75hiJtC8KcXiSNm3wV+yNTOLZJg0tTXFp
         CcDnNBEVYlOJj98ra+ZqkK2W/NgaLZ60WNSJgEoN4NYNkCB2QB2oXRRd601ph8osCgLk
         fE+GP8Xg2NA97G7JWsO8n9Y/ekNxl+SIrugEV1BfoHGDD3YmGU6uuDIRymcZmbPOOIAe
         W4kbcehLY7lp4TcRp/BwMymv1KidNoHd+3va+GF5pSFIY8wfv9bThEhKSv+O5CUyk4Ct
         lvOqX4Y7g5dNI6Ub4pRj7+97axD/CYyvgWHXxLVdliIm6dJhbYT7xdDsSHD3MhaLjIsj
         SaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dDleZ4Lfyk2bTm2KE7iij6QxWvLTX00muEXEWoCAFGw=;
        b=NdcrX3HIiNFMAG+C1HFt7b0l2QtGkUks200VBUo0mfYxfI0kO2/91rMv3jez67KlCa
         7yzrjx9O2Wn+x83w22poQKyM/a/8Ke1OjGlq7uHYn9ur8aasj8A7WTjfmROaly1X8V2d
         sSOXqzb1O1FcrPvmSFOKJODtr3CqARhFujDzMzJuOWP9YTFwcHW2fRWNxEUr4+vP+1yW
         cOXO2QoSCrK/2J8da91o/42iQzyamidGLJ7IEE7CPO9MEHQvW8/UCdhQhrMeR7Q0fA8T
         HsJMeIR8fkm2zg+f2yC3tOAYQnLYJh3f0bHiqn/3Ou3sm7B9RmrzsLIu2V+rHCHhMIRa
         Qjfg==
X-Gm-Message-State: AOAM531i9bCg7DS6UUdABjEVsK5ueX/O40OGAHWhxRbRk/GSwp0C5Qr0
	DAOD5H4DtwRkQqGb7lbdj5uxnQ==
X-Google-Smtp-Source: ABdhPJwHSkFB7K2VjKuiDUuVy23sflYoaE0vwtJd3oSBAB2GpyxT+HEQZ0LfyomFTTrXctk3u+IJfg==
X-Received: by 2002:a37:8d86:: with SMTP id p128mr4404337qkd.706.1639492990618;
        Tue, 14 Dec 2021 06:43:10 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id x190sm6769qkb.115.2021.12.14.06.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:43:10 -0800 (PST)
Date: Tue, 14 Dec 2021 15:43:07 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Michal Hocko <mhocko@kernel.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 23/33] mm/memcg: Convert slab objcgs from struct page
 to struct slab
Message-ID: <Ybite9s1TS7cS67J@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-24-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-24-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:00PM +0100, Vlastimil Babka wrote:
> page->memcg_data is used with MEMCG_DATA_OBJCGS flag only for slab pages
> so convert all the related infrastructure to struct slab.
> 
> To avoid include cycles, move the inline definitions of slab_objcgs() and
> slab_objcgs_check() from memcontrol.h to mm/slab.h.
> 
> This is not just mechanistic changing of types and names. Now in
> mem_cgroup_from_obj() we use PageSlab flag to decide if we interpret the page
> as slab, instead of relying on MEMCG_DATA_OBJCGS bit checked in
> page_objcgs_check() (now slab_objcgs_check()). Similarly in
> memcg_slab_free_hook() where we can encounter kmalloc_large() pages (here the
> PageSlab flag check is implied by virt_to_slab()).

Yup, this is great.

> @@ -2865,24 +2865,31 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>   */
>  struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	page = virt_to_head_page(p);
> +	folio = virt_to_folio(p);
>  
>  	/*
>  	 * Slab objects are accounted individually, not per-page.
>  	 * Memcg membership data for each individual object is saved in
>  	 * the page->obj_cgroups.
>  	 */
> -	if (page_objcgs_check(page)) {
> +	if (folio_test_slab(folio)) {
> +		struct obj_cgroup **objcgs;
>  		struct obj_cgroup *objcg;
> +		struct slab *slab;
>  		unsigned int off;
>  
> -		off = obj_to_index(page->slab_cache, page_slab(page), p);
> -		objcg = page_objcgs(page)[off];
> +		slab = folio_slab(folio);
> +		objcgs = slab_objcgs_check(slab);

AFAICS the change to the _check() variant was accidental.

folio_test_slab() makes sure it's a slab page, so the legit options
for memcg_data are NULL or |MEMCG_DATA_OBJCGS; using slab_objcgs()
here would include the proper asserts, like page_objcgs() used to.
