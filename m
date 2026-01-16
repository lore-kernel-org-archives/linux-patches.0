Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE602040B6;
	Fri, 16 Jan 2026 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588835; cv=none; b=OnhZ6kBfqPgT18U2G/V7rZgehw0dE9E1uqre7+gTTxAb5/TpWvHU/RJyaat1YnqYSXJYSjhVcmioK5pbzIbSiWAx+5cdgFZNb9/9IqLlvf32IIbG+vg/GIQoRzyr+W3jweDNK3igOxp8qVOh+6n4mpuN1otRCjHkNPshPBi9ZSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588835; c=relaxed/simple;
	bh=nNy6zWITDfM/HTX22ifMxTYrNiekIyMwFPA3SpxuUFY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UswJz49I6Q+tRMbub/Qm39XrF99Exj1ZBrUDiVXN6PJMMZFkMRdICLBroBP7rmzgnD3N/chNcIn8RZOK9Z0/poEIKFxQLcd84bROiQZGWg/5gsnFbKcOYYGXEL11ima+1ybQgpFF6rS40exguaKJHuv38IxWOKw0zBy/p783MNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vgoD0-000tFw-2f;
	Fri, 16 Jan 2026 18:06:05 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vgoCx-00000000cqZ-3gej;
	Fri, 16 Jan 2026 19:06:03 +0100
Message-ID: <47a757bb4d86fb40f14d83adabda441ada44ad16.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 023/451] samples: work around glibc redefining some
 of our defines wrong
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Linus Torvalds <torvalds@linux-foundation.org>,
  Sasha Levin <sashal@kernel.org>
Date: Fri, 16 Jan 2026 19:05:58 +0100
In-Reply-To: <20260115164231.729022046@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164231.729022046@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sZPvyrNRd+ibLOzUat53"
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


--=-sZPvyrNRd+ibLOzUat53
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:43 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> [ Upstream commit a48f822908982353c3256e35a089e9e7d0d61580 ]
>=20
> Apparently as of version 2.42, glibc headers define AT_RENAME_NOREPLACE
> and some of the other flags for renameat2() and friends in <stdio.h>.

This is not relevant to 5.10 or any branch older than 6.12, because
<linux/fcntl.h> only started defining these macros in 6.12.

Ben.

> Which would all be fine, except for inexplicable reasons glibc decided
> to define them _differently_ from the kernel definitions, which then
> makes some of our sample code that includes both kernel headers and user
> space headers unhappy, because the compiler will (correctly) complain
> about redefining things.
>=20
> Now, mixing kernel headers and user space headers is always a somewhat
> iffy proposition due to namespacing issues, but it's kind of inevitable
> in our sample and selftest code.  And this is just glibc being stupid.
>=20
> Those defines come from the kernel, glibc is exposing the kernel
> interfaces, and glibc shouldn't make up some random new expressions for
> these values.
>=20
> It's not like glibc headers changed the actual result values, but they
> arbitrarily just decided to use a different expression to describe those
> values.  The kernel just does
>=20
>     #define AT_RENAME_NOREPLACE  0x0001
>=20
> while glibc does
>=20
>     # define RENAME_NOREPLACE (1 << 0)
>     # define AT_RENAME_NOREPLACE RENAME_NOREPLACE
>=20
> instead.  Same value in the end, but very different macro definition.
>=20
> For absolutely no reason.
>=20
> This has since been fixed in the glibc development tree, so eventually
> we'll end up with the canonical expressions and no clashes.  But in the
> meantime the broken headers are in the glibc-2.42 release and have made
> it out into distributions.
>=20
> Do a minimal work-around to make the samples build cleanly by just
> undefining the affected macros in between the user space header include
> and the kernel header includes.
>=20
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  samples/vfs/test-statx.c         | 6 ++++++
>  samples/watch_queue/watch_test.c | 6 ++++++
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/samples/vfs/test-statx.c b/samples/vfs/test-statx.c
> index 49c7a46cee073..424a6fa15723c 100644
> --- a/samples/vfs/test-statx.c
> +++ b/samples/vfs/test-statx.c
> @@ -19,6 +19,12 @@
>  #include <time.h>
>  #include <sys/syscall.h>
>  #include <sys/types.h>
> +
> +// Work around glibc header silliness
> +#undef AT_RENAME_NOREPLACE
> +#undef AT_RENAME_EXCHANGE
> +#undef AT_RENAME_WHITEOUT
> +
>  #include <linux/stat.h>
>  #include <linux/fcntl.h>
>  #define statx foo
> diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch=
_test.c
> index 8c6cb57d5cfc5..24cf7d7a19725 100644
> --- a/samples/watch_queue/watch_test.c
> +++ b/samples/watch_queue/watch_test.c
> @@ -16,6 +16,12 @@
>  #include <errno.h>
>  #include <sys/ioctl.h>
>  #include <limits.h>
> +
> +// Work around glibc header silliness
> +#undef AT_RENAME_NOREPLACE
> +#undef AT_RENAME_EXCHANGE
> +#undef AT_RENAME_WHITEOUT
> +
>  #include <linux/watch_queue.h>
>  #include <linux/unistd.h>
>  #include <linux/keyctl.h>

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed
                                                    - Carolyn Scheppner

--=-sZPvyrNRd+ibLOzUat53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlqfgcACgkQ57/I7JWG
EQks7xAA0UXgRgbI7ZANUcanTa5p0uSAiUI7Y/7aGdgXiPwcp4oPostIEtEzoVi4
49RSEJQcUOBiMMQwM3a9I3FuuMVeaav2WX/fTdcLCfStCW1piWRNveN8/oiYJd8D
h5B4AdRFQAlJy+L5RtV3KUTiQf7tvahIo/HqHQxSnPnPSwSXIpKn1+LTeGButGoV
4MoULA7g4hjikworp53BnzXba3HqIuw+KvVTYdSNbb90xAcy3tcuiHjSGHPrTUt/
QuJ5RzKydqV6z3SNZgKeul5dRhVoAO+tzr49Ahg/fWrjwgZ8wK5fKESh3etX840+
x8kJMl/NGwxE7d6EmrLI7bhKI/AD6CAKeH+wUBlU5Y2cCAE3Vkm7yqSXktZiDNRR
Kp1q9WvO9pU9pjJ7DghRm0f+VQs0xX4fh0sfhzCqpBJLzffhmPIt+PqK/bbHRrcI
ht5mErK3tNApzdT2V9VvRYdy8vTVCEmIrfr1YpGBkaDrPtNiS8MRULBMoDtWFjkX
+CxCZWHg6GUYRQtNNM6nr2ttSDNQSvK5sjhobWXZQBYPniu3RHq5bhNGFE1CqdBd
OGO6G3Zo7P7QdlF/xufzMpPZQraTp0lDrZx1La0SykXO3a9Uue6JUdtD1lG3guR3
NXqIlGe631ttPo2nRsKXdIW79+zbWmU7+zSfGP9slCmLBhqkaYs=
=sPCz
-----END PGP SIGNATURE-----

--=-sZPvyrNRd+ibLOzUat53--
