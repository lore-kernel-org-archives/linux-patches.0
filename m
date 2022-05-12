Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD6D2F31
	for <patches@lists.linux.dev>; Thu, 12 May 2022 21:31:30 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id m128so12135031ybm.5
        for <patches@lists.linux.dev>; Thu, 12 May 2022 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3GME8g6CPueWMd7lO8qXn1DRp2ceHlUdCzpOykCHbrg=;
        b=sZeZsptj07txPT3pe6bg85WLBogL/niFdujvXhGmvGHvUMdf+ubK/UMpNHCLyogLwJ
         1SzO61ddJPTl2rtfw/kEWCzbP/eORv0uCHNC9PQeJyNGrGAE73x2lB0kWBr2Kjmq3xRa
         mHwmaWFkL87Lq1cgfh194/MR4V/+H09KgB3y8gzFiALIbiGBD1RimwncOW3qBHBZ2PVs
         UJ6FI/VP/MEHjwSS79k9qDB+GAXe0Ehg7pg7yN/vCBgUpTkurP3pNm1JUOvBj2epSt4W
         zK35VaXeUyV2ai5LhbEjWsjFjQ7WQtGm92S5pR09fzSj8A5IT67/CPetqREViJP8tMHW
         dVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3GME8g6CPueWMd7lO8qXn1DRp2ceHlUdCzpOykCHbrg=;
        b=jf/SRmR3xwD66rTEcGDzLHMt+yErXL3KALXFamlJXhEm9sXMKgdKpj38DSekKknxB0
         SBB5V5JxhWltozLwxsFzm69nh50VBXZIchKBfr2azsplF2HDkKO1adciEKNaHefF/AuN
         nslm82lNarG3VquuCi+MUD/Y4tiwFK5eD2qvDiHdsti770sjx2YJPQsKwV1kqNhczzJF
         C4e3Iob10ClSU/mKZNRQwgSi9/Txwo/wJkRRr2mQ7VLxKmTUw8vUJeUOUl9Qxvm1t7ms
         30vo800CzbWm4WxEVhdIP6GaERpYYPmmslXZuysAxWkaIoHENgnzDy5fcVXCHbGtF/XU
         NInQ==
X-Gm-Message-State: AOAM531b53dQsiNAOGKyDzORARJyK90P6QJceIGltECIe51zhb9ei1lX
	CYm0pIYHpSYwBv/QTKl/1bJ+QSXyNzcqH7C5DotS8Q==
X-Google-Smtp-Source: ABdhPJzRP9OzjWdpg6cI3ylhn4k+6QO0736A21gHd6fEDFV4tnKVbdWhReuAz2gSne+SFZ3750d7D1xL3b8UC7zpu2M=
X-Received: by 2002:a25:84c3:0:b0:64a:de2c:2b75 with SMTP id
 x3-20020a2584c3000000b0064ade2c2b75mr1889370ybm.70.1652391089597; Thu, 12 May
 2022 14:31:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220512211704.3158759-1-nathan@kernel.org>
In-Reply-To: <20220512211704.3158759-1-nathan@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 12 May 2022 14:30:53 -0700
Message-ID: <CABCJKucbETQeRHx4bLG1fWZBnpszbrS9N+Ryp9sr2AcAY=9sxA@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix CFI violation with show_dynamic_id()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	LKML <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, May 12, 2022 at 2:17 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> When an attribute group is created with sysfs_create_group(), the
> ->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
> callback to kobj_attr_show(). kobj_attr_show() uses container_of() to
> get the ->show() callback from the attribute it was passed, meaning the
> ->show() callback needs to be the same type as the ->show() callback in
> 'struct kobj_attribute'.
>
> However, show_dynamic_id() has the type of the ->show() callback in
> 'struct device_attribute', which causes a CFI violation when opening the
> 'id' sysfs node under drm/card0/metrics. This happens to work because
> the layout of 'struct kobj_attribute' and 'struct device_attribute' are
> the same, so the container_of() cast happens to allow the ->show()
> callback to still work.
>
> Change the type of show_dynamic_id() to match the ->show() callback in
> 'struct kobj_attributes' and update the type of sysfs_metric_id to
> match, which resolves the CFI violation.
>
> Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFIG interface")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/i915/i915_perf.c       | 4 ++--
>  drivers/gpu/drm/i915/i915_perf_types.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index 0a9c3fcc09b1..1577ab6754db 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4050,8 +4050,8 @@ static struct i915_oa_reg *alloc_oa_regs(struct i915_perf *perf,
>         return ERR_PTR(err);
>  }
>
> -static ssize_t show_dynamic_id(struct device *dev,
> -                              struct device_attribute *attr,
> +static ssize_t show_dynamic_id(struct kobject *kobj,
> +                              struct kobj_attribute *attr,
>                                char *buf)
>  {
>         struct i915_oa_config *oa_config =
> diff --git a/drivers/gpu/drm/i915/i915_perf_types.h b/drivers/gpu/drm/i915/i915_perf_types.h
> index 473a3c0544bb..05cb9a335a97 100644
> --- a/drivers/gpu/drm/i915/i915_perf_types.h
> +++ b/drivers/gpu/drm/i915/i915_perf_types.h
> @@ -55,7 +55,7 @@ struct i915_oa_config {
>
>         struct attribute_group sysfs_metric;
>         struct attribute *attrs[2];
> -       struct device_attribute sysfs_metric_id;
> +       struct kobj_attribute sysfs_metric_id;
>
>         struct kref ref;
>         struct rcu_head rcu;

This looks correct to me. Thanks for testing this and fixing the issue!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
