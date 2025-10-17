Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF97242935;
	Fri, 17 Oct 2025 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714265; cv=none; b=B1qGm5g/fDFXYUt3ht9Y14j+PkrpYEMv5vCg7qXLR9sgCG49bMKm5N8j1CfnBEwtbeb9XDUmOBWK4TfBkdVSCoQ+RmuGZQ3sxCI5wWYbOfa6htN1X0zRfQsTyJP4+EzZS0gjl5Fx9NvjCvoca4c5cq3hj5gz1IbHIX94yok4Ays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714265; c=relaxed/simple;
	bh=qaVn1EfSCoq/X/UjKkqcIvx5tNmh0D9GKE60MXiKX6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWzMZp3yAcGE1PuK30x1blh2U+XSxUhD9T54NS0Drno9jOWtuWzqqnklXPo73JLQDGp97MM1aJP5MzOO0oLa4df63I4vjlMQ81PfsFoIIC+lyTeiGKQvI6X4SE1j68/sb7qAoxKhWrWj2kRss7qa0yTaj9f9DkbO5IEIEfgMhAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skYTIl5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skYTIl5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAF3C4CEE7;
	Fri, 17 Oct 2025 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714264;
	bh=qaVn1EfSCoq/X/UjKkqcIvx5tNmh0D9GKE60MXiKX6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skYTIl5IMTckDVlNYgX8ZEZn+SD6mhjGfHeLoB6pTU6aLyWh6GvU/EF7BskTlAE+L
	 05bH2qWi/SAwwkDvk1J4NAjSEJ8tOfGImQEwJLolRSGQe/ES4nGNIRp9WT8ufdx023
	 X9AHWeinjDtXJP8oXbg7orv93d1tE88SpwxGrxmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexey Gladkov <legion@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/277] s390/vmlinux.lds.S: Move .vmlinux.info to end of allocatable sections
Date: Fri, 17 Oct 2025 16:51:31 +0200
Message-ID: <20251017145150.200875376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index 3f2f90e38808c..0d18d3267bc4f 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -207,6 +207,28 @@ SECTIONS
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
@@ -237,28 +259,6 @@ SECTIONS
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



