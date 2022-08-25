Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1233C30
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 18:20:00 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id bq23so20279593lfb.7
        for <patches@lists.linux.dev>; Thu, 25 Aug 2022 11:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=LzcSMU79flsCFGsYwPA8jm006j9ntJHVrXRums+x4hg=;
        b=SYv3Q3AaGa03fEqdwIrUan3UK8SVmw9Z+8W0B7f1Bj2B8+vTNPtKhvy5T89n7XvozG
         NDgrl5LlirpCD9r3IS2kZBXYAE8dV6QP7j2D5koQYtr3nUg9jAbPihRKFqrhn5RwEcp7
         BZd5umqi6jfrO6Cx8Bgf7w4lG0lyQa4YV0Q/DkOpfm5hmLCPyrSHeF6USOHTKnb82axs
         UbqNS0wIZUyhVt9oIeAumA1MQ798CrLeXJrUDk7NUqGzWAQI6IfNL7t9zG0bFBciPxy1
         +Yq1LnHzDtJzsiTKE4JhDpzYlvm+dVVQN2UNFpkKFOEdD6wZ+Y0MP9sxzTcXJXAlNHDb
         gwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=LzcSMU79flsCFGsYwPA8jm006j9ntJHVrXRums+x4hg=;
        b=iLpV+At3d+oe4kL8wuUW+qLaIoB9/P55KLH4aKgpWncO3W6NniI2DyGPt4+hQ5oaxl
         Sz3coz/4VA+XcIsajQCKGMfBMbDVKwfHspVMgHdzUTqUWKf0G242F1eaOWhmbXobSVIs
         PjD5QTf13CyWnpckcae2MS+DFQ58L+MOWk6dspuptpstNAmQuiaZWZbYN70nxFmjx9ld
         fuwdm5KpsJXEcw/2f1ComZHOqOfy+3zSYxjeViiMfVjkDwlu3HoeDawa5He5tHNDHMKa
         X8Qut4svtyp38hEfewW1ZO+tmzHa09ubZicW49fCUdfL1txNtKxXJmghe2H+xNwe/uBo
         1bnQ==
X-Gm-Message-State: ACgBeo3gl9UGJ75brdVX6BHO0zi7LQ4MgWj+Lb75U79QrFlvb8tpIat2
	EtWxteFAxYWhBSc9+3d12Y92TKODAS4jomK7tvhDAQ==
X-Google-Smtp-Source: AA6agR4DcOai/4bkoqgXsxN2AlpaLedM35dK8SSB6wQ+78buD9y4OrDy89oUbjQQpHxrnsnUIN+AQrnsjuDafmd1nR8=
X-Received: by 2002:a05:6512:158b:b0:48b:38:cff8 with SMTP id
 bp11-20020a056512158b00b0048b0038cff8mr1399470lfb.100.1661451598905; Thu, 25
 Aug 2022 11:19:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220825180607.2707947-1-nathan@kernel.org>
In-Reply-To: <20220825180607.2707947-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 25 Aug 2022 11:19:47 -0700
Message-ID: <CAKwvOdmNCT+USwe5Lui27Oa1jfNyy3NwP3jW=Q7JJi1R5ibRnw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx5e: Do not use err uninitialized in mlx5e_rep_add_meta_tunnel_rule()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Tom Rix <trix@redhat.com>, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 25, 2022 at 11:06 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>           if (IS_ERR(flow_rule)) {
>               ^~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
>           return err;
>                 ^~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:2: note: remove the 'if' if its condition is always true
>           if (IS_ERR(flow_rule)) {
>           ^~~~~~~~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:474:9: note: initialize the variable 'err' to silence this warning
>           int err;
>                 ^
>                   = 0
>   1 error generated.
>
> There is little reason to have the 'goto + error variable' construct in
> this function. Get rid of it and just return the PTR_ERR value in the if
> statement and 0 at the end.
>
> Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1695
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the fix!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index c8617a62e542..a977804137a8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -471,22 +471,18 @@ mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
>         struct mlx5_eswitch_rep *rep = rpriv->rep;
>         struct mlx5_flow_handle *flow_rule;
>         struct mlx5_flow_group *g;
> -       int err;
>
>         g = esw->fdb_table.offloads.send_to_vport_meta_grp;
>         if (!g)
>                 return 0;
>
>         flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
> -       if (IS_ERR(flow_rule)) {
> -               err = PTR_ERR(flow_rule);
> -               goto out;
> -       }
> +       if (IS_ERR(flow_rule))
> +               return PTR_ERR(flow_rule);
>
>         rpriv->send_to_vport_meta_rule = flow_rule;
>
> -out:
> -       return err;
> +       return 0;
>  }
>
>  static void
>
> base-commit: c19d893fbf3f2f8fa864ae39652c7fee939edde2
> --
> 2.37.2
>


-- 
Thanks,
~Nick Desaulniers
