Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E5E1EB5C2;
	Sat, 17 Jan 2026 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768679897; cv=none; b=TITBx1hzz+e47H45xCNcB8SDk66bE4uS3O9ZIqusnGW+ep6kOa61z05HRF1tndPn7QQBH7GLL1lN/LA2TP0g2B6nbP/RoIbengdSvw3QDJXXdG/23VKzEOlTl3ORlo10Co3iPO4xcJngbMrzwpcH473Oo2kej58jff6TIQk9gZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768679897; c=relaxed/simple;
	bh=8JaLyiTLAVD4NbqbnmukE12QWy9ijKB0HPrzz/uyMHc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OGS6F9A6BgjJnlB6XgLEDwkcacg0zY78IPI9U+LrM0t32aWszTQqCaJNTp7Veukmj6gmnkGh6nuiwN1pm+jFGqH6c22DtzXim0rcmYNR7WPf5ZkraL8v72X6rnAVhlAuChebbLXrF6ur7+qVTs/xxsBwnF+tt9173qbd2WI9YKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhCQy-0011Yw-3C;
	Sat, 17 Jan 2026 19:58:07 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhCQw-00000000jSy-2GaG;
	Sat, 17 Jan 2026 20:58:06 +0100
Message-ID: <188e82d04a1d73b08044831678066b2e5e5f9c3a.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 183/451] ethtool: Avoid overflowing userspace
 buffer on stats query
From: Ben Hutchings <ben@decadent.org.uk>
To: Gal Pressman <gal@nvidia.com>, Paolo Abeni <pabeni@redhat.com>
Cc: patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>, Tariq
 Toukan	 <tariqt@nvidia.com>, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman	 <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Sat, 17 Jan 2026 20:58:01 +0100
In-Reply-To: <20260115164237.523595757@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164237.523595757@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-B1UzyVeyb18RZR3pMk11"
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


--=-B1UzyVeyb18RZR3pMk11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Gal Pressman <gal@nvidia.com>
>=20
> [ Upstream commit 7b07be1ff1cb6c49869910518650e8d0abc7d25f ]
>=20
> The ethtool -S command operates across three ioctl calls:
> ETHTOOL_GSSET_INFO for the size, ETHTOOL_GSTRINGS for the names, and
> ETHTOOL_GSTATS for the values.
>=20
> If the number of stats changes between these calls (e.g., due to device
> reconfiguration), userspace's buffer allocation will be incorrect,
> potentially leading to buffer overflow.
[...]

This seems like it could cause a regression for the DPDK driver for
mlx5, which sets ethtool_stats::n_stats to a "maximum" value:
https://sources.debian.org/src/dpdk/25.11-2/drivers/net/mlx5/linux/mlx5_eth=
dev_os.c?hl=3D1324#L1324

Everything else I could find with Debian codesearch does seem to
initialise ethtool_gstrings::len and ethtool_stats::n_stats as you
expect, though.

This change should be documented in include/uapi/linux/ethtool.h, which
currently specifies these fields as output only.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-B1UzyVeyb18RZR3pMk11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlr6ckACgkQ57/I7JWG
EQlu3A/9GL8S4EmGc+DRXu21BGe8vrxzeJu9+FJqSB5rZr7LK8/M6SJPkN+I0wmg
hYYAYvqo4AD9ul+1HXsFMhNiY5ZrVdfm3dGNMRovD79CeB90OScpNe70Sf+T1y7m
Y/NUJutB1OQ0Ae9L+jWh7lU96Xa4glwbqp0gB+7WlA8Uf3GKeyz31ytCa5CuWcHB
2mGYutgBihOrgXyplkNVX3kBPRBgQ3/AP1EttpNY0Kyrb+tBsS/vceemg52c45TP
XYgJ0XU5OlIXPWuRpxWZZOmAC7kvL5QJmrIiXvP9xrUPVcqgJLE94XP8eSNjV66T
7DJR/b59YmmqnUoNWeC0P34Gfo56YDKHDc5oGWIdd5iqZ0edniynDvgBiu+F7eG8
Lt1r1O40fP0pu4CuDeIyjY2ImfYi0ufShbySzD/Kt0lbEy5GJuuAsKLO5LZi8Ntf
FCpQOKsvWQJTkbpd1++cZ/MRv6wjL7IDcMu3oNM31qlGYnYEXVPMnb7RL8BVNBsX
xBxLT0O430gmpFpQm8wifA3uy421W4rhv8iHJ9825+Fy9ntd2Zd9+9x8N7sPETXX
Suk5F8CPhyK/yXllig0SenKihtu5CJJI6cW8U8o8EY4M/rbJ6SUb12gxe9jt4YNx
pxFrAmEhTGsO6JSrSYysKNRyyO+dm0qFoUJxrRaFT5SGzrD4Kqk=
=VcGg
-----END PGP SIGNATURE-----

--=-B1UzyVeyb18RZR3pMk11--
