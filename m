Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6A211CA0;
	Sun, 18 Jan 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768747788; cv=none; b=Cw6kCUMPK6nYH1IpJdcjrhhapkBVRLylrPQO2IZ6znngSK7RhpbEfmz5sb169pYCcwsDFpFvp1Al6wYGtTEvvH9KjCHIC10TEYzjLpA+53V/eLn3ZpTJcf0X8eoVTNL9pLQIL/lxf/iucnlpiczXIAiPYiZ8GoXHvQqjUbPRd58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768747788; c=relaxed/simple;
	bh=aZnl9Rb94EwilhyNSNRsJOM4xZz9zqZXPfs6Ct9rPfQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n9MmQeGZ8gf6/GhXsNavQTuE8oOnsi2tXyc/sawIcAC1gayN5cCX/EZFpk+kY3MPZpMWTIv29HxCNQ99wr3wEZV+bxb2kXDLJ4jFAMISSujZw7Ustwn6ufMTLiU1ZHTzK0bILZmEwTTwfhwrk9k0xcTW+eBKEVEYQkKOCvJ47e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhU65-00181i-3C;
	Sun, 18 Jan 2026 14:49:44 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhU63-00000000oXy-31yA;
	Sun, 18 Jan 2026 15:49:43 +0100
Message-ID: <ddc7d38473d222cd9c2e332a387989d3af50d6e4.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 335/451] net: macb: Relocate mog_init_rings()
 callback from macb_mac_link_up() to macb_open()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kevin Hao <kexin.hao@windriver.com>, Xiaolei
 Wang	 <xiaolei.wang@windriver.com>, Paolo Abeni <pabeni@redhat.com>
Date: Sun, 18 Jan 2026 15:49:39 +0100
In-Reply-To: <20260115164243.014159406@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164243.014159406@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cOCGk8YarqItNP/e++5h"
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


--=-cOCGk8YarqItNP/e++5h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:48 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Xiaolei Wang <xiaolei.wang@windriver.com>
>=20
> commit 99537d5c476cada9cf75aef9fa75579a31faadb9 upstream.
[...]
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -654,7 +654,6 @@ static void macb_mac_link_up(struct phyl
>  		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
>  		 * cleared the pipeline and control registers.
>  		 */
> -		bp->macbgem_ops.mog_init_rings(bp);
>  		macb_init_buffers(bp);
> =20
>  		for (q =3D 0, queue =3D bp->queues; q < bp->num_queues; ++q, ++queue)
> @@ -2287,6 +2286,8 @@ static void gem_init_rings(struct macb *
>  	unsigned int q;
>  	int i;
> =20
> +	bp->macbgem_ops.mog_init_rings(bp);
> +

This is in the wrong function; it needs to be inserted in macb_open() as
in the upstream version.

Ben.

>  	for (q =3D 0, queue =3D bp->queues; q < bp->num_queues; ++q, ++queue) {
>  		for (i =3D 0; i < bp->tx_ring_size; i++) {
>  			desc =3D macb_tx_desc(queue, i);
>=20
>=20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-cOCGk8YarqItNP/e++5h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmls8wMACgkQ57/I7JWG
EQlZ0A//VrrLbR/gOt6DtDOwhDr9kTYwlDq37cNJYhBiJGJ8TtzjxNZ1vvxBtUa9
yHkZt2lAWmO0/yVDSyP+ft6minAZLmtduweQfjS2n7RF6trtaTpyvuR2Ruh/ft4W
FDZthDyFqr5AH6n7fHQ1013SJRL8SYe12xqr0tbN5u3ZcW+bnmbBc2BtKGazSKN3
+Rxt/pl/BLK2eKaTeCuUSsFLhAwAqdaQ42agxlA6MW7OZAcBRpWKqqaco/J2YVMh
xQ/1+NNlt95QWuSBk+Kr1aHBFLCYJpglS3SW+9Vv2OccYUD+dg9lI2TluAwy9eJB
HvCmOoHTez6trCI9Z4Rj3zs0FzRohj2FlSEX/JaAF5OMoxutOnFmFmIrpydhQ/1x
GWUsd8vhwtPLmqu6GahCdwJMu6lkSA5j8DLHkLtULtHYjIVRNH53rNW6Pt1GuuB3
F6PFxRanzzl4rXuuk/G5AIDS3vkzPlozUtUlThhAfL7opMD2S3EUqwoEAnNhWeq6
0rtO4PcvsI85vTdX6Vje2GyRyysrnUFZBGPxI6t6reu0cuPzFzc927UfYHPgLGO+
svk4mqih7pC6sURZWHRD+DaI/ci9c5WkLA0b85myIpJMMU0AseGFSpsxLG2YPArA
94vrcdC5kujlSLs2EH4y3yRa7Fz0p9kVF6ns77uxr1qhv2lp/no=
=rV3d
-----END PGP SIGNATURE-----

--=-cOCGk8YarqItNP/e++5h--
