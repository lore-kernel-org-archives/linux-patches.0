Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4842F18027;
	Sun, 18 Jan 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768756670; cv=none; b=fnK2ch+iPWXX0IYrBL+uiSG8lHTnU+VmOFztNfvbNMN9FPi8hu+GIAwtf7ZSs7eY6+/yB9yUu2FYsuaaR1UxwYBGkpPwdwLB0sZJZWPVuMDudLlz4lQOwvg0GbyBG94VOiWo2h4v1lXedUjziGxHSh0ktGbSZtpdI0izSew2sjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768756670; c=relaxed/simple;
	bh=UXTVEjUXuz1tUjSdFZkW8sDsc5nSOwABa/2sCHdjcQY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lhNcxAELBzpvDLxVUVm8tSlJJhnc4bDxJXHVzMrQiVbXk+BqGpm2DWj/GXBrP5/g9Gm/zyfEwBMTbmLJfCb7scM0GqJYc/EuqRZkCRpvkqqWlCF7i1xEHeQLEJHJQnx+3c7XiNbytzl9u0VB6eOTYsek3YPOPynieXCSY8njUeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhWPJ-0018ZP-0u;
	Sun, 18 Jan 2026 17:17:44 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhWPG-00000000pus-2Ppj;
	Sun, 18 Jan 2026 18:17:42 +0100
Message-ID: <6fe17868327207e8b850cf9f88b7dc58b2021f73.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 372/451] hwmon: (max16065) Use local variable to
 avoid TOCTOU
From: Ben Hutchings <ben@decadent.org.uk>
To: Gui-Dong Han <hanguidong02@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Sun, 18 Jan 2026 18:17:37 +0100
In-Reply-To: <20260115164244.371233832@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164244.371233832@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1OmL21kCMaNAg83KIYeg"
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


--=-1OmL21kCMaNAg83KIYeg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Gui-Dong Han <hanguidong02@gmail.com>
>=20
> [ Upstream commit b8d5acdcf525f44e521ca4ef51dce4dac403dab4 ]
>=20
> In max16065_current_show, data->curr_sense is read twice: once for the
> error check and again for the calculation. Since
> i2c_smbus_read_byte_data returns negative error codes on failure, if the
> data changes to an error code between the check and the use, ADC_TO_CURR
> results in an incorrect calculation.
>=20
> Read data->curr_sense into a local variable to ensure consistency.

Simply copying shared data to a local variable before using it cannot
fix a data race.  The compiler is allowed to optimise away that copy and
keep using data->curr_sense, since it can see that the current thread
does not change data->curr_sense.

You have to, at minimum, use READ_ONCE() here and WRITE_ONCE() when
writing to max16065_data::curr_sense to ensure that the compiler does
not optimise away the copy.

> Note
> that data->curr_gain is constant and safe to access directly.
>=20
> This aligns max16065_current_show with max16065_input_show, which
> already uses a local variable for the same reason.

Then there are 2 functions that need a further fix...

Ben.

> Link: https://lore.kernel.org/all/CALbr=3DLYJ_ehtp53HXEVkSpYoub+XYSTU8Rg=
=3Do1xxMJ8=3D5z8B-g@mail.gmail.com/
> Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compa=
tibles")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
> Link: https://lore.kernel.org/r/20251128124709.3876-1-hanguidong02@gmail.=
com
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/hwmon/max16065.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> --- a/drivers/hwmon/max16065.c
> +++ b/drivers/hwmon/max16065.c
> @@ -216,12 +216,13 @@ static ssize_t max16065_current_show(str
>  				     struct device_attribute *da, char *buf)
>  {
>  	struct max16065_data *data =3D max16065_update_device(dev);
> +	int curr_sense =3D data->curr_sense;
> =20
> -	if (unlikely(data->curr_sense < 0))
> -		return data->curr_sense;
> +	if (unlikely(curr_sense < 0))
> +		return curr_sense;
> =20
>  	return sysfs_emit(buf, "%d\n",
> -			  ADC_TO_CURR(data->curr_sense, data->curr_gain));
> +			  ADC_TO_CURR(curr_sense, data->curr_gain));
>  }
> =20
>  static ssize_t max16065_limit_store(struct device *dev,
>=20
>=20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-1OmL21kCMaNAg83KIYeg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmltFbEACgkQ57/I7JWG
EQnh0RAAkLa2bHOGwfHY1FtBsy/OW/AinqjjTFMGDNKJMqAWHcNdsnv6oji2Ba+2
QEXusb71j3WUDvQbTfnmJ13vsdevqzGCy4vKBRgGRHtC1/oOjMXzf5FB7FbO7g9/
VSEIW+KPoH9zmbjBDXV/bRjLXr6hU+w4yxfDM1nSi9FVtlAynxoRWk+gJqoSvpdU
eKHxodSYEFiJ9fAkzehYbEbA50EoKn8ZRRN6P0A7XscSky2tPhoqnG7VEuOY0Qil
p7mTsuVfQQ1hSc/qETPRiyNDUOlOwQHXeFlxnr1PFdrdK4z+IlY2t44YClYngcio
wZIUYjglcgpDJetnoirz+XW+s1xvh0jmvYPXVrrXuG/rpZwUrFCsnKjCyQyfSVCE
oTRquHGem4oI7oqjdaAQqonWW0X7cF/gWUD+XiGb5gPSmj7qrC71HA+2wItSJ0VH
j2lW3B34anu9DSR5vl3qy4GTt4/C4iGP+yDrOwT7LhS6ul8MTEAHyyasCJkqFIUl
nLtIaIj4cmHfGLj3aFP8h/hpg/0OcIeE3TRNTzR2HLh8oFDsGrub5X3x0dxgeYhQ
HNngG9nXlEQaecBJ84NBKn341mGRZ+VGkRSmImOD6QtSd7pUUMXMci/+Qqgf02T6
+acdmwHTZeKrmxYGL5E7mkgWEaU2nl1kZe3vyTxzVGXYjIHk/ho=
=FkXz
-----END PGP SIGNATURE-----

--=-1OmL21kCMaNAg83KIYeg--
