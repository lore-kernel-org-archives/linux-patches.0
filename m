Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1007B
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 00:05:04 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id n130so21173696yba.10
        for <patches@lists.linux.dev>; Wed, 26 Oct 2022 17:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5fCQYHP/s1K+a3B3xVNrAVIKsujOkSpQyFTVrdP9WZU=;
        b=lKQNO9bgERIRucRGh5EiElF1GA3n+J9zZ4fLzo0u8K6EjbiEWvzzt5mDcg0FQWecbg
         3+4Ig2CQxfWUgIUqThVxKctefOYuU+Ue5MQjmYxVhqFPH8EACMr8HlniwWU6x3tjlgk1
         NGySlIRkS9tSab1iH0a3LLipnJhBQVDN/WZj/drpzk1CFYiAv/ODuKsjhucLfMUNwPry
         B22owquRWPBRqdpTlaPjdDwlc+wkZEQNSx5e3/AJM+78B5mV3FuqU20y4eJidx00zCHv
         xaN75uzIQEQX2XuYyy7RUBW3PHc2ILYOLLKqSJZesCbFwKul4sIFCSmdBtFZsjw3DPIk
         /WNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5fCQYHP/s1K+a3B3xVNrAVIKsujOkSpQyFTVrdP9WZU=;
        b=fmDbC57EN/SIn9XIrjrruQlen9kxdyxtE2eJ4rjxp9bJi4TC6sDmHtmA3PPevGv3KS
         AOptlWzXaz9qg8bW4A813m3FinpGEk8v1dctz+rDm0lt2sulCl95L9FiSRtuLdUcibwT
         PigwFkEMkEhvGE5yiChSOul2RhSxfA4H8S113l7/S3tdlVN1F9d3fqjcNdIY3ao8f4xS
         AWMZTtpdPV5Xn39wCm6rFiokchk+vKGUo7/+JhMRIW7RZNQpUsifuE8HJCNZ3PhwnxXf
         SBDu4MGSqKe/UrChayKSnkIvBX0hyXm3yV1V6W1qA+suaIuVogsE0wUYV18MfLrlkfDQ
         bRsg==
X-Gm-Message-State: ACrzQf24Ww9io/ikVvIFDGCKaQj2Oi8ZSYLhnO47TJ94PV5EUJ48mM8c
	tzw5yIbXCLiMQs3PU1EpzerInzBCafS10bV1VcMSNQ==
X-Google-Smtp-Source: AMsMyM7PJvx01pg/lTXKX+/RYgQQElv69gJCPjUiaPIpxvxFs6wPf3zu/GMrbpmjb9ZMUpkbZzlN4QoydwxzD9y3/QU=
X-Received: by 2002:a05:6902:1542:b0:6ca:675a:fdee with SMTP id
 r2-20020a056902154200b006ca675afdeemr29400463ybu.125.1666829103682; Wed, 26
 Oct 2022 17:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221026204031.1699061-1-Jason@zx2c4.com>
In-Reply-To: <20221026204031.1699061-1-Jason@zx2c4.com>
From: Marco Elver <elver@google.com>
Date: Wed, 26 Oct 2022 17:04:27 -0700
Message-ID: <CANpmjNMmHa04Fqf5Ub5-vz6HuqT_Gg8GmEfKD6rv8JeMfBZ32w@mail.gmail.com>
Subject: Re: [PATCH] kfence: buffer random bools in bitmask
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kasan-dev@googlegroups.com, patches@lists.linux.dev, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Oct 2022 at 13:40, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Recently kfence got a 4x speed up in calls to the RNG, due to using
> internally get_random_u8() instead of get_random_u32() for its random
> boolean values. We can extend that speed up another 8x, to 32x total, by
> buffering a long at a time, and reading bits from it.
>
> I'd looked into introducing a get_random_bool(), along with the
> complexities required for that kind of function to work for a general
> case. But kfence is the only high-speed user of random booleans in a hot
> path, so we're better off open coding this to take advantage of kfence
> particularities.

kfence_guarded_alloc() is supposed to be a slow-path. And if it were a
hot-path, I currently see no evidence that a call into the RNG
dominates the time spent there.

Do you have profiles?

What are the real benefits of this change?
Is it to avoid depleting the entropy pool?

> In particular, we take advantage of the fact that kfence_guarded_alloc()
> already disables interrupts for its raw spinlocks, so that we can keep
> track of a per-cpu buffered boolean bitmask, without needing to add more
> interrupt disabling.
>
> This is slightly complicated by PREEMPT_RT, where we actually need to
> take a local_lock instead. But the resulting code in both cases compiles
> down to something very compact, and is basically zero cost.
> Specifically, on !PREEMPT_RT, this amounts to:
>
>     local_irq_save(flags);
>     random boolean stuff;
>     raw_spin_lock(&other_thing);
>     do the existing stuff;
>     raw_spin_unlock_irqrestore(&other_thing, flags);
>
> By using a local_lock in the way this patch does, we now also get this
> code on PREEMPT_RT:
>
>     spin_lock(this_cpu_ptr(&local_lock));
>     random boolean stuff;
>     spin_unlock(this_cpu_ptr(&local_lock));
>     raw_spin_lock_irqsave(&other_thing, flags);
>     do the existing stuff;
>     raw_spin_unlock_irqrestore(&other_thing, flags);
>
> This is also optimal for RT systems. So all and all, this is pretty
> good. But there are some compile-time conditionals in order to
> accomplish this.
>
> Cc: Marco Elver <elver@google.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  mm/kfence/core.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6cbd93f2007b..c212ae0cecba 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -356,21 +356,47 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
>                                   unsigned long *stack_entries, size_t num_stack_entries,
>                                   u32 alloc_stack_hash)
>  {
> +       struct random_bools {
> +               unsigned long bits;
> +               unsigned int len;
> +               local_lock_t lock;
> +       };
> +       static DEFINE_PER_CPU(struct random_bools, pcpu_bools) = {
> +               .lock = INIT_LOCAL_LOCK(pcpu_bools.lock)
> +       };

If I remember right, function-scoped static DEFINE_PER_CPU were
disallowed (but I now cannot recall why and where it said that :-/).

> +       struct random_bools *bools;
>         struct kfence_metadata *meta = NULL;
>         unsigned long flags;
>         struct slab *slab;
>         void *addr;
> -       const bool random_right_allocate = get_random_u32_below(2);
> +       bool random_right_allocate;
>         const bool random_fault = CONFIG_KFENCE_STRESS_TEST_FAULTS &&
>                                   !get_random_u32_below(CONFIG_KFENCE_STRESS_TEST_FAULTS);
>
> +       local_lock_irqsave(&pcpu_bools.lock, flags);
> +       bools = raw_cpu_ptr(&pcpu_bools);
> +       if (unlikely(!bools->len)) {
> +               bools->bits = get_random_long();
> +               bools->len = BITS_PER_LONG;
> +       }
> +       random_right_allocate = bools->bits & 1;
> +       bools->bits >>= 1;
> +       bools->len--;

This should be factored into its own function that returns a result
for random_right_allocate.

>         /* Try to obtain a free object. */
> -       raw_spin_lock_irqsave(&kfence_freelist_lock, flags);
> +       if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +               raw_spin_lock_irqsave(&kfence_freelist_lock, flags);
> +       else
> +               raw_spin_lock(&kfence_freelist_lock);
>         if (!list_empty(&kfence_freelist)) {
>                 meta = list_entry(kfence_freelist.next, struct kfence_metadata, list);
>                 list_del_init(&meta->list);
>         }
> -       raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
> +       if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +               raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
> +       else
> +               raw_spin_unlock(&kfence_freelist_lock);
> +       local_unlock_irqrestore(&pcpu_bools.lock, flags);

Overall this introduces complexities that should be hidden behind some
new abstractions.

But besides that, I'd first want to understand what the real benefit
is given all this is supposed to be a slow-path.

Thanks,
-- Marco
