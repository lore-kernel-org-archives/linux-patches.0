Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691B727F00
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:51:24 +0000 (UTC)
Date: Fri, 21 Jul 2023 16:51:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
	s=protonmail; t=1689958268; x=1690217468;
	bh=DkpppEg7Zj8m0V7Qrf/Ok1FMsnpB36Swy3jVx327QPQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=tceBapAei1mOX2Sg0HsjdKVrftGBKa/+Dw3p5rTg83XlidTSi04U/0KdxoRQdjuC5
	 v8B86qhhQX75J38Iply8XeanuioFrvPAR+jeQT817f8wE2R4ls84afD+7NWdgVJTtX
	 XhKyX4dxFAdVdYmBdZM/cOcXqK+9cJkOgM6AgYcQ=
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
From: Thomas Backlund <tmb@tmb.nu>
Cc: patches@lists.linux.dev, =?utf-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, "Pelloux-Prayer, Pierre-Eric" <Pierre-eric.Pelloux-prayer@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Pelloux-Prayer@vger.kernel.org
Subject: Re: [PATCH 6.4 213/292] drm/ttm: never consider pinned BOs for eviction&swap
Message-ID: <ccf59286-1698-3f02-e472-edda5208c58d@tmb.nu>
Feedback-ID: 19711308:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Den 2023-07-21 kl. 19:05, skrev Greg Kroah-Hartman:
> From: Christian K=C3=B6nig <christian.koenig@amd.com>
>=20
> commit a2848d08742c8e8494675892c02c0d22acbe3cf8 upstream.
>=20
> There is a small window where we have already incremented the pin count
> but not yet moved the bo from the lru to the pinned list.
>=20
> Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> Reported-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.=
com>
> Tested-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.co=
m>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> Link: https://patchwork.freedesktop.org/patch/msgid/20230707120826.3701-1=
-christian.koenig@amd.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/ttm/ttm_bo.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>=20
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -517,6 +517,12 @@ static bool ttm_bo_evict_swapout_allowab
>   {
>   =09bool ret =3D false;
>  =20
> +=09if (bo->pin_count) {
> +=09=09*locked =3D false;
> +=09=09*busy =3D false;
> +=09=09return false;
> +=09}
> +
>   =09if (bo->base.resv =3D=3D ctx->resv) {
>   =09=09dma_resv_assert_held(bo->base.resv);
>   =09=09if (ctx->allow_res_evict)
>=20


This one will trigger GPF and needs a follow-up fix that is not upstream=20
yet:
https://patchwork.freedesktop.org/patch/547897/

as reported on LKML in thread:
[bug/bisected] commit a2848d08742c8e8494675892c02c0d22acbe3cf8 cause=20
general protection fault, probably for non-canonical address=20
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI

--
Thomas



