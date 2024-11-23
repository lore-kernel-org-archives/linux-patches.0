Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8616DEA9
	for <patches@lists.linux.dev>; Sat, 23 Nov 2024 07:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732346768; cv=none; b=b0RsTVzlHJV144WMEkfTJLVzWrVNSrNQh5mSYKK71c5//SQxvSMT4utyQhYs/bIB09+Ng0xx4Ae+dxy4+WZoDKg+kWcVoGU1qcBKfFzzJ2rVKBbVWGOxNBOxhYZWbCqHLHDNMfjLIB1xdi+sS7XGbZgQ2RRdcenHvN9B4g9H/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732346768; c=relaxed/simple;
	bh=EAWioJm7T9zrffHgoQOW92hh/2+ZDtEiBN2Sxxbv8L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fa7NP6DgOnTnmA1PzE4PAS55YiNnXZWTVlb5EEK9Ic0/faipy2RF9mmmihQ4nDiGtUnix6eI5Dj2U3+Rt+8OhDl59SgvwhSFD/WlBvxH4pGJ9wzwx6T0r5T7SEnqnbNi+GkBOcHCAKP155jq9DeIOmP7y92blcxQNAHxkg6Fm9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4E1F21C00B2; Sat, 23 Nov 2024 08:25:57 +0100 (CET)
Date: Sat, 23 Nov 2024 08:25:56 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	seanjc@google.com, chuck.lever@oracle.com
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Message-ID: <Z0GDhId6mYswr+K0@duo.ucw.cz>
References: <20241120125809.623237564@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dKzwtp+IgQh+PyQN"
Content-Disposition: inline
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>


--dKzwtp+IgQh+PyQN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Sean Christopherson <seanjc@google.com>
>     KVM: VMX: Bury Intel PT virtualization (guest/host mode) behind
>     CONFIG_BROKEN

So... someone is passing kernel command line parameter, and setup
works for him, now we start silently ignoring that parameter? That is
pretty unfriendly.

> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Limit the number of concurrent async COPY operations

@@ -1782,10 +1783,16 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_com=
pound_state *cstate,
        if (nfsd4_copy_is_async(copy)) {
-               status =3D nfserrno(-ENOMEM);
                async_copy =3D kzalloc(sizeof(struct nfsd4_copy), GFP_KERNE=
L);
                if (!async_copy)
                        goto out_err;

This is wrong. Status is success from previous code, and you are now
returning it in case of error.

(Also, the atomic dance does not work. It will not allow desired
concurency in case of races. Semaphore is canonical solution for
this.)

> Andrew Morton <akpm@linux-foundation.org>
>     mm: revert "mm: shmem: fix data-race in shmem_getattr()"

No problem with this patch, but please remember this next time you
apply "no real bug but warnings are bad" change...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--dKzwtp+IgQh+PyQN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ0GDhAAKCRAw5/Bqldv6
8mwVAJ90VQOUZGh4OjHfAY6QIg8yMJT+swCeKKibxVEWFjUVjuhhT8BLdgEWNZI=
=M/mH
-----END PGP SIGNATURE-----

--dKzwtp+IgQh+PyQN--
