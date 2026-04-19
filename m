Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A80175A6D;
	Sun, 19 Apr 2026 10:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776594386; cv=none; b=MFD808ts0cvs66px28Lc+iMuz2NliITq+coxd/1oiYTl3NHJ1lGubSdPP/cBBzqfKBCHUG6rRRlSOBFt8bxG5KScmq2zCQwQu+8u9osi20K5kaoiNJ/h4m30aK9ycV9ehoA8divQu5HDQuUvrcBn3m0NaROxp6R7Xet4hAchyuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776594386; c=relaxed/simple;
	bh=S4ghgkBMPdy1X4QqEQ0xyv4IdtjF8SLm/c0CarDqJKg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KDjXcrbKIEb8GX1ZG1W4GTOIc1FwLXqE6llFeNK0wzO60Y+G1FppxH4g7xWki0w8HmUTrt6vgJ6GsqDsgjhabc5bB2m5WZcE5WHLDrKzlxsqtouJy2rp+m670Zunpfzu5NZ1dUGF98ovuHSlhUwKciIIy948j78UAhAnk7L7Agg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wEPM5-005UxS-2E;
	Sun, 19 Apr 2026 10:26:20 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wEPM3-00000004f2v-0DY0;
	Sun, 19 Apr 2026 12:26:19 +0200
Message-ID: <0d3747dc57d7bfa3c53efcf4d133021ead5bef9d.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 430/491] apparmor: validate DFA start states are in
 bounds in unpack_pdb
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  John Johansen <john.johansen@canonical.com>
Cc: patches@lists.linux.dev, Qualys Security Advisory <qsa@qualys.com>, 
 Salvatore Bonaccorso	 <carnil@debian.org>, Georgia Garcia
 <georgia.garcia@canonical.com>, Cengiz Can	 <cengiz.can@canonical.com>,
 Massimiliano Pellizzer	 <massimiliano.pellizzer@canonical.com>
Date: Sun, 19 Apr 2026 12:26:13 +0200
In-Reply-To: <20260413155835.127014179@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155835.127014179@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uv2HiuW6W4Flc1loWdaE"
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


--=-uv2HiuW6W4Flc1loWdaE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
>=20
> commit 9063d7e2615f4a7ab321de6b520e23d370e58816 upstream.
>=20
> Backport for conflicts caused by
>   ad596ea74e74 ("apparmor: group dfa policydb unpacking")
>   - rearrange and consolidated the unpack.
>=20
>   b11e51dd7094 ("apparmor: test: make static symbols visible during kunit=
 testing")
>   - rename function and make it visible to kunit tests
>=20
> Start states are read from untrusted data and used as indexes into the
> DFA state tables. The aa_dfa_next() function call in unpack_pdb() will
> access dfa->tables[YYTD_ID_BASE][start], and if the start state exceeds
> the number of states in the DFA, this results in an out-of-bound read.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  BUG: KASAN: slab-out-of-bounds in aa_dfa_next+0x2a1/0x360
>  Read of size 4 at addr ffff88811956fb90 by task su/1097
>  ...
>=20
> Reject policies with out-of-bounds start states during unpacking
> to prevent the issue.
>=20
> Fixes: ad5ff3db53c6 ("AppArmor: Add ability to load extended policy")
> Reported-by: Qualys Security Advisory <qsa@qualys.com>
> Tested-by: Salvatore Bonaccorso <carnil@debian.org>
> Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
> Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
> Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.c=
om>
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  security/apparmor/policy_unpack.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>=20
> --- a/security/apparmor/policy_unpack.c
> +++ b/security/apparmor/policy_unpack.c
> @@ -841,9 +841,18 @@ static struct aa_profile *unpack_profile
>  			error =3D -EPROTO;
>  			goto fail;
>  		}
> -		if (!unpack_u32(e, &profile->policy.start[0], "start"))
> +		if (!unpack_u32(e, &profile->policy.start[0], "start")) {
>  			/* default start state */
>  			profile->policy.start[0] =3D DFA_START;
> +		} else {
> +			size_t state_count =3D profile->policy.dfa->tables[YYTD_ID_BASE]->td_=
lolen;
> +
> +			if (profile->policy.start[0] >=3D state_count) {
> +				info =3D "invalid dfa start state";
> +				goto fail;
> +			}
> +		}
[...]

Isn't this range check needed even if we use the default start state?=20
unpack_table() only checks that td_tolen > 0, so we could end up with
profile->policy.start[0] =3D DFA_START =3D=3D 1 and
profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen =3D=3D 1.

(This is specific to the backport as the upstream version didn't put
this check in an else-block.)

Ben.


--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable
from a rigged demo.

--=-uv2HiuW6W4Flc1loWdaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnkrcYACgkQ57/I7JWG
EQkg1A/9FKkNxbCGI3uONMr4AQeXYeKJcdWjOju4zAyrL6XNGsGJTKxIfT31Isls
SRn9nkqLdWdlZL7jJYjjjrz+HGo2pbJpwtLqhdTkey5+70EL5w+Gkhqj17iGskUj
VaH5zWVlaPFBIbtWKgJyHBXZqwu2a8Q5ATQ9kzo+Az5KE4AKjBHdL+XNw1ZXGVVz
HSNwEqjtf4cyqofRXk7ZnZW3FWW3cJOfcWvf/yjGzIMDXmv0Fd5PPMTPXmN109L1
MVFSBkVvDuqWKDCMRGHV9sBSHV/pP0UMvfL7ZFb+2qeXkoux95UgT1JpfYx2cTCh
gPvG4ip+Uyb/zvQXhA8W9WJWNFezU1afmhKHmVGEhFApal6GtpKTI+11FHTOITNK
lXV6T9qgNJw70M2stPMPJpVuBXaWusS06XKsiRgHvgzHyncGNixAiPOjbA75b3OW
y72bnac0meDxSHbqyTkUNd8rc6DyZL3iNIBlTB8+SZvqeQjX78uTtHnd3Up+rpqI
jhtXlXi7MktBkFSI4ERRSHTlTJMp9UVe9Hieo3hwhjjiDSACzc15X7jtpKCmkAMr
Y4cwebdRadHxNCeND9SHJIvp8L4lYrxrc7gBT27+Qqfcwd7d+2c02arbMr/Ijppd
Ae/oo7eOa4Qr3l20eb815xek0Dl9mBsJ79RlpxshRTQHFPQw0J8=
=dcXf
-----END PGP SIGNATURE-----

--=-uv2HiuW6W4Flc1loWdaE--
