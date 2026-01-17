Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB395CA4E;
	Sat, 17 Jan 2026 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768662743; cv=none; b=pbB5DmRGIg+EvDHs67poBcVDtQQZn9rbq7XimebySXyqSt4uu0/Y2t0MdJ+1sbW9QipSRCWuTl4E6VnqnoTWPmyDzf3WcR/mgiwnqmJFN4kdU1S0ik3KETVHG7sJTcJuOJPneVX4KXJFeTpyWCZzvbQ4qSqWYWKic9dnKh2TGtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768662743; c=relaxed/simple;
	bh=83LAUJ+1TevLNSu+5VtFIIPngsdoY7tJDxOxG65kpoI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WvK/4Sc4s0JOK9h/8axlUzkeIBw6NSFcaivuYenDUF1YVKMSQZxGolw85xaI61bKoD6WrtZnLDp+WcBYwl5funH2MWYadu3EUorcXO2bPl++edJ8YmwjDx+GUKtgkCXuZAs5HKiKXvLRskem6yB7P+J6QhlZacQadBJBctCKECM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh7yO-000zq0-2x;
	Sat, 17 Jan 2026 15:12:19 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vh7yL-00000000gPd-2Djq;
	Sat, 17 Jan 2026 16:12:17 +0100
Message-ID: <2a56712cbff26cd8d9a090ba01da0237d5e40a23.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 110/451] netfilter: nft_connlimit: move stateful
 fields out of expression data
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>, Sasha
 Levin <sashal@kernel.org>
Date: Sat, 17 Jan 2026 16:12:11 +0100
In-Reply-To: <20260115164234.897738785@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164234.897738785@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eijgIDYWU9OfZD5hBFcU"
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


--=-eijgIDYWU9OfZD5hBFcU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:45 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> [ Upstream commit 37f319f37d9005693dff085bb72852eeebc803ef ]
>=20
> In preparation for the rule blob representation.
[...]
> @@ -200,7 +205,11 @@ static int nft_connlimit_clone(struct nft_expr *dst,=
 const struct nft_expr *src,
>  	struct nft_connlimit *priv_dst =3D nft_expr_priv(dst);
>  	struct nft_connlimit *priv_src =3D nft_expr_priv(src);
> =20
> -	nf_conncount_list_init(&priv_dst->list);
> +	priv_dst->list =3D kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
> +	if (priv_dst->list)
> +		return -ENOMEM;
[...]

This condition is inverted.  Fixed upstream by:

commit 51edb2ff1c6fc27d3fa73f0773a31597ecd8e230
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 10 20:48:17 2022 +0100
=20
    netfilter: nf_tables: typo NULL check in _clone() function

but that won't apply directly.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-eijgIDYWU9OfZD5hBFcU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlrpssACgkQ57/I7JWG
EQkCuw/+LjWmAYJafh7ua7wOa3mFCq3KGPI4bNK2roes3Ue07rTP4WrX5rXFBzhX
i3icch65JOlSr9Pr4zxBFErwOEyNJ4aS1JhZCw7b1487ymoOYvgKSgwjc49DsQ09
n7Baqb85c48PYV3GgtKS1BgbKpKXVNDJ6GUjZjsEyt8gv1cPlveHZ3NOywrMV0u0
dL1Yw81GgerjDmT+mnxCaMeDA4luB7iGBn7KqLmCA2wRaDnoYj6sJglJwJm0tntA
C5AJOlOAnUK7ii2dfylq7yzs3UkREhshO+AifvzfwRUJa8fPtQx2jckmmf3desib
C/0gDgS16Dny6X8z6sC8m+JQh7QF4Id4hdcf9cX/ovWcjTIZNmxJBrbmN5WZihdD
FSXLbQj2BhwLcNJI3tbhZSIxO5SNYXkNnV/8CnSxECzkawaWlmyZGyclbEspqpfQ
AS9r8QNj4/dkZR4Q/ANRdXUqBoxTn+pPD0dZK+JzUX2WwrHFxVVSSvD0ZmE/fyA+
rN+QGtoPxAy8gStBsOuiKfHpYWaOSgf23c1Mv/owUxzvEs4MzZnKUWujsU/vGOV/
wBeyq7uyszjB8o05Gs6MegH6d2k1QiWidxKvQ+5aHVx6UuusGbkeraFde3HM5QVO
vvVznxHIv/pOshSsCU/7QOd6mBjv5uIkW2L7aPZL90PYi1GBEh8=
=iZml
-----END PGP SIGNATURE-----

--=-eijgIDYWU9OfZD5hBFcU--
