Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1113E32B12B;
	Sun, 31 May 2026 20:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780258456; cv=none; b=IvIb4bRGU9N8CGkeG6URzyTqXxVg4RfjfLkXPMtlj1oCiXOMDV+6L8PANNA3NHOOdG4Y20bNt86sVWGxLrcKx3ALpSrcviubf1Qmgo7vvIaEE9wR9OPUN9Vmpt3MGYe2rt8JxfUztpG27HFc3f3SnVndfIU5n6BdijlvuNrxYOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780258456; c=relaxed/simple;
	bh=10PBxLE8vh1z+Yx+PNDrgc3lS5UezaNt+zZZKiygrrM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hLqtF3eerPHit10iS2FxCJQKXRdt1ftFxdu+1w1+2KKQfksrrDHn+9feWoj6DJ/Kp00ni3XNvXIgqXHYuFBQJ8ZkSNUMohyMd7sKowopYChvflUkaM9cdE3Yy4yWvivzWLJXbn5f+4N1OFq4tasHqRCrCKyJNKEikq6e1cWPRcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTmY0-000PfP-0e;
	Sun, 31 May 2026 20:14:12 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTmXz-0000000FRLT-1dRW;
	Sun, 31 May 2026 22:14:11 +0200
Message-ID: <5903b777c7688dd17f8e4eb173361c80ea0fff46.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 177/589] KVM: nSVM: Sync NextRIP to cached vmcb12
 after VMRUN of L2
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yosry Ahmed <yosry@kernel.org>, Sean
 Christopherson <seanjc@google.com>
Date: Sun, 31 May 2026 22:14:06 +0200
In-Reply-To: <20260530160229.538712833@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160229.538712833@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3c8dqEpHifOe+gwk3EA9"
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


--=-3c8dqEpHifOe+gwk3EA9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:00 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Yosry Ahmed <yosry@kernel.org>
>=20
> commit 778d8c1b2a6ffe622ddcd3bb35b620e6e41f4da0 upstream.
>=20
> After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
> fields written by the CPU from vmcb02 to the cached vmcb12. This is
> because the cached vmcb12 is used as the authoritative copy of some of
> the controls, and is the payload when saving/restoring nested state.
>=20
> NextRIP is also written by the CPU (in some cases) after VMRUN, but is
> not sync'd to the cached vmcb12. As a result, it is corrupted after
> save/restore (replaced by the original value written by L1 on nested
> VMRUN). This could cause problems for both KVM (e.g. when injecting a
> soft IRQ) or L1 (e.g. when using NextRIP to advance RIP after emulating
> an instruction).
>=20
> Fix this by sync'ing NextRIP to the cache after VMRUN of L2, but only
> after completing interrupts (not in nested_sync_control_from_vmcb02()),
> as KVM may update NextRIP (e.g. when re-injecting a soft IRQ).
>=20
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_S=
ET_NESTED_STATE")
> CC: stable@vger.kernel.org
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> Link: https://patch.msgid.link/20260225005950.3739782-2-yosry@kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kvm/svm/svm.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3677,6 +3677,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
>  	if (is_guest_mode(vcpu))
>  		return EXIT_FASTPATH_NONE;
> =20
> +	/*
> +	 * Update the cache after completing interrupts to get an accurate
> +	 * NextRIP, e.g. when re-injecting a soft interrupt.
> +	 *
> +	 * FIXME: Rework svm_get_nested_state() to not pull data from the
> +	 *        cache (except for maybe int_ctl).
> +	 */
> +	if (is_guest_mode(vcpu))
> +		svm->nested.ctl.next_rip =3D svm->vmcb->control.next_rip;

I don't know whether this assignment would be a correct fix for 5.10,
but in this version it is unreachable because of the previous if-
statement.

Ben.

> +
>  	return svm_exit_handlers_fastpath(vcpu);
>  }
> =20
>=20
>=20

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

--=-3c8dqEpHifOe+gwk3EA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmoclo4ACgkQ57/I7JWG
EQl9SQ/+LTc6DQ9dIPl/HC7xwDogMCb7M19V+MXsDTDwRil/BYd844R7oqxcm6ho
9Z2u5H32vn1K/tObwsqy46Ou1Hw94cj46rrlJJ42tWg49Eq6oqnXqb7WXr9kJrpO
Ic7UI0wrR3W9HuoCOLHhkM0XEEelHCTFjbyRQ5GnDJDgSdfHUe5KMiX5t8XI8l8t
Jn7JRwd3UFiVIVGD53U5+lJU5axhJJ9vnkCcPpSTifi4yHOMI+Z5MiGuMwbpBxhT
m5jJJgCRTiHjrbyosn7oCnn1Uuqr737QWB0BcLsL6VGRohX2OzAkKy+M3NGDBVzJ
qNiNbddPhJkCM2jXjUEbTDkXxBMzhOJzfbkL349CL482glHzj02L2gLnzg1G5Nub
AAhjdtyqDekZZRekBAoriXm4F3I6mvfm3BhC86yu+/MDFsOJA14Iklntkngn895V
PSXWn+0USUXpfLUaEAttxyfAV5v5iYLKewCyawplCDPDhjxLcJk0H89UAwKwHiv/
9LEdpDvgE/s4+a3IYlFMu11yKqKj33Rlma9x7iXqEX2bIQvtKNCb8lC1lHhQqg8/
uV2XcsxdVi5QpdMq8VszS2aVDtseIz57ISjXHEJX9RcVNVg45iY70e374pawiJ1X
NM4gcxWRrQ+6gdtQdWY+EBfStKeSmjo6LBKrRGE6/unNr6wkuEs=
=87de
-----END PGP SIGNATURE-----

--=-3c8dqEpHifOe+gwk3EA9--
