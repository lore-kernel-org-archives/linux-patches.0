Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF32133D7
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 18:36:10 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-51456392cbbso5287537a12.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 11:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685644569; x=1688236569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqdld08AHlocCOE5HPdzOheyuuDMewclsKeA9B/chwo=;
        b=wi8KuBahrZlj0SDPP88Ia4mG5ZAKPAEDf9GHkf7bJ2BnlCAF4Y5OMShh9C0X/XuDPG
         I2cbBoXkCuMusSj8vn8brqiWQ/dR9Cnmmc5hUvdFVU1c1eNhRVxiAJpaUgHuJmK26BPC
         6xvB0b9Bwv0SqERNmdRo3iTuSxd/3T2sF2XDJe8hyfo+BizkeED8dyeHTnNNFHwVuD1L
         JxmS+J28hj3j7eAcqZqYfIl5q/G+vYpiDFJiNcUtWwqLdgDt6Qr6rECxM35OuAOL7ZF+
         DYs25rUgUwBPZExib4RP18X08Pdyi3/Hbfp3s4H1xnnTnfgvujmn8DBr5c317Qw1lmob
         O3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685644569; x=1688236569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqdld08AHlocCOE5HPdzOheyuuDMewclsKeA9B/chwo=;
        b=j3r9apmyWAwLZsUvE6z0TppRfIvSDHMMOkF/nC/JMRMckYVlbhpiE4SJucjyzdIT2f
         zkV9QXP3c0Dud0K9iiVgzHFi8TGP7jw+uUxi9Jg6+5ow6vqL7t+McTmy6ldEq4p4lKNo
         yDKPiPoxbhnDDZLLBf2ozMhpTJwudQvnXUaDeaCMg8F/Z3dqK2QJGhzYmdAKA19pemEg
         3WbA19Nj/2d1RuKPIxXygY49ucgneJjzB7isc/FZSFam46eqWRYPcNT82ADEPuJXRSzI
         KicfEZ1prtFHIGCp0OCubN7meDm9Odu3fJlZ/o96JyAb5AVREsEE1evVuOJkW3gD5pYn
         b0lg==
X-Gm-Message-State: AC+VfDxt6O+10laNankjn8+0vfs+iCIsQSS+PdUSYRT21Jjc3nBQOQQR
	5cay5uWbRZIycskOgCFEkJZ5e/SDA9lWGOy72VY8lw==
X-Google-Smtp-Source: ACHHUZ6dQSS8Kpm/QKkdqSH2j/BI0GGqWfeOf2DFfBKMT6o9HFX2IqHbD5OXiszDm3y26MaFIThfifQ2VB/+wTwcNeQ=
X-Received: by 2002:a17:907:3e02:b0:96a:b6e1:66d9 with SMTP id
 hp2-20020a1709073e0200b0096ab6e166d9mr3029393ejc.7.1685644568661; Thu, 01 Jun
 2023 11:36:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601-zswap-cgroup-wsometimes-uninitialized-v2-1-84912684ac35@kernel.org>
In-Reply-To: <20230601-zswap-cgroup-wsometimes-uninitialized-v2-1-84912684ac35@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 1 Jun 2023 11:35:32 -0700
Message-ID: <CAJD7tkYymYNHt9NfYq3s5KR0BytzD8bCo7oaR8T7C2hXZdgGpw@mail.gmail.com>
Subject: Re: [PATCH v2] zswap: Avoid uninitialized use of ret in zswap_frontswap_store()
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, 
	vitaly.wool@konsulko.com, nphamcs@gmail.com, ndesaulniers@google.com, 
	trix@redhat.com, linux-mm@kvack.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 1, 2023 at 11:34=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns:
>
>   mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized whenever=
 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   mm/zswap.c:1327:9: note: uninitialized use occurs here
>    1327 |         return ret;
>         |                ^~~
>   mm/zswap.c:1183:2: note: remove the 'if' if its condition is always fal=
se
>    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1184 |                 goto reject;
>         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence this =
warning
>    1158 |         int ret;
>         |                ^
>         |                 =3D 0
>   1 error generated.
>
> This condition used to return -ENOMEM by going to the shrink label, so
> set ret to -ENOMEM in the if block explicitly to avoid using it
> uninitialized.
>
> Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
> Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks!

Reviewed-by: Yosry Ahmed <yosryahmed@google.com>

> ---
> Changes in v2:
> - Change ret to -ENOMEM to match this condition's previous return value
>   (Yosry)
> - Link to v1: https://lore.kernel.org/r/20230601-zswap-cgroup-wsometimes-=
uninitialized-v1-1-35debdd19293@kernel.org
> ---
>  mm/zswap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cff93643a6ab..30092d9a3b23 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type, pg=
off_t offset,
>          * local cgroup limits.
>          */
>         objcg =3D get_obj_cgroup_from_page(page);
> -       if (objcg && !obj_cgroup_may_zswap(objcg))
> +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> +               ret =3D -ENOMEM;
>                 goto reject;
> +       }
>
>         /* reclaim space if needed */
>         if (zswap_is_full()) {
>
> ---
> base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
> change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff4247ed
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
