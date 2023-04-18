Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F132510E6
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 04:41:44 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id m14so10658463ybk.4
        for <patches@lists.linux.dev>; Mon, 17 Apr 2023 21:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681792904; x=1684384904;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MmNCqthD+HS7Zi170wxRoVdfC1QjJufvMpFTlluYfgk=;
        b=5HIAuV2jRVPb0IzmRrjaTOEMld/LD1MF6ynGtV4zhwLZcRconkU/MaIg83VumtbJyk
         3vqG1IjqeZVwIY0K0fYqOUdfgnohulgubhh+Vd/HhVJKuC048gWuKMC2TM6G7Mr8QU1p
         y2AhDuMTlHUdw4tKtyhsDxLlaSSs2YUhbzu4kU8BqglUdL2wMIv5uqDgDW6zGokMf5XQ
         yKOvJ2UtxcwtMBPmNvslcODjKwEUm88cmtOO5IyAX66LLF1IP3vRQ6ALitYGFOrovhgp
         oUGPyt2zqjuAPLU2t1vmkJwXdpbJTBvuhxe0PnkdVTAqinwrOvkYMsux/hUVEcZBrNuC
         092A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681792904; x=1684384904;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MmNCqthD+HS7Zi170wxRoVdfC1QjJufvMpFTlluYfgk=;
        b=XndhzWQDK6p0aLXoi1s2RF6YRPuQ8Yjr50UmqAlWOOmUCofGp4I8u+hzvteejvTbHP
         e5WY0dXrBqeMOYN63J/LHPkPo7zhtLPM2gEVBrg9Xnw+tEeI6NaCveMXZAxclXCfH5wb
         +ZDhZDk6umJ1OiaFlP7l3V7zVH9np/xudab45CJVw5P7Wvn25nps7RV3E6jdd96Z+4Xl
         dYB9q6LrZOF31G5UHF9dt2utj0MSIjPF2iIBmADkw1ceoVwxKXOI/yFqbC4szDedPVIt
         SSYAj86GwXicarf4p9x2OuhSnoFY+j1oiSqJA6dhEOb/WesWK8uJhtKcVSNyd+eJBlNE
         Unvg==
X-Gm-Message-State: AAQBX9co9pu8o7WME2dOGVEXTVcVmmWSzNIja1C7KcOkDl6Hu+5Un+m9
	+CO55VzcpJXvkXJbGchbP/kyoQ==
X-Google-Smtp-Source: AKy350YSpBYh4FnbfdOkmTwnW4ECz0ExA/bjjnP+tRYaYmJoWhpFvQ8HJaqQh0Vrm08Y/2qCHvK31Q==
X-Received: by 2002:a05:6902:114d:b0:b8f:384b:4f83 with SMTP id p13-20020a056902114d00b00b8f384b4f83mr19369905ybu.33.1681792903775;
        Mon, 17 Apr 2023 21:41:43 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id w10-20020a05690204ea00b00b7767ca747csm3435131ybs.25.2023.04.17.21.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 21:41:43 -0700 (PDT)
Date: Mon, 17 Apr 2023 21:41:41 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To: Luis Chamberlain <mcgrof@kernel.org>
cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org, 
    brauner@kernel.org, linux-mm@kvack.org, p.raghav@samsung.com, 
    da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net, 
    yosryahmed@google.com, keescook@chromium.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 4/6] shmem: skip page split if we're not reclaiming
In-Reply-To: <20230309230545.2930737-5-mcgrof@kernel.org>
Message-ID: <cfaac1a4-20c6-bdd6-ff68-981e9a8858e@google.com>
References: <20230309230545.2930737-1-mcgrof@kernel.org> <20230309230545.2930737-5-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 9 Mar 2023, Luis Chamberlain wrote:

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
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  mm/shmem.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 68e9970baf1e..dfd995da77b4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1350,6 +1350,12 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>  	if (WARN_ON_ONCE(!wbc->for_reclaim))
>  		goto redirty;
>  
> +	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
> +		goto redirty;

Well, okay, I don't mind that.  But shall we take bets on how soon syzbot
(hope it's not watching) will try flipping SHM_LOCK on while swapping out
pages from a SHM segment, and hit that warning?  Perhaps I'm wrong, but I
don't think any serialization prevents that.

Hugh

> +
> +	if (!total_swap_pages)
> +		goto redirty;
> +
>  	/*
>  	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
>  	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> @@ -1365,10 +1371,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>  	}
>  
>  	index = folio->index;
> -	if (info->flags & VM_LOCKED)
> -		goto redirty;
> -	if (!total_swap_pages)
> -		goto redirty;
>  
>  	/*
>  	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
> -- 
> 2.39.1
