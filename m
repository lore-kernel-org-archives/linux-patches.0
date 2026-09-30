Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8F255C31C;
	Wed, 30 Sep 2026 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790404; cv=none; b=k2k+0ima32UxA7dTRNh81hDEsAucRHUEY0xoiDGnFCrPKOKiAph0NGJYrEmVLQthV2eMnUVmploHpvYu77Mqgac6VmnpTH1NatWZzCRMltGk/xf8pNNbriOJi2i/ObPm1rpaIqn/3oOUx6yL6SNbiiB3Kz0wsIjDb+z2CpbQVFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790404; c=relaxed/simple;
	bh=dxmKrXOL+WTqmVTJ2VVPY55ddSiWJ29O0dBW3b2/Isw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYl+Adw4pJiKzJqvW7wI8QIGOloOZoX9Uk3u1jpKFK5qw7KiISrcaiM9qTcj92yQmmSL10yCt8n0/A/7ELhlNEbiTmFxtHsRtVM670opwV0BWXWr6kHFJdXtlP9ApDRe6ZM2loZXk+4JqEquwGCODF7JmYyTU0xwwCmQaWnvQDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCHFn/us; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCHFn/us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008BD1F000FF;
	Wed, 30 Sep 2026 17:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790403;
	bh=49C1gnGuUIUQfLnVKZsbOdG83s9fgLdEZQe0IEZvoKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCHFn/us2fjYVP4Tw75g+Qw/Oekuo60o/Y/PqjiYdAXC3o3elDr38LNK3lBTIqn94
	 jpiu36OR2TNjv4/wiDhR+UHaC1cG43Qu1TzZXMTXNLTBfmsKZRR7I7Mc3pOOUYX54j
	 Jw4IIyR9jyiLWcjryf4lNwX15Qir4W00HILbGpfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 816/877] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
Date: Wed, 30 Sep 2026 17:28:47 +0200
Message-ID: <20260930152432.333121823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[Fuad: dropped the nPMSDSFR_EL1 hunk, 6.12 lacks FEAT_SPE_FDS support]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/booting.rst |    1 +
 arch/arm64/include/asm/el2_setup.h   |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -400,6 +400,7 @@ Before jumping into the kernel, the foll
     - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMZR_EL0 (bit 21) must be initialised to 0b1.
 
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -274,6 +274,7 @@
 	b.lt	.Lskip_fgt2_\@
 
 	mov	x0, xzr
+	mov	x2, xzr
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
 	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
@@ -282,9 +283,14 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+	orr	x2, x2, #HDFGWTR2_EL2_nPMICNTR_EL0
+	orr	x2, x2, #HDFGWTR2_EL2_nPMICFILTR_EL0
+	orr	x2, x2, #HDFGWTR2_EL2_nPMUACR_EL1
+	/* PMZR_EL0 is write-only, so it has no read trap to disable */
+	orr	x2, x2, #HDFGWTR2_EL2_nPMZR_EL0
 .Lskip_pmuv3p9_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
-	msr_s   SYS_HDFGWTR2_EL2, x0
+	msr_s   SYS_HDFGWTR2_EL2, x2
 	msr_s   SYS_HFGRTR2_EL2, xzr
 	msr_s   SYS_HFGWTR2_EL2, xzr
 	msr_s   SYS_HFGITR2_EL2, xzr


