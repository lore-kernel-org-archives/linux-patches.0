Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764D28480
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 17:23:44 +0000 (UTC)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-3691e040abaso49513117b3.9
        for <patches@lists.linux.dev>; Fri, 04 Nov 2022 10:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qjeSPcfZKsfnrVevxgSeMkvqmACOU3/OJEjGUxStCPE=;
        b=Hc8xWNdGHH0Jju5ZVWxwrwy0Q+Xj2WiAaA5nT4BYBXQuB/dJr4yeV2LKi4x0ezIguw
         k1c5MLbf0m3HIJeijOFHdpBa/gxkB9OZT7lkdubqxU/NgJ+/YlHnh9GOUiOItq+ca6tT
         PFGzH6AEIfHyF225+4Rw9fXgOQkZd8Ex7gzM1D+40FTDkWblJVLzI3H1nM3os7po/+fd
         9bTBlqch2pDoiZFxbbqtHweTj8t16Ml7kk8mz3NeQ0L9+2YZn4gmFFaFUxwAnPL/UU6t
         b1bsSXWNPMofYF44HsPlDOSVm5mves0msDE3R+QjkwJ1ajGGCtzRhtUm+Y8GinnOWgf2
         cr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjeSPcfZKsfnrVevxgSeMkvqmACOU3/OJEjGUxStCPE=;
        b=imSimVuSuCIIvtxN79mHPEbPPvzsZcg5RCgWOkuq6LIsfci6JxxvFNsDlH8maUqapM
         RO7s/xJpGvikm4Xvl3T8lN5VnLVEAkvwbc8tEOeH8MXEGMxVZ9ap9KRyC6kpCGuZuOJB
         adBhWv/HuNtlHDdlnNTOauFXQszzB+REfwlScSClHNZ3sGEKu6hq/YvUjkyag7NVT+u3
         eRu59kQSsq2WaC4EAB59mTaAczZha0mYJlkdyJw3uKnusRecpWTqGUftQQu8RDXpOJAJ
         Dz/O4b5evV2MdRQpm/NOX/9o9Tv+yB49qkZtv/iPgE3nh00t6JpQGaRoHIY+pL0Q+JKw
         wkrQ==
X-Gm-Message-State: ACrzQf2GAAvNQzddtrL0TOcXuXenBgFj4ZhGg0lSPoHEOuZpv3Bvhqyd
	H4O40KPblaBRLLeE8vXnuzJ7M5UFFoyKB47xEi/Ilg==
X-Google-Smtp-Source: AMsMyM7TAGfxSN3KjUNx0FJxNdz1y5kpNt0VqpDfMd/ts5Oq8a3j/gb56UqXzHwTXbEOlKxtO7l9CFhYqTv9xhWuC6w=
X-Received: by 2002:a81:5a86:0:b0:36f:cece:6efd with SMTP id
 o128-20020a815a86000000b0036fcece6efdmr34064709ywb.489.1667582623102; Fri, 04
 Nov 2022 10:23:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org> <20221102022056.996215743@linuxfoundation.org>
 <20221104171155.GA29661@duo.ucw.cz>
In-Reply-To: <20221104171155.GA29661@duo.ucw.cz>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 4 Nov 2022 10:23:32 -0700
Message-ID: <CANn89iKfhPA6qMvdJ50RV2XZAPcmkUhNDVK4Fj6L5bsaxzdaVA@mail.gmail.com>
Subject: Re: [PATCH 5.10 69/91] ipv6: ensure sane device mtu in tunnels
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>, 
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 4, 2022 at 10:11 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
> >
> > Another syzbot report [1] with no reproducer hints
> > at a bug in ip6_gre tunnel (dev:ip6gretap0)
> >
> > Since ipv6 mcast code makes sure to read dev->mtu once
> > and applies a sanity check on it (see commit b9b312a7a451
> > "ipv6: mcast: better catch silly mtu values"), a remaining
> > possibility is that a layer is able to set dev->mtu to
> > an underflowed value (high order bit set).
> >
> > This could happen indeed in ip6gre_tnl_link_config_route(),
> > ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
> >
> > Make sure to sanitize mtu value in a local variable before
> > it is written once on dev->mtu, as lockless readers could
> > catch wrong temporary value.
>
> Ok, but now types seem to be confused:
>
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index 3a2741569b84..0d4cab94c5dd 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> >       struct net_device *tdev = NULL;
> >       struct __ip6_tnl_parm *p = &t->parms;
> >       struct flowi6 *fl6 = &t->fl.u.ip6;
> > -     unsigned int mtu;
> >       int t_hlen;
> > +     int mtu;
> >
> >       memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
> >       memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> > @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> >                       dev->hard_header_len = tdev->hard_header_len + t_hlen;
> >                       mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
>
> mtu is now signed, but we still do min_t on unsigned types.
>
> > -                     dev->mtu = mtu - t_hlen;
> > +                     mtu = mtu - t_hlen;
> >                       if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> > -                             dev->mtu -= 8;
> > +                             mtu -= 8;
> >
>
> I don't see overflow potential right away, but it may be worth fixing.
>

This was intended ( part of the fix) so that the following check is
going to catch 'negative' mtu

[1]
if (mtu < IPV6_MIN_MTU)
    mtu = IPV6_MIN_MTU;

Otherwise, if a fuzzer succeeds to get mtu = 0xFFFFFFC0,
sanity test [1] leaves the problematic mtu in dev->mtu.

Thanks.
