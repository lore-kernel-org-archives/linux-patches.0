Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870E03546E8;
	Mon,  1 Jun 2026 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343192; cv=none; b=O9yUlpgTbL/6ON/thNcpNiN0S2nppD+cr9AoqIgudHaFrMrzq+D9irQ8T9AEo2gqC4tH83BVrDhEoFiGKKXlaczJTheovvsQPTP5tPWXbHyMapTfH5SyQayl5k0AZhAGtj8WbNiUDh4dFBVW2q/DXXv/ZyI1R1s2R9yOXYXxu1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343192; c=relaxed/simple;
	bh=vSB/fMujNUsjzK08XjSOJQSMK7QL7VqivXC8P6ij/fE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g+IO05YMQ9CitShOiLCNCxTaNFGiW2tNyZ/EaVa20hU/JSEZHCertY4Z3P5Lx+p8u4AjHWl+xfEgFZA6DzTpjnSWrI1+spVjHnwGvaPMXo5EzhIt0cyDHcXMMY6Vqg4Qqo/+P1Tm/0o69dF1j3+jW+fpeIgLz41nW6vTCrGZtCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU8ai-000XH1-21;
	Mon, 01 Jun 2026 19:46:28 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU8ag-0000000Fobu-1sCF;
	Mon, 01 Jun 2026 21:46:26 +0200
Message-ID: <edea6d36625f362c3fcaed6bd251a02827081a1d.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 274/589] drm/gem: Fix inconsistent plane dimension
 calculation in drm_gem_fb_init_with_funcs()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>, 
 Ashutosh Desai <ashutoshdesai993@gmail.com>
Date: Mon, 01 Jun 2026 21:46:20 +0200
In-Reply-To: <20260530160232.175451425@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160232.175451425@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-n3M/QvZyuWLzD+qIJ+iN"
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


--=-n3M/QvZyuWLzD+qIJ+iN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:02 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ashutosh Desai <ashutoshdesai993@gmail.com>
>=20
> commit 3d4c2268bd7243c3780fe32bf24ff876da272acf upstream.
>=20
> drm_gem_fb_init_with_funcs() computes sub-sampled plane dimensions
> using plain integer division:
>=20
>   unsigned int width  =3D mode_cmd->width  / (i ? info->hsub : 1);
>   unsigned int height =3D mode_cmd->height / (i ? info->vsub : 1);
>=20
> However, the ioctl-level framebuffer_check() in drm_framebuffer.c uses
> drm_format_info_plane_width/height() which round up dimensions via
> DIV_ROUND_UP(). This inconsistency corrupts the subsequent GEM object
> size check for certain pixel format and dimension combinations.
>=20
> For example, with NV12 (vsub=3D2) and a 1-pixel-tall framebuffer the
> GEM size validation path sees height=3D0 instead of height=3D1. The
> expression (height - 1) then wraps to UINT_MAX as an unsigned int,
> causing min_size to overflow and wrap back to a small value. A tiny
> GEM object therefore passes the size guard, yet when the GPU accesses
> the chroma plane it will read or write memory beyond the object's
> bounds.
>=20
> Fix by replacing the open-coded divisions with drm_format_info_plane_widt=
h()
> and drm_format_info_plane_height(), which use DIV_ROUND_UP() and match
> the calculation already used in framebuffer_check().

This depends on commit f2f455981a34 "drm: Remove plane hsub/vsub
alignment requirement for core helpers", which went into 6.7 and has not
yet been backported to any stable branch.

Ben.

> Fixes: 4c3dbb2c312c ("drm: Add GEM backed framebuffer library")
> Cc: stable@vger.kernel.org # v4.14+
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Link: https://patch.msgid.link/20260420013637.457751-1-ashutoshdesai993@g=
mail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/drm_gem_framebuffer_helper.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> --- a/drivers/gpu/drm/drm_gem_framebuffer_helper.c
> +++ b/drivers/gpu/drm/drm_gem_framebuffer_helper.c
> @@ -159,8 +159,8 @@ int drm_gem_fb_init_with_funcs(struct dr
>  		return -EINVAL;
> =20
>  	for (i =3D 0; i < info->num_planes; i++) {
> -		unsigned int width =3D mode_cmd->width / (i ? info->hsub : 1);
> -		unsigned int height =3D mode_cmd->height / (i ? info->vsub : 1);
> +		unsigned int width =3D drm_format_info_plane_width(info, mode_cmd->wid=
th, i);
> +		unsigned int height =3D drm_format_info_plane_height(info, mode_cmd->h=
eight, i);
>  		unsigned int min_size;
> =20
>  		objs[i] =3D drm_gem_object_lookup(file, mode_cmd->handles[i]);
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-n3M/QvZyuWLzD+qIJ+iN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmod4Y0ACgkQ57/I7JWG
EQkjrQ/9Ez5QuSOpF45mgPpE7NLl+pExIJMWMWygxq3h2JC7mbK1BI4wqKrbFz4m
pwnraJ5ZayWZY/dEd0yyM4MPBiuohxXWgn/mb3Jm0h0D8yGjm80Y/OTbgcvJIJ/z
qL4HwR982510p63WGRMmoxfyPHRY6rVWbwoYJ+ZeqZ68jk5nYjC6IN1xpvERCCWU
czSscmA6Cw54LlJYLdeKNeWiZzwdNIqQ1E2/JY1yvkfHmVgrQbt3cE4U9qNxLB86
pCRYzoaM5naynIBRV24zy7sp1PAqpBAG2/LEDwuJCUFIFbqhiZn2Op3zik9OsP5J
RbIs3nlDSpizKI2szSoN2UV+T2n1B2slVAl8GsUh0nXTAsSIYg66cMaDddSXAJVE
Ei25kVAJkBpEWrwkcj/QbHuBZ4fCi83stiv/7tWf84QOuQ89u6NfSdGxW0L0h9GW
9imTLvYLzwBydf70NSdzlU9HBVGCnQr65GBa55Mu3RQS+OsMvCDNvMnEQndksFvt
MUz179m4+1p007EORHaWUkql3Wfg4639FZAAjnymBHXD+3uYt0zOOAiPXgrRWG7l
uXVJ6zDo1Nl8wI1IwUhM1AqbOvjSfwHvmf1QHqrdUgEFviPxw4nHzpDyJhRbrXgA
sJwO2P9dMBGdtJLMzLivNOuDWyGunrEk8LKyKR7cKdMllqV8cek=
=6xhr
-----END PGP SIGNATURE-----

--=-n3M/QvZyuWLzD+qIJ+iN--
