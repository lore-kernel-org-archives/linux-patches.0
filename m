Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C10526CE39;
	Sun,  5 Jul 2026 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783286320; cv=none; b=RuzS2sZww3vqTilg0vAl+V+VF3a8vguVo7cD6CYfgcQHQUjqS+f7E+tO1Cq3TgMwNN7aHxBpavq92nLRVCjE5WO1HwgTmc3aVdmVClS97N/M/iY5B33N5U6aWr0ji+riIimjBD/TbenWRPYMKLs0zaQDhMHOxc8iMxo+1GGPgUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783286320; c=relaxed/simple;
	bh=sTOZ8JXmXAvGgA7KICyRuUyLtY2VSfNeaIj5d2kqE3Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aqARIZcuEDDmRF52PUu1++G1Zr2nipE/YYDcwymlAYZ7kyDEcx+EopEO/eJ3fY0DihcCdRxyJP4e8AjwE3qJt3v5Pmd8XnzXBV0ezsqnuIz03gdmuaLxOyJ8ppPeFjIEeRiiBU4eHkIdyhef8LoOcvdAE1t3YHuEp0k9aUkedi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wgUEW-000E5c-0x;
	Sun, 05 Jul 2026 21:18:36 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wgUEV-0000000CUoQ-1vA3;
	Sun, 05 Jul 2026 23:18:35 +0200
Message-ID: <c1c9fdd193db5a288c825364ee525d570dadfbe0.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 89/96] misc: fastrpc: Fix NULL pointer dereference
 in rpmsg callback
From: Ben Hutchings <ben@decadent.org.uk>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, Bjorn Andersson
	 <andersson@kernel.org>
Cc: patches@lists.linux.dev, Srinivas Kandagatla <srini@kernel.org>, Sasha
 Levin <sashal@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable	 <stable@vger.kernel.org>
Date: Sun, 05 Jul 2026 23:18:29 +0200
In-Reply-To: <20260702155110.852713780@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
	 <20260702155110.852713780@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-l4Tg04UtNu07mIIfDIaX"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-l4Tg04UtNu07mIIfDIaX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-07-02 at 18:20 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
>=20
> [ Upstream commit 5401fb4fe10fac6134c308495df18ed74aebb9c4 ]
[...]
> Fix both issues by moving all cctx initialization ahead of
> dev_set_drvdata() so the structure is fully initialized before it
> becomes visible to the callback, and add a NULL check in
> fastrpc_rpmsg_callback() as a guard against any remaining window.
[...]

You can't fix race conditions with simple reads and writes!  To ensure
that things happen in the right order, there also needs to be an
smp_wmb() before setting the driver data and smp_rmb() after getting the
driver data.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed
                                                    - Carolyn Scheppner

--=-l4Tg04UtNu07mIIfDIaX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmpKyiYACgkQ57/I7JWG
EQkZPw//e6yVxuVpOKU96DZQS1E5TtYyKH+1sYuYrU1fovB+UQTrDJJO6Zfp9if+
LJRrAWuTMavv9GQ9DyH70kFBfAgzTrNPO0OJTRU/Qvbx26Q8v96Zk0oMUUoSW0t6
nm6G/5vHqAAKIjrI9PEyOEb3XDoRvuExQPeYbSESYyjTL2D+zL1XDK49/BSh+YDy
NciRhAKuiR5UoXjMITiYfljXd5vRYs7fBIlPH7AQX6XZBIvSPldU2Bnt01pR0gtj
0IWRxzBDRAi67NOTHIbM8gNnlQt4o/2HQMLuT8JuIH8O0aKyQnfm5BpPGuSB4rD+
hNgRsaYVyAfh5jYEsDkPdcvUfWoukIXgcGQJde0RTK3wOn8j01K3lpCyfBdIGzPj
+jqSU5zA2fxgglw6rLSVrSa4Qv+extk5Z+az8oPbIvfJbtnArbabdO10auUYsnbr
276bIqmXeiXrOJQrT1BX7O1GHLpYsAIEHMTcqRm7P9575IudTDHuB7iiT8y+HRNe
TnzitIjfmGnjGwEEx6Vviav5bepgkTTws7vXsVX+Id+uH4VMO4D7m6kTpFQYUMxK
/ciMKdouMSxRzg+y+CJzdvdw6WEGQ28sD06jcL4fPvRx7rlSP3iiY5pRriVrveh6
wBT83Eb5MEjzch6phxGhXE5IiJwIgP7haT2b831ZiKjSMTzj0Js=
=jFTA
-----END PGP SIGNATURE-----

--=-l4Tg04UtNu07mIIfDIaX--
