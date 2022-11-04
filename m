Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319938480
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 17:31:42 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 83D811C09F0; Fri,  4 Nov 2022 18:31:40 +0100 (CET)
Date: Fri, 4 Nov 2022 18:31:40 +0100
From: Pavel Machek <pavel@denx.de>
To: Eric Dumazet <edumazet@google.com>
Cc: Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 69/91] ipv6: ensure sane device mtu in tunnels
Message-ID: <20221104173140.GA980@duo.ucw.cz>
References: <20221102022055.039689234@linuxfoundation.org>
 <20221102022056.996215743@linuxfoundation.org>
 <20221104171155.GA29661@duo.ucw.cz>
 <CANn89iKfhPA6qMvdJ50RV2XZAPcmkUhNDVK4Fj6L5bsaxzdaVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <CANn89iKfhPA6qMvdJ50RV2XZAPcmkUhNDVK4Fj6L5bsaxzdaVA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
> > >
> > > Another syzbot report [1] with no reproducer hints
> > > at a bug in ip6_gre tunnel (dev:ip6gretap0)
> > >
> > > Since ipv6 mcast code makes sure to read dev->mtu once
> > > and applies a sanity check on it (see commit b9b312a7a451
> > > "ipv6: mcast: better catch silly mtu values"), a remaining
> > > possibility is that a layer is able to set dev->mtu to
> > > an underflowed value (high order bit set).
> > >
> > > This could happen indeed in ip6gre_tnl_link_config_route(),
> > > ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
> > >
> > > Make sure to sanitize mtu value in a local variable before
> > > it is written once on dev->mtu, as lockless readers could
> > > catch wrong temporary value.
> >
> > Ok, but now types seem to be confused:
> >
> > > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > > index 3a2741569b84..0d4cab94c5dd 100644
> > > --- a/net/ipv6/ip6_tunnel.c
> > > +++ b/net/ipv6/ip6_tunnel.c
> > > @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl =
*t)
> > >       struct net_device *tdev =3D NULL;
> > >       struct __ip6_tnl_parm *p =3D &t->parms;
> > >       struct flowi6 *fl6 =3D &t->fl.u.ip6;
> > > -     unsigned int mtu;
> > >       int t_hlen;
> > > +     int mtu;
> > >
> > >       memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
> > >       memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> > > @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tn=
l *t)
> > >                       dev->hard_header_len =3D tdev->hard_header_len =
+ t_hlen;
> > >                       mtu =3D min_t(unsigned int, tdev->mtu, IP6_MAX_=
MTU);
> >
> > mtu is now signed, but we still do min_t on unsigned types.
> >
> > > -                     dev->mtu =3D mtu - t_hlen;
> > > +                     mtu =3D mtu - t_hlen;
> > >                       if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMI=
T))
> > > -                             dev->mtu -=3D 8;
> > > +                             mtu -=3D 8;
> > >
> >
> > I don't see overflow potential right away, but it may be worth fixing.
> >
>=20
> This was intended ( part of the fix) so that the following check is
> going to catch 'negative' mtu
>=20
> [1]
> if (mtu < IPV6_MIN_MTU)
>     mtu =3D IPV6_MIN_MTU;
>=20
> Otherwise, if a fuzzer succeeds to get mtu =3D 0xFFFFFFC0,
> sanity test [1] leaves the problematic mtu in dev->mtu.

This is the line I'm complaining about (1525 in 5.10):

mtu =3D min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);

I don't think it does any harm, but it looks wrong/confusing.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VMfAAKCRAw5/Bqldv6
8tUtAJ4kZL3M7+i0vhbrmqegWXkAUx5CMACgtmHZ1m3TvilpSI1mh+hkKWgGwqQ=
=sl6N
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
