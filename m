Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E8719BD3
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 16:21:37 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-262c42d3fafso3818672a91.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689092497; x=1691684497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRd6MSnrDwuyQ7znWMqv6yCTnL1/DCJOC7bU8PD4YHA=;
        b=gpWbxLEJAvmtMRm+FhOebdn8dZhw/8ODnpNfzpB0MQM3pSJXTeWlGHA4rduGWhj+cX
         Ro43D8BRredizt+GPW75K5Q3Y+Dr3QH6caOSAfHsa+RWAxkbmzOtytqAsA0nIQKnhMse
         Bhf/WZN5knflEGP6D2uaxg9geafaqTw2FfFRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689092497; x=1691684497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRd6MSnrDwuyQ7znWMqv6yCTnL1/DCJOC7bU8PD4YHA=;
        b=Z9IdCazZa1fkCP3dhB2DCM7ME/4k54c8uWInbtZN+YSflRaNuV+fdQwQ39pfVwI0lI
         d9tlGW0sQ5xhOomNhy6UWBR7cCe8uSDBxbD57ZiqBHds0DziOruIAuFP/1lgn2g7FTy+
         O5WWvPcVkUpFgjhI7z0BXDzLzw5weAGLQ/9nzs/6SHuOL4uAFkxHAZODFUOMDTf6gbMF
         UCX41XwI6/sj0IctqibPDi2Wf/xpRNdxTRb36I5Jvx8VfmNroGKUjQfUz8WSc20ge54a
         /2RF+yJ7MKaQq3/3jHevdZtXG9Z2Ru530JeMxjDUzPO6uxkki8Sgm8f2tY+oA6cXncQf
         X/lA==
X-Gm-Message-State: ABy/qLaDC4iDuAq3XMBmaseUJOeIX29TZ92YHd7S1GKu/de9jKuA7oMd
	8qMkz4+R7wy6WxlVOjH4l99nzA==
X-Google-Smtp-Source: APBJJlGmfygMjusEhLAateZabdJC+NgJo425Y8P55gtNUAQan1lVCm6MeEIhr+Us9T17E8ZvkbTgag==
X-Received: by 2002:a17:90b:1d02:b0:263:114c:52fc with SMTP id on2-20020a17090b1d0200b00263114c52fcmr23830843pjb.12.1689092497290;
        Tue, 11 Jul 2023 09:21:37 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id dw16-20020a17090b095000b00260cce91d20sm2026175pjb.33.2023.07.11.09.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 09:21:36 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:21:36 -0700
From: Kees Cook <keescook@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/slub: remove freelist_dereference()
Message-ID: <202307110917.DEED145F0@keescook>
References: <20230711134623.12695-3-vbabka@suse.cz>
 <20230711134623.12695-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711134623.12695-4-vbabka@suse.cz>

On Tue, Jul 11, 2023 at 03:46:25PM +0200, Vlastimil Babka wrote:
> freelist_dereference() is a one-liner only used from get_freepointer().
> Remove it and make get_freepointer() call freelist_ptr_decode()
> directly to make the code easier to follow.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 07edad305512..c4556a5dab4b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -397,18 +397,14 @@ static inline void *freelist_ptr_decode(const struct kmem_cache *s,
>  	return decoded;
>  }
>  
> -/* Returns the freelist pointer recorded at location ptr_addr. */
> -static inline void *freelist_dereference(const struct kmem_cache *s,
> -					 void *ptr_addr)
> -{
> -	return freelist_ptr_decode(s, *(freeptr_t *)(ptr_addr),
> -			    (unsigned long)ptr_addr);
> -}
> -
>  static inline void *get_freepointer(struct kmem_cache *s, void *object)
>  {
> -	object = kasan_reset_tag(object);
> -	return freelist_dereference(s, (freeptr_t *)(object + s->offset));
> +	unsigned long ptr_addr;
> +	freeptr_t p;
> +
> +	ptr_addr = ((unsigned long)kasan_reset_tag(object)) + s->offset;
> +	p = *(freeptr_t *)(ptr_addr);
> +	return freelist_ptr_decode(s, p, ptr_addr);
>  }
>  
>  #ifndef CONFIG_SLUB_TINY
> -- 
> 2.41.0
> 

I like reducing the complexity here, but I find dropping the "object"
reassignment makes this a bit harder to read. What about:

	object = kasan_reset_tag(object);
	unsigned long ptr_addr = (unsigned long)object + s->offset;
	freeptr_t p = *(freeptr_t *)(ptr_addr);

	return freelist_ptr_decode(s, p, ptr_addr);

?

They're the same result, so either way:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
