Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31A019463
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 15:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1qpsVy-0008QE-BH; Mon, 09 Oct 2023 17:49:50 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1qpsVx-000S0Z-PT; Mon, 09 Oct 2023 17:49:49 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1qpsVx-00CO8J-GD; Mon, 09 Oct 2023 17:49:49 +0200
Date: Mon, 9 Oct 2023 17:49:49 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH 6.1 001/162] spi: zynqmp-gqspi: Convert to platform
 remove callback returning void
Message-ID: <20231009154949.33tpn4fsbacllhme@pengutronix.de>
References: <20231009130122.946357448@linuxfoundation.org>
 <20231009130122.990256512@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="c2qh7h5mmh3kzvla"
Content-Disposition: inline
In-Reply-To: <20231009130122.990256512@linuxfoundation.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev


--c2qh7h5mmh3kzvla
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Oct 09, 2023 at 02:59:42PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 3ffefa1d9c9eba60c7f8b4a9ce2df3e4c7f4a88e ]
>=20
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Link: https://lore.kernel.org/r/20230303172041.2103336-88-u.kleine-koenig=
@pengutronix.de
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Stable-dep-of: 1527b076ae2c ("spi: zynqmp-gqspi: fix clock imbalance on p=
robe failure")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

While I don't think this patch is dangerous to backport, the more
conservative option of directly applying 1527b076ae2c would have been
the one I'd chosen.

The simple(?) conflict resolution for picking 1527b076ae2c on top of
v6.1.56 looks as follows:

diff --cc drivers/spi/spi-zynqmp-gqspi.c
index c760aac070e5,c309dedfd602..000000000000
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@@ -1244,20 -1368,17 +1244,24 @@@ static int zynqmp_qspi_remove(struct pl
  {
  	struct zynqmp_qspi *xqspi =3D platform_get_drvdata(pdev);
 =20
+ 	pm_runtime_get_sync(&pdev->dev);
+=20
  	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
+=20
+ 	pm_runtime_disable(&pdev->dev);
+ 	pm_runtime_put_noidle(&pdev->dev);
+ 	pm_runtime_set_suspended(&pdev->dev);
  	clk_disable_unprepare(xqspi->refclk);
  	clk_disable_unprepare(xqspi->pclk);
- 	pm_runtime_set_suspended(&pdev->dev);
- 	pm_runtime_disable(&pdev->dev);
 +
 +	return 0;
  }
 =20
 +static const struct of_device_id zynqmp_qspi_of_match[] =3D {
 +	{ .compatible =3D "xlnx,zynqmp-qspi-1.0", },
 +	{ /* End of table */ }
 +};
 +
  MODULE_DEVICE_TABLE(of, zynqmp_qspi_of_match);
 =20
  static struct platform_driver zynqmp_qspi_driver =3D {

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--c2qh7h5mmh3kzvla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmUkIRwACgkQj4D7WH0S
/k6ZoAf+J5Ks/FEz56QUy2KWUuBj1HOmD2SlzwXqKNcXPrDK5m/rmyt67+TPkTgL
kO3rYuByLUjtoM0hSRAuhgomQQ4h3ZrNpxn2W3fOKTtVzNGQZF526zjy3gvCY78E
aUKf9oFiPF8XCbCAJjUkg9qfyNd99SofzzXkbZxFmRpKSRvmcz9cAJ5Peso6DPu7
ECXC0Yudkerjaziav6mkFXqJrVfyI3YcZ0kFd5B42bBA4RXSKUF/R+eLtQLatrA6
JtCcmCP8w3+HY+fsXJUesh79nuPEJwT3vOqX9akIHJJV5mzbXdlIKZkymE6ty7NN
eUp9aRWhDeGCtchw2kIGXcQSnVgWrg==
=GO02
-----END PGP SIGNATURE-----

--c2qh7h5mmh3kzvla--
