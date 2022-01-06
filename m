Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2539E173
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 13:42:22 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id s15so2577139pfk.6
        for <patches@lists.linux.dev>; Thu, 06 Jan 2022 05:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WIn9iUdeD2B4Cs6ET+8eDagQcKrMAeD/AEHYHYVJ70M=;
        b=cFvDgcrgvYMhqDAP6aWV8xTfVgdXVkZBqgCxGQJ7mrgJ8ZIyUJeiNN+E8olDsiCQg1
         aap/fCopxF2Ah17Dxq3cFjeuCHiE6GF8IMlwt930OB1lLP11i924vP0Eb/fv/ttatNkk
         tTW7kG3HZUx/zV+9AatW5WHTVgVB2748Jr3w3j00WljsHGCee41V+xOnrw1nTTWRN+CZ
         nZ1mq3q8t1veoAftWBB0+zBX4b0zGVJHVEhCdNxLKjZKJNzw6L0SxbihmxD/eeKUMs5A
         zXWhK6GT6xbJMJ/1GJeeT3NVDcUybvzTlzB9JKzDW298Ga5WeiCGtNqH2po6r0i+/ZDm
         EewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WIn9iUdeD2B4Cs6ET+8eDagQcKrMAeD/AEHYHYVJ70M=;
        b=M1oloFFMeacygRQIeKK1awlYRgAZjhwAs8EbJmUfJqFPxOw6+om1IEYhY2R360vA8Y
         ufMZ3rePJVlIpMZ733jtTdwcyjuwBCxuN2zZotrhXa0LrikcUWynRC6BHgIjYWya7XIp
         67dGbiDDsrLA1GV3l+mL/D36A9yU+xNHZb9dbueATVSwkhRhDVGDC6rAW8po28IYudw4
         o40oV+79jkoJ2l9jQ7JAU6nmd7Huxq02C9KsBs8VaGgtznHSuFLdsxcS/19RKXiP/bQj
         chV684o73wuWxYa3HI9OaO4jKEcIynClRC6v+2tjroM+0oJojBd2dymojT78GHdDVNmN
         JkOA==
X-Gm-Message-State: AOAM530ZtDtqq+HkOCPOIzSZjehdR7B4uDCiqRWMCQmaCLGntbR9zB+C
	6kM99ZOoeE/mHawitjMMFaM=
X-Google-Smtp-Source: ABdhPJzUtaqkp6M0FNqOSaOMNma7sCaWHhoGrK773bb5+SPhe16yFSgp3G2sN3fDSyCsB1Mj7PpuiA==
X-Received: by 2002:a05:6a00:8c5:b0:4bc:4c7e:7742 with SMTP id s5-20020a056a0008c500b004bc4c7e7742mr34388586pfu.18.1641476541692;
        Thu, 06 Jan 2022 05:42:21 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id nn16sm6696227pjb.54.2022.01.06.05.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:42:21 -0800 (PST)
Date: Thu, 6 Jan 2022 13:42:16 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 07/32] mm: Convert __ksize() to struct slab
Message-ID: <YdbxuCMUz9l1TW8e@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-8-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-8-vbabka@suse.cz>

On Tue, Jan 04, 2022 at 01:10:21AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> In SLUB, use folios, and struct slab to access slab_cache field.
> In SLOB, use folios to properly resolve pointers beyond
> PAGE_SIZE offset of the object.
> 
> [ vbabka@suse.cz: use folios, and only convert folio_test_slab() == true
>   folios to struct slab ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> ---
>  mm/slob.c |  8 ++++----
>  mm/slub.c | 12 +++++-------
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index 03deee1e6a94..c8a4290012a6 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -570,7 +570,7 @@ EXPORT_SYMBOL(kfree);
>  /* can't use ksize for kmem_cache_alloc memory, only kmalloc */
>  size_t __ksize(const void *block)
>  {
> -	struct page *sp;
> +	struct folio *folio;
>  	int align;
>  	unsigned int *m;
>  
> @@ -578,9 +578,9 @@ size_t __ksize(const void *block)
>  	if (unlikely(block == ZERO_SIZE_PTR))
>  		return 0;
>  
> -	sp = virt_to_page(block);
> -	if (unlikely(!PageSlab(sp)))
> -		return page_size(sp);
> +	folio = virt_to_folio(block);
> +	if (unlikely(!folio_test_slab(folio)))
> +		return folio_size(folio);
>
>  	align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
>  	m = (unsigned int *)(block - align);
> diff --git a/mm/slub.c b/mm/slub.c
> index c94fb4b4d655..269e10d341a8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4527,19 +4527,17 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
>  
>  size_t __ksize(const void *object)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	if (unlikely(object == ZERO_SIZE_PTR))
>  		return 0;
>  
> -	page = virt_to_head_page(object);
> +	folio = virt_to_folio(object);
>  
> -	if (unlikely(!PageSlab(page))) {
> -		WARN_ON(!PageCompound(page));
> -		return page_size(page);
> -	}
> +	if (unlikely(!folio_test_slab(folio)))
> +		return folio_size(folio);
>  
> -	return slab_ksize(page->slab_cache);
> +	return slab_ksize(folio_slab(folio)->slab_cache);
>  }
>  EXPORT_SYMBOL(__ksize);
>

This patch Looks good.
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

BTW, I see no reason to implement SLAB version of __ksize separately.
And there are no modules that use __ksize. EXPORT_SYMBOL is unnecessary.

BTW, Until when can I review your patches? until next week before starting
window?

Thanks!

> -- 
> 2.34.1
> 
