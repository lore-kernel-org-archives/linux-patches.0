Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CE61FD3
	for <patches@lists.linux.dev>; Sun,  2 Apr 2023 05:09:43 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso29542150pjb.0
        for <patches@lists.linux.dev>; Sat, 01 Apr 2023 22:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680412183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcLtKW5dA48qzTUGgoX0tKQeVpPNMnjuygndAHWt5os=;
        b=GMeoq310zOmtFnO+ZbfugK6HsZIFju4p8arLMffSNZlknshUAGo9SFe/6YEZaYgq7n
         MXwl9IoqYSYSO/IimzIITK28JnoDkfX4siV9m1Kf4yTFCa8Teznyz2hweCZjheEb7FW2
         Ju754vzEaSgiGnK3K05hblR/sUQpF1LWdbPhHIovsnrQPUW4uYI7NygezqjeB3ZBlp2q
         U65wKQKQg5VQErOw4ut0Po+Fl57BVUK7NWS5oKuwamOxfkG9aBxqIVlnUHBv2Geehlbd
         Hgl77r/Qr1j8bJrgoO7qUsWN2LK6+QLWznxl7Vq3AzJ4GF9tCaM3Kg8ldEWq4NmRD0zx
         mxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680412183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcLtKW5dA48qzTUGgoX0tKQeVpPNMnjuygndAHWt5os=;
        b=wDYifrWiKduBRJmG7wKnb6GzNLDutl+O5UkWkK/gFivdDpAFt1WR6yrrmME+LeNj3n
         xDNKvBSb3RftqE0sZsOV4wOz8ZEXr8m/nOVSOFpR2MpaQ92pcsp3NNfW+gO+Likp6lq1
         U88r9HNj88ZFpnL6QbZSx+v1zMfVzJk8pGgpekYTpi/yE868ICECm9/Ux0fH4ALpsSKZ
         +MOBHF67OJLFI0SClQG5JIKI8+sEtP9+0JN72uIFQ4LYJzVVFr0RksHku+0zpEgiQHge
         YePV0HXx1AuKtURezjyhFPV2UrlrQfZgq9mAotazVjYzfSjjpMOWPs19i9LQxUxCGXNw
         ePlQ==
X-Gm-Message-State: AAQBX9d/cIwR7DiSmwA3F8mbB/KcDsTJVeKPGxyuArbVDbIFbGkKC13j
	zbEtgv78AZ42uvrr01Us3UIOhGySHE7sVXfsRH4=
X-Google-Smtp-Source: AKy350YPuURXwC57sDalj6w4V2wbvUU3a1umoK+xHY28NA27tXIavSamvnvOj2xgLQ2E75kqn3Irm68wPpO6Wl5b7hg=
X-Received: by 2002:a17:90a:5145:b0:23d:551c:c5fb with SMTP id
 k5-20020a17090a514500b0023d551cc5fbmr9770700pjm.4.1680412183513; Sat, 01 Apr
 2023 22:09:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230401094658.11146-1-vbabka@suse.cz>
In-Reply-To: <20230401094658.11146-1-vbabka@suse.cz>
From: Jeff Xie <xiehuan09@gmail.com>
Date: Sun, 2 Apr 2023 13:09:31 +0800
Message-ID: <CAEr6+EBK1WUq0U9n3VwhU1+=F5X7-654v0XwqHtENOt98HU0gw@mail.gmail.com>
Subject: Re: [PATCH] mm: remove all the slab allocators
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 1, 2023 at 5:47=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> As the SLOB removal is on track and the SLAB removal is planned, I have
> realized - why should we stop there and not remove also SLUB? What's a
> slab allocator good for in 2023? The RAM sizes are getting larger and
> the modules cheaper [1]. The object constructor trick was perhaps
> interesting in 1994, but not with contemporary CPUs. So all the slab
> allocator does today is just adding an unnecessary layer of complexity
> over the page allocator.
>
> Thus, with this patch, all three slab allocators are removed, and only a
> layer that passes everything to the page allocator remains in the slab.h
> and mm/slab_common.c files. This will allow users to gradually
> transition away and use the page allocator directly. To summarize the
> advantages:
>
> - Less code to maintain: over 13k lines are removed by this patch, and
>   more could be removed if I wast^Wspent more time on this, and later as
>   users are transitioned from the legacy layer. This no longer needs a
>   separate subsystem so remove it from MAINTAINERS (I hope I can keep the
>   kernel.org account anyway, though).
>
> - Simplified MEMCG_KMEM accounting: while I was lazy and just marked it
>   BROKEN in this patch, it should be trivial to use the page memcg
>   accounting now that we use the page allocator. The per-object
>   accounting went through several iterations in the past and was always
>   complex and added overhead. Page accounting is much simpler by
>   comparison.
>
> - Simplified KASAN and friends: also was lazy in this patch so they
>   can't be enabled but should be easy to fix up and work just on the
>   page level.
>
> - Simpler debugging: just use debug_pagealloc=3Don, no need to look up th=
e
>   exact syntax of the absurdly complex slub_debug parameter.

This really simplifies the complexity of dealing with memory problems
in the production environment,
 and I hope it can be merged into the linux kernel soon.

Acked-by: Jeff Xie <xiehuan09@gmail.com>

--=20
Thanks,
JeffXie
