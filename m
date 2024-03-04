Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC9C1EB5A;
	Mon,  4 Mar 2024 21:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588906; cv=none; b=hrMo3otqyQUoFbBXz2xqaYXAtN9zUBq1MzP25MNuKGQVEeJ8qVEtWLW038T6zAtgZcNq9JMTz5XWxfvRPiDajnb/nPgABgshSWF/N/IZn7PJyfcX8O470uVwcfdCFiAbhssufqA/XvMYYKt3QDj6SvUUelZbfSX60PAc42QVZ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588906; c=relaxed/simple;
	bh=Nw43l77qYIqqU2bjoW9TCXmjAb7UrCplKRQwL4eiz64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kscy0Xni1uf1y0Ci0Fz+cofzfaMJw7KN/j1AX2xAyG0Fv8APNTIQnCqKa18LP6CgI+iHp1L/k6ziiNm8P1iW6uGHxiuvEqbsp2cAG/wHFxnA6RBy+0mBc6Yru3EydCqRmFtjRywrAB7ELwxAWeiw/yJZp5fzzs+8t8JRKdx1B7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5aN9saw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5aN9saw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD1BC433C7;
	Mon,  4 Mar 2024 21:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588905;
	bh=Nw43l77qYIqqU2bjoW9TCXmjAb7UrCplKRQwL4eiz64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5aN9sawFQArN+u7lXflWPRkcYOwMoOaJyIVgcq98pld571L5z65Hxn4Ttkc48Phb
	 lV/ZfDN5W6diFVueqCsEBYUJk1feeEhS/n06U7MAQlndiBiqewFlFWKTfYNnSCaeLI
	 ejHbZnlDIVyn1wktI+zk+ljqaD+XWRG0Vgen6mHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 131/215] x86/decompressor: Assign paging related global variables earlier
Date: Mon,  4 Mar 2024 21:23:14 +0000
Message-ID: <20240304211601.238870835@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 00c6b0978ec182f1a672095930872168b9d5b1e2 upstream.

There is no need to defer the assignment of the paging related global
variables 'pgdir_shift' and 'ptrs_per_p4d' until after the trampoline is
cleaned up, so assign them as soon as it is clear that 5-level paging
will be enabled.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-9-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/misc.h       |    2 --
 arch/x86/boot/compressed/pgtable_64.c |   14 +++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -170,9 +170,7 @@ static inline int count_immovable_mem_re
 #endif
 
 /* ident_map_64.c */
-#ifdef CONFIG_X86_5LEVEL
 extern unsigned int __pgtable_l5_enabled, pgdir_shift, ptrs_per_p4d;
-#endif
 extern void kernel_add_identity_map(unsigned long start, unsigned long end);
 
 /* Used by PAGE_KERN* macros: */
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -130,6 +130,11 @@ struct paging_config paging_prepare(void
 			native_cpuid_eax(0) >= 7 &&
 			(native_cpuid_ecx(7) & (1 << (X86_FEATURE_LA57 & 31)))) {
 		paging_config.l5_required = 1;
+
+		/* Initialize variables for 5-level paging */
+		__pgtable_l5_enabled = 1;
+		pgdir_shift = 48;
+		ptrs_per_p4d = 512;
 	}
 
 	paging_config.trampoline_start = find_trampoline_placement();
@@ -206,13 +211,4 @@ void cleanup_trampoline(void *pgtable)
 
 	/* Restore trampoline memory */
 	memcpy(trampoline_32bit, trampoline_save, TRAMPOLINE_32BIT_SIZE);
-
-	/* Initialize variables for 5-level paging */
-#ifdef CONFIG_X86_5LEVEL
-	if (__read_cr4() & X86_CR4_LA57) {
-		__pgtable_l5_enabled = 1;
-		pgdir_shift = 48;
-		ptrs_per_p4d = 512;
-	}
-#endif
 }


