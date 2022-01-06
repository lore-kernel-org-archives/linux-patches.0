Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F2E173
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 06:40:16 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso2196485pjb.1
        for <patches@lists.linux.dev>; Wed, 05 Jan 2022 22:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qpDNDsqfZRWzVoTY8vjmdsaIkg0QfrFvBT5+U+FS8dQ=;
        b=eIz7awawWEsIs2ZxILc9hK+qK9hX+gsY3ORerh87u3jYTlPlWpR0MMDOuzGM0KNEIH
         DY0uTs9eceRynVlxnoO+AVDAWGtkiPDl4UfsdRO687EkMdN+lbZCLS2rkIU0jJx63UA6
         4AnpxzdnnByOYUCbf6b0uXS29gSAuAXidSSa+TC1RT3jkWph22sMbcUj9NkqPuwRHBsp
         pSNrz2ug1BaiRBDORnmZPAAMLEtI+2yUtxlEZFsnF9jnaRRkVIWe9vjek3ArDd7ISE+F
         LaIOhVnjprojlzX7cVU3RLKsJC/ivLsi/wV2SijtdtxNhKxiapJ9IDk/S1rfRG7UTELT
         O5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qpDNDsqfZRWzVoTY8vjmdsaIkg0QfrFvBT5+U+FS8dQ=;
        b=8IMq8DpJftyInhAUyLEVPtxR+6gUnCYcD0u4rLuJzP8VXK7J9Lb4AcZtzhp7FCyZdX
         2Ics4SyCVjwyeRcs8BT+IlgdQrI1lNZJdJw0RdTjE7x2Tw0txhQDlhl+eSDryjTV3Hev
         uHDYHYcQkHf7LzMn+EBIp/ALOsX5iBpJn/HO5Pyih4JftUQDDrVBYEdrFtBmw66nEyZB
         G3CIyeogKBYDRekJyg92bNU0fCV9US5xPw1JQsaKPlyCLkXi3kqcLphJ/37u1TgyixM4
         zVZwUQo2JBWO46WjIqqbZ9Yl8HZqMfIpu1/y3zE8NNMdTmB6FHZ8ki2S7N3DQCa79jnm
         SwOQ==
X-Gm-Message-State: AOAM532gm//sFfS/IEp4MWW+BSFcC0q2l3Si9s+34d5YixAdnD/gm9pF
	2bq06ttZPSa1t6mF1JjUCX0=
X-Google-Smtp-Source: ABdhPJxl6ahwctJYFxS36uin1LuvfGqoiHung0FOw71afRe/SZgkDRmRgqSq5W8Rw+rz6yvWl2W50w==
X-Received: by 2002:a17:90b:3808:: with SMTP id mq8mr8353278pjb.85.1641451216015;
        Wed, 05 Jan 2022 22:40:16 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id f7sm1192627pfc.141.2022.01.05.22.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 22:40:15 -0800 (PST)
Date: Thu, 6 Jan 2022 06:40:11 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 02/32] mm/slab: Dissolve slab_map_pages() in its caller
Message-ID: <YdaOy6hFAdL8LyBS@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-3-vbabka@suse.cz>

On Tue, Jan 04, 2022 at 01:10:16AM +0100, Vlastimil Babka wrote:
> The function no longer does what its name and comment suggests, and just
> sets two struct page fields, which can be done directly in its sole
> caller.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> ---
>  mm/slab.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index ca4822f6b2b6..381875e23277 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2546,18 +2546,6 @@ static void slab_put_obj(struct kmem_cache *cachep,
>  	set_free_obj(page, page->active, objnr);
>  }
>  
> -/*
> - * Map pages beginning at addr to the given cache and slab. This is required
> - * for the slab allocator to be able to lookup the cache and slab of a
> - * virtual address for kfree, ksize, and slab debugging.
> - */
> -static void slab_map_pages(struct kmem_cache *cache, struct page *page,
> -			   void *freelist)
> -{
> -	page->slab_cache = cache;
> -	page->freelist = freelist;
> -}
> -
>  /*
>   * Grow (by 1) the number of slabs within a cache.  This is called by
>   * kmem_cache_alloc() when there are no active objs left in a cache.
> @@ -2621,7 +2609,8 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
>  	if (OFF_SLAB(cachep) && !freelist)
>  		goto opps1;
>  
> -	slab_map_pages(cachep, page, freelist);
> +	page->slab_cache = cachep;
> +	page->freelist = freelist;
>  
>  	cache_init_objs(cachep, page);
>  

Looks good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

> -- 
> 2.34.1
> 
