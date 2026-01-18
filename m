Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CA63328E1;
	Sun, 18 Jan 2026 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768748234; cv=none; b=RYqUrAs+Qm0KQGCM7sysqg7lTHM7cIXcGc96uz0MuibOxnMpI6VYlmf536D5X1bj4IgV2r/h5XI2g6tN2bKGOdWQT0D9f8N1ow7QkbnP9DAvZnbmY+luf52yE5n5fD8hsWA9XRaDWqwSktZ2EJJHsbzfkel06TPtzVOSILIGECQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768748234; c=relaxed/simple;
	bh=dQA8nxDSxirkjcdotFmSmvHU4Bni1Dl5EGmTvO6FRXk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rX2XGaIKhxZkmEpZIAybwbJpAEdiCPBkJ/MitDhcj0kAYJOuaNAgyCOmSe+zFKnn0gCv+sOmTx2lAd4aCZTPU00mK4PQcoUe8ta7fDX6DcFPkKR+EwYlJU/taHnSwrjzgb7N3Bge7Ly7NXnsCPBzuhcsS26nVMIZfYHJ5Kaie78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhUDI-00186K-35;
	Sun, 18 Jan 2026 14:57:11 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhUDH-00000000ofD-01p0;
	Sun, 18 Jan 2026 15:57:11 +0100
Message-ID: <a0252a297d15f3e2b86aad41e8e324883e06e8b2.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 337/451] drm/nouveau/dispnv50: Dont call
 drm_atomic_get_crtc_state() in prepare_fb
From: Ben Hutchings <ben@decadent.org.uk>
To: Lyude Paul <lyude@redhat.com>, Dave Airlie <airlied@redhat.com>
Cc: patches@lists.linux.dev, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  stable <stable@vger.kernel.org>
Date: Sun, 18 Jan 2026 15:57:05 +0100
In-Reply-To: <20260115164243.086124676@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164243.086124676@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UlMEeZ1+5fzDANACx3/b"
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


--=-UlMEeZ1+5fzDANACx3/b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:48 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Lyude Paul <lyude@redhat.com>
>=20
> commit 560271e10b2c86e95ea35afa9e79822e4847f07a upstream.
>=20
> Since we recently started warning about uses of this function after the
> atomic check phase completes, we've started getting warnings about this i=
n
> nouveau. It appears a misplaced drm_atomic_get_crtc_state() call has been
> hiding in our .prepare_fb callback for a while.
>=20
> So, fix this by adding a new nv50_head_atom_get_new() function and use th=
at
> in our .prepare_fb callback instead.
[...]
> +static inline struct nv50_head_atom *
> +nv50_head_atom_get_new(struct drm_atomic_state *state, struct drm_crtc *=
crtc)
> +{
> +	struct drm_crtc_state *statec =3D drm_atomic_get_new_crtc_state(state, =
crtc);
> +
> +	if (!statec)
> +		return NULL;
> +
>  	return nv50_head_atom(statec);
>  }
> =20
> --- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
> @@ -561,7 +561,7 @@ nv50_wndw_prepare_fb(struct drm_plane *p
>  	asyw->image.offset[0] =3D nvbo->offset;
> =20
>  	if (wndw->func->prepare) {
> -		asyh =3D nv50_head_atom_get(asyw->state.state, asyw->state.crtc);
> +		asyh =3D nv50_head_atom_get_new(asyw->state.state, asyw->state.crtc);
>  		if (IS_ERR(asyh))
>  			return PTR_ERR(asyh);

But now the error check here doesn't work.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-UlMEeZ1+5fzDANACx3/b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmls9MIACgkQ57/I7JWG
EQkSoRAArkK6KViVJtIXLGC4VDYxcT48VLktludygzaZir9czSYLI3+c3BgpWyj1
ORL9RC3EplE0VCi0aYzhvicm4hUL4qYza9xTnjUosshWO3gZ5uBZnLI9O0e7zEf+
S0qEGjbGKfTVyWp9HY/ZB5CUGy/um2bmWEnCHlaX8KXRcc8NEANoX1z1wgc23Ir2
/bRBuVJP4FrOJ66yYAJcPWuyfaJ2+suXPAddzq6dLOzb196ajJc3vqNx5RFJZWzX
R1o0gL+KiNnLQDjV1XyLHedwtL2Onel4yPkfS+mQ5cDf3AqKxTXDRuZ6dqE1dZrL
q1Hu5nMkciXS4tjYvectEfJwDbaqQb52z6v9m4THdckmvCfWH5WUs8TybRLebK7d
uJ2j0e/P4oCGH6XdGAFiT+sDPvx9uYDZXYq6vt/KXugucWkFlwVfXE+raF9I5gLE
D6CPvCThYgskvc+uX+GgQ1kk4YmtX4gqVHNwqA+rs1I6oXM25NiYtIg2drEWO6xp
VntFkNqnT8fLMyQd4OCvEuJ0oaaDacky03HcBXC3GfhIqvOycNeSUeLGjBeBoImu
dWdZO2KRiqoNwtz4WzSDKAzvfDhNggHoapNTAQL0PzgVZ63YwPW7DuzNSWnx0gio
DF/PjZ30SKhPM64i9JyCQTfj032JmzkvwtjHx3acvz0XsAI/rJ0=
=WDBD
-----END PGP SIGNATURE-----

--=-UlMEeZ1+5fzDANACx3/b--
