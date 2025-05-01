Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1171220E03C;
	Thu,  1 May 2025 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746091408; cv=none; b=rBGCR4Zvez46cSWPvYK58B0RXwBgh/9jPm+5RTBpUsA11+AV1IOaWLUg21yBMsE+EfL4y/fGzEjBmaF9djXXBFv+7OT/oL9hRzhIxUoi91yEsTUtT5Jk2O+JMVnof7UMzF3ufNi7uZeohyqm1DtyBWCx6uzCNZojFuK9KsVf8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746091408; c=relaxed/simple;
	bh=mEMr0h0yhTv0Vqj2KXFxJsF480NuePE1fdRFqc+606U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NeuFY1BtKP8vMtBzkCpjHOi13ZGxCBcc3fhtnpoWXoSAsK4gQojP/reqQocRwWHNy4fTJgJ1hYnmlauTUWmld3ClQpdBJe3YrJW/WvG5tDKITB+CMLgBJx3FKoXS8mjJiD5/YlIeIklRDK8SGZL/JpPZIPDm0BsWTrE3cifrH9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=WC5PUHBp; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="WC5PUHBp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1746091397;
	bh=Afd/qagLKI/fX+0RGz5E2Ib/ep+ALL7XK8CbKf8SgZ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=WC5PUHBpzf/Bq7qfABvB68s996X+KfIVkxXtnqWlzFu6ZE1F9tPrgFtZTAApIeEah
	 Td6zPENp9j3EAxeWDDIck+n9YbS/THiOkDHcW1tTj6/GFUMuFgv/YSPY92ZbiyyQLl
	 yNoKEPyWyHpDIUJD7IZtBA0mycpOVKxxpLINqk4A=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 4D8E365F64;
	Thu,  1 May 2025 05:23:16 -0400 (EDT)
Message-ID: <7249b7dfdfa5fc56d321c9b69affa17b325d1e4a.camel@xry111.site>
Subject: Re: [PATCH v2] riscv: vdso.lds.S: Do not export __vdso_getrandom
 when building a 32-bit vDSO
From: Xi Ruoyao <xry111@xry111.site>
To: Nathan Chancellor <nathan@kernel.org>, Palmer Dabbelt
 <palmer@rivosinc.com>,  Alexandre Ghiti	 <alex@ghiti.fr>
Cc: linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, Linux Kernel Functional Testing <lkft@linaro.org>
Date: Thu, 01 May 2025 17:23:14 +0800
In-Reply-To: <20250423-riscv-fix-compat_vdso-lld-v2-1-b7bbbc244501@kernel.org>
References: 
	<20250423-riscv-fix-compat_vdso-lld-v2-1-b7bbbc244501@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-04-23 at 13:03 -0700, Nathan Chancellor wrote:
> ld.lld defaults to '--no-undefined-version', which causes the compat
> vDSO for 64-bit builds and the regular vDSO for 32-bit builds to break
> after wiring up the vDSO getrandom() call because __vdso_getrandom is
> unconditionally exported, even though it is not always present.
>=20
> =C2=A0 ld.lld: error: version script assignment of 'LINUX_4.15' to symbol=
 '__vdso_getrandom' failed: symbol not defined
>=20
> Move the export of __vdso_getrandom() under an ifdef to only include it
> when CONFIG_VDSO_GETRANDOM is defined (to exclude 32-bit builds) and
> COMPAT_VDSO is not defined (to exclude the 32-bit vDSO on 64-bit builds)
> to resolve the error.
>=20
> Fixes: 89079520cef6 ("RISC-V: vDSO: Wire up getrandom() vDSO implementati=
on")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/CA+G9fYtN2ie+YtK3H9mrQ5QqrSCFGGjVbtJcfiYX=
0oHMVWMn9w@mail.gmail.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Xi Ruoyao <xry111@xry111.site>

I didn't expect my patch to make it way into -next as it already failed
the CI.  I was just too busy on $other_stuff and thinking "hey let me
rework the patch when I get some time" :(.

> ---
> Changes in v2:
> - Include a check for CONFIG_VDSO_GETRANDOM to fix breakage on
> =C2=A0 rv32_defconfig. Include the tags for the report that helped highli=
ght
> =C2=A0 this issue.
> - Link to v1: https://lore.kernel.org/r/20250423-riscv-fix-compat_vdso-ll=
d-v1-1-820de5cad605@kernel.org
> ---
> =C2=A0arch/riscv/kernel/vdso/vdso.lds.S | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/v=
dso.lds.S
> index abc69cda0445..7c15b0f4ee3b 100644
> --- a/arch/riscv/kernel/vdso/vdso.lds.S
> +++ b/arch/riscv/kernel/vdso/vdso.lds.S
> @@ -80,7 +80,9 @@ VERSION
> =C2=A0#ifndef COMPAT_VDSO
> =C2=A0		__vdso_riscv_hwprobe;
> =C2=A0#endif
> +#if defined(CONFIG_VDSO_GETRANDOM) && !defined(COMPAT_VDSO)
> =C2=A0		__vdso_getrandom;
> +#endif
> =C2=A0	local: *;
> =C2=A0	};
> =C2=A0}
>=20
> ---
> base-commit: bafa451a96d0f1404aa1a5a267f78767a55fac71
> change-id: 20250423-riscv-fix-compat_vdso-lld-e1b80b324d97
>=20
> Best regards,

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
