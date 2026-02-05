Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15833375CF;
	Thu,  5 Feb 2026 22:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770331505; cv=none; b=OnPqGFEICalJ004hdLZmxQ31kbKJQd8fCoCjd+V1vgU3Ss1sVMUJGPT1sHHzc0CMTIiM739bGLvBxM0cZGbUbUO9N6f4Kc7z5sj8TTn2Okg6Gfy8ggquXNe6+NXfD4SmNTO6ZBsULcYgtd5Y7RbfB3MpHajyPn91m9wSlPMIMvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770331505; c=relaxed/simple;
	bh=/ffLX6YgfrJcit13MiLprISEsSu7kd33CXuG1QYQj54=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RTkRgWnI9LFeR44Z0B7tjeFmjabGnS+wrmDcZlThhEbLR54u4ZEpNDk7kuQbWDcKEpn53MbLdTu1/dM/l3P3xcxlCCz85F4IcR3ty7U6ZnJzzD787GNh9AvW1m7RNkswQudjC8M+VTLocIr3yqwQTsGWO78zGXbIZnSHiwC62V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo85n-003wju-2S;
	Thu, 05 Feb 2026 22:44:55 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo85l-00000001iPF-40O5;
	Thu, 05 Feb 2026 23:44:53 +0100
Message-ID: <eb892614c9cd28aa03922567f8a6d75ed2f594bc.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 070/161] iio: imu: st_lsm6dsx: fix iio_chan_spec
 for sensors without event detection
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Francesco Lavra <flavra@baylibre.com>, Andy
 Shevchenko <andriy.shevchenko@intel.com>, Lorenzo Bianconi
 <lorenzo@kernel.org>, Jonathan Cameron	 <Jonathan.Cameron@huawei.com>
Date: Thu, 05 Feb 2026 23:44:49 +0100
In-Reply-To: <20260204143854.274769162@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
	 <20260204143854.274769162@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-j2mShSeSpPrbvNOPKsYC"
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


--=-j2mShSeSpPrbvNOPKsYC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-02-04 at 15:38 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Francesco Lavra <flavra@baylibre.com>
>=20
> commit c34e2e2d67b3bb8d5a6d09b0d6dac845cdd13fb3 upstream.
>=20
> The st_lsm6dsx_acc_channels array of struct iio_chan_spec has a non-NULL
> event_spec field, indicating support for IIO events. However, event
> detection is not supported for all sensors, and if userspace tries to
> configure accelerometer wakeup events on a sensor device that does not
> support them (e.g. LSM6DS0), st_lsm6dsx_write_event() dereferences a NULL
> pointer when trying to write to the wakeup register.
> Define an additional struct iio_chan_spec array whose members have a NULL
> event_spec field, and use this array instead of st_lsm6dsx_acc_channels f=
or
> sensors without event detection capability.
[...]
> @@ -1170,8 +1177,8 @@ static const struct st_lsm6dsx_settings
>  		},
>  		.channels =3D {
>  			[ST_LSM6DSX_ID_ACC] =3D {
> -				.chan =3D st_lsm6dsx_acc_channels,
> -				.len =3D ARRAY_SIZE(st_lsm6dsx_acc_channels),
> +				.chan =3D st_lsm6ds0_acc_channels,
> +				.len =3D ARRAY_SIZE(st_lsm6ds0_acc_channels),
>  			},
>  			[ST_LSM6DSX_ID_GYRO] =3D {
>  				.chan =3D st_lsm6dsx_gyro_channels,

In the upstream commit the 3rd hunk changed the entry for hardware IDs
ST_LSM6DSO16IS_ID and ST_ISM330IS_ID.

That entry was added by commit f35e1ee9cb5d "iio: imu: st_lsm6dsx: add
support to LSM6DSO16IS" in 6.2.  So in this backport the 3rd hunk is
changing configuration for other devices.

I think the right thing to do for the 5.10-6.1 branches is to only apply
the first 2 hunks.

Ben.

--=20
Ben Hutchings
Horngren's Observation:
              Among economists, the real world is often a special case.

--=-j2mShSeSpPrbvNOPKsYC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmFHWEACgkQ57/I7JWG
EQnyAw//c/2i2nhXDgpvmtvVoF/vTaQKMZNpAqmD1HI+6MZpbYgMh8SeIrtnfW4b
xorm0fyLaPBkMnMR+xtAic+jYdAWribj4YvcO8PThMVesPKCXUOJD/5Pd4IwTVCP
WtsYlm3qfSMOqZUp49NuHjBULO5Ix9eKMXVgy5TtdbkpEWn1eDJhIvk5UkbL1kNO
ar9dinVUzk8ag88AXpoChF9KlgYWXt9/EsvtaiLwgFuZ7FwsnMFsIH01KrASxTx+
9TZwYhFzmbdxrU80tDci82ikGCiUuVesjVTVy/KuWsithYWQqRk4SEnzGMjm/Sd7
jhS/k7Kak1y7ZdwSXcqhjF3lLB7HSlkwq+cGUIHFY15rpu8udtf0ncxItNc0pGHm
OyFwX+MEE9dSeEQ5KHN8a23Fza/by1mtae4UqardJ5DpIX/NC1qyKRxxNK+k8SAa
kZP1k6TuxTQ76fj6/h+m/S0jy0dmOAb6x1w0VAiMX2BesjitHOzvMH1AxO0IN0Tu
8DPRvzxbVv4sX4CrzAz/5hcf3bCB+hMuERiUCAcfz7skJGqmbpi1VN6SEbqcMQ57
b0I5OaMlvRL6CdgANrSWszAOOR5uy0etZGwQwiQDONodCEVje8taOLXYD/vw3crg
xOYydwiGKhm4GfizOW7M16pR2bFA/lXlKvkfFH9br6/Jd3/KDR0=
=L2fk
-----END PGP SIGNATURE-----

--=-j2mShSeSpPrbvNOPKsYC--
