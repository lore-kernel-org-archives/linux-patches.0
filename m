Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF1F6FD5
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 19:50:35 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id ec29so12620771edb.6
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 11:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678132233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGF3eBQCskPypQoa4poy914imrg9HtlxceInjpF7/z4=;
        b=mZ8aHkID3MYrdt/9Uj6MWAdKC+ca9LbPlDVSB+E2WxwydB9b5hNluXDkOI0ZIRIt6H
         JaqJBKlSeEI8ktDXf45lH4gll8I70MjIrn9Qg6DA83IlaJ6dX3Qjr1NoqnHm5SKdzT+1
         G0uXCK/1NJ/BWwryali1SKHJXLIz3z+Q52bu7PKzK4jUpW+a9aHPbHjkAEoBbDiS5xsL
         0xu2/ka/xWdjtna14tYdM/Lav4k2ZAlt4BUNXI5IzpKEaepS1llmLMJLj81yDJiYwQN7
         CHQWI3cMAAN9AdtB8q/EC+tlMFFVpnLa+lE7pEdgigAxXp00OiBF/7NESSZ2NudVvgqH
         /Hsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678132233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGF3eBQCskPypQoa4poy914imrg9HtlxceInjpF7/z4=;
        b=kBTnuukjZPlGSbJwiIn5Vt2efpw2u7kYVUXlWydu1+r/iPmdJ/s+SCzyV/R9ytg495
         mh7pYbf63TaxCzoiliu1Ae5n93kP487j9Ul+aA6454kyXkmpfa4CGj7VNeXVDKy/RQ4f
         bTDwSanLGCJtVutA4sa98zXiqmzNZqkWZ8zs6XFE/mXRs4r31jim0KBYwpM0uGS65EWG
         kj+RjLHznBuI2MxPXwo5ZVuSOZzxyvtvt/5AoTc1zskigRXJdB+495hn3KC6yIdxzhsi
         IWiOqp3NR8Q/H0HretSge6bnCsggXuvXnal/9qxQYzA8MjV/V7BewZXJ8vwJqf+VgKZa
         sCNg==
X-Gm-Message-State: AO0yUKVq15a/i84rcT6fbZiQu2gWytFyK+m7+/FlnL1qomignlrtIUyW
	J6qwKb1vKEf3IyQCMBbBHJGjgWnXiwPEovxeUAc52A==
X-Google-Smtp-Source: AK7set/KxagLsz+HgruUKFFw19IQyTEgXRH5QRjlFyA1p1b8uEBesr2ZKqCVm3jOD9bsKoSfy751fj3R+bUQhbTtAt0=
X-Received: by 2002:a50:8711:0:b0:4bb:d098:2138 with SMTP id
 i17-20020a508711000000b004bbd0982138mr6450122edb.5.1678132233505; Mon, 06 Mar
 2023 11:50:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302232758.888157-1-mcgrof@kernel.org> <20230302232758.888157-5-mcgrof@kernel.org>
In-Reply-To: <20230302232758.888157-5-mcgrof@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Mar 2023 11:49:57 -0800
Message-ID: <CAJD7tkbH5c-D9nvhSW6MNvDiBUBVJTpkJCbNvAamL_a801P7Sg@mail.gmail.com>
Subject: Re: [PATCH 4/6] shmem: skip page split if we're not reclaiming
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org, 
	brauner@kernel.org, linux-mm@kvack.org, p.raghav@samsung.com, 
	da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net, 
	keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 2, 2023 at 3:28=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org>=
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
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Yosry Ahmed <yosryahmed@google.com>

> ---
>  mm/shmem.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a5a6da51087e..6006dbb7dbcb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1352,6 +1352,12 @@ static int shmem_writepage(struct page *page, stru=
ct writeback_control *wbc)
>                 goto redirty;
>         }
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
> @@ -1367,10 +1373,6 @@ static int shmem_writepage(struct page *page, stru=
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
