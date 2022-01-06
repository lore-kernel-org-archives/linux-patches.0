Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381A9173
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 06:44:33 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id t19so1720181pfg.9
        for <patches@lists.linux.dev>; Wed, 05 Jan 2022 22:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+XhwRad15ARCCz7PlhBFDwqIW/JNQ6pxL2qxvbxceos=;
        b=OCAnvGF/gg4vCqpsgCqY8xzROD0pzmq64psau5Eaw/qtFZ4gBmNXYscubAkD32ymez
         NmL5PbZuHjHwZHCNaYy1xK2dNQrs2fSNK4NynBkyLj/Gb/PwilMt50QLRPnFgaozAIlY
         Tc2sbYG+B+izb1YJrvMjeSqsHFjrJMWCvBaFY1jig5dVPBFoIrPzy5JnYCq/Aau24s9d
         T3cI97EB9Arq6cPBgmIpg/kTuxFSffN95SJt7gCepBnaSa+P+dFUFjLvAXLfbH9QOAKx
         R+n4TYgyigVk8fBcoDXI8xejyh+odqtCu3eIuZ9hmrLQ4nNc3/gtmLcKBgXyBO7amE4i
         bppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+XhwRad15ARCCz7PlhBFDwqIW/JNQ6pxL2qxvbxceos=;
        b=jcLIcWPV5/W5/njbmDqDDIv59z+wxBLeT6FtVxaIgm+ARpnj0GpFs79FvYeZBvnqGh
         2Q1r1bH3LVeEOueU8powfq4TrHkOY0fe46i9BctfxQde35DvOFcqK2R1G36Lwfr2FrsB
         HH4Cx+bOmbvh4Vta08k/655E22aAXIFelcbWi6tp3CATcbbV82X57U6rWTiILEj62F1L
         Nlo9/nWGY2DKP29h/voVR6jILNqasqE4BikkMGlHRxzJXIWaqmir7GDbClfARJmLgYDW
         8eTePJYsAr0U33pCA2ODQI8x2Aw9EHzqQBQyvCcrSa8DlSNfIJXaWQFDN2wVSAS7NpPr
         uyoQ==
X-Gm-Message-State: AOAM530PDZ2DuUDoHSQ0ekbt/64Ne2HFAPwHYYxGL1CfkmUYU2uAfgkQ
	7VPfL6bXUjQN+nHvHhKsxJA=
X-Google-Smtp-Source: ABdhPJz5su97NryxCuZJ5mNr86k4sQKY3Q+ejq8ibz5/9Wv/pBMH27fiQlGTNwfy7/jtc+rdrDwTmA==
X-Received: by 2002:a63:784d:: with SMTP id t74mr36118499pgc.261.1641451472848;
        Wed, 05 Jan 2022 22:44:32 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id mh3sm4967524pjb.26.2022.01.05.22.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 22:44:32 -0800 (PST)
Date: Thu, 6 Jan 2022 06:44:28 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 06/32] mm: Convert virt_to_cache() to use struct slab
Message-ID: <YdaPzNKl4jvOdJ4O@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-7-vbabka@suse.cz>

On Tue, Jan 04, 2022 at 01:10:20AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This function is entirely self-contained, so can be converted from page
> to slab.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> ---
>  mm/slab.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index dd3f72fddff6..1408ada9ff72 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -574,13 +574,13 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s,
>  
>  static inline struct kmem_cache *virt_to_cache(const void *obj)
>  {
> -	struct page *page;
> +	struct slab *slab;
>  
> -	page = virt_to_head_page(obj);
> -	if (WARN_ONCE(!PageSlab(page), "%s: Object is not a Slab page!\n",
> +	slab = virt_to_slab(obj);
> +	if (WARN_ONCE(!slab, "%s: Object is not a Slab page!\n",
>  					__func__))
>  		return NULL;
> -	return page->slab_cache;
> +	return slab->slab_cache;
>  }
>  

Looks good,
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

>  static __always_inline void account_slab(struct slab *slab, int order,
> -- 
> 2.34.1
> 
