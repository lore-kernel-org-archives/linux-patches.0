Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD621ABAA;
	Sun, 21 Jun 2026 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782058353; cv=none; b=fLpFHMHBtQ3pBqJm8V2Vt3/x2FySBHwsx0pe7sBnIuOlqJazPg+ahhOvb0eD7qA/V0GOk6lpq/ruv9ZdutI/R2cfGn6AVbw+BVwyFcOaj38zHxK8TkggMeqQ4Wltrc69HVaINEwH6UKwwPo+9bicu7YWDIGpgyQhsGOQTCGiZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782058353; c=relaxed/simple;
	bh=C5gbBvGbEjXZp+lv/dI+WhRjHTDqFwecX2kHUEMmcRI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g6jKIiF8QwB7MViLu7p9cZVYnMjVnDmzl+DCoFKDdf7pU4vBEFabDCPqAOjDEqe6yjFjDcgjh89hqFfiVGpPhGqi9grSMcEIueZIqpdkg/nPo7JAP1/pau/JXM2j5IIVr8GNcsbB9AjisyJqAXrs1JIu1lCcleZqEms4xWt8KNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wbKmZ-003aX7-11;
	Sun, 21 Jun 2026 16:12:27 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wbKmY-00000007LsX-1WL8;
	Sun, 21 Jun 2026 18:12:26 +0200
Message-ID: <51fafef3d7dce78fd0210b55e45336caaa4a71d9.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 342/522] thermal: core: Fix thermal zone governor
 cleanup issues
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sun, 21 Jun 2026 18:12:21 +0200
In-Reply-To: <42c2abbdfdd4ea8e234fbcfc4b37095ebd2c7b36.camel@decadent.org.uk>
References: <20260616145125.307082728@linuxfoundation.org>
		 <20260616145141.812464695@linuxfoundation.org>
	 <42c2abbdfdd4ea8e234fbcfc4b37095ebd2c7b36.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6TXC5E2rZosMEtxACXKK"
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


--=-6TXC5E2rZosMEtxACXKK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-06-21 at 17:29 +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >=20
> > [ Upstream commit 41ff66baf81c6541f4f985dd7eac4494d03d9440 ]
> >=20
> > If thermal_zone_device_register_with_trips() fails after adding
> > a thermal governor to the thermal zone being registered, the
> > governor is not removed from it as appropriate which may lead to
> > a memory leak.
> >=20
> > In turn, thermal_zone_device_unregister() calls thermal_set_governor()
> > without acquiring the thermal zone lock beforehand which may race with
> > a governor update via sysfs and may lead to a use-after-free in that
> > case.
> >=20
> > Address these issues by adding two thermal_set_governor() calls, one to
> > thermal_release() to remove the governor from the given thermal zone,
> > and one to the thermal zone registration error path to cover failures
> > preceding the thermal zone device registration.
> >=20
> > Fixes: e33df1d2f3a0 ("thermal: let governors have private data for each=
 thermal zone")
> > Cc: All applicable <stable@vger.kernel.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Link: https://patch.msgid.link/5092923.31r3eYUQgx@rafael.j.wysocki
> > [ adapted context for missing mutex_destroy/complete ]
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/thermal/thermal_core.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >=20
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -756,6 +756,7 @@ static void thermal_release(struct devic
> >  		     sizeof("thermal_zone") - 1)) {
> >  		tz =3D to_thermal_zone(dev);
> >  		thermal_zone_destroy_device_groups(tz);
> > +		thermal_set_governor(tz, NULL);
> >  		kfree(tz);
> >  	} else if (!strncmp(dev_name(dev), "cooling_device",
> >  			    sizeof("cooling_device") - 1)) {
> > @@ -1260,8 +1261,10 @@ thermal_zone_device_register_with_trips(
> >  	/* sys I/F */
> >  	/* Add nodes that are always present via .groups */
> >  	result =3D thermal_zone_create_device_groups(tz, mask);
> > -	if (result)
> > +	if (result) {
> > +		thermal_set_governor(tz, NULL);
> >  		goto remove_id;
> > +	}
>=20
> The order of initialisation in thermal_zone_device_register_with_trips()
> is quite different between 6.1 and mainline.  Clearing the governor here
> doesn't make sense as the governor has not been set yet.
>=20
> The proper place for this in 6.1 seems to be in the failure path after
> calling thermal_add_hwmon_sysfs().

The backports to all stable branches from 5.10 to 6.12 (inclusive) seem
to have the same problem.

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-6TXC5E2rZosMEtxACXKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo4DWUACgkQ57/I7JWG
EQlg2Q//ZABfGMf6qsHOLuHxRJUjyPiW09wSzv6JicIRylu7qVSl03dwRsxSv8gn
+52uawEQUqGe+qF+3DOXvC4JPOLwG3Y75dwOfkso1HyEGfy3c+DtrODWiYPfMXSP
K9JH304mYR1EIcv9Gek4H381B0LFORPC+X+t2B0DWF/acsxuWGgmr5m7JI/bwNUj
6ajDQcBl5bmsc2o/3tjZQ5bIxdjrGut35KRou7kB+xnZ3AUkxzbdMmce6LV4idIP
3APRoYRfAyjkgfOERF403UOl//jnISXA/CR5qih2oBq0EcDFWq74MSknDbVXI2y2
/zMQLzjSkIpqkTCkt/xU+wAH8Ua4wEWSWxKCF2eMUtlHZe4ZiOwxknCbrKq9eg5H
GBWw+M4EkSxrTFxghMEjScRo6SMIrqspdIk1w/9ocMKc9/cb357+092z+0xQ/5oZ
dGL9hjZU6CLyDWYdZIq+Rzk3d5ymCjqXKd9IwN8HkareVd8XQU9bi9KHW6Z2ax+T
x1/8uu38H36KB6PQRiy86b911ASQSr2ye1uj/3Qc4lxLgfMqOBCAR0cb0paPMvqx
SOXhNtOUjvwE9CnrpnLZUqJfaXfa/89gDf3DuOlHq7HMCDdliFP5mh1CcKr7ChVc
9KJe+nFJqSvTUhTPzAF1bqVqWfeYg7GZ7iNZK3g8wYXcyZaNSRU=
=eTi/
-----END PGP SIGNATURE-----

--=-6TXC5E2rZosMEtxACXKK--
