Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C01C946C;
	Mon, 29 Apr 2024 21:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.217.213.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714426858; cv=none; b=b8O+E+kzaii61ySk546KkRwGwHlfttL0jUtx4fo5qn3Oh7NoQacBQ26i34T7TD0u9qzaMrn5KMM89LmpFACDlus3pO09EW9uVoRo+5HNNyIci92pcVEM9M9ciSSYdWG2BSj/YZ3f92Zsk6dvwe1M0K5UUvmV//upfGgqrfLPFtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714426858; c=relaxed/simple;
	bh=dWUicLAVHgPizD3w58CSDc00SK7yVM//HqDvYPcjH2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBHXlaonfduPYhl+qFodM8meQTSOayZUcYZLIzWshlY4YU0F+q04Z5lAAwAbNlGoR+V7rOCrtustQ9+MoySVhbAY5IbkVm51ahyAjUJ3X8aXr9Of80ATZS+MtpFZXpuhhO9Cr79Pt/Lcn2Mz1xVOUdndsXePnWHx72Vn5lXSLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=95.217.213.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from 213.219.156.63.adsl.dyn.edpnet.net ([213.219.156.63] helo=deadeye)
	by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ben@decadent.org.uk>)
	id 1s1Yk2-00068b-0u; Mon, 29 Apr 2024 23:40:54 +0200
Received: from ben by deadeye with local (Exim 4.97)
	(envelope-from <ben@decadent.org.uk>)
	id 1s1Yk1-00000001wKo-1fnz;
	Mon, 29 Apr 2024 23:40:53 +0200
Date: Mon, 29 Apr 2024 23:40:53 +0200
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 4.19] Revert "loop: Remove sector_t truncation checks"
Message-ID: <ZjAT5UeQ8fc7CY0w@decadent.org.uk>
References: <496c59ccd7eefd9cd27f6454f6271f96e66f1da7.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F3OOQ5E1epQDIInv"
Content-Disposition: inline
In-Reply-To: <496c59ccd7eefd9cd27f6454f6271f96e66f1da7.camel@decadent.org.uk>
X-SA-Exim-Connect-IP: 213.219.156.63
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--F3OOQ5E1epQDIInv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This reverts commit f92a3b0d003b9f7eb1f452598966a08802183f47, which
was commit 083a6a50783ef54256eec3499e6575237e0e3d53 upstream.  In 4.19
there is still an option to use 32-bit sector_t on 32-bit
architectures, so we need to keep checking for truncation.

Since loop_set_status() was refactored by subsequent patches, this
reintroduces its truncation check in loop_set_status_from_info()
instead.

I tested that the loop ioctl operations have the expected behaviour on
x86_64, x86_32 with CONFIG_LBDAF=3Dy, and (the special case) x86_32 with
CONFIG_LBDAF=3Dn.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/loop.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6050b039e4d2..860dac8b3f9a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -243,12 +243,16 @@ static void loop_set_size(struct loop_device *lo, lof=
f_t size)
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 }
=20
-static void
+static int
 figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
 	loff_t size =3D get_size(offset, sizelimit, lo->lo_backing_file);
+	sector_t x =3D (sector_t)size;
=20
+	if (unlikely((loff_t)x !=3D size))
+		return -EFBIG;
 	loop_set_size(lo, size);
+	return 0;
 }
=20
 static inline int
@@ -996,7 +1000,10 @@ static int loop_set_fd(struct loop_device *lo, fmode_=
t mode,
 	    !file->f_op->write_iter)
 		lo_flags |=3D LO_FLAGS_READ_ONLY;
=20
+	error =3D -EFBIG;
 	size =3D get_loop_size(lo, file);
+	if ((loff_t)(sector_t)size !=3D size)
+		goto out_unlock;
=20
 	error =3D loop_prepare_queue(lo);
 	if (error)
@@ -1246,6 +1253,7 @@ loop_set_status_from_info(struct loop_device *lo,
 	int err;
 	struct loop_func_table *xfer;
 	kuid_t uid =3D current_uid();
+	loff_t new_size;
=20
 	if ((unsigned int) info->lo_encrypt_key_size > LO_KEY_SIZE)
 		return -EINVAL;
@@ -1273,6 +1281,11 @@ loop_set_status_from_info(struct loop_device *lo,
 	if (info->lo_offset > LLONG_MAX || info->lo_sizelimit > LLONG_MAX)
 		return -EOVERFLOW;
=20
+	new_size =3D get_size(info->lo_offset, info->lo_sizelimit,
+			    lo->lo_backing_file);
+	if ((loff_t)(sector_t)new_size !=3D new_size)
+		return -EFBIG;
+
 	lo->lo_offset =3D info->lo_offset;
 	lo->lo_sizelimit =3D info->lo_sizelimit;
=20
@@ -1531,9 +1544,7 @@ static int loop_set_capacity(struct loop_device *lo)
 	if (unlikely(lo->lo_state !=3D Lo_bound))
 		return -ENXIO;
=20
-	figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
-
-	return 0;
+	return figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 }
=20
 static int loop_set_dio(struct loop_device *lo, unsigned long arg)

--F3OOQ5E1epQDIInv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmYwE+UACgkQ57/I7JWG
EQno5Q//SoYi/r+qQ/Bdus8y9mTBdIsiJf282Hcop9lneUh79BRorg9aN71Pf+MF
R1yXyROjTxaPTN/bQj3GIKbMGs//igC8dTMg/INwAusZP+zT/UbY5aKGt4N+gGWH
Dbsozs/xHYYIRJAKCG1xxhRwFh5d2RIe7CQEgNAqM8kloGm7SICsN7zXQ0R2QYgh
WMY6RRzvfFK7rbWqV6rZhMWYUCur/LZfMcXvaOA2k9veljPK+MQn5qpSAcBNBThr
P8r6Nz7JB23MFYw5FmZRjdfpu2JmNyNCNK6eQhn1T6bngxrEhuQraZdE2m8SpwmG
n/Q0CQ7oO0X5nmuLk8jg/x36DOD383BLcECfm9JbDWbC8OfesasJCUP++L/+iS9N
6yZUPOg0EegIGNF29R6vUucIO9bmDGCGMVt/A/PXXn7AUbSb38Pr+ErvBEVrdmHE
+v8vd62f1+fJ3EJDT49wpTinpXcyqrFIkJcgkTt+j/WExLLCCky99JXJ5vgm51Dn
f6kDMfq0pGRu/9Ytv9oZ9lkw2Pz7l9kfDFds8LEFbsAavvgiPi0YaJVHvmDNroKP
0HHiz/L9awc07nQNOyR9qLSFkx2DTp7tXtIEnHLSwPx7Y0T+F0XmhA613rAOKZvx
Mi0aHHTHR/6z2dznkDJlYXJOC2mOi7n19ffcAo+5ddw+A3wNwQI=
=NjXM
-----END PGP SIGNATURE-----

--F3OOQ5E1epQDIInv--
