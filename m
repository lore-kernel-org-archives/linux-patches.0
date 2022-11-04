Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B991C847D
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 17:11:57 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B26FE1C09D8; Fri,  4 Nov 2022 18:11:55 +0100 (CET)
Date: Fri, 4 Nov 2022 18:11:55 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 69/91] ipv6: ensure sane device mtu in tunnels
Message-ID: <20221104171155.GA29661@duo.ucw.cz>
References: <20221102022055.039689234@linuxfoundation.org>
 <20221102022056.996215743@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20221102022056.996215743@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
>=20
> Another syzbot report [1] with no reproducer hints
> at a bug in ip6_gre tunnel (dev:ip6gretap0)
>=20
> Since ipv6 mcast code makes sure to read dev->mtu once
> and applies a sanity check on it (see commit b9b312a7a451
> "ipv6: mcast: better catch silly mtu values"), a remaining
> possibility is that a layer is able to set dev->mtu to
> an underflowed value (high order bit set).
>=20
> This could happen indeed in ip6gre_tnl_link_config_route(),
> ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
>=20
> Make sure to sanitize mtu value in a local variable before
> it is written once on dev->mtu, as lockless readers could
> catch wrong temporary value.

Ok, but now types seem to be confused:

> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 3a2741569b84..0d4cab94c5dd 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
>  	struct net_device *tdev =3D NULL;
>  	struct __ip6_tnl_parm *p =3D &t->parms;
>  	struct flowi6 *fl6 =3D &t->fl.u.ip6;
> -	unsigned int mtu;
>  	int t_hlen;
> +	int mtu;
> =20
>  	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
>  	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
>  			dev->hard_header_len =3D tdev->hard_header_len + t_hlen;
>  			mtu =3D min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);

mtu is now signed, but we still do min_t on unsigned types.

> -			dev->mtu =3D mtu - t_hlen;
> +			mtu =3D mtu - t_hlen;
>  			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> -				dev->mtu -=3D 8;
> +				mtu -=3D 8;
>

I don't see overflow potential right away, but it may be worth fixing.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VH2wAKCRAw5/Bqldv6
8uotAJ4pYyzbaTLCHpWzacTvQFPvCt73WQCaAxktuaUB/Zxx4BkdtirNDZUI45A=
=XIKy
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
