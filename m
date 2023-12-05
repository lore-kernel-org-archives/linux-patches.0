Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74955C1F
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="MTi3kfhV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701773244; x=1733309244;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=plwsPb3W/ttbyLGTecUtoVvI8YdDGBssYXlxlJS8cMw=;
  b=MTi3kfhVKUxCZtCsrM432P0m2LQ6vsORvKQ6rQ+oazCnlSsaaYiw2yf+
   WEaanlWrX0FKfe80LYtjlmBkkuoaKWQDQldT04WgLCj3SjEFxv0Pgq3b7
   Soz1VmJ68iNXIKCmgPi9n/n0xcC+wd3G7ToIpxAES9XMwTy03USQt3KSA
   L8+pCyfwL6Ai8lvstVGDlNQ6YO2eFljXCUzJWfc8X85LMkiMISq2Jf80g
   1fdXQx10vaVrYNju6f09aCDNrQPap81khh/YcNGDvkpuyyz+Nt6zGDqw3
   UVb6QwJaX/NUbAai8ksWUrHD42eQlntquk4LzIhVojJvlQL5E/tALP8cI
   w==;
X-CSE-ConnectionGUID: MDKKp6t3TXCDGIRc+4Ok5Q==
X-CSE-MsgGUID: V9T+scCbQju9SjXvZ0GOeg==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="asc'?scan'208";a="179932143"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2023 03:47:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 03:47:14 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex01.mchp-main.com (10.10.85.143)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Tue, 5 Dec 2023 03:47:13 -0700
Date: Tue, 5 Dec 2023 10:46:43 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Alexandre Ghiti
	<alexghiti@rivosinc.com>, Palmer Dabbelt <palmer@rivosinc.com>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.1 084/107] drivers: perf: Check find_first_bit() return
 value
Message-ID: <20231205-heave-snowiness-8b0e2cb7cecd@wendy>
References: <20231205031531.426872356@linuxfoundation.org>
 <20231205031536.858427109@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iy3lZmAh+eg7tD+t"
Content-Disposition: inline
In-Reply-To: <20231205031536.858427109@linuxfoundation.org>

--iy3lZmAh+eg7tD+t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 05, 2023 at 12:16:59PM +0900, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Alexandre Ghiti <alexghiti@rivosinc.com>
>=20
> [ Upstream commit c6e316ac05532febb0c966fa9b55f5258ed037be ]
>=20
> We must check the return value of find_first_bit() before using the
> return value as an index array since it happens to overflow the array
> and then panic:
>=20
> [  107.318430] Kernel BUG [#1]
> [  107.319434] CPU: 3 PID: 1238 Comm: kill Tainted: G            E      6=
=2E6.0-rc6ubuntu-defconfig #2
> [  107.319465] Hardware name: riscv-virtio,qemu (DT)
> [  107.319551] epc : pmu_sbi_ovf_handler+0x3a4/0x3ae
> [  107.319840]  ra : pmu_sbi_ovf_handler+0x52/0x3ae
> [  107.319868] epc : ffffffff80a0a77c ra : ffffffff80a0a42a sp : ffffaf83=
fecda350
> [  107.319884]  gp : ffffffff823961a8 tp : ffffaf8083db1dc0 t0 : ffffaf83=
fecda480
> [  107.319899]  t1 : ffffffff80cafe62 t2 : 000000000000ff00 s0 : ffffaf83=
fecda520
> [  107.319921]  s1 : ffffaf83fecda380 a0 : 00000018fca29df0 a1 : ffffffff=
ffffffff
> [  107.319936]  a2 : 0000000001073734 a3 : 0000000000000004 a4 : 00000000=
00000000
> [  107.319951]  a5 : 0000000000000040 a6 : 000000001d1c8774 a7 : 00000000=
00504d55
> [  107.319965]  s2 : ffffffff82451f10 s3 : ffffffff82724e70 s4 : 00000000=
0000003f
> [  107.319980]  s5 : 0000000000000011 s6 : ffffaf8083db27c0 s7 : 00000000=
00000000
> [  107.319995]  s8 : 0000000000000001 s9 : 00007fffb45d6558 s10: 00007fff=
b45d81a0
> [  107.320009]  s11: ffffaf7ffff60000 t3 : 0000000000000004 t4 : 00000000=
00000000
> [  107.320023]  t5 : ffffaf7f80000000 t6 : ffffaf8000000000
> [  107.320037] status: 0000000200000100 badaddr: 0000000000000000 cause: =
0000000000000003
> [  107.320081] [<ffffffff80a0a77c>] pmu_sbi_ovf_handler+0x3a4/0x3ae
> [  107.320112] [<ffffffff800b42d0>] handle_percpu_devid_irq+0x9e/0x1a0
> [  107.320131] [<ffffffff800ad92c>] generic_handle_domain_irq+0x28/0x36
> [  107.320148] [<ffffffff8065f9f8>] riscv_intc_irq+0x36/0x4e
> [  107.320166] [<ffffffff80caf4a0>] handle_riscv_irq+0x54/0x86
> [  107.320189] [<ffffffff80cb0036>] do_irq+0x64/0x96
> [  107.320271] Code: 85a6 855e b097 ff7f 80e7 9220 b709 9002 4501 bbd9 (9=
002) 6097
> [  107.320585] ---[ end trace 0000000000000000 ]---
> [  107.320704] Kernel panic - not syncing: Fatal exception in interrupt
> [  107.320775] SMP: stopping secondary CPUs
> [  107.321219] Kernel Offset: 0x0 from 0xffffffff80000000
> [  107.333051] ---[ end Kernel panic - not syncing: Fatal exception in in=
terrupt ]---
>=20
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Link: https://lore.kernel.org/r/20231109082128.40777-1-alexghiti@rivosinc=
=2Ecom
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/perf/riscv_pmu_sbi.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 382fe5ee6100b..e0a84046435b1 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -578,6 +578,11 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void=
 *dev)
> =20
>  	/* Firmware counter don't support overflow yet */
>  	fidx =3D find_first_bit(cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTERS);
> +	if (fidx =3D=3D RISCV_MAX_COUNTERS) {
> +		csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));

This breaks the build, "riscv_pmu_irq_num" does not exist in 6.1,
perhaps "riscv_pmu_irq" is the right choice, but it needs a deeper look.

> +		return IRQ_NONE;
> +	}
> +
>  	event =3D cpu_hw_evt->events[fidx];
>  	if (!event) {
>  		csr_clear(CSR_SIP, SIP_LCOFIP);
> --=20
> 2.42.0
>=20
>=20
>=20

--iy3lZmAh+eg7tD+t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZW7/jwAKCRB4tDGHoIJi
0pWnAQC7ZTFFm2t4uj7bJjZf2bmK+S1S2kdAkf5LQTcV6h9HOAEAxJX6X7zu9/IG
rzg0C4zAXwQiUR0YfRYjqeq2KCORuAQ=
=I4zU
-----END PGP SIGNATURE-----

--iy3lZmAh+eg7tD+t--
