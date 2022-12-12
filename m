Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8152585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:11:16 +0000 (UTC)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-381662c78a9so144777667b3.7
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 05:11:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtZ2FMA0O4uYUm7aQmSU8L+LI/VWAtJ0XYx+JdwdYTc=;
        b=E6HxguKDSaNVHOvSzmZBUoJlCcvnZtBdnkDkuEzitIZ50BNkYn55nGhS3r2npKbsYv
         7QhgrPpGckluzkGVxquC6+4da9elocmtanvZlkFPXq7N3Qy4pgNhQMRJx3v0LZQAbt6P
         /fGlPgU/JnxQJ2FkKYAz87JliGCGhHg3sgxEfxOfhUwqHmxweN5Vk2c+OeOaONNttaNN
         C7K+AaQ6cTV+EK3P1K7yWY5g5mpJLS5LQSuj7uhGuXM8FTd5sRSVIDFB1BBRxAtpVR3V
         SMcKlkoaws+ky4K2xRNihbL9DrYBfVw2m5zS7SslWkUdUfGq4fH88BeTuKTkXJ7wCmh0
         4Rfw==
X-Gm-Message-State: ANoB5pnm03ij53cP/9Fs/t9lAtgU2MYvG4ARe0newKduGi1vNC+aoPZ7
	FPrnRIQZjcndQw/MbI6rD6c=
X-Google-Smtp-Source: AA0mqf7+Aixqg4qs18bRCQtwCQMbbfyLdDkUgVLDofTIN7Vq8afs+p552ohMQrOoGgYEsUcaaw5YyQ==
X-Received: by 2002:a05:7508:3a85:b0:47:39b7:aeb8 with SMTP id de5-20020a0575083a8500b0004739b7aeb8mr1124297gbb.10.1670850675322;
        Mon, 12 Dec 2022 05:11:15 -0800 (PST)
Received: from fedora ([216.211.255.155])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006ff8a122a1asm3626860qkp.78.2022.12.12.05.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:11:13 -0800 (PST)
Date: Mon, 12 Dec 2022 05:11:11 -0800
From: Dennis Zhou <dennis@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>, Baoquan He <bhe@redhat.com>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm, slub: remove percpu slabs with CONFIG_SLUB_TINY
Message-ID: <Y5cob2jicdNoviU3@fedora>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-11-vbabka@suse.cz>
 <Y4NEkF8DI1uXFRv4@hyeyoo>
 <f318ccc3-eb03-e359-cb6f-157d0b4aed31@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f318ccc3-eb03-e359-cb6f-157d0b4aed31@suse.cz>

Hello,

On Mon, Dec 12, 2022 at 11:54:28AM +0100, Vlastimil Babka wrote:
> On 11/27/22 12:05, Hyeonggon Yoo wrote:
> > On Mon, Nov 21, 2022 at 06:12:00PM +0100, Vlastimil Babka wrote:
> >> SLUB gets most of its scalability by percpu slabs. However for
> >> CONFIG_SLUB_TINY the goal is minimal memory overhead, not scalability.
> >> Thus, #ifdef out the whole kmem_cache_cpu percpu structure and
> >> associated code. Additionally to the slab page savings, this reduces
> >> percpu allocator usage, and code size.
> > 
> > [+Cc Dennis]
> 
> +To: Baoquan also.
> 
> > Wondering if we can reduce (or zero) early reservation of percpu area
> > when #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_TINY)?
> 
> Good point. I've sent a PR as it was [1], but (if merged) we can still
> improve that during RC series, if it means more memory saved thanks to less
> percpu usage with CONFIG_SLUB_TINY.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/tag/?h=slab-for-6.2-rc1

The early reservation area not used at boot is then used to serve normal
percpu allocations. Percpu allocates additional chunks based on a free
page float count and is backed page by page, not all at once. I get
slabs is the main motivator of early reservation, but if there are other
users of percpu, then shrinking the early reservation area is a bit
moot.

Thanks,
Dennis

> 
> >> This change builds on recent commit c7323a5ad078 ("mm/slub: restrict
> >> sysfs validation to debug caches and make it safe"), as caches with
> >> enabled debugging also avoid percpu slabs and all allocations and
> >> freeing ends up working with the partial list. With a bit more
> >> refactoring by the preceding patches, use the same code paths with
> >> CONFIG_SLUB_TINY.
> >> 
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > 
> 
