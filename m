Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049AF8480
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 17:36:06 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id 131so2224823ybl.3
        for <patches@lists.linux.dev>; Fri, 04 Nov 2022 10:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I3Gzf6/nexPToRji6N5bO/dL9FXtbk5UeonSa66mO0w=;
        b=RJ1/fYDFtRMRRV1tOozcs1tCUlJ4hIhtltYrdQ8trNvIMsH4D9xeKDU3XEN/RzhS0P
         NNo829xVbvZ4/m7TXi3cpBgoKHU8V2tcxJsuByE4wjNfre3z1+xmXKMZBeVVVI9bSHzT
         MgV++LB+c3iLth3betc4rykAI+DMJsn4nWT5tzbd1f8DGkM8bXTye3sNhGnVShHnUt5e
         Lzq12o38A6inUoSZAiQ+AXiUMD6dxklJA9dx/jqp3t4dAwD6timxHAThVx8/iwmAoZ6M
         NVId/Z27xUnrIAwuzFJnocW/z6hHoPBWiE6arMLAvadcW7QSxurqlWgFejl/vFCYWMhj
         qvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3Gzf6/nexPToRji6N5bO/dL9FXtbk5UeonSa66mO0w=;
        b=vAwza8Q2CdnMDBFkVWYKYvIROPyTxI074wQ//OYr5MpxgZgKaNSaxBTwyI8CDcPB9t
         ZmJKyax8bGG+E5JLCr+FcrH9CKXM49+DEPvxnPocro3veKmJEX4twh0DnSFJ7/d6LQq9
         ejIlP0SiD/2rYI+aiZ/ROzsRtGbtzr17H4KlkfOsFmAEA1X3B9nBep9hYhqgARA9mgSj
         PEwWi1t0KqkTn8SI4XzSeDnSkPk/JfLQRjp5KvMj0NIHXVCDa8yINIjQy7Lwjc/l/dAN
         3in5f/ySUbDfunl0fvc/q48EytTioibCPxUDv+gKaah3y6YXtKb7OxftpgVkYUA3KQuf
         4csg==
X-Gm-Message-State: ANoB5pkPKi/K2qvaBPHA/mC0tV4nFbtQZeFSOY2LKiuhgGweYjYEZQEg
	PAS4EHd8v6yMZVRcfYhQzra7e/pn0ClOeMl/+UnbQg==
X-Google-Smtp-Source: AA0mqf5NoDRt6raEcSo5u5nI7z7HAfUPqxb4X7Rxa/1vFG+y2xtdXFj/Z2GR+JHJyyOUNnt5FRnDr6Eq3QJM396H2KE=
X-Received: by 2002:a25:b83:0:b0:6d3:bb1d:305e with SMTP id
 125-20020a250b83000000b006d3bb1d305emr2472905ybl.598.1667583365610; Fri, 04
 Nov 2022 10:36:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org> <20221102022056.996215743@linuxfoundation.org>
 <20221104171155.GA29661@duo.ucw.cz> <CANn89iKfhPA6qMvdJ50RV2XZAPcmkUhNDVK4Fj6L5bsaxzdaVA@mail.gmail.com>
 <20221104173140.GA980@duo.ucw.cz>
In-Reply-To: <20221104173140.GA980@duo.ucw.cz>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 4 Nov 2022 10:35:54 -0700
Message-ID: <CANn89iLUdwSytmjOO8TT0pPYTshxc5sZD9H7O0pqU+hPXBc4AQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 69/91] ipv6: ensure sane device mtu in tunnels
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>, 
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 4, 2022 at 10:31 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > > > [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
> > > >
> > > > Another syzbot report [1] with no reproducer hints
> > > > at a bug in ip6_gre tunnel (dev:ip6gretap0)
> > > >
> > > > Since ipv6 mcast code makes sure to read dev->mtu once
> > > > and applies a sanity check on it (see commit b9b312a7a451
> > > > "ipv6: mcast: better catch silly mtu values"), a remaining
> > > > possibility is that a layer is able to set dev->mtu to
> > > > an underflowed value (high order bit set).
> > > >
> > > > This could happen indeed in ip6gre_tnl_link_config_route(),
> > > > ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
> > > >
> > > > Make sure to sanitize mtu value in a local variable before
> > > > it is written once on dev->mtu, as lockless readers could
> > > > catch wrong temporary value.
> > >
> > > Ok, but now types seem to be confused:
> > >
> > > > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > > > index 3a2741569b84..0d4cab94c5dd 100644
> > > > --- a/net/ipv6/ip6_tunnel.c
> > > > +++ b/net/ipv6/ip6_tunnel.c
> > > > @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> > > >       struct net_device *tdev = NULL;
> > > >       struct __ip6_tnl_parm *p = &t->parms;
> > > >       struct flowi6 *fl6 = &t->fl.u.ip6;
> > > > -     unsigned int mtu;
> > > >       int t_hlen;
> > > > +     int mtu;
> > > >
> > > >       memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
> > > >       memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> > > > @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
> > > >                       dev->hard_header_len = tdev->hard_header_len + t_hlen;
> > > >                       mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
> > >
> > > mtu is now signed, but we still do min_t on unsigned types.
> > >
> > > > -                     dev->mtu = mtu - t_hlen;
> > > > +                     mtu = mtu - t_hlen;
> > > >                       if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> > > > -                             dev->mtu -= 8;
> > > > +                             mtu -= 8;
> > > >
> > >
> > > I don't see overflow potential right away, but it may be worth fixing.
> > >
> >
> > This was intended ( part of the fix) so that the following check is
> > going to catch 'negative' mtu
> >
> > [1]
> > if (mtu < IPV6_MIN_MTU)
> >     mtu = IPV6_MIN_MTU;
> >
> > Otherwise, if a fuzzer succeeds to get mtu = 0xFFFFFFC0,
> > sanity test [1] leaves the problematic mtu in dev->mtu.
>
> This is the line I'm complaining about (1525 in 5.10):
>
> mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
>
> I don't think it does any harm, but it looks wrong/confusing.
>

So you are confused by :

some_integer_var = some_unsigned_int_expression;

I do not see any issue with that.

Thanks.
