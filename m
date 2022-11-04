Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691C08480
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 17:15:28 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 6EDD41C09D8; Fri,  4 Nov 2022 18:15:26 +0100 (CET)
Date: Fri, 4 Nov 2022 18:15:25 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Juergen Borleis <jbe@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 75/91] net: fec: limit register access on i.MX6UL
Message-ID: <20221104171525.GB29661@duo.ucw.cz>
References: <20221102022055.039689234@linuxfoundation.org>
 <20221102022057.177463393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20221102022057.177463393@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Using 'ethtool -d [=E2=80=A6]' on an i.MX6UL leads to a kernel crash:
>=20
>    Unhandled fault: external abort on non-linefetch (0x1008) at [=E2=80=
=A6]
>=20
> due to this SoC has less registers in its FEC implementation compared to =
other
> i.MX6 variants. Thus, a run-time decision is required to avoid access to
> non-existing registers.

Ok, but the code is rather creative:

> @@ -2275,7 +2300,24 @@ static void fec_enet_get_regs(struct net_device *n=
dev,
>  	u32 *buf =3D (u32 *)regbuf;
>  	u32 i, off;
>  	int ret;
> +#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M52=
8x) || \
> +	defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) |=
| \
> +	defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
> +	u32 *reg_list;
> +	u32 reg_cnt;
> =20
> +	if (!of_machine_is_compatible("fsl,imx6ul")) {
> +		reg_list =3D fec_enet_register_offset;
> +		reg_cnt =3D ARRAY_SIZE(fec_enet_register_offset);
> +	} else {
> +		reg_list =3D fec_enet_register_offset_6ul;
> +		reg_cnt =3D ARRAY_SIZE(fec_enet_register_offset_6ul);
> +	}
> +#else
> +	/* coldfire */
> +	static u32 *reg_list =3D fec_enet_register_offset;
> +	static const u32 reg_cnt =3D ARRAY_SIZE(fec_enet_register_offset);
> +#endif

First, COMPILE_TEST now changes behaviour of the code, which is
unexpected. I guess coldfire machine with
of_machine_is_compatible("fsl,imx6ul") =3D=3D true is not probable, but
still.

Second reg_list is static, which is quite confusing. I guess that was
attempt to enable compiler optimalizations, but I don't think compiler
needs this much help.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VIrQAKCRAw5/Bqldv6
8oRrAJ4wdCUGqm+LBjJ9LaRsVUZzEnkPUQCfVox/RGX6nE9Pv7LYkebzMf9Of2Q=
=arp8
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
