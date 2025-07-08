Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F4F21A928
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 06:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751956792; cv=none; b=AYPi+LHGBrIFanq0F3cdRlqwbnruGdug1WaUoIOOQlgE2VWHg2r8qy03WBYTiFQjEuJNI/jS+zwyHQo5hJg/jwOXOONt/q74qAs/hLz4+XjFZR4aSsW7O1yTmaf97PQM3cwcV7dGuM8lxiDvIFIlBqGO6+49wunEMgH1+uitTJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751956792; c=relaxed/simple;
	bh=/+rZ+qOaO2sDKbnd4NLr4zgegw4MO6vu4F3mLw7BGhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqGCODxMLAGsQBoTyzV90vWLVLl8uquwRIB1wwfAlpbEq1PwPUrJLC+LY+6TWkrYCVG8nRvx+TYtcsaOWcGTEOIMExMls1RPuVzLmv72GX01LquLL0Q3mZavS7F/iX7Mh2I2kEkEZqsiksmmInMEkb/hTXPoXqOT7UN9sdbTqGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz; spf=pass smtp.mailfrom=ucw.cz; dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b=pi9S06D/; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b="pi9S06D/"
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id EA5551C00B2; Tue,  8 Jul 2025 08:39:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
	t=1751956787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkQDJKWFePkir3VVOngFU49HXADxPt6pfGrGXj/dAME=;
	b=pi9S06D/6cVWHJpKxkRtDpDBSlrWst1CBY0sx2rT9xV6TtgDCsNaqgO3WyNekmrrEgNPKv
	2IsGB0eSptYebbZJzyzlSLJjSkePo25qvzS13RPNykBqBw7sYCXVrzeaVATXOK/U9Llx2c
	9RZ5v8uUF+67/IdD+irc9CBiQX6zQmg=
Date: Tue, 8 Jul 2025 08:39:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	Nat Wittstock <nat@fardog.io>, Lucian Langa <lucilanga@7pot.org>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	rafael@kernel.org, len.brown@intel.com, ebiederm@xmission.com,
	linux-pm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.15 6/8] PM: Restrict swap use to later in the
 suspend sequence
Message-ID: <aGy9M3zEX7rgo5sS@duo.ucw.cz>
References: <20250708000215.793090-1-sashal@kernel.org>
 <20250708000215.793090-6-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1kwsET5uSiv9nLtr"
Content-Disposition: inline
In-Reply-To: <20250708000215.793090-6-sashal@kernel.org>


--1kwsET5uSiv9nLtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> [ Upstream commit 12ffc3b1513ebc1f11ae77d053948504a94a68a6 ]
>=20
> Currently swap is restricted before drivers have had a chance to do
> their prepare() PM callbacks. Restricting swap this early means that if
> a driver needs to evict some content from memory into sawp in it's
> prepare callback, it won't be able to.
>=20
> On AMD dGPUs this can lead to failed suspends under memory pressure
> situations as all VRAM must be evicted to system memory or swap.
>=20
> Move the swap restriction to right after all devices have had a chance
> to do the prepare() callback.  If there is any problem with the sequence,
> restore swap in the appropriate dpm resume callbacks or error handling
> paths.
>=20
> Closes: https://github.com/ROCm/ROCK-Kernel-Driver/issues/174
> Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2362
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Tested-by: Nat Wittstock <nat@fardog.io>
> Tested-by: Lucian Langa <lucilanga@7pot.org>
> Link: https://patch.msgid.link/20250613214413.4127087-1-superm1@kernel.org
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


> ## Small, Contained Change
>=20
> 3. **Minimal Code Changes**: The fix is remarkably simple - it just
>    moves the `pm_restrict_gfp_mask()` call from early in the suspend
>    sequence to after `dpm_prepare()` completes. The changes are:

This is not contained change. It changes environment in which drivers run.

I have strong suspicion that you did not do actual analysis, but let
some kind of LVM "analyze", then signed it with your name. Is my
analysis correct?
								Pavel
--=20
I don't work for Nazis and criminals, and neither should you.
Boycott Putin, Trump, and Musk!

--1kwsET5uSiv9nLtr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaGy9MwAKCRAw5/Bqldv6
8ghtAJ9sA/huV29bml+0HHb127MElooywgCgnva6bxPc+31mjS5JfXMx0Nis0Ns=
=KqmG
-----END PGP SIGNATURE-----

--1kwsET5uSiv9nLtr--
