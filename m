Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBD610785
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 21:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB4DC433D6;
	Mon, 21 Nov 2022 21:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669066537;
	bh=ME3JoFynEewzrOSy9c/B1ctbwfUDRGobuFBsXDrfdw8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=qoxS8FrV44z8YCfl3O/WSwGWeEfMrhZaleDfeKlLyy/FburDP3i2I/LH7Wf7Gzyv5
	 f94asK7C6zzNQVssQefVHv274RkO1LR0qMFPlxvep6gbuBy5YUlQLOdHWermXvcmsa
	 oLRDGu7JRKVZ3rglw6KkylEpLbjHNCuLEn1Jnvju95PohaVMggaw/qTcfH3RDk83aF
	 oZppzQSx8/NUdzmWh/2CyQLePYR8D2eM6IeUrTlwaknOgX+n6v229zr8X+6K42MDjV
	 JCVPOpIKDtS42aqMl+9o0ncZ3tV9zE++7CJEyYgB2zGvmYJn0pdeJcPWnvEgpYVlPw
	 gborMbJ9tZYnw==
Date: Mon, 21 Nov 2022 13:35:30 -0800
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>
CC: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kees Cook <keescook@chromium.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_01/12=5D_mm=2C_slab=3A_ignore_har?= =?US-ASCII?Q?dened_usercopy_parameters_when_disabled?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20221121171202.22080-2-vbabka@suse.cz>
References: <20221121171202.22080-1-vbabka@suse.cz> <20221121171202.22080-2-vbabka@suse.cz>
Message-ID: <206E0154-63A6-45CF-8E19-BD01B35AEF0B@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 21, 2022 9:11:51 AM PST, Vlastimil Babka <vbabka@suse=2Ecz> wro=
te:
>With CONFIG_HARDENED_USERCOPY not enabled, there are no
>__check_heap_object() checks happening that would use the kmem_cache
>useroffset and usersize fields=2E Yet the fields are still initialized,
>preventing merging of otherwise compatible caches=2E Thus ignore the
>values passed to cache creation and leave them zero when
>CONFIG_HARDENED_USERCOPY is disabled=2E
>
>In a quick virtme boot test, this has reduced the number of caches in
>/proc/slabinfo from 131 to 111=2E
>
>Cc: Kees Cook <keescook@chromium=2Eorg>
>Signed-off-by: Vlastimil Babka <vbabka@suse=2Ecz>
>---
> mm/slab_common=2Ec | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/mm/slab_common=2Ec b/mm/slab_common=2Ec
>index 0042fb2730d1=2E=2Ea8cb5de255fc 100644
>--- a/mm/slab_common=2Ec
>+++ b/mm/slab_common=2Ec
>@@ -317,7 +317,8 @@ kmem_cache_create_usercopy(const char *name,
> 	flags &=3D CACHE_CREATE_MASK;
>=20
> 	/* Fail closed on bad usersize of useroffset values=2E */
>-	if (WARN_ON(!usersize && useroffset) ||
>+	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
>+	    WARN_ON(!usersize && useroffset) ||
> 	    WARN_ON(size < usersize || size - usersize < useroffset))
> 		usersize =3D useroffset =3D 0;
>=20
>@@ -640,6 +641,9 @@ void __init create_boot_cache(struct kmem_cache *s, c=
onst char *name,
> 		align =3D max(align, size);
> 	s->align =3D calculate_alignment(flags, align, size);
>=20
>+	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY))
>+		useroffset =3D usersize =3D 0;
>+
> 	s->useroffset =3D useroffset;
> 	s->usersize =3D usersize;
>=20

"Always non-mergeable" is intentional here, but I do see the argument for =
not doing it under hardened-usercopy=2E

That said, if you keep this part, maybe go the full step and ifdef away us=
eroffset/usersize's struct member definition and other logic, especially fo=
r SLUB_TINY benefits, so 2 ulongs are dropped from the cache struct?

-Kees


--=20
Kees Cook
