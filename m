Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981344C8C68
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671814; cv=none; b=qtbXCA9NDmnDZsJgdJgWz++bO1wLVbd4ekS5HQu5ukIRgtqYZvGNnrr5BD2772orUmKsn62JbyamP2Pw8mOM3dwFD+cDMpcecesWNgq2u5X71sIDjnto6+acMrRPU/j9b1H53T/JPOijl3O3rMP9uRn7utLFr5JttzKkg8HNvB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671814; c=relaxed/simple;
	bh=vPUPe34SO2JglEZiysxYUWLmntqyQV9Hk8YwVJOfXdg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oGcVCnWov6z0I8lZRp/mWyW1ylyr/t1UfPCy+a8dlX8qcppcDYum2Q02UxZyP1bS8IXXS7npEvTd6iaQ3SKxSdmuWUTSL5NeZBIh3XHNLykbwChshjWyoLTRiURYOdtOwC2sRmreIfDnZgCEwfdWM+kK45yvBp7tC1ZCqaS2Yy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=O+YQQlZ2; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="O+YQQlZ2"
Message-ID: <327bfd74accc71d7f125adef80d8c975b3d08ea8.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1789671810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OOTpwc8sL40iqA8cZ/0F1iUmrFBEI7CMvETPWiGXU74=;
	b=O+YQQlZ2osCMkzf1x1BF7VOlv+O5oD9FuFqYli6pvOBXAuz0fTBQMJZ6QaZqOirS8LLfc9
	45U7YTs6IVwH9YEnU3W8lczvO8vKQDc1UqUu2JpNEKzF92fWiY8fIUFxjzGq7lfFGQKIHb
	cwAuz1Siw5HZNSjbyNZoYvULFSndxvk=
Subject: Re: [PATCH 7.2 439/733] sunvdc: unmap LDC cookies when the
 descriptor send fails
From: Stian Halseth <stian@itx.no>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, John Paul Adrian Glaubitz
	 <glaubitz@physik.fu-berlin.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin
	 <sashal@kernel.org>
Date: Thu, 17 Sep 2026 21:03:28 +0200
In-Reply-To: <20260917151402.800394062@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
	 <20260917151402.800394062@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iEgpSDOHJEb5gehGqf/+"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0


--=-iEgpSDOHJEb5gehGqf/+
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

No objection to this patch, but please also queue its companion

  5067d4ba7139 ("sunvdc: fix -EIO issue due to lack of retries")

which was applied to mainline together with this one. The same
applies to the 6.18 and 6.12 queues, which carry this patch as well.

With both applied, the stable trees match mainline behavior.

Order matters: 0c6da21fa35e must go first (it already is, in the
queues).

Best regards
Stian Halseth


On Thu, 2026-09-17 at 16:12 +0100, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.=A0 If anyone has any objections, please let me
> know.
>=20
> ------------------
>=20
> From: Stian Halseth <stian@itx.no>
>=20
> [ Upstream commit 0c6da21fa35e03fc74f09895433ccd6d4a9c3530 ]
>=20
> __send_request() maps the request's pages into the LDC channel's map
> table (ldc_map_sg()), fills in the descriptor and marks it
> VIO_DESC_READY before ringing the doorbell via __vdc_tx_trigger().
> When the trigger fails, the error path only prints a message: the
> descriptor stays READY and the cookies are never unmapped. The
> mapping is normally released in vdc_end_one() when the peer completes
> the descriptor - but a descriptor whose doorbell was never sent will
> never complete, and since dr->prod is not advanced on failure, the
> reset path (vdc_requeue_inflight(), which walks [cons, prod)) never
> visits it either. The map table entries are leaked permanently.
>=20
> Since commit a11f6ca9aef9 ("sunvdc: Do not spin in an infinite loop
> when vio_ldc_send() returns EAGAIN") trigger failures occur in
> practice under load, so every resulting I/O error also leaks one
> request's worth of entries from the fixed-size (8192 entries per
> channel) map table. Because the allocator hands out contiguous
> ranges, fragmentation makes large multi-segment requests fail first
> as the table drains, until ldc_map_sg() fails permanently and the
> disk is dead until reboot.
>=20
> It also makes any retry-based recovery unusable: requeuing the
> request on -EAGAIN remaps the pages on every attempt, overwriting
> desc->cookies and orphaning the previous mapping, so the table
> drains at the retry rate. This is the memory exhaustion observed
> when the requeue approach was first tested in October 2025.
>=20
> Roll back on failure: unmap the cookies, mark the descriptor FREE
> again and clear the request entry. If the trigger failed with
> -ENOTCONN, __vdc_tx_trigger() has already reset the port, which
> tears down and reallocates both the dring and the LDC channel
> including its map table - nothing to roll back, and the stale
> descriptor must not be touched.
>=20
> Fixes: a11f6ca9aef9 ("sunvdc: Do not spin in an infinite loop when
> vio_ldc_send() returns EAGAIN")
> Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Link: https://github.com/sparclinux/issues/issues/2
> Signed-off-by: Stian Halseth <stian@itx.no>
> Link: https://patch.msgid.link/20260901173947.3292110-2-stian@itx.no
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =A0drivers/block/sunvdc.c | 17 +++++++++++++++++
> =A01 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
> index 020bd9f1a7b6a..24ad56536ed60 100644
> --- a/drivers/block/sunvdc.c
> +++ b/drivers/block/sunvdc.c
> @@ -525,6 +525,23 @@ static int __send_request(struct request *req)
> =A0 err =3D __vdc_tx_trigger(port);
> =A0 if (err < 0) {
> =A0 printk(KERN_ERR PFX "vdc_tx_trigger() failure, err=3D%d\n", err);
> + /*
> + * If the port was reset (-ENOTCONN), the dring and the
> + * LDC channel including all of its mappings are already
> + * torn down and reallocated - there is nothing to undo
> + * and @desc must not be touched.
> + *
> + * For any other failure the descriptor was never handed
> + * to the peer: unmap the cookies and free the descriptor
> + * again, so that a later retry of the request does not
> + * leak LDC map table entries.
> + */
> + if (err !=3D -ENOTCONN) {
> + ldc_unmap(port->vio.lp, desc->cookies,
> + =A0 desc->ncookies);
> + desc->hdr.state =3D VIO_DESC_FREE;
> + rqe->req =3D NULL;
> + }
> =A0 } else {
> =A0 port->req_id++;
> =A0 dr->prod =3D vio_dring_next(dr, dr->prod);

--=-iEgpSDOHJEb5gehGqf/+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCaqw5gAAKCRDoeAEuJe36
VkZ+AQCdkxnziux63ZajXJyy2EPy0V67BLpY53DeJ1IeWT9+lQEA1VNAn4xIT79/
QfxQ8KtAq+xtcM36tW3Zl8bdBzvJhA0=
=Pfpi
-----END PGP SIGNATURE-----

--=-iEgpSDOHJEb5gehGqf/+--
