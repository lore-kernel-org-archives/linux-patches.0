Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A0D2609DC;
	Sun, 18 Jan 2026 23:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768779214; cv=none; b=FRw1inPLiIqRY31Cx5e5a1jh83YKW6ZjHfaTcU5pmIjzGbuVAVTSHYdt+UNYbJqLTNTE5g0wHHV+z6cMQJazKf4riOFd6INg1f8iHhvgEYSVnCWv+lVCHnfCNF5lyEc/iCxhhS0/ZwXpEJiJ942au65g60Rr/FgT43acPiDhPHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768779214; c=relaxed/simple;
	bh=lvBhFtMniHKnzoLL4T2pCrSYxfOfO6hcj8XjWvQyf9I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hdPvmh6tlZllnBd4MhvnIftppWJFUn4xatwt8lkDl3ISewf8rUYqv8qaI7dCA+woE+FDDc69LwXaVLQvLw17Rn42MGTPkMB8+Bn1k4N+B3fogeLuvBSmNTWSRUVuDby+EnTze435rXCCx/yjszxlhUsEfkOJP+S55U8bvuK0ap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhcGr-001BF6-1Y;
	Sun, 18 Jan 2026 23:33:24 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhcGo-00000000saV-2KSg;
	Mon, 19 Jan 2026 00:33:22 +0100
Message-ID: <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 423/451] tls: Use __sk_dst_get() and dst_dev_rcu()
 in get_netdev_for_sock().
From: Ben Hutchings <ben@decadent.org.uk>
To: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>, Eric
 Dumazet <edumazet@google.com>, Sabrina Dubroca <sd@queasysnail.net>, Jakub
 Kicinski	 <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman	 <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Mon, 19 Jan 2026 00:33:17 +0100
In-Reply-To: <20260115164246.242565555@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164246.242565555@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KdOIYA1KKbg2CZ+ImQoT"
User-Agent: Evolution 3.56.2-8 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-KdOIYA1KKbg2CZ+ImQoT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:50 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Kuniyuki Iwashima <kuniyu@google.com>
>=20
> [ Upstream commit c65f27b9c3be2269918e1cbad6d8884741f835c5 ]
>=20
> get_netdev_for_sock() is called during setsockopt(),
> so not under RCU.
>=20
> Using sk_dst_get(sk)->dev could trigger UAF.
>=20
> Let's use __sk_dst_get() and dst_dev_rcu().
>=20
> Note that the only ->ndo_sk_get_lower_dev() user is
> bond_sk_get_lower_dev(), which uses RCU.
[...]

So should 5.10 also have a backport of commit 007feb87fb15
("net/bonding: Implement ndo_sk_get_lower_dev")?  Or is the use of
netdev_sk_get_lowest_dev() here not actually that important?

It seems kind of wrong to add the netdev operation and a caller for it,
but no implementation.

Ben.


--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat. - John Lehman

--=-KdOIYA1KKbg2CZ+ImQoT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmltbb0ACgkQ57/I7JWG
EQlEqxAAzFb/2fOdz1nzjo/hyFMHwIvpAh2r7qFkIWW6X0eKbeJFHwtdwuXeSZqR
SJ6Dh+R/L8pGBAWBOny16q9pLo76EXZtwqkgUnmx2HoQIsMfcLa/o+P2wN+ynLRk
yLYNCxWJRBsq8nLLHcn6tgqPvdtPMjXnb2vlXgXCU2fN4IX+Is41NGqBvHeWbE1Q
7CFcZJWEWMWPcGS56DbH0DR7diEV4IpQe6QSYJ6eME7mkkhV5CMBSAGohtvrQ0JE
h9vc+U9Z9KUPp2p9aOcF/sDPsbvvGBoXoIMR82iwXZ3eNj5mqHcXBZZ+35qqjYgU
sddhQZCxLarR5ZDLid87BG+NywgeKSJtwtp1yJWH+2YdALBY4K+Dib/nO3rISwOW
m+EGeOBBX1dha2OerL9Uws+Hp9s2ADjTu5u5nwzwiegGfWDE4DqbAwAQEu61rSgo
smqA3i63LzerAauF/6G5gve9WzzpyAiyBhv6mzHwxbIN2N/D5L3B53z/j+17MvxI
U6yX8hWZy2vgy+UdJMcOhmYBjMqupRfRXuJ0IjbdA0E03HPOB9A8I1qf1LDvgRO8
evC7m/1tSNvxw7x5sjm/8ALvJpH2ggtnspjoyozvp2Jr5KWoyk5mt6l6v1t5BL49
OK7TA8efA6yKVKdp6GaSLygNtDgP4qEg3ydgHl3kiI79DSXjlfI=
=DVOP
-----END PGP SIGNATURE-----

--=-KdOIYA1KKbg2CZ+ImQoT--
