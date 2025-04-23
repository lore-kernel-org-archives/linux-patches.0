Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE7C27F4D1;
	Wed, 23 Apr 2025 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421107; cv=none; b=idLeB2rdmi13x62tsJ5eDMs32GNMJ2rHKIqwlv2rYZo0Zc+M5N5FHM7Nw8AUxJJ0kprF1TPri7QWfR2q22EeNyJCK9QcAsJuk1CQCtIBBYayKKWKWfKX4Ko77Iq5v4aaB5uuAdUvgxs93Xbu6EToOayl69ZNo93ApbUX2hJD2lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421107; c=relaxed/simple;
	bh=7DTSy5c0LEFq6TqHnzfnsQmzUsM4pf25hH2RxLEG93Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsEcSOy+JeYra2YSoGa0J8cei+Xx2igNPCWQen0onmweNHG/JudpLqLmG5kQMkpsMXsAZL3DBTdO7yRr1fDTSQtoxSl7F5I8DeLjWJp4ezbdIio05LswDYY4HqKOXV7a6HKbLyxDc53QiPokQfYI1c0jIbtR8KrKrcWLSQRGOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hvFVCAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hvFVCAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A40FC4CEE2;
	Wed, 23 Apr 2025 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421107;
	bh=7DTSy5c0LEFq6TqHnzfnsQmzUsM4pf25hH2RxLEG93Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hvFVCAT5jtCig0nLcR7J+2P1wXVGhGv9rr1fqWPCDQqC+r/7lY6jONUP0bL1ytgl
	 5mFUJqmXQQe+4u9tGT5X8/QqouQIk1PlkkqIa90I1ICOq8vw+QED7eZHLF8F1SngTk
	 3vQDZQF1wXYC9QPBtFNzmVYq8r7P2N/Ly4RFZTd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rob Herring <robh@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 192/223] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Date: Wed, 23 Apr 2025 16:44:24 +0200
Message-ID: <20250423142624.996855042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 858c7bfcb35e1100b58bb63c9f562d86e09418d9 upstream.

FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
access from EL1 requires appropriate EL2 fine grained trap configuration
via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
Otherwise such register accesses will result in traps into EL2.

Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.

Also update booting.rst with SCR_EL3.FGTEn2 requirement for all FEAT_FGT2
based registers to be accessible in EL2.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Fixes: 0bbff9ed8165 ("perf/arm_pmuv3: Add PMUv3.9 per counter EL0 access control")
Fixes: d8226d8cfbaf ("perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter")
Tested-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250227035119.2025171-1-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/booting.rst |   22 ++++++++++++++++++++++
 arch/arm64/include/asm/el2_setup.h   |   25 +++++++++++++++++++++++++
 arch/arm64/tools/sysreg              |    1 +
 3 files changed, 48 insertions(+)

--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -285,6 +285,12 @@ Before jumping into the kernel, the foll
 
     - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
 
+  For CPUs with the Fine Grained Traps 2 (FEAT_FGT2) extension present:
+
+  - If EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
+
   For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
 
   - If EL3 is present and the kernel is entered at EL2:
@@ -379,6 +385,22 @@ Before jumping into the kernel, the foll
 
     - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
 
+  For CPUs with the Performance Monitors Extension (FEAT_PMUv3p9):
+
+ - If EL3 is present:
+
+    - MDCR_EL3.EnPM2 (bit 7) must be initialised to 0b1.
+
+ - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
+    - HDFGRTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
+    - HDFGRTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+
+    - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
   - If the kernel is entered at EL1 and EL2 is present:
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -215,6 +215,30 @@
 .Lskip_fgt_\@:
 .endm
 
+.macro __init_el2_fgt2
+	mrs	x1, id_aa64mmfr0_el1
+	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
+	b.lt	.Lskip_fgt2_\@
+
+	mov	x0, xzr
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
+	b.lt	.Lskip_pmuv3p9_\@
+
+	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
+	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
+	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+.Lskip_pmuv3p9_\@:
+	msr_s   SYS_HDFGRTR2_EL2, x0
+	msr_s   SYS_HDFGWTR2_EL2, x0
+	msr_s   SYS_HFGRTR2_EL2, xzr
+	msr_s   SYS_HFGWTR2_EL2, xzr
+	msr_s   SYS_HFGITR2_EL2, xzr
+.Lskip_fgt2_\@:
+.endm
+
 .macro __init_el2_nvhe_prepare_eret
 	mov	x0, #INIT_PSTATE_EL1
 	msr	spsr_el2, x0
@@ -240,6 +264,7 @@
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
+	__init_el2_fgt2
 .endm
 
 #ifndef __KVM_NVHE_HYPERVISOR__
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1238,6 +1238,7 @@ UnsignedEnum	11:8	PMUVer
 	0b0110	V3P5
 	0b0111	V3P7
 	0b1000	V3P8
+	0b1001	V3P9
 	0b1111	IMP_DEF
 EndEnum
 UnsignedEnum	7:4	TraceVer


