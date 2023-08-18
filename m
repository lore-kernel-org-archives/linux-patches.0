Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89F018031
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 11:47:50 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-79ae250266cso278565241.2
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 04:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692359269; x=1692964069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bAfIM5gpLJTpuPiiqsDtzWBiv40WoFry3jyTY/pzGKQ=;
        b=WgFyAtGBMxvr226dkfTHl5GKxVdN0h0kzbcnKkrDeKL5Ytm3ODeLGpBw3r8/9neIvl
         4PgYqJcR3HIXVKyz/eDspWnSbTYXggMWmwAyYUxyZCLSrlcvE5jarpyyPh5an6FfsVbE
         rq2cpMAUGAhSXnFr1YtBtfa/uPtC+qYHNbhNnh3XH6JzDjDcBq9lltcDR16c/+8FjZKW
         kPkCPN4+2CWSUj4cBzqCw+OXpU1lqkDs+7yP0qnOEeprus4uBBXMrMPhRrAj+VK8IMAg
         47KKkowdN1QOLpwwVHJ0UuDM+5S5//PjWoBGGfWbP2D3U0gqE4PVNJGU3qiSzzLsx0BG
         o7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692359269; x=1692964069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bAfIM5gpLJTpuPiiqsDtzWBiv40WoFry3jyTY/pzGKQ=;
        b=YpNKnEyLgyy6hOmAvwTvr2UWQ431pKGoqKHHnhOIQG69d/AbaS3QTGGaRyk7Drnqy6
         tKFO6e46dyFq7HzybzD4brb3u6u5JmYhW62EQg90/rhP8+R4+cQn6Voh4yTvpc+X7cy2
         IAcLssPUvKtWZ3q79ClEWsJTCC9RziieFpv6pCSkMqiW8hcV+oqC20xJ5Qggovu+TL/3
         IrJGZt+IXvsN8nJqTjpdhkmasVEFrRDXk+v1c8MAHBvsawKJEJuEvLu6u+n8ssw8LuuI
         TAcLmnlmksEDvvNKZKVyUxVGNS4CHbYfNmi/33jqTiE834A5iI0V52rQYXHUr34o3jcr
         JtjQ==
X-Gm-Message-State: AOJu0YzFBbA2OsP11IsuEIb4U2VaQMgIGBAf8hWx+wU6fiRmlnqDBpqQ
	9j56oB0gx8aMCa95Ikw8S4SDb+GdhjKl743hg70=
X-Google-Smtp-Source: AGHT+IGJrBuWc0TgeyRTJnSrv8cqlREWyOoz6U6qJj7S3f7Ew1q7aRXhto3Nmue2STFJvfLAkqstSuKdh0XXv93p+lc=
X-Received: by 2002:a67:f5d6:0:b0:447:6965:7285 with SMTP id
 t22-20020a67f5d6000000b0044769657285mr3080841vso.9.1692359269361; Fri, 18 Aug
 2023 04:47:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808095342.12637-7-vbabka@suse.cz> <20230808095342.12637-8-vbabka@suse.cz>
In-Reply-To: <20230808095342.12637-8-vbabka@suse.cz>
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Date: Fri, 18 Aug 2023 20:47:37 +0900
Message-ID: <CAB=+i9QaA+ewMeGM9ngkn06ag2HFoJqCRhmfG4qP-_G3Gv5DTQ@mail.gmail.com>
Subject: Re: [RFC v1 1/5] mm, slub: fix bulk alloc and free stats
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 8, 2023 at 6:53=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> The SLUB sysfs stats enabled CONFIG_SLUB_STATS have two deficiencies
> identified wrt bulk alloc/free operations:
>
> - Bulk allocations from cpu freelist are not counted. Add the
>   ALLOC_FASTPATH counter there.
>
> - Bulk fastpath freeing will count a list of multiple objects with a
>   single FREE_FASTPATH inc. Add a stat_add() variant to count them all.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index e3b5d5c0eb3a..a9437d48840c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -341,6 +341,14 @@ static inline void stat(const struct kmem_cache *s, =
enum stat_item si)
>  #endif
>  }
>
> +static inline void stat_add(const struct kmem_cache *s, enum stat_item s=
i, int v)
> +{
> +#ifdef CONFIG_SLUB_STATS
> +       raw_cpu_add(s->cpu_slab->stat[si], v);
> +#endif
> +}
> +
> +
>  /*
>   * Tracks for which NUMA nodes we have kmem_cache_nodes allocated.
>   * Corresponds to node_state[N_NORMAL_MEMORY], but can temporarily
> @@ -3776,7 +3784,7 @@ static __always_inline void do_slab_free(struct kme=
m_cache *s,
>
>                 local_unlock(&s->cpu_slab->lock);
>         }
> -       stat(s, FREE_FASTPATH);
> +       stat_add(s, FREE_FASTPATH, cnt);

Should bulk free slowpath also be counted in the same way?

>  }
>  #else /* CONFIG_SLUB_TINY */
>  static void do_slab_free(struct kmem_cache *s,
> @@ -3978,6 +3986,7 @@ static inline int __kmem_cache_alloc_bulk(struct km=
em_cache *s, gfp_t flags,
>                 c->freelist =3D get_freepointer(s, object);
>                 p[i] =3D object;
>                 maybe_wipe_obj_freeptr(s, p[i]);
> +               stat(s, ALLOC_FASTPATH);
>         }
>         c->tid =3D next_tid(c->tid);
>         local_unlock_irqrestore(&s->cpu_slab->lock, irqflags);
> --
> 2.41.0
>
