Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188FB3081C2;
	Thu,  4 Dec 2025 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764884726; cv=none; b=D8TgcRjAk+yEyWCd1wpXqyuG5wBBGP0Qzo9jolCdnzKNEzU2JQ+DKRJQjbXAO/GpW9Bnvhw8jInEKujGvMxqAhhy3I5ZTxtX35x5h3DPDlL8kLaPvBY90ufIgqdReC0OT0CCS3siICRX/4s6tHDcNgkMpcYd7+w8ggTNoICv9tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764884726; c=relaxed/simple;
	bh=JacmcE2VUtvgotHA9Ha1QmmeZf8PhTpLq2/q5wacEM8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CuNVA+zKmxiA4AXqXmTRuoB6D8LjtgDd54/OeMru5D7MQz2TyEjk0jRt63OAkZr/Su5Ahud2XA54apRcXsvsyVI2kBxW7acTYLK0PhpLEcecsAkod7y2cLGqpgITN8sZqJJ1hjNY/hgVMBwe/Ih0iIvwitZFKkXtLZ+IkN70eVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vRH8Y-006EDn-33;
	Thu, 04 Dec 2025 21:45:18 +0000
Received: from ben by deadeye with local (Exim 4.99)
	(envelope-from <ben@decadent.org.uk>)
	id 1vRH8X-000000003fY-3RBb;
	Thu, 04 Dec 2025 22:45:17 +0100
Message-ID: <21524ff157007f80e5b0b4dfb130736c034f0c56.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 044/300] memstick: Add timeout to prevent
 indefinite waiting
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: patches@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>, Sasha
 Levin	 <sashal@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable	 <stable@vger.kernel.org>
Date: Thu, 04 Dec 2025 22:45:12 +0100
In-Reply-To: <20251203152402.246628462@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
	 <20251203152402.246628462@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+LSVuDIfcuX0+Wk0nIPU"
User-Agent: Evolution 3.56.2-7 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-+LSVuDIfcuX0+Wk0nIPU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 16:24 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jiayi Li <lijiayi@kylinos.cn>
>=20
> [ Upstream commit b65e630a55a490a0269ab1e4a282af975848064c ]
>=20
> Add timeout handling to wait_for_completion calls in memstick_set_rw_addr=
()
> and memstick_alloc_card() to prevent indefinite blocking in case of
> hardware or communication failures.

However, if the card does respond after the timeout, it appears that
there can be a data race and UAF of the memstick_dev structure in
memstick_next_req() and the callback function.  It looks like some (but
not all) host drivers implement command timeouts themselves, so perhaps
that is where this should actually be fixed.

Ben.

> Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
> Link: https://lore.kernel.org/r/20250804024825.1565078-1-lijiayi@kylinos.=
cn
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/memstick/core/memstick.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/mem=
stick.c
> index e24ab362e51a9..7b8483f8d6f4f 100644
> --- a/drivers/memstick/core/memstick.c
> +++ b/drivers/memstick/core/memstick.c
> @@ -369,7 +369,9 @@ int memstick_set_rw_addr(struct memstick_dev *card)
>  {
>  	card->next_request =3D h_memstick_set_rw_addr;
>  	memstick_new_req(card->host);
> -	wait_for_completion(&card->mrq_complete);
> +	if (!wait_for_completion_timeout(&card->mrq_complete,
> +			msecs_to_jiffies(500)))
> +		card->current_mrq.error =3D -ETIMEDOUT;
> =20
>  	return card->current_mrq.error;
>  }
> @@ -403,7 +405,9 @@ static struct memstick_dev *memstick_alloc_card(struc=
t memstick_host *host)
> =20
>  		card->next_request =3D h_memstick_read_dev_id;
>  		memstick_new_req(host);
> -		wait_for_completion(&card->mrq_complete);
> +		if (!wait_for_completion_timeout(&card->mrq_complete,
> +				msecs_to_jiffies(500)))
> +			card->current_mrq.error =3D -ETIMEDOUT;
> =20
>  		if (card->current_mrq.error)
>  			goto err_out;

--=20
Ben Hutchings
It is easier to change the specification to fit the program
than vice versa.

--=-+LSVuDIfcuX0+Wk0nIPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmkyAOkACgkQ57/I7JWG
EQlW3xAAqHPMd/uPqFBPveJ8hRD4sQiGDVpXlq6RPzAIdMR7p7a8d5MmEq6y3wsu
AedY5f9pgWmpxTcRuEnn84R6dLzp7/jfD8CiZwfg/UxVaP+UriB6cmi+r+tIabMk
NJgwpG9ciMCr1xI7sXxc7vNF+nKKPf4nOsJtgYFLYTehjAOPGxPjJcYWEitF1C8C
febciNVcFlGf882+4tHpEO8kA7HhUUvkjLpeVsY1qdvPw6O4kUwjakGBkLVoCNxL
ZmAOuu3UUFmsYPk2/HHrez7M0L3dXJwAObxxyzQ8X/MJ47wNtnNe7kcU6niP6nFy
/TsLO2zhUM5krAqtmsBdEeVZ1IX+plWhTBuRuccs3YE0sjJGh3XBIGBqCqfInKn3
pRM+GN5yKAA3rUIS2hFkxz+tCsCrSypdUtA2kGjmVSNJyelwxwEA1B6K9FrVjknE
PbL3YZ4uQRrczTcSQUENxXFT+SyWhF5SYBKUuph2yg2BIi1/yRQ4bj4xJjuzIL5m
IDXqtkc70WoPXFyDKLQpdU7Qdue89Ny+/qqzOycdCUUKXnHTBVGmHRf8i4+DrV/q
LL028JpAdy6ZcSef56Mnnvmfc6h2HXNceVsAsX4ZtkCbKK+DsHRmLbiCbwp4qQcC
pOf/o3Ot9aGNeGk1l2JZ5RNq3hci/idZ9hZIrJVvje4md6KX3E4=
=lEf5
-----END PGP SIGNATURE-----

--=-+LSVuDIfcuX0+Wk0nIPU--
