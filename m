Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D8F51CF44;
	Wed, 30 Sep 2026 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793326; cv=none; b=TW7OvMciRdrqtoOItGCCCmSiV4wQf/4/tPhiWLgxzv6sNuJmvhTb+xsfJpsgjWP6uLIUjcHdjMkZJAz6tv7DpGuKiXHq8AI9sFzynf+uMUxmSecnTjD9hiDXvncnVI8nlAtrEif+GmyjWRYyzUl/jlvW8S6Kqw0lROZu4Q0V4cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793326; c=relaxed/simple;
	bh=IYm2iJ3DvdePmR63aO8ehdbInN6ztZC3QKjkf3jeAts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsHopZV2w2GRdYR1HuMv84kjMSuQM0JSg/nscd0vPuTJczYmoBwiOOvWnYoGzYxCK4PndUBkrkCzcxGjqfKuzWi/GXSbizoPkQZXACrKO/r1eiMT88GPKwd15I0mppeYrmpmkLK5Xi8z2hdpkMwaYQdtRsA0TVORD0X84ALIsHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGIL9TSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGIL9TSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F63E1F0089A;
	Wed, 30 Sep 2026 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793324;
	bh=x+6fV/nra97H7Yv/bF9WztW6MTdCCVVbgP6tfD7C29E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGIL9TSUAXfP0ldnotJRq4rlxZeJobUUOBAKZfSB/7iafWkEmoYy+NND0l3NniwOx
	 /COrspixy2FVvSo2puvok6W4pYLp5lkCDLwa6mxL4LfF8BRfwsOZPIJTRmgABNdHIo
	 Ge1ZT/YIaA1f4SordoZy4Xuv2WwcYkQtRXUtqiLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 213/395] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
Date: Wed, 30 Sep 2026 17:27:55 +0200
Message-ID: <20260930152345.280396042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 2bc6b218717b9d08f466f88209251d54bc09b207 upstream.

__init_el2_fgt2() writes one mask to both HDFGRTR2_EL2 and HDFGWTR2_EL2.
PMZR_EL0 is write-only, so its trap bit, nPMZR_EL0, exists only in
HDFGWTR2_EL2 and is therefore never set: a PMZR_EL0 write from the host
traps to EL2, where the nVHE hypervisor has no handler and BUG()s. The
kernel never writes PMZR_EL0, but kernel.perf_user_access=1 has the PMU
driver set PMUSERENR_EL0.UEN for a task with a user-read event, so a
write from EL0 reaches the trap and takes the host down without a panic
message.

Accumulate the HDFGWTR2_EL2 bits separately, as __init_el2_fgt() already
does for HDFGWTR_EL2, and set nPMZR_EL0 with the other FEAT_PMUv3p9
bits.

Fixes: 858c7bfcb35e1 ("arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/booting.rst |    1 +
 arch/arm64/include/asm/el2_setup.h   |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -465,6 +465,7 @@ Before jumping into the kernel, the foll
     - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMZR_EL0 (bit 21) must be initialised to 0b1.
 
   For CPUs with SPE data source filtering (FEAT_SPE_FDS):
 
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -409,6 +409,7 @@
 	b.lt	.Lskip_fgt2_\@
 
 	mov	x0, xzr
+	mov	x2, xzr
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
 	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
@@ -417,6 +418,11 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+	orr	x2, x2, #HDFGWTR2_EL2_nPMICNTR_EL0
+	orr	x2, x2, #HDFGWTR2_EL2_nPMICFILTR_EL0
+	orr	x2, x2, #HDFGWTR2_EL2_nPMUACR_EL1
+	/* PMZR_EL0 is write-only, so it has no read trap to disable */
+	orr	x2, x2, #HDFGWTR2_EL2_nPMZR_EL0
 .Lskip_pmuv3p9_\@:
 	/* If SPE is implemented, */
 	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
@@ -427,10 +433,11 @@
 	cbz	x1, .Lskip_spefds_\@
 	/* disable traps of PMSDSFR to EL2. */
 	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
+	orr	x2, x2, #HDFGWTR2_EL2_nPMSDSFR_EL1
 
 .Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
-	msr_s   SYS_HDFGWTR2_EL2, x0
+	msr_s   SYS_HDFGWTR2_EL2, x2
 	msr_s   SYS_HFGRTR2_EL2, xzr
 	msr_s   SYS_HFGWTR2_EL2, xzr
 	msr_s   SYS_HFGITR2_EL2, xzr


