Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E442928469F;
	Sun, 19 Apr 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776613565; cv=none; b=hYH1d9PIdlKXoTD/rJAThCIG9pe0Pv/LJhI/aTHGL0vhIuCPNLBNf0ylGpWPUa1tNw57O18UirdzB1xUXQdEdE43OHYpNRfac2WgQOkv2VBW1ELvWR/rZbHfNgaRL1CK/Yzh9SdKuurb7k06peoBEYPItiO5FE7Y/8cAV9fFP2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776613565; c=relaxed/simple;
	bh=RkaoqqRXVDD/vZ3nFXaEIpRzSA+WaJCvs7g7BQc65GY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LmJZKUXWVcgrkq+FTFgDgq3SpAEyPcErCzXERZoyCi6zQ8NjCVCRuir4WqXvMl1y6/yl2iqq4mRtJxTdSQ8Dob5IhCduYBh0ByOfsyaoSNWcuz92USapxvZjpKbRJlpbQjeFmFqxh6foOqNGNbbMUBvY/rXgAnDDVHXWBASupJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wEULM-005WxP-05;
	Sun, 19 Apr 2026 15:45:55 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wEULK-00000004sR3-1cJ6;
	Sun, 19 Apr 2026 17:45:54 +0200
Message-ID: <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, 
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Date: Sun, 19 Apr 2026 17:45:49 +0200
In-Reply-To: <20260413155837.438151458@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155837.438151458@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kEJna/SwI3grbcgqB86B"
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


--=-kEJna/SwI3grbcgqB86B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:02 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jens Axboe <axboe@kernel.dk>
>=20
> Commit 84230ad2d2afbf0c44c32967e525c0ad92e26b4e upstream.
>=20
> When the core of io_uring was updated to handle completions
> consistently and with fixed return codes, the POLL_REMOVE opcode
> with updates got slightly broken. If a POLL_ADD is pending and
> then POLL_REMOVE is used to update the events of that request, if that
> update causes the POLL_ADD to now trigger, then that completion is lost
> and a CQE is never posted.
>=20
> Additionally, ensure that if an update does cause an existing POLL_ADD
> to complete, that the completion value isn't always overwritten with
> -ECANCELED. For that case, whatever io_poll_add() set the value to
> should just be retained.

This backport is very different from the upstream version, and I have
some questions about that (inline below).

> Cc: stable@vger.kernel.org
> Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
> Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
> Tested-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  io_uring/io_uring.c |   26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>=20
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -5980,7 +5980,7 @@ static int io_poll_add_prep(struct io_ki
>  	return 0;
>  }
> =20
> -static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
> +static int __io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_poll_iocb *poll =3D &req->poll;
>  	struct io_poll_table ipt;
> @@ -5992,11 +5992,21 @@ static int io_poll_add(struct io_kiocb *
>  	if (!ret && ipt.error)
>  		req_set_fail(req);
>  	ret =3D ret ?: ipt.error;
> -	if (ret)
> +	if (ret > 0) {
>  		__io_req_complete(req, issue_flags, ret, 0);
> +		return ret;
> +	}
>  	return 0;
>  }
> =20
> +static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	int ret;
> +
> +	ret =3D __io_poll_add(req, issue_flags);
> +	return ret < 0 ? ret : 0;

__io_poll_add() still never returns a negative result, so why is there a
check for that here?

> +}
> +
>  static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags=
)
>  {
>  	struct io_ring_ctx *ctx =3D req->ctx;
> @@ -6012,6 +6022,7 @@ static int io_poll_update(struct io_kioc
>  		ret =3D preq ? -EALREADY : -ENOENT;
>  		goto out;
>  	}
> +	preq->result =3D -ECANCELED;
>  	spin_unlock(&ctx->completion_lock);
> =20
>  	if (req->poll_update.update_events || req->poll_update.update_user_data=
) {
> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>  		if (req->poll_update.update_user_data)
>  			preq->user_data =3D req->poll_update.new_user_data;
> =20
> -		ret2 =3D io_poll_add(preq, issue_flags);
> +		ret2 =3D __io_poll_add(preq, issue_flags);
>  		/* successfully updated, don't complete poll request */
>  		if (!ret2)
>  			goto out;
> +		preq->result =3D ret2;
> +
>  	}
> -	req_set_fail(preq);
> -	io_req_complete(preq, -ECANCELED);
> +	if (preq->result < 0)
> +		req_set_fail(preq);
> +	io_req_complete(preq, preq->result);

If __io_poll_add() returned an events mask then it completed preq, but
then we also complete preq here.  Is that really correct?

Ben.

>  out:
> -	if (ret < 0)
> -		req_set_fail(req);
>  	/* complete update request, we're done with it */
>  	io_req_complete(req, ret);
>  	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
>=20
>=20

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable
from a rigged demo.

--=-kEJna/SwI3grbcgqB86B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnk+K0ACgkQ57/I7JWG
EQlcTBAAx2XEzGqHBT9ChlTEtCa6B0rpSy5AGkRqkMvM3/YSWnxV3d703E4Lgq9U
dakkOwWeohsv283TOMOV9L5ZqwhEnq+77Yqnse/OoAcO/nAim/OLVAzPd+/RVc6O
jq7tkWQVPZ5XeaDRZ6VmhCyObM/3e1vBwwcUjSQRpBVDgWP7U9A+PtTXp2be7Jib
dtQN78xd6rfW7kjsF2qmJNFWQ2GCpN4EbtmlKvy0DdGANzhqSMRaa7mwOFXgjixS
vIipJW65ZSELU3yQO7XBTE9ppl0MXdfHgxBqvOENYF9CKcHDJqSazP45iKuekGth
V5CTN29W6VOlwLyrZcXaCkPkMiRGDkAq9BwZ/TXMDGRyU054St3Ky8BScX3zkyva
aAzdPT07C8W/7vzmqQ8KqJIfzGIfZ9iE++FEhvzZjSRhq6Vw8sU+CNxlPK6T/zI6
8KwxnYX99kO3Ju4AQpboebY5MaMyQhc1I6PGAB3amChTWP7WIUqA82wHkqi0l9GS
iAVpicLEtrXY8jxNRilBcOvOmTMcvuphWd24fWBHifINHbCJyQYC/ViINTUsDZdZ
UTFNeMkCgasmB0pWEoXnImUAQwGIiEnGFaOXpp7QZS3Gzd+2W/9FMPaEOHMmZMP+
hjnNeauuJuZzrs7u666i+kUEFV2/oTrjDBzN2Yj+FrcJejx2XiY=
=HRgj
-----END PGP SIGNATURE-----

--=-kEJna/SwI3grbcgqB86B--
