Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BFF2F12C0;
	Fri, 17 Oct 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715205; cv=none; b=YHAcxMmEOIh5AyULdFDMaJmGDmkNV33asYpd3PwOqdbLK42WLjjwYtnU9N21VXF1fPeM0UyOThQsGS4aN5LAUCTESBigWYp2B8fbCz+IcZMnTrpkevOOY9w6nSnduCktNIhA4dO37Wr656V556QSYAjiqZJsEn9xdZxRnM1KtJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715205; c=relaxed/simple;
	bh=obwvhDHNc4m4mr9S94Ua6TgvDxrpWAo0Vs4gD91uYFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2kAvIq5Bhia1AkhsuJoPDhcUoWU8c+bRfw5B0m/a26Yph3NEQ6Ax/iZIKUgWcKgjXrSauXpAxxWX551LLpvPFQ6cR5feTIimkchMKvDCvihM2amObCyMLK4bxTEyjMxpNk7SwHuT0mQEW2qRgJZGrkOldafq8MfQLgxV8savUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3sIavGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3sIavGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C971C4CEE7;
	Fri, 17 Oct 2025 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715204;
	bh=obwvhDHNc4m4mr9S94Ua6TgvDxrpWAo0Vs4gD91uYFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3sIavGXKIFZbin4YHK3JSqaF5iCGor/UE2NFc7mBN6JBuNp3X/Z61DlKe19USMxf
	 Vr6DODcD7OKqBq3LDgyyWTM2+rCL8+D2KkktdnNFpsXT3dhZUAsNrP/KT9AI7oaciB
	 TkfDsHvISTgUQEqpiSzQmP0FQ2SOnGaz/fk8dsBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexey Gladkov <legion@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 135/371] s390/vmlinux.lds.S: Move .vmlinux.info to end of allocatable sections
Date: Fri, 17 Oct 2025 16:51:50 +0200
Message-ID: <20251017145206.812949226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 9338d660b79a0dfe4eb3fe9bd748054cded87d4f ]

When building s390 defconfig with binutils older than 2.32, there are
several warnings during the final linking stage:

  s390-linux-ld: .tmp_vmlinux1: warning: allocated section `.got.plt' not in segment
  s390-linux-ld: .tmp_vmlinux2: warning: allocated section `.got.plt' not in segment
  s390-linux-ld: vmlinux.unstripped: warning: allocated section `.got.plt' not in segment
  s390-linux-objcopy: vmlinux: warning: allocated section `.got.plt' not in segment
  s390-linux-objcopy: st7afZyb: warning: allocated section `.got.plt' not in segment

binutils commit afca762f598 ("S/390: Improve partial relro support for
64 bit") [1] in 2.32 changed where .got.plt is emitted, avoiding the
warning.

The :NONE in the .vmlinux.info output section description changes the
segment for subsequent allocated sections. Move .vmlinux.info right
above the discards section to place all other sections in the previously
defined segment, .data.

Fixes: 30226853d6ec ("s390: vmlinux.lds.S: explicitly handle '.got' and '.plt' sections")
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=afca762f598d453c563f244cd3777715b1a0cb72 [1]
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251008-kbuild-fix-modinfo-regressions-v1-3-9fc776c5887c@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 44 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index feecf1a6ddb44..d74d4c52ccd05 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -214,6 +214,28 @@ SECTIONS
 	DWARF_DEBUG
 	ELF_DETAILS
 
+	/*
+	 * Make sure that the .got.plt is either completely empty or it
+	 * contains only the three reserved double words.
+	 */
+	.got.plt : {
+		*(.got.plt)
+	}
+	ASSERT(SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0x18, "Unexpected GOT/PLT entries detected!")
+
+	/*
+	 * Sections that should stay zero sized, which is safer to
+	 * explicitly check instead of blindly discarding.
+	 */
+	.plt : {
+		*(.plt) *(.plt.*) *(.iplt) *(.igot .igot.plt)
+	}
+	ASSERT(SIZEOF(.plt) == 0, "Unexpected run-time procedure linkages detected!")
+	.rela.dyn : {
+		*(.rela.*) *(.rela_*)
+	}
+	ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations (.rela) detected!")
+
 	/*
 	 * uncompressed image info used by the decompressor
 	 * it should match struct vmlinux_info
@@ -244,28 +266,6 @@ SECTIONS
 #endif
 	} :NONE
 
-	/*
-	 * Make sure that the .got.plt is either completely empty or it
-	 * contains only the three reserved double words.
-	 */
-	.got.plt : {
-		*(.got.plt)
-	}
-	ASSERT(SIZEOF(.got.plt) == 0 || SIZEOF(.got.plt) == 0x18, "Unexpected GOT/PLT entries detected!")
-
-	/*
-	 * Sections that should stay zero sized, which is safer to
-	 * explicitly check instead of blindly discarding.
-	 */
-	.plt : {
-		*(.plt) *(.plt.*) *(.iplt) *(.igot .igot.plt)
-	}
-	ASSERT(SIZEOF(.plt) == 0, "Unexpected run-time procedure linkages detected!")
-	.rela.dyn : {
-		*(.rela.*) *(.rela_*)
-	}
-	ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations (.rela) detected!")
-
 	/* Sections to be discarded */
 	DISCARDS
 	/DISCARD/ : {
-- 
2.51.0



