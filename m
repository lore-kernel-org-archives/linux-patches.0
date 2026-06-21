Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DBF1A681B;
	Sun, 21 Jun 2026 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782054167; cv=none; b=VLTiT9IQq2HTN8aBrGzIdUeA5KpvwIyt6YaLz9Vs9XDPg1FoOQPtQy9AmFO3adA/5DYG0LMr0KL6Op8eqfiEFhSa3jOdUM93ObZGOF3u3z4yHPBF7jDVc7BplQbSfciRxlZCBn99mrGkw/AXkY4CRCebNvm+4x6U1j5ROks3CrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782054167; c=relaxed/simple;
	bh=8N2LjD8Zi0JzSsimy/PTOMo66xc0ZQPjFDjo6+IiGi8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Uo1uU/FKtncKnm26ajSUye7fzhm2X+2qWCs95yH11HARNYISY31JIX7xyFuxbEcUXQmOenGVUiqSIqf5Th0FY3ebJ9YVZ0wX+fwwRJhC2EGXVBP4QymvZWuCrxtsCucouoMSxkFS1wIjGbzBgCSAk7ZW3PCgQ9utVpMuRPhVVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wbJgy-003aIM-0V;
	Sun, 21 Jun 2026 15:02:36 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wbJgw-00000007GXD-2yyJ;
	Sun, 21 Jun 2026 17:02:34 +0200
Message-ID: <b0d5836032ce3135bfc473f6bff791306d086925.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 337/522] arm64/mm: Enable batched TLB flush in
 unmap_hotplug_range()
From: Ben Hutchings <ben@decadent.org.uk>
To: Anshuman Khandual <anshuman.khandual@arm.com>, Catalin Marinas
	 <catalin.marinas@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>
Cc: patches@lists.linux.dev, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Sasha
 Levin	 <sashal@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable	 <stable@vger.kernel.org>
Date: Sun, 21 Jun 2026 17:02:27 +0200
In-Reply-To: <20260616145141.584613180@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145141.584613180@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y3J05c+vgPYhtoDB2K3t"
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


--=-y3J05c+vgPYhtoDB2K3t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Anshuman Khandual <anshuman.khandual@arm.com>
>=20
> [ Upstream commit 48478b9f791376b4b89018d7afdfd06865498f65 ]
[...]
> @@ -949,15 +953,14 @@ static void unmap_hotplug_pmd_range(pud_
>  		WARN_ON(!pmd_present(pmd));
>  		if (pmd_sect(pmd)) {
>  			pmd_clear(pmdp);
> -
> -			/*
> -			 * One TLBI should be sufficient here as the PMD_SIZE
> -			 * range is mapped with a single block entry.
> -			 */
> -			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> -			if (free_mapped)
> +			if (free_mapped) {
> +				/* CONT blocks are not supported in the vmemmap */
> +				WARN_ON(pmd_cont(pmd));
> +				flush_tlb_kernel_range(addr, addr + PMD_SIZE);

It wasn't clear to me from the commit message why this now adds PMD_SIZE
rather than PAGE_SIZE.  It seems like this change is fine for Linux
6.13+ with a CPU that supports TLB range flushing, but otherwise results
in unnecessarily executing multiple TLB invalidations at intervals of
the base page size.

>  				free_hotplug_page_range(pmd_page(pmd),
>  							PMD_SIZE, altmap);
> +			}
> +			/* unmap_hotplug_range() flushes TLB for !free_mapped */
>  			continue;
>  		}
>  		WARN_ON(!pmd_table(pmd));
> @@ -982,15 +985,12 @@ static void unmap_hotplug_pud_range(p4d_
>  		WARN_ON(!pud_present(pud));
>  		if (pud_sect(pud)) {
>  			pud_clear(pudp);
> -
> -			/*
> -			 * One TLBI should be sufficient here as the PUD_SIZE
> -			 * range is mapped with a single block entry.
> -			 */
> -			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> -			if (free_mapped)
> +			if (free_mapped) {
> +				flush_tlb_kernel_range(addr, addr + PUD_SIZE);
[...]

Similarly here, but this is effectively flush_tlb_all() instead.

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-y3J05c+vgPYhtoDB2K3t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo3/QMACgkQ57/I7JWG
EQnOORAAwi0dEpNPAe2/DhmuUrnEJymCCPR62cFYxp4C5G1M4TDy1TVbrr9sJXTB
VJKQ3SW44b1t7f36h3pnCqcA3ceDfjFkPr6Mca9OabfxerxX0LGe7SCAFlMCAhqC
nkM1iRJ6x2jzkCExZe2A+V3fIElM/QNzQaviy0g4t479/RLbRWtZCSGD1+1L+G//
BC9HvehneiyHmf/FbxmCyvceniexwRUnXRXWf7HVxn6JNCWgS0Y4qTVT1mYgqXej
GUuFtZPei0MuiOz/hJEVsJ/P8mFwsb6XWaVr5B1NyFLDdIMDpKuZWBgxaohCOMrt
xcj8GVCBCtvwA7wpz9yeI+0aCTkQuSwbvdgOm40lP/hwuA742FiIarsKBrCNbIfN
U+yFWOM8qmz/qPbaLslTENXUVMIt+2NBGugrLm0aeyNHvmMlyukO5RJagU7NIYyK
Iz8UVpNAxB7CbcBV9VHWl1MC1aHf3innDFmkDL6y+VPJ03SfE1cFONF1nL0IEwSg
UT+6TWIW+863nkHc2eTQ4KEhjFFmcbM2RkgdFP/A8LeYhxMqSFhyjESymGIsS+ox
LoR/xhRfXddxOiPVIQtFBBEH7C58OrDU5dWJl5zmYHf3khc342CcolzS4/21Ua/J
mWvMGYveWNU4fe/MPeU289MyTsroe0c2P+ysyEcKtB+3yIjPWQQ=
=lNMR
-----END PGP SIGNATURE-----

--=-y3J05c+vgPYhtoDB2K3t--
