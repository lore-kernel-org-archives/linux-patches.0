Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44D2C26E
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:09:39 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id da10so13550835edb.3
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 15:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678403378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L82LLAFa3yKPGqihEjumWOS8LCu91FNhSAsS82H2S9Y=;
        b=YL+yymwll8LWqsXH9BumplzZ1FYULA6wAuo2rS5NSlsw7qMzmpSEGnyuwl+92wgoKc
         AGVm89QmivXRyOWbYzZXYYYph8BTyq5K0zc71DpKbVqtD4WFI1xakRh0NWOM2Nh9hAS1
         A4jjCH0UULVIQXSPgrnVTD/KRjI/aSGFMD6a0f1si8McUSgFNqR02Wa+y7sZ36qBBD9I
         8ZZpg9j5LjzgrPBfzMgUvfgX/c/aiLKBSvQl0AAlBr/JpG69m9OZr16xmln/Sr/hlkgV
         qqKByUoCXeXt9wI3FjbXDE6q7akRssXth/EaIDXsy2HLRK+YpxcxfKvQMf/ou3eCkXp8
         7eeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678403378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L82LLAFa3yKPGqihEjumWOS8LCu91FNhSAsS82H2S9Y=;
        b=ji+KpN08LEhVwyiRzuE8DbcevW0gRVF3+lEEidz3/IwEX08HNSpte3q7lERGMV4JeT
         klNR2tTx5a2K57KAiRc3Q3igc3jLRQVdQiWv83P8yhimQz9eotG+DC2jPnXJTdO8BJki
         sdo5NNQY9KGo4BGIIpkprooeW3WD0Je+AQI/pQAeCn/A8phaAkwdY6idhtmc5IzRmz9X
         KpzczS9MYoiZ96134o1I6iulpzCy2imGl3nt6SN25NLpHCtEJ9Kd15fM5gmNUbXgRW45
         pyyoriIQ8X+Zlc2tZvq8N+1skOE/KGfIRKcA7sL55EwdFuwWDIy7gf6zwKHQ/tWk2vdM
         Qb5Q==
X-Gm-Message-State: AO0yUKUAxnCZIzEdMaopX+4q88zVJ9Df2Pdl+TkgMulZG0UjCGCMZUND
	FYqPZ9wMguzyIDY7pisQn4KtIG0OyJbmOCNdGJc9yA==
X-Google-Smtp-Source: AK7set8AcinN2hr2zJihYxX8vcj8C1IPM0eI53YU3Xrhk3kW37BWKt78hyHgHxxiBGSv7riWGLA37o19ds/90kmhRL0=
X-Received: by 2002:a17:906:b11:b0:8f3:9ee9:f1e2 with SMTP id
 u17-20020a1709060b1100b008f39ee9f1e2mr197745ejg.5.1678403377576; Thu, 09 Mar
 2023 15:09:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230309230545.2930737-1-mcgrof@kernel.org> <20230309230545.2930737-5-mcgrof@kernel.org>
In-Reply-To: <20230309230545.2930737-5-mcgrof@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 9 Mar 2023 15:09:01 -0800
Message-ID: <CAJD7tka+4gaEUHWcUQu9fgLrGmuoZDb3Yp7GT4fv=Tzrwobd4g@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] shmem: skip page split if we're not reclaiming
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org, 
	brauner@kernel.org, linux-mm@kvack.org, p.raghav@samsung.com, 
	da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net, 
	keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 9, 2023 at 3:05=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org>=
 wrote:
>
> In theory when info->flags & VM_LOCKED we should not be getting
> shem_writepage() called so we should be verifying this with a
> WARN_ON_ONCE(). Since we should not be swapping then best to ensure
> we also don't do the folio split earlier too. So just move the check
> early to avoid folio splits in case its a dubious call.
>
> We also have a similar early bail when !total_swap_pages so just move
> that earlier to avoid the possible folio split in the same situation.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>

> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  mm/shmem.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 68e9970baf1e..dfd995da77b4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1350,6 +1350,12 @@ static int shmem_writepage(struct page *page, stru=
ct writeback_control *wbc)
>         if (WARN_ON_ONCE(!wbc->for_reclaim))
>                 goto redirty;
>
> +       if (WARN_ON_ONCE(info->flags & VM_LOCKED))
> +               goto redirty;
> +
> +       if (!total_swap_pages)
> +               goto redirty;
> +
>         /*
>          * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "alway=
s" or
>          * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge p=
ages,
> @@ -1365,10 +1371,6 @@ static int shmem_writepage(struct page *page, stru=
ct writeback_control *wbc)
>         }
>
>         index =3D folio->index;
> -       if (info->flags & VM_LOCKED)
> -               goto redirty;
> -       if (!total_swap_pages)
> -               goto redirty;
>
>         /*
>          * This is somewhat ridiculous, but without plumbing a SWAP_MAP_F=
ALLOC
> --
> 2.39.1
>
