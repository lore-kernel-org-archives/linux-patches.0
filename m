Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F126727450;
	Wed, 13 Aug 2025 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755093392; cv=none; b=td36y1cLcMDnhOYvgoPb8NySCv2ndYb/2T0J7x9vbdMFBT02UKZrK1LKVPo3wybWivykzUMF/AoLaGEwBzy7d4Dqn0sQVSJ3SKnuzB1lr4sgqu6Z+kz1+/xE65NtdG7uSxsbKb+VBKAwpspY/XCtdbRJ7I0FR1Skd8DnOuxeM/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755093392; c=relaxed/simple;
	bh=PU8D4TvDAaiDVPVg+2dLpyoPg7qqnDgECUB9LA69pDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwpa1knsM5ol170a98q1Zut9mSnoy9K8PVUghUW8VE7itoGQdDOTqpFmXu71Nej66igycULfG5rffhoYCrJwATSTLxOwuLdRIhMHY93anyUJBjj66HA4p/9WYcdsXFSehmFdz40en4mAscRAQJnsByLwl/a6e6X/t4Q99N1/SLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfnvEkGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfnvEkGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2AAC4CEED;
	Wed, 13 Aug 2025 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755093391;
	bh=PU8D4TvDAaiDVPVg+2dLpyoPg7qqnDgECUB9LA69pDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DfnvEkGjlqlBmycupm29qobQQ7q/ILqOB43RDwKfg8vgJw0I/PreZK2XHrUgn02OR
	 nZ4ATmmMOOLbF5jZFz8sLCRTeILdzEEpprPW1jzufXkZyxy0eKqZcrufrJyiLdlFot
	 Y6UMyfulsdg7WJ4qEVKRlTltIxhEe7ktB3j5CjbrTcwVOvIYk0qlNzsoi2dt4AxYru
	 LovStafbDmfrBiTV63Y6Bzr2st4W+lG0e31cPDZO4gI1wlbf2XR2ObvcgjLySXz8Y5
	 BFkiEwdeqLSChCugFLb79vRwMrO444EVLyResNzgK6LGgVF6lgAcUlj5Ukq1k0avA0
	 zc7n7ufOz+X/w==
Date: Wed, 13 Aug 2025 14:56:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Message-ID: <f8133619-cbea-4794-97ff-f6c5d457e251@sirena.org.uk>
References: <20250812173419.303046420@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="toqZ+J3Itf5R37vU"
Content-Disposition: inline
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
X-Cookie: Turn the other cheek.


--toqZ+J3Itf5R37vU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2025 at 07:24:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

As mentioned elsewhere I'm seeing failures in epoll_ctl04 from LTP:

  epoll_ctl04.c:59: TFAIL: epoll_ctl(..., EPOLL_CTL_ADD, ...) with number of nesting is 5 expected EINVAL: ELOOP (40)

these bisect down to "eventpoll: Fix semi-unbounded recursion".  Bisect
log and links to full console logs:

# bad: [cd8771110407dfe976259483baaae2c6e62a4146] Linux 6.16.1-rc1
# good: [038d61fd642278bab63ee8ef722c50d10ab01e8f] Linux 6.16
git bisect start 'cd8771110407dfe976259483baaae2c6e62a4146' '038d61fd642278bab63ee8ef722c50d10ab01e8f'
# test job: [cd8771110407dfe976259483baaae2c6e62a4146] https://lava.sirena.org.uk/scheduler/job/1664129
# bad: [cd8771110407dfe976259483baaae2c6e62a4146] Linux 6.16.1-rc1
git bisect bad cd8771110407dfe976259483baaae2c6e62a4146
# test job: [7ee553aeaf6d124298f393ec5eaa219b0968e16f] https://lava.sirena.org.uk/scheduler/job/1666114
# bad: [7ee553aeaf6d124298f393ec5eaa219b0968e16f] media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check
git bisect bad 7ee553aeaf6d124298f393ec5eaa219b0968e16f
# test job: [716cab0f18aa38d77b92073dab931186c770054f] https://lava.sirena.org.uk/scheduler/job/1666908
# bad: [716cab0f18aa38d77b92073dab931186c770054f] wifi: ath12k: Avoid accessing uninitialized arvif->ar during beacon miss
git bisect bad 716cab0f18aa38d77b92073dab931186c770054f
# test job: [7fac9c079ff503f261ffb49bdd7f283803beca93] https://lava.sirena.org.uk/scheduler/job/1667071
# bad: [7fac9c079ff503f261ffb49bdd7f283803beca93] ASoC: SDCA: Add missing default in switch in entity_pde_event()
git bisect bad 7fac9c079ff503f261ffb49bdd7f283803beca93
# test job: [1da0a31f7c952ad518d3a91df9a9109ba3c02d73] https://lava.sirena.org.uk/scheduler/job/1667175
# bad: [1da0a31f7c952ad518d3a91df9a9109ba3c02d73] selftests: Fix errno checking in syscall_user_dispatch test
git bisect bad 1da0a31f7c952ad518d3a91df9a9109ba3c02d73
# test job: [53cd2297915f5c3be56ddad54be5cefb9cbc2fb9] https://lava.sirena.org.uk/scheduler/job/1667249
# good: [53cd2297915f5c3be56ddad54be5cefb9cbc2fb9] ublk: validate ublk server pid
git bisect good 53cd2297915f5c3be56ddad54be5cefb9cbc2fb9
# test job: [8aca40e2c98c5eae8da96e84caaaaec97152dbed] https://lava.sirena.org.uk/scheduler/job/1667289
# bad: [8aca40e2c98c5eae8da96e84caaaaec97152dbed] block: restore two stage elevator switch while running nr_hw_queue update
git bisect bad 8aca40e2c98c5eae8da96e84caaaaec97152dbed
# test job: [9fccd15a5cdcd1d2376f96fdba97ff82d26ea8ba] https://lava.sirena.org.uk/scheduler/job/1667364
# good: [9fccd15a5cdcd1d2376f96fdba97ff82d26ea8ba] io_uring: fix breakage in EXPERT menu
git bisect good 9fccd15a5cdcd1d2376f96fdba97ff82d26ea8ba
# test job: [b47ce23d38c737a2f84af2b18c5e6b6e09e4932d] https://lava.sirena.org.uk/scheduler/job/1667417
# bad: [b47ce23d38c737a2f84af2b18c5e6b6e09e4932d] eventpoll: Fix semi-unbounded recursion
git bisect bad b47ce23d38c737a2f84af2b18c5e6b6e09e4932d
# test job: [cac4afc0cefeb0b4d066867aebe0b7cb6806b9ae] https://lava.sirena.org.uk/scheduler/job/1667503
# good: [cac4afc0cefeb0b4d066867aebe0b7cb6806b9ae] btrfs: remove partial support for lowest level from btrfs_search_forward()
git bisect good cac4afc0cefeb0b4d066867aebe0b7cb6806b9ae
# first bad commit: [b47ce23d38c737a2f84af2b18c5e6b6e09e4932d] eventpoll: Fix semi-unbounded recursion

--toqZ+J3Itf5R37vU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmicmYgACgkQJNaLcl1U
h9BWOQf/fc12VadwQyASyYC8BClCyWix8956AMY1zJq9QxO/dW3mRBj2FY7bovnc
AZIQPMeT+6H3ecohcV2h1QDDS/afHihUw+G9GALhD9SifdSJm2tzV4gDW8HwPoSz
sE29wYbz6VwEZro0dYIwV61Lh1k/dL4i9asiaQXLlDTPVf4ffAqo3ACM+uZufj8i
5vCRk+vykda9wMO7bAV+5Bba70WRYUPfE8kq585F277wzurXqo48SPVQDLCkXT2m
G/J6fKQHTIe2tmky5BbiLvWg2ffXW0KZWrHS3liZDcFXpVs5hrcMfca7NB7Q9Gss
emggwHmz9hjWmt20YWk8Fehg43fJLw==
=phQ8
-----END PGP SIGNATURE-----

--toqZ+J3Itf5R37vU--
