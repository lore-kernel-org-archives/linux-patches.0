Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67EE3A3E7D
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 12:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269482; cv=none; b=m65kbnubD6LpDI9Af5VRoJyw5+s+LiVINMEz26e+IqU2ulb8QMlQnKSoGIS3dhapThHDrhAr8W0ZuHA6L3gT0/aP/9mWQp/o2lDGkZU91+EG4XwyKwFZrOGSjgHGV3Uv4TIfylhabfHyxXsl9XGuP+JOXyeuWHTcpe2WXbCvYpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269482; c=relaxed/simple;
	bh=8dtJcXEGJmPGeA1rM9q9gWixTYw8sIVc0d26qbbuAD4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bFmp52DWlYzqPN+nd3CwohWUnRQcvDxSqkt0qseKrQ/GTawKcextMxZAHru5/h4tgPaJWQYux4LOsmj4rHtJx4MysycCw1RYqrDxYRWmxG4ve0aB858iDMukX5EzKy/1nGGsKtR8LUkav1gMFzDOUoBkS9eEcAfyLMvv6fw3lfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1w4eXZ-001Tl5-09;
	Mon, 23 Mar 2026 12:37:51 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1w4eXV-00000003v6W-3S83;
	Mon, 23 Mar 2026 13:37:49 +0100
Message-ID: <f7f34b5cf1ddd5a880e0ceba52670bb73f2d21e2.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 094/147] RDMA/rxe: Fix double free in
 rxe_srq_from_init
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>, Zhu Yanjun
	 <yanjun.Zhu@linux.dev>, Leon Romanovsky <leon@kernel.org>
Date: Mon, 23 Mar 2026 13:37:44 +0100
In-Reply-To: <20260228181736.1605592-94-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
	 <20260228181736.1605592-94-sashal@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-azKMFOm/Ad8dBlui01/I"
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


--=-azKMFOm/Ad8dBlui01/I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-02-28 at 13:16 -0500, Sasha Levin wrote:
> From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
>=20
> [ Upstream commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 ]
>=20
> In rxe_srq_from_init(), the queue pointer 'q' is assigned to
> 'srq->rq.queue' before copying the SRQ number to user space.
> If copy_to_user() fails, the function calls rxe_queue_cleanup()
> to free the queue, but leaves the now-invalid pointer in
> 'srq->rq.queue'.
[...]
> Fix this by moving 'srq->rq.queue =3D q' after copy_to_user.

But this backport to 5.10 only added an assignment to srq->rq.queue and
did not remove the existing assignment (on line 101), so the bug is not
fixed here.

Ben.

> Fixes: aae0484e15f0 ("IB/rxe: avoid srq memory leak")
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> Link: https://patch.msgid.link/20260112015412.29458-1-jiashengjiangcool@g=
mail.com
> Reviewed-by: Zhu Yanjun <yanjun.Zhu@linux.dev>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_srq.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/=
rxe/rxe_srq.c
> index 41b0d1e11bafd..9d9baca269499 100644
> --- a/drivers/infiniband/sw/rxe/rxe_srq.c
> +++ b/drivers/infiniband/sw/rxe/rxe_srq.c
> @@ -116,6 +116,9 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe=
_srq *srq,
>  		}
>  	}
> =20
> +	srq->rq.queue =3D q;
> +	init->attr.max_wr =3D srq->rq.max_wr;
> +
>  	return 0;
>  }
> =20

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-azKMFOm/Ad8dBlui01/I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnBNBgACgkQ57/I7JWG
EQl6jBAAstorXBxH/UgDxZxiI3SspO96I60C+pjQPZnu0Xx+KLTQhSghBiRwPkwA
/bwZlJQnY38Ew7OwardMrLHXW4rVO85IfT04OXidxhZnBZ0l4m4qOM5DI82ELNIZ
4hggt8nmbPhwZQ8tEIu+ar4V3rxe7sa+rAOxdA7B5hPFzd4wB4lGiTwuOxGMWz46
4j9rCGE/dswGwvJiNK7M6ItCXNDSByYCBQFfcsmsi/YRjVxc6RJUJjeldYhTJ3nr
aCe55ZcZN0Fyxw2b/Efkorqzj7HDMKV5FUCHE7fBL5kxvO7yd9injoCngKr8kMu8
rCxNvx6+pybmEnwAPJ3iCSAGGcmKDvYqiJzXxmHRfDoWkJl6VBijVUTPS2GD1TLZ
BbutXvTaqYGzqhjzZQPChtfDcFjy4jFD9uGCLHigyMlQbkqllrpEgmDx5wm6ZK9r
u+a53Gav2bY9UljMxbzQr8PgyIpkZfWk+EWXx2TWMyaIkxuuwXuISwDOexvMFJAe
oo/7XxRiZywSxn8LtwoGm4Wz780Fc8boF1zppKISX2sn/2KeMAse2CA/XJH4HmN1
ikEb94W0RVGNipyOauMvgZtixJ8uKUNlKknNFL/OeYfGjlSNPovg21jyJUDdVsVa
95xl3OClrEvdIh0Vov4W8WteOsE3lGdW3wb9kzTB0Zdrn0tLQos=
=qehp
-----END PGP SIGNATURE-----

--=-azKMFOm/Ad8dBlui01/I--
