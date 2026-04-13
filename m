Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9403C1BBBE5;
	Mon, 13 Apr 2026 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112679; cv=none; b=iWMiY6Qa1FB68NrXli0FezjqrYoE/kJcTFM+F9YmT7Pu4KvuHfTj9NVQyBd1lAGC/p7Dy3TnanRtsgZ1JzM9crhIUg/Aior7XAel2vWWGpYYJ4Lg6jw3sVag1V2iIr8P7KJb5XVpqhn/jgaMfBg4oxYajF39B5rvWjZD2jmFL2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112679; c=relaxed/simple;
	bh=3wUS8NAjFIBA9OMbfU/MSZWkJIP930o8FpE7jwMWBDc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mm9xkz0oxMnYzZNZea8UuG9ltLArJl2n4CyJZ/YQIgCkMlDB/dp4poAgIm5CrcRb+T4h+luKsi44tU1wlkiPezovil4pNgPhJVznOq7Nx1+JZZ/F6h2hquR/2DtPOlVvwG0Iv5TSPyiqjdXKoGoN7tJkDR3u2eTZ8zoZDiJPQiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCO2d-004mx4-2I;
	Mon, 13 Apr 2026 20:37:54 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCO2b-00000002gyZ-3hPH;
	Mon, 13 Apr 2026 22:37:53 +0200
Message-ID: <d71f28ba9093b1cc66ebdea548a5698cb325d583.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 420/491] mm/hugetlb: fix copy_hugetlb_page_range()
 to use ->pt_share_count
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jane Chu <jane.chu@oracle.com>, Harry Yoo	
 <harry.yoo@oracle.com>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand	 <david@redhat.com>, Jann Horn <jannh@google.com>, Liu Shixin	
 <liushixin2@huawei.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton
	 <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>,
  Sasha Levin <sashal@kernel.org>
Date: Mon, 13 Apr 2026 22:37:53 +0200
In-Reply-To: <20260413155834.749968232@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155834.749968232@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-d0D9LrALplPqKbRdASb7"
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


--=-d0D9LrALplPqKbRdASb7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jane Chu <jane.chu@oracle.com>

This one was commit 14967a9c7d247841b0312c48dcf8cd29e55a4cc8 upstream.

Ben.

> commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
> count") introduced ->pt_share_count dedicated to hugetlb PMD share count
> tracking, but omitted fixing copy_hugetlb_page_range(), leaving the
> function relying on page_count() for tracking that no longer works.
>=20
> When lazy page table copy for hugetlb is disabled, that is, revert commit
> bcd51a3c679d ("hugetlb: lazy page table copies in fork()") fork()'ing wit=
h
> hugetlb PMD sharing quickly lockup -
>=20
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
> There are two options to resolve the potential latent issue:
>   1. warn against PMD sharing in copy_hugetlb_page_range(),
>   2. fix it.
> This patch opts for the second option.
> While at it, simplify the comment, the details are not actually relevant
> anymore.
>=20
> Link: https://lkml.kernel.org/r/20250916004520.1604530-1-jane.chu@oracle.=
com
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared coun=
t")
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> (cherry picked from commit 14967a9c7d247841b0312c48dcf8cd29e55a4cc8)
> [ David: We don't have ptdesc and the wrappers, so work directly on the
>   page->pt_share_count. CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING is still
>   called CONFIG_ARCH_WANT_HUGE_PMD_SHARE. ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  mm/hugetlb.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a2cab8f2190f8..8fa34032bc173 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3865,16 +3865,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst=
, struct mm_struct *src,
>  			break;
>  		}
> =20
> -		/*
> -		 * If the pagetables are shared don't copy or take references.
> -		 *
> -		 * dst_pte =3D=3D src_pte is the common case of src/dest sharing.
> -		 * However, src could have 'unshared' and dst shares with
> -		 * another vma. So page_count of ptep page is checked instead
> -		 * to reliably determine whether pte is shared.
> -		 */
> -		if (page_count(virt_to_page(dst_pte)) > 1)
> +#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
> +		/* If the pagetables are shared, there is nothing to do */
> +		if (atomic_read(&virt_to_page(dst_pte)->pt_share_count))
>  			continue;
> +#endif
> =20
>  		dst_ptl =3D huge_pte_lock(h, dst, dst_pte);
>  		src_ptl =3D huge_pte_lockptr(h, src, src_pte);

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-d0D9LrALplPqKbRdASb7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmndVCEACgkQ57/I7JWG
EQnEbg/+OrlC6tYMf/pZXeEZSkzUqXelCuPxBtugLx/C/2Ea7d4f6U0IJju91zeE
YZWoGckWH8SxqwjKY0MKpuCIREv08jC1IDn1DGnh3iCeJFnbmvsznITJf5cdHzCZ
l+YQ5QfrVcco3Kg0uf5CMaP6UTqOLgncHxkamxLGa8Y5jDlmBgQbjUeAWwxuUGMd
g5vNEb3wIg74dck/MDesibsb3mFR8vtDPArtZ4sqTQzNxGV0ijX5LKMOWb7j1o0d
1jJOY7MJ6zTaXJNE5OTFQ676rCkH+LILbnCPyZx8cx4VKbJZOafWYKy5wdRb6og2
9eUbohjpHJOVHOd5ObBgk7bRp36CkbNSezcCndDx3pFNFCYzGNLveHhJQ+d1zRdb
hjY7aqA4VcxGwGcESnJ9mF7js1sScIUbbrOuXrn8PX2g1Ya5EuJ+A5s+KQ/KL2ZT
Fx1ZErs6qkYQstbCDoyt4h8ofLdC+iWw60QkG5R8ZCozu+J0arfEdL2srw4uAy6T
Wx0CKj1AxxOP0kesqlZRdui7Dsvf53cAyhClfrD+sf1DHUCCeTl8zopsWgUKDEQx
WfIXfyggMKrhnS18TstXv9cgw5WacDtwWKq8ynnPk6latQrkto5lKdEa+QBrF8mC
E8MrDDu7Oz08iCU4lLwk8jobkepELQV/A+w2kQud6RGXsbpTtYo=
=u7oz
-----END PGP SIGNATURE-----

--=-d0D9LrALplPqKbRdASb7--
