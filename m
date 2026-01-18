Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0228E50095A;
	Sun, 18 Jan 2026 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768762222; cv=none; b=pokW6bPK8ka37FmZhoZc+3zN+MV8LiQrzrBgTKAs8dtJrOVKHN9DnVZAed1PAkvXHb5Ik2gi7MQJXnFsPAukqPVeDui69RHRbyMrijQQaJGU5Vz86pA4EIHcue6scubbx/5SgQRNoSYTf1rSQagF89yP6puWMumZOV8xGuBWGnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768762222; c=relaxed/simple;
	bh=wE++U4ix1sHZXa5y0lRcLp/A8MvIMpuQccfPjVr6PHU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iZflO6UrpQMqHRl/zy+e5FA+lEsmhbDvuM571vgMb6+ZfKo/P0hV9i72xpOIyZl4QowQHz7YHMI0xXm7X6s+S88r3JhEgCfXLeANh7tcdQ1B8FLkVG5Yv6iBpggf8yTBGBQAibZfeyW9iu6PQ2P0iFEQ/V1YCEEb3Q0JYkyFx2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhXqt-00194N-0a;
	Sun, 18 Jan 2026 18:50:17 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vhXqq-00000000qsh-19Kv;
	Sun, 18 Jan 2026 19:50:16 +0100
Message-ID: <ac4bdf4fd2952f95a300b027f705dddffbe54a1e.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 393/451] NFSD: NFSv4 file creation neglects setting
 ACL
From: Ben Hutchings <ben@decadent.org.uk>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: patches@lists.linux.dev, Aurelien Couderc
 <aurelien.couderc2002@gmail.com>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Date: Sun, 18 Jan 2026 19:50:11 +0100
In-Reply-To: <20260115164245.151340252@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
	 <20260115164245.151340252@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-a628iJZ2IuWGJ/zSUBkp"
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


--=-a628iJZ2IuWGJ/zSUBkp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> [ Upstream commit 913f7cf77bf14c13cfea70e89bcb6d0b22239562 ]
>=20
> An NFSv4 client that sets an ACL with a named principal during file
> creation retrieves the ACL afterwards, and finds that it is only a
> default ACL (based on the mode bits) and not the ACL that was
> requested during file creation. This violates RFC 8881 section
> 6.4.1.3: "the ACL attribute is set as given".
>=20
> The issue occurs in nfsd_create_setattr(). On 6.1.y, the check to
> determine whether nfsd_setattr() should be called is simply
> "iap->ia_valid", which only accounts for iattr changes. When only
> an ACL is present (and no iattr fields are set), nfsd_setattr() is
> skipped and the POSIX ACL is never applied to the inode.
>=20
> Subsequently, when the client retrieves the ACL, the server finds
> no POSIX ACL on the inode and returns one generated from the file's
> mode bits rather than returning the originally-specified ACL.
>=20
> Reported-by: Aurelien Couderc <aurelien.couderc2002@gmail.com>
> Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
> Cc: stable@vger.kernel.org
> [ cel: Adjust nfsd_create_setattr() instead of nfsd_attrs_valid() ]
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Would it make sense to also backport:

commit 442d27ff09a218b61020ab56387dbc508ad6bfa6
Author: Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Fri May 3 09:09:06 2024 -0400

    nfsd: set security label during create operations

?  It seems like that's fixing a similar kind of bug, and would also
make the upstream version of this apply cleanly.

Ben.

> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/nfsd/vfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1335,7 +1335,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
>  	 * Callers expect new file metadata to be committed even
>  	 * if the attributes have not changed.
>  	 */
> -	if (iap->ia_valid)
> +	if (iap->ia_valid || attrs->na_pacl || attrs->na_dpacl)
>  		status =3D nfsd_setattr(rqstp, resfhp, attrs, 0, (time64_t)0);
>  	else
>  		status =3D nfserrno(commit_metadata(resfhp));
>=20
>=20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-a628iJZ2IuWGJ/zSUBkp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmltK2MACgkQ57/I7JWG
EQnWiQ/8CypNefSG2tAmnSiFaxRfMUtN6kIJbgF7PyPSoVbrpZerXWL6fd99mAxb
e0HqdNdDEDfwLeL0l+0Rci+JANyiEy9vN0+gVieRuRGYlKEQ0mFL1lqsa4KuN5Q3
wwYnJTZPu4sGVusVYLnIQMAwaFpv40sSbAiSVx5IFcIrPtkquoY82ZeyMBNj1Fz6
Efx0Kt6qqM7iBbMhDw75RR3FPtw4ywopnHh0z3JgWPx7dE4TKP2x8mJH8BwOvzxu
nBU93uoDlTCfA4fGkGEzkjRRsHhJ3KYlpPligLavxJRZh17jMtxK3geG7DByy4Fq
29SOlJQC+JRgGnALiHbQr0DwFBbI9CszQksIhihLoP9VmXh7NOblldf5LYpRRD3h
HTJfQY7ThIGIKtFSACjtYRZMlWEl+vsdbTu/HR8vDeFb5ugJBBTvYojzJZKxe2r5
8IJX/iKLqPAKht33zqL504vAFSYuwn5OZKh0gv6wpLXbnYwiCXCE5CDYiWCrWcZn
NYj6DxrUN14AS+74TY1ZZOix///S3yQOo/UFjvSCy4h0Gk8tL7ZYSfcit4QTHPws
+UrIzBdb6cQmcbmwsZODpHWqx3xnChzE3SxqgOxt+tU8AUwAxasQoJ7kgaz4itkA
Hh4ga7hMj6ezHtaPR0MikBA1qGcVGchGTv3pdUBWZ97dCD6tn9s=
=gc7W
-----END PGP SIGNATURE-----

--=-a628iJZ2IuWGJ/zSUBkp--
