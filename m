Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EBA23E25B;
	Thu, 25 Jun 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407016; cv=none; b=f19BIrT9b61orhfC7Hh5xJGLPSsJkXyi2AZjsB1uJx+Wk6WjsXk3FAcE6ep/KeGNK1YSmD8qbVhNC6s6P7jW1bJg3cLGutPHat3O0TP4w6xxHuZ4F83eE1d8CpSvqnb6Vcs22vcvc/buAVovRx+9W/v4eNZHqiWn1wuu1UDmjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407016; c=relaxed/simple;
	bh=TkaC+ITyc5ECGcY11xX9NJOyBuFYLfP2h/nqfbyS8KM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jh51cb02wJsbPt/itLSPdtp00yF4zRNZTaPIn+RIH7wblJUre7QlcxOm/wHuv2GX0sskqjX9egpikOXzdZgbPNL+IFd8IFtjETJ0t6Xnlpi6WwaX0H5UVJk7aTXt+2XoWLPdgx3qpefOhqhGnB0/BXFk7GKZSQPgPon4jkT2SY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcnU5-004JTU-0c;
	Thu, 25 Jun 2026 17:03:25 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcnU3-00000008Sti-30x4;
	Thu, 25 Jun 2026 19:03:23 +0200
Message-ID: <0e31e18e9567e8d58fbb8e06955c3ed8e5a120d3.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 431/522] cgroup/cpuset: Reset DL migration state on
 can_attach() failure
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Guopeng Zhang <zhangguopeng@kylinos.cn>, Tejun
 Heo	 <tj@kernel.org>, Chen Ridong <chenridong@huaweicloud.com>, Waiman Long
	 <longman@redhat.com>, Sasha Levin <sashal@kernel.org>
Date: Thu, 25 Jun 2026 19:03:18 +0200
In-Reply-To: <20260616145146.132165243@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145146.132165243@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MaYQKXGlI/qt01T47OJK"
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


--=-MaYQKXGlI/qt01T47OJK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:29 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>=20
> [ Upstream commit 4a39eda5fdd867fc39f3c039714dd432cee00268 ]
>=20
> cpuset_can_attach() accumulates temporary SCHED_DEADLINE migration
> state in the destination cpuset while walking the taskset.
[...]
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2579,16 +2579,13 @@ static int cpuset_can_attach(struct cgro
>  		int cpu =3D cpumask_any_and(cpu_active_mask, cs->effective_cpus);
> =20
>  		if (unlikely(cpu >=3D nr_cpu_ids)) {
> -			reset_migrate_dl_data(cs);
>  			ret =3D -EINVAL;
>  			goto out_unlock;
>  		}
> =20
>  		ret =3D dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
> -		if (ret) {
> -			reset_migrate_dl_data(cs);
> +		if (ret)
>  			goto out_unlock;
> -		}
>  	}
> =20
>  out_success:
> @@ -3401,7 +3398,10 @@ static int cpuset_can_fork(struct task_s

In this backport the second hunk is being applied to the wrong function!
The backport to 6.6 has the same problem.

Ben.

>  	 * changes which zero cpus/mems_allowed.
>  	 */
>  	cs->attach_in_progress++;
> +
>  out_unlock:
> +	if (ret)
> +		reset_migrate_dl_data(cs);
>  	mutex_unlock(&cpuset_mutex);
>  	return ret;
>  }
>=20
>=20

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-MaYQKXGlI/qt01T47OJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo9X1YACgkQ57/I7JWG
EQm1IBAAyTPz8RlfmKVe8sazTi0W6JmbsxE0aONe892BrngEcAz0g2zEr+OIkgHN
vh1p7udtSSTGT9iy5SqAu/N+PUd/vlGWb/qbzLHat74HdsxfdcS3iV2qPBivEwNn
INA7DxD83LCx+Hvz/Dmz4dy5G4tXqpRZLhWLAnCTqoMSeXpaW65XfddJnAPLPXl6
Y+V/tvyLOwRa9F+ZJUlaUIQ73JlzS7fApzj4wPz59gkyDrwzv3+otM9WY52zmwtx
gzCaKUK8epodzNBrKFdXBN2EbzUJu/cihPreFPIx5KcT3nWkwC863HOlAxv+EXsX
rgLcDCjEI6Xi3VozaTrQkYKEPIQRHL6Y0vMFF8Nc+nii6yS1566Uj5PzmkK0ybch
ZYsSz7rs6fl+HFD9iOPKmhqM9mQ4WNRtqJZ63phqUTceQwp6kBrJd+sJ+p4+78HQ
1UhoSeAnlCSJnu67gdrUbfga9rKi9ZbhGn4de+B5GEAsAreehG0+Bx2a2IPkMham
oLY7XBLLl1aHJQ9qpciqdhjliXoFDDdMl12Rz9PkwG6eMPu+8rTujtY4qPrhpcnB
PjITP0JQlbSLegJWwd2Q6YiC8ptseGuFB2z4cCTExgfh0pAP12lxOyzo+CtUDoFj
O2MluhcBM99WLEXTE1rrbDfPUqUSxcU8qt4a0sveKq/Ipuj1HOo=
=SrAn
-----END PGP SIGNATURE-----

--=-MaYQKXGlI/qt01T47OJK--
