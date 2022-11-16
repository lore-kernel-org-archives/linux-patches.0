Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071062F46
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 10:29:59 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 497C01C09F6; Wed, 16 Nov 2022 11:29:58 +0100 (CET)
Date: Wed, 16 Nov 2022 11:29:57 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/118] nfc: s3fwrn5: Fix potential memory leak in
 s3fwrn5_nci_send()
Message-ID: <Y3S7pQH6mHitxcfy@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.795605593@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QPc+M1xnBIb8zWhZ"
Content-Disposition: inline
In-Reply-To: <20221108133341.795605593@linuxfoundation.org>


--QPc+M1xnBIb8zWhZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Shang XiaoJing <shangxiaojing@huawei.com>
>=20
> [ Upstream commit 3a146b7e3099dc7cf3114f627d9b79291e2d2203 ]
>=20
> s3fwrn5_nci_send() will call s3fwrn5_i2c_write() or s3fwrn82_uart_write(),
> and free the skb if write() failed. However, even if the write() run
> succeeds, the skb will not be freed in write(). As the result, the skb
> will memleak. s3fwrn5_nci_send() should also free the skb when write()
> succeeds.

There are more error returns in that function that do not free
anything. Do they need to be fixed, too?

Same goes for "nfc: nxp-nci: Fix potential memory leak in
nxp_nci_send()".

Best regards,
								Pavel
> +++ b/drivers/nfc/s3fwrn5/core.c
> @@ -97,11 +97,15 @@ static int s3fwrn5_nci_send(struct nci_dev *ndev, str=
uct sk_buff *skb)
>  	}
> =20
>  	ret =3D s3fwrn5_write(info, skb);
> -	if (ret < 0)
> +	if (ret < 0) {
>  		kfree_skb(skb);
> +		mutex_unlock(&info->mutex);
> +		return ret;
> +	}
> =20
> +	consume_skb(skb);
>  	mutex_unlock(&info->mutex);
> -	return ret;
> +	return 0;
>  }
> =20
>  static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QPc+M1xnBIb8zWhZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S7pQAKCRAw5/Bqldv6
8goeAJ44aZI0JntTnEd3VkXi5ZM1g5bn8ACeNcxzFxqqnP1PxZHKCBRI/oFXnD8=
=PYQk
-----END PGP SIGNATURE-----

--QPc+M1xnBIb8zWhZ--
