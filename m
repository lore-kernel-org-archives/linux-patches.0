Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0F71E376C;
	Sat, 17 Jan 2026 20:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768682859; cv=none; b=Q85KJpWSOaovhpxZ90SKl7nNJw1Tn5tq7H/P3wGM/nLkLX0kIcbJuqEk45poq3BNGto5icSiNdZLclCT2JYFi62y5L2N1he2W0Fn4cK5SnoTf73cfsKPaW80mQpjuc+vYuWeZ1r+H51zePwRdWp6E09+uT/LF+EeiSBXxzqtzAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768682859; c=relaxed/simple;
	bh=7OX75PFzf+BTjsQfDek3IFcJ2pBrarnX5OL2lA0VGyc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V9hbb1F5Q2wQ5j08wfLoPeDxxvhDqJ/gO+bk9uElY0Si9eIFdlfWWh67Zjga7Jo6Jhmm1XVHaoQYOER4Sc3EECdK+W9f0uW5z/XY9KzfGKde1wcvvh+quy2Laj2vRZqKHfBKwupqYGkSE3Zo6M9slBI42n5hdxofiAI25/vXuOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhDCr-0011m2-2b;
	Sat, 17 Jan 2026 20:47:36 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhDCp-00000000kEH-1Dn9;
	Sat, 17 Jan 2026 21:47:35 +0100
Message-ID: <21f26a1c5d9b0ddf0320a13bf3625642d506b11d.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 219/451] nvme-fc: dont hold rport lock when putting
 ctrl
From: Ben Hutchings <ben@decadent.org.uk>
To: Daniel Wagner <wagi@kernel.org>, Keith Busch <kbusch@kernel.org>
Cc: patches@lists.linux.dev, Justin Tee <justin.tee@broadcom.com>, Christoph
 Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Sat, 17 Jan 2026 21:47:30 +0100
In-Reply-To: <20260115164238.821426188@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164238.821426188@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gy70/NOqcAjtTcUVw+Al"
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


--=-gy70/NOqcAjtTcUVw+Al
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:47 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Daniel Wagner <wagi@kernel.org>
>=20
> [ Upstream commit b71cbcf7d170e51148d5467820ae8a72febcb651 ]
>=20
> nvme_fc_ctrl_put can acquire the rport lock when freeing the
> ctrl object:
>=20
> nvme_fc_ctrl_put
>   nvme_fc_ctrl_free
>     spin_lock_irqsave(rport->lock)
>=20
> Thus we can't hold the rport lock when calling nvme_fc_ctrl_put.
>=20
> Justin suggested use the safe list iterator variant because
> nvme_fc_ctrl_put will also modify the rport->list.

The "safe" list iterator macros do protect against deletion of the
current node within the loop body, but they assume the next node won't
also be deleted.

[...]
> -	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
> +	list_for_each_entry_safe(ctrl, tmp, &rport->ctrl_list, ctrl_list) {
>  		if (!nvme_fc_ctrl_get(ctrl))
>  			continue;
>  		spin_lock(&ctrl->lock);
> @@ -1520,7 +1520,9 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rpor=
t,
>  		if (ret)
>  			/* leave the ctrl get reference */
>  			break;
> +		spin_unlock_irqrestore(&rport->lock, flags);
>  		nvme_fc_ctrl_put(ctrl);
> +		spin_lock_irqsave(&rport->lock, flags);

Does anything prevent the next node (*tmp) being removed by another
thread while the lock is dropped here?

Ben.

>  	}
> =20
>  	spin_unlock_irqrestore(&rport->lock, flags);

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-gy70/NOqcAjtTcUVw+Al
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmlr9WIACgkQ57/I7JWG
EQmjxhAAx0DEYyEweE+d5AXtH4VpSeJs49PHjeRsdfikP2xseGnU8jPciPSZSAmA
dtKrLUHBa9xejUoJjsuU7GkM946a4bmep5sBhhgFdEiSy6JSNTYSlv/PgMpuL9of
6AkDuyZkMrde47cxdZciQvJvwt1IRtjmZ6w6v8indj9nzX2qsc5GjDyyOTpSHk/e
9SbZusE/X6eMO1iH3o9DJgOo2gZghNfaTj/SYc2VUtffaUyxGtbo0cyvfGU0RLLt
oUmUqG7sa43Z9ZVIW597/6Ri6Y2uWqYqLXRyAEhw9o6iFNBdx97wjWQi9U8RT3ju
jVmsRzdhywIG8KJX6/Ugy5V2WUByAtWZUxx/kZ5hsg2XHeirKmd4gQLLh2KKv2Uy
MZv1QOk/pLEi0NmoLE9YCoMt5XXdgYtSGRr9/hgMS4y68WW6EF7n/VvcmpZTw5md
j+N9ZZNQaUFoBWprAV8WcInMRy3ALim5KCPYP3JIrwIh8/sEgmkNdaRYn9yEPz8c
xPbM8n/vhgabFtqLfAcFJYcumBVMa64LXLb4sbYPkAh0/mCgGuXMPpL38OYfdsz2
MTs68CwDDyk3tgq3Iz4t3GvKD2cXfk/sGZpIsr3KTHspTvKvjhhSRuKFE6cqgmzT
6v+Nuvc+/RzQfUVn6Yh728ncKHnPLr4lHEatXNuB5JnSa4ab0mA=
=1AEq
-----END PGP SIGNATURE-----

--=-gy70/NOqcAjtTcUVw+Al--
