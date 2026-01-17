Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77019253B42;
	Sat, 17 Jan 2026 21:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768684812; cv=none; b=jhCUw1ZI4X3TMigvAfo1IzftJpN9bHhUXmnlE5CVC5g0HNoxQ0JBnuhgz2FmEUx+bXog8J1eCEqv24UH+RXEWrxiAoPa+nYlO+Rqj2m3N6LelOFHcx3VCSE9byJENKE91DdNMhkjdPXcopBXJbZSdmWse+J24RVAxghMYdnx+P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768684812; c=relaxed/simple;
	bh=mjzoexsq0MOUp1fzWikKTASTy+ZjbScZSE+tSilkMIw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L4sCnoq+TQBri4XDmkcTk660PObpCuALERfwuMyogsf+OFTQwEPRIQq+BIQtl97NHJd01+LroI4lqgGmdFz2YSgKHArVRWSiNxjOKxdCdO9P9TUQcDe4P4p4qvR/mW4PFT623RNQxVodQ8/2WFDT3VZlHqSCl1jVhVzNsi1cQPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhDiK-0011xO-39;
	Sat, 17 Jan 2026 21:20:07 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhDiI-00000000khs-1CzO;
	Sat, 17 Jan 2026 22:20:06 +0100
Message-ID: <d147f0eb71f9cefbfb7605e95d98564d7f0ed346.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 234/451] usb: phy: fsl-usb: Fix use-after-free in
 delayed work during device removal
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, stable <stable@kernel.org>, Duoming Zhou
	 <duoming@zju.edu.cn>
Date: Sat, 17 Jan 2026 22:19:58 +0100
In-Reply-To: <20260115164239.360073394@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164239.360073394@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+7H8HUOR/8ftKauSt5xn"
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


--=-+7H8HUOR/8ftKauSt5xn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:47 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Duoming Zhou <duoming@zju.edu.cn>
>=20
> commit 41ca62e3e21e48c2903b3b45e232cf4f2ff7434f upstream.
>=20
> The delayed work item otg_event is initialized in fsl_otg_conf() and
> scheduled under two conditions:
> 1. When a host controller binds to the OTG controller.
> 2. When the USB ID pin state changes (cable insertion/removal).
>=20
> A race condition occurs when the device is removed via fsl_otg_remove():
> the fsl_otg instance may be freed while the delayed work is still pending
> or executing. This leads to use-after-free when the work function
> fsl_otg_event() accesses the already freed memory.
>=20
> The problematic scenario:
>=20
> (detach thread)            | (delayed work)
> fsl_otg_remove()           |
>   kfree(fsl_otg_dev) //FREE| fsl_otg_event()
>                            |   og =3D container_of(...) //USE
>                            |   og-> //USE
>=20
> Fix this by calling disable_delayed_work_sync() in fsl_otg_remove()
> before deallocating the fsl_otg structure. This ensures the delayed work
> is properly canceled and completes execution prior to memory deallocation=
.
[...]

The disable_delayed_work_sync() function was only added in 6.10 and has
not (yet) been backported anywhere.

So for older branches, either this fix needs to be changed to use
cancel_delayed_work_sync() (which I suspect requires reordering some of
the cleanup, to be safe) or disable_delayed_work_sync() needs to be
backported first.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-+7H8HUOR/8ftKauSt5xn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlr/P4ACgkQ57/I7JWG
EQnq0xAAwh5w1T/W9ykjJWBKM6q8INwGeydTrthku9JJMFmiq8d7O76aYU7DJGTC
FpaiMMjDP3nTGnhUgG0XJeNW1WbMWclQjj0aWSsCYSjdfRTy+DNq7uzgRl5pbGcU
UDSN9D9iWiP35CvyjuI7O43PuXJ1m+baFDKY/QvZbs69LmP/keBkjaVIT5vY8v8/
bSCwrv+JwVz3S9HzVGQMs3Q0XSe8EjPrjRk/SVeVo5b8MV5xR2CWABrzNfaH3AGC
0Bh69Kb0NGyrwqMLepOYHxaWERZMDTyj/DVd0J/c626E+207C+Ie86aSl0rhgWyT
FsOzBI5VtbmD7x9AY4f4boTywT7sL5TKUuH+Z/PFv0nh3JgAtUHASpUkCNTKT82V
r68bk7DnBfLRYT7DYrV1WjEB1l7tdDNEmaXLanVsixro1rumRp8KhShdogGwc+Xs
wvGZnAAEuIIyqXx2CbYRUFbugXr1wtsrCQqfYOQDXdWdITKuVZY3+iBT0Fs6ioGd
f+gd8UvqlhkKIwy7baYhVVqFLfiCaRoZiuWiidjopRVgrFSHLCkYRR+qGNm+TXlt
m9zF16HG6qRHfVZXUrEEk2zyyXtawb8k59W8b8LLqPvzE7zAVq7A3hvgFGVSBiPb
GvHyE3Oo8h/vfLlKTcmWK3khHsPqwQEvBw4DfWwn4Bajzku9lFg=
=WLyj
-----END PGP SIGNATURE-----

--=-+7H8HUOR/8ftKauSt5xn--
