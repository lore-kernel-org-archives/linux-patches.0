Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA52C89
	for <patches@lists.linux.dev>; Sat,  5 Mar 2022 00:40:02 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id w27so16884182lfa.5
        for <patches@lists.linux.dev>; Fri, 04 Mar 2022 16:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9JoqIqG9ALTLtwDHVki+prFRlZFXcAlq6egQCrq7K48=;
        b=efp0vXLQSBCLYCI3HsefVtpqZZXuJRLS4N3VI9flJMKAMgRJUnfkeVb/vyDeUWEPKd
         9FbuGykdx82sBKQCwF5HnqcJYF8J++QohFB0xocObfnDpJEa9A7NcsIrEH41mJYPNUI1
         q41/VB+aniPDhQtodfgkwBr0uokQYYJgaJxhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9JoqIqG9ALTLtwDHVki+prFRlZFXcAlq6egQCrq7K48=;
        b=Sw2sYdKnFkPL+NEl0GMjC2e6Fx0+F+DCZxpCox2OWVGV1Bkz8wkbVDnizPaoRbH28L
         TjaAhjy8ex7R3/wvk+yDo75ydqNn0qxF5xJQwJDg77hdnLFOYg7Um2+p6RhWFI/A+3xi
         LU/sceA6a7xyCFfoVGP+IjF1w+EHDO8iUt/ZGsdYCUoaz2Z0Ji1fYAnjhKer8N6Y6NBb
         gQ4O8W71UmnULZ6w7cWkXMduSPHi2135CcnRWzxG9Md9Q966j4Kj3GDU0uji/g372aFj
         GIAB47Uq4PHCO4tvPOcVVz9aJEXvVsFmcecdGr0AyTvmp38a00L558Gbs5oLa9stdkfN
         j9sg==
X-Gm-Message-State: AOAM5323P8OiPFYOmY6dAUmEfEw2kl/708hv/jLaV6Gj0+dmKb897isc
	8zgpMXkCFEPgbIrps7aYLR8nRHbBRr9o9p2C9WAaww==
X-Google-Smtp-Source: ABdhPJx0r1fMEgm3S2vY9guOJrp9d60ZKv15dNXYUNF/NoP6qqYkcE+hHfNgtYqyq25t9LQKHhoRFCReOGVtUBsyhHY=
X-Received: by 2002:a05:6512:2190:b0:443:f5b2:67ef with SMTP id
 b16-20020a056512219000b00443f5b267efmr771891lft.670.1646440800257; Fri, 04
 Mar 2022 16:40:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304211524.10706-1-rdunlap@infradead.org>
In-Reply-To: <20220304211524.10706-1-rdunlap@infradead.org>
From: Dimitris Michailidis <d.michailidis@fungible.com>
Date: Fri, 4 Mar 2022 16:39:49 -0800
Message-ID: <CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
Subject: Re: [PATCH net-next?] net: fungible: fix multiple build problems
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, 
	Dimitris Michailidis <dmichail@fungible.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 4, 2022 at 1:15 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> It is currently possible to have CONFIG_FUN_ETH=3Dy and CONFIG_TLS=3Dm.

This combination is allowed if TLS_DEVICE=3Dn, which I suspect you have in =
your
config. I don't think you can get the combination otherwise. In that
case the driver
doesn't have TLS support and doesn't need anything from the TLS module.
The compile problems you see I think come from the next item.

> This causes build errors. Therefore FUN_ETH should
>         depend on TLS || TLS=3Dn
>
> TLS_DEVICE is a bool symbol, so there is no need to test it as
>         depends on TLS && TLS_DEVICE || TLS_DEVICE=3Dn
>
> And due to rules of precedence, the above means
>         depends on (TLS && TLS_DEVICE) || TLS_DEVICE=3Dn
> but that's probably not what was meant here. More likely it
> should have been
>         depends on TLS && (TLS_DEVICE || TLS_DEVICE=3Dn)
>
> That no longer matters.
>
> Also, gcc 7.5 does not handle the "C language" vs. #ifdef preprocessor
> usage of IS_ENABLED() very well -- it is causing compile errors.

I believe this is the source of the errors you see but it's not the compile=
r's
fault or something specific to 7.5.0. The errors are because when
IS_ENABLED() is false some of the symbols in the "if" are undefined and the
compiler checks them regardless.

> $ gcc --version
> gcc (SUSE Linux) 7.5.0
>
> And then funeth uses sbitmap, so it should select SBITMAP in order
> to prevent build errors.

Indeed. I think the "select SBITMAP" should be added to "config FUN_CORE"
though as that is the module using sbitmap.

> Fixes these build errors:
>
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function =E2=80=
=98write_pkt_desc=E2=80=99:
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:13: error: implic=
it declaration of function =E2=80=98tls_driver_ctx=E2=80=99 [-Werror=3Dimpl=
icit-function-declaration]
>    tls_ctx =3D tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
>              ^~~~~~~~~~~~~~
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:37: error: =E2=80=
=98TLS_OFFLOAD_CTX_DIR_TX=E2=80=99 undeclared (first use in this function);=
 did you mean =E2=80=98BPF_OFFLOAD_MAP_FREE=E2=80=99?
>    tls_ctx =3D tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
>                                      ^~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:37: note: each un=
declared identifier is reported only once for each function it appears in
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:245:23: error: derefe=
rencing pointer to incomplete type =E2=80=98struct fun_ktls_tx_ctx=E2=80=99
>    tls->tlsid =3D tls_ctx->tlsid;
>                        ^~
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function =E2=80=
=98fun_start_xmit=E2=80=99:
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:310:6: error: implici=
t declaration of function =E2=80=98tls_is_sk_tx_device_offloaded=E2=80=99 [=
-Werror=3Dimplicit-function-declaration]
>       tls_is_sk_tx_device_offloaded(skb->sk)) {
>       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:311:9: error: implici=
t declaration of function =E2=80=98fun_tls_tx=E2=80=99; did you mean =E2=80=
=98fun_xdp_tx=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    skb =3D fun_tls_tx(skb, q, &tls_len);
>          ^~~~~~~~~~
> ../drivers/net/ethernet/fungible/funeth/funeth_tx.c:311:7: warning: assig=
nment makes pointer from integer without a cast [-Wint-conversion]
>    skb =3D fun_tls_tx(skb, q, &tls_len);
>        ^
>
> and
>
> ERROR: modpost: "__sbitmap_queue_get" [drivers/net/ethernet/fungible/func=
ore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_finish_wait" [drivers/net/ethernet/fungible/func=
ore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_clear" [drivers/net/ethernet/fungible/func=
ore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_prepare_to_wait" [drivers/net/ethernet/fungible/=
funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_init_node" [drivers/net/ethernet/fungible/=
funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_wake_all" [drivers/net/ethernet/fungible/f=
uncore/funcore.ko] undefined!
>
> #Fixes: not-merged-yet ("X")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Dimitris Michailidis <dmichail@fungible.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/fungible/funeth/Kconfig     |    3 ++-
>  drivers/net/ethernet/fungible/funeth/funeth_tx.c |    9 ++++++---
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> --- mmotm-2022-0303-2124.orig/drivers/net/ethernet/fungible/funeth/Kconfi=
g
> +++ mmotm-2022-0303-2124/drivers/net/ethernet/fungible/funeth/Kconfig
> @@ -6,9 +6,10 @@
>  config FUN_ETH
>         tristate "Fungible Ethernet device driver"
>         depends on PCI && PCI_MSI
> -       depends on TLS && TLS_DEVICE || TLS_DEVICE=3Dn
> +       depends on TLS || TLS=3Dn
>         select NET_DEVLINK
>         select FUN_CORE
> +       select SBITMAP
>         help
>           This driver supports the Ethernet functionality of Fungible ada=
pters.
>           It works with both physical and virtual functions.
> --- mmotm-2022-0303-2124.orig/drivers/net/ethernet/fungible/funeth/funeth=
_tx.c
> +++ mmotm-2022-0303-2124/drivers/net/ethernet/fungible/funeth/funeth_tx.c
> @@ -234,7 +234,8 @@ static unsigned int write_pkt_desc(struc
>                         fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
>         }
>
> -       if (IS_ENABLED(CONFIG_TLS_DEVICE) && unlikely(tls_len)) {
> +#if IS_ENABLED(CONFIG_TLS_DEVICE)
> +       if (unlikely(tls_len)) {
>                 struct fun_eth_tls *tls =3D (struct fun_eth_tls *)gle;
>                 struct fun_ktls_tx_ctx *tls_ctx;
>
> @@ -250,6 +251,7 @@ static unsigned int write_pkt_desc(struc
>                 q->stats.tx_tls_pkts +=3D 1 + extra_pkts;
>                 u64_stats_update_end(&q->syncp);
>         }
> +#endif
>
>         u64_stats_update_begin(&q->syncp);
>         q->stats.tx_bytes +=3D skb->len + extra_bytes;
> @@ -306,12 +308,13 @@ netdev_tx_t fun_start_xmit(struct sk_buf
>         unsigned int tls_len =3D 0;
>         unsigned int ndesc;
>
> -       if (IS_ENABLED(CONFIG_TLS_DEVICE) && skb->sk &&
> -           tls_is_sk_tx_device_offloaded(skb->sk)) {
> +#if IS_ENABLED(CONFIG_TLS_DEVICE)
> +       if (skb->sk && tls_is_sk_tx_device_offloaded(skb->sk)) {
>                 skb =3D fun_tls_tx(skb, q, &tls_len);
>                 if (unlikely(!skb))
>                         goto dropped;
>         }
> +#endif
>
>         ndesc =3D write_pkt_desc(skb, q, tls_len);
>         if (unlikely(!ndesc)) {
