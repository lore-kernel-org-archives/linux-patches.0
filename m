Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA7199FBF
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731086654; cv=none; b=YbO8JS1uhF+39kjQ9O5edsBBnSCmULqq12xxM/CtVXhDnSmsX6cRWgV+Lvhg7TQOGLgbVXPrzL4EFkNeIPoC3mZ3YPldyB6qVT5qlgLx7G4zmUnQyrh/WjeYjrwvU1jF1p2vyam8uuzbubFF9fKAN1QZfxLEQyqs8/x2PvLyiUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731086654; c=relaxed/simple;
	bh=p/Q3zj8qIH2ThrBRizyuweJ8R1Been3HPLb9zh0QrMM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=OX2fxqBY69fFjJ+128MLtElyhaQzM1dsHUTggJfPuozh5r+/DEMOPMKFfJVF1xv89CW4w+C6R/Kw/GQScIrtwkn+ToqEOcm3O1nPC771NSBwQ1tau1WTo1S0AHNbHQNE62MU3ws8PKpAebRWtZad7Ks1Se+/5Dsncv4uuXFUy3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=AVLtzl6M; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="AVLtzl6M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1731086640;
	bh=p/Q3zj8qIH2ThrBRizyuweJ8R1Been3HPLb9zh0QrMM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=AVLtzl6M//n8dQvjJhvkV+XDtoFL+Jt3mW3O+MrcQFjHEAVcKiN6DyjT/13Ntsvtk
	 x0tifAlUiw0qKsqxabi2rxvdgu+Fe3SoVpyjlgk9TTCHX7knzNRFQvp4lMghLulppj
	 G0v1PzYsQmMezOSMlmiuUhV7DCVht5cgYxu22tKc=
Date: Fri, 8 Nov 2024 12:23:50 -0500 (EST)
From: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas@weissschuh.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Message-ID: <f005d74e-7b35-42de-a80f-e5650e3d164d@weissschuh.net>
In-Reply-To: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org>
References: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org>
Subject: Re: [PATCH] cdx: Fix cdx_mmap_resource() after constifying attr in
 ->mmap()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <f005d74e-7b35-42de-a80f-e5650e3d164d@weissschuh.net>

Hi Nathan,

Nov 7, 2024 12:07:56 Nathan Chancellor <nathan@kernel.org>:

> Commit 94a20fb9af16 ("sysfs: treewide: constify attribute callback of
> bin_attribute::mmap()") missed updating the attr parameter of
> cdx_mmap_resource(), resulting in a build failure.
>
> =C2=A0 drivers/cdx/cdx.c: In function 'cdx_create_res_attr':
> =C2=A0 drivers/cdx/cdx.c:773:24: error: assignment to 'int (*)(struct fil=
e *, struct kobject *, const struct bin_attribute *, struct vm_area_struct =
*)' from incompatible pointer type 'int (*)(struct file *, struct kobject *=
, struct bin_attribute *, struct vm_area_struct *)' [-Wincompatible-pointer=
-types]
> =C2=A0=C2=A0=C2=A0 773 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
res_attr->mmap =3D cdx_mmap_resource;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>
> Update cdx_mmap_resource() to match, resolving the build failure.
>
> Fixes: 94a20fb9af16 ("sysfs: treewide: constify attribute callback of bin=
_attribute::mmap()")

I'm not sure about the Fixes tag.
cdx.c is not yet in mainline and this change should be folded into the cdx =
patch or the sysfs patch, depending on their order in the merge window.
I guess Greg will take care of it.

Thanks for the notification, though!

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

If it ends up as a real commit:

Reviewed-by: Thomas Wei=C3=9Fschuu <linux@weissschuh.net>

> ---
> drivers/cdx/cdx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
> index 07371cb653d356977cbd3dd99a1b848146d5a993..316bd89a95caf97163a126478=
985c52b1b596bb4 100644
> --- a/drivers/cdx/cdx.c
> +++ b/drivers/cdx/cdx.c
> @@ -707,7 +707,7 @@ static const struct vm_operations_struct cdx_phys_vm_=
ops =3D {
> =C2=A0 * Return: true on success, false otherwise.
> =C2=A0 */
> static int cdx_mmap_resource(struct file *fp, struct kobject *kobj,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct bin_attribute *attr,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 const struct bin_attribute *attr,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct vm_area_struct *vma)
> {
> =C2=A0=C2=A0=C2=A0 struct cdx_device *cdx_dev =3D to_cdx_device(kobj_to_d=
ev(kobj));
>
> ---
> base-commit: 298c2af4788ed027a42c2bab0f210219825fb5fd
> change-id: 20241107-sysfs-const-mmap-fix-cdx-1457914fe16d
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>

