Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16103382CB;
	Wed, 15 Apr 2026 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776255069; cv=none; b=oR12hYIBjEoqlhxCIcMmtlKWOtrntSbvCHH47Xl7zPM2Qri/sccn6vc8eHuofXai6JfIkmIhy3hmGlyRpXRHNUH1JY+JN2zD5hS2OfOGu/VnVMhn3vItKeU0W2CGCDpmcT+Q/M5VwFHVYjvRZ+frn6/283lLOa6P4TVjgqxNz7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776255069; c=relaxed/simple;
	bh=YPsCldXH4MVx6lVVeFCbqASGiP/XgmRzqYdJ0PDJuNY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=URHmz3XuJY0mMO05cvVKxjMdxdPXW6ISUp5L/lnUgKOixr3v8KmXNpIDta9EdoMmIE22V0pGIZzoEwskefSqOR/9anySZWVCO+Ycx4fuVeoPW/3P6OBIcXDTYmDxImENpwNO4YTDr6ud/gB7m3ZFsbZui2S9SdkvUsJu22oJt3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCz5G-004yV6-2Q;
	Wed, 15 Apr 2026 12:11:05 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCz5E-00000003cr6-0j70;
	Wed, 15 Apr 2026 14:11:04 +0200
Message-ID: <9e1d8d13f872acab49ac25ccf6d18b3a2698d421.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 191/491] can: gs_usb: gs_can_open(): always
 configure bitrates before starting device
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>, Sasha
 Levin <sashal@kernel.org>
Date: Wed, 15 Apr 2026 14:10:57 +0200
In-Reply-To: <20260413155826.219285216@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155826.219285216@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A8/X/vPOLnoV27P0DlDK"
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


--=-A8/X/vPOLnoV27P0DlDK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:57 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> [ Upstream commit 2df6162785f31f1bbb598cfc3b08e4efc88f80b6 ]
[...]
> --- a/drivers/net/can/usb/gs_usb.c
> +++ b/drivers/net/can/usb/gs_usb.c
> @@ -413,9 +413,8 @@ static void gs_usb_receive_bulk_callback
>  	}
>  }
> =20
> -static int gs_usb_set_bittiming(struct net_device *netdev)
> +static int gs_usb_set_bittiming(struct gs_can *dev)
>  {
> -	struct gs_can *dev =3D netdev_priv(netdev);
>  	struct can_bittiming *bt =3D &dev->can.bittiming;
>  	struct usb_interface *intf =3D dev->iface;
>  	int rc;
> @@ -445,7 +444,7 @@ static int gs_usb_set_bittiming(struct n
>  	kfree(dbt);
> =20
>  	if (rc < 0)
> -		dev_err(netdev->dev.parent, "Couldn't set bittimings (err=3D%d)",
> +		dev_err(dev->netdev->dev.parent, "Couldn't set bittimings (err=3D%d)",
>  			rc);
> =20
>  	return (rc > 0) ? 0 : rc;
> @@ -675,6 +674,13 @@ static int gs_can_open(struct net_device
>  	if (ctrlmode & CAN_CTRLMODE_3_SAMPLES)
>  		flags |=3D GS_CAN_MODE_TRIPLE_SAMPLE;
> =20
> +	rc =3D gs_usb_set_bittiming(dev);
> +	if (rc) {
> +		netdev_err(netdev, "failed to set bittiming: %pe\n", ERR_PTR(rc));
> +		kfree(dm);

This error path leaks the URBs allocated above (but the upstream version
does not have this problem).

I think it would make sense to backport commit 2603be9e8167 ("can:
gs_usb: gs_can_open(): improve error handling") before this one.

Ben.

> +		return rc;
> +	}
> +
>  	/* finally start device */
>  	dev->can.state =3D CAN_STATE_ERROR_ACTIVE;
>  	dm->mode =3D cpu_to_le32(GS_CAN_MODE_START);
> @@ -888,7 +894,6 @@ static struct gs_can *gs_make_candev(uns
>  	dev->can.state =3D CAN_STATE_STOPPED;
>  	dev->can.clock.freq =3D le32_to_cpu(bt_const->fclk_can);
>  	dev->can.bittiming_const =3D &dev->bt_const;
> -	dev->can.do_set_bittiming =3D gs_usb_set_bittiming;
> =20
>  	dev->can.ctrlmode_supported =3D 0;
> =20
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-A8/X/vPOLnoV27P0DlDK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnfgFEACgkQ57/I7JWG
EQkEVQ//cJH7FsLT5P9J5VlHsVlX3GIncFn1KyW6OLEHdYKR/SdJ0ggjaaMR3vNk
f+zcx1HicSyoNvNWV5yAptNpgBpW22OaQMqsBU138LEIUQchpTRZKu48Li7NFnGY
kv8gf5ulpV3BN6Swy3kLV/o4647rjEZNI8sZV4gF51F9oH1WSRPCj7EZqYu4c5mL
AoIahbzR+Yzo8X6nPm/wsp0JsYNLoTxS7QnJSyVOwJd8gyEBiYap3rcRKMQsEhr4
COzrc5OMceDIMIqM6PDjPXIsPvuITGwAparyyCtg3dVrBpRTuXD4MlC+UH/fQrdK
H792DTLYZZ/aN4fKH6e/j77JAsOjvHq14d+4lYgoSZQekHOldfTQBqv0R8eJkv6l
vQYEKNuWQaoDHYtmzq8OO7AaZHK0V71F3WCrhRjJBZtBt4esN5196buS/s/fOvyL
DuSuELPOoL1uQ92KHeOFKVTCa1NcppuQl6R01qjN0afnInRd1u3QSbjW71dcUI9a
f3G6EI+fjyYI8JBq8AAyLdfq3k7bFD7W5u4Ouybt1wtMlBQzcD7P2+MWWHtsxdXQ
XD4TRMjPdthxGB8L3SNULlA8scFu3AUQZ7qns4WEo6Iw7iaVFpqpejLY/Lm/x6eD
NY6hKcfaaByIrmRqGAnCZp5X7Mb/edIWTPIIv0XJSyC1lUNLHZ4=
=i+9Q
-----END PGP SIGNATURE-----

--=-A8/X/vPOLnoV27P0DlDK--
