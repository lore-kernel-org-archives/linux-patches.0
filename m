Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A42BB1D;
	Sun, 21 Jun 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782055807; cv=none; b=i0HtwBSF9EpYRBqBK8K1jXZh2dAr8XpojUzVmdSeLuGgON+y8j2CQBCX/pgnDTioSkqsISFMtyuf5HvT/Kdafl1T1WXCjSXUx2wphj2Z1ML3s2Qd6U+KPJjHF6UmzsIaDnpUWt3zyCdVdoEV5bsyH2ETDUOqiQoijEvBB9ljSNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782055807; c=relaxed/simple;
	bh=kA7f/hyE+3+kwHlt8ck/CMY1g+O20asTeh55awW8wcI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TYS2kxntM49L0DHWsnuKZ6SmOwg9cGSOGz86M1E2iTuqsNiCUPyJGfaco/G5N/zZsAJLVV63ca0ycu4KCEvq1HNEYjmmWlDRPXdlvRh98a1vf4BOkVrEzUhm/RMLizC3Qnuq0wwVgUB0LtOVAoHc041xydCJGXHZxqMgxBob1zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wbK7V-003aPu-1c;
	Sun, 21 Jun 2026 15:30:01 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wbK7V-00000007J8w-0KY8;
	Sun, 21 Jun 2026 17:30:01 +0200
Message-ID: <42c2abbdfdd4ea8e234fbcfc4b37095ebd2c7b36.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 342/522] thermal: core: Fix thermal zone governor
 cleanup issues
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sun, 21 Jun 2026 17:29:55 +0200
In-Reply-To: <20260616145141.812464695@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145141.812464695@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LItfnKP3/zk17l2uSLEl"
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


--=-LItfnKP3/zk17l2uSLEl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>=20
> [ Upstream commit 41ff66baf81c6541f4f985dd7eac4494d03d9440 ]
>=20
> If thermal_zone_device_register_with_trips() fails after adding
> a thermal governor to the thermal zone being registered, the
> governor is not removed from it as appropriate which may lead to
> a memory leak.
>=20
> In turn, thermal_zone_device_unregister() calls thermal_set_governor()
> without acquiring the thermal zone lock beforehand which may race with
> a governor update via sysfs and may lead to a use-after-free in that
> case.
>=20
> Address these issues by adding two thermal_set_governor() calls, one to
> thermal_release() to remove the governor from the given thermal zone,
> and one to the thermal zone registration error path to cover failures
> preceding the thermal zone device registration.
>=20
> Fixes: e33df1d2f3a0 ("thermal: let governors have private data for each t=
hermal zone")
> Cc: All applicable <stable@vger.kernel.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Link: https://patch.msgid.link/5092923.31r3eYUQgx@rafael.j.wysocki
> [ adapted context for missing mutex_destroy/complete ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/thermal/thermal_core.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -756,6 +756,7 @@ static void thermal_release(struct devic
>  		     sizeof("thermal_zone") - 1)) {
>  		tz =3D to_thermal_zone(dev);
>  		thermal_zone_destroy_device_groups(tz);
> +		thermal_set_governor(tz, NULL);
>  		kfree(tz);
>  	} else if (!strncmp(dev_name(dev), "cooling_device",
>  			    sizeof("cooling_device") - 1)) {
> @@ -1260,8 +1261,10 @@ thermal_zone_device_register_with_trips(
>  	/* sys I/F */
>  	/* Add nodes that are always present via .groups */
>  	result =3D thermal_zone_create_device_groups(tz, mask);
> -	if (result)
> +	if (result) {
> +		thermal_set_governor(tz, NULL);
>  		goto remove_id;
> +	}

The order of initialisation in thermal_zone_device_register_with_trips()
is quite different between 6.1 and mainline.  Clearing the governor here
doesn't make sense as the governor has not been set yet.

The proper place for this in 6.1 seems to be in the failure path after
calling thermal_add_hwmon_sysfs().

Ben.

> =20
>  	/* A new thermal zone needs to be updated anyway. */
>  	atomic_set(&tz->need_update, 1);
> @@ -1396,8 +1399,6 @@ void thermal_zone_device_unregister(stru
> =20
>  	cancel_delayed_work_sync(&tz->poll_queue);
> =20
> -	thermal_set_governor(tz, NULL);
> -
>  	thermal_remove_hwmon_sysfs(tz);
>  	ida_free(&thermal_tz_ida, tz->id);
>  	ida_destroy(&tz->ida);
>=20
>=20

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-LItfnKP3/zk17l2uSLEl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo4A3QACgkQ57/I7JWG
EQnxEBAAktpSm8ttjcA5EALDe7ApE+dVmLcq+CA/kVofOgkvAH+WdkXvYmgUTWgE
9yJwoYVHsM7VYN6CIFAlFi9wq3FNe2IsXAJizFl4g+CJE/MceOom9YQ5FA12lSpb
AX15Ke+CBT9imiCCMp39aGyW0mwCCydeSuj3dJGVmoWr+Kyc/cm9KJiWlmxLV0dN
g6NCrYV9iCrze4s0An5EXmC3912+v1CQNI1Q2rxkl+sSx+B3yZ55nG9z+E20+HMb
TwbMLVvg24XjRsY/NVqJSF5Rz5gz/8/6BQSQVALPidR5P31KWXChIpfM54+BE9Y8
EqEfkBin1z78aa+Et+miDvthtf03JkMRC4nWFQS+tFpUltxe1TffTr1wJC8fG9SI
emPMKsUwHPfvQMmY8lAGrfV9ddZ1lhsX85Ni01bp0zV0TNI8DSrM56UFyoocp5zg
jL8mtYVONcHPX4er+keYvLEJT+SD8s0N0cEdPT2iKXv1LUz/KCy0Nhfscq3pJiU8
dolVs/NqjA2n+WaFuwslhK6d6d5+rts9gWtJNWb98blqXnNRlkCwKHsfX3vJRn8J
Qr0jA9B0evtaztoYGeAsTRCbwcsttp+YtHEQKnl5/1EZ8YqrdRqgfdcWv7jATa53
MWzD/NyXE+Re3wV4uBFzSLbmY7d9w5eX+hp9lq05KaJRirXa1ag=
=7K1w
-----END PGP SIGNATURE-----

--=-LItfnKP3/zk17l2uSLEl--
