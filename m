Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EF41DE4EF;
	Sat, 12 Sep 2026 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222358; cv=none; b=Sbr6+KPM1OH1+ibh8QyEowDo1C8aegebIMhKphkZlhxhEqcNDM27j71GWofEYOm9XYSST2u8cM50V8or/WACC+8KtWfMbxldSNK+QF2HSrSaYBfZG4xu0VaLNPgvcLHPq8LYaBPJ9zRaTUdRX6plYaNetc6r0GhqmVYBQwjavOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222358; c=relaxed/simple;
	bh=w5Ivfxv8srZytDmF7m01/7+aB52Lsl/SDIZoB1pw4Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHBL4TJh4Thy/vWnfXt4E4IsqRXgeGlX4OrNgyMvAZYdND7tjJjFBgWQPf/FLrjue1NcQ4ikE115HbMGHpRTk8r9HNTaylKCS4vjAU2XynRJ2+Pw2Tyn5fgqymem4JLB9kqye2/u7IFuSylLeArWaNd+OQbv/2+2TQMo3Cit7eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvLqL/bD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvLqL/bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779D31F000FF;
	Sat, 12 Sep 2026 14:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222357;
	bh=Q5RAT1iSTHIrqX7YlttZKm+BIvRi5PgLS6rI3kWsq1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvLqL/bDgc2TH3t9b5mCib3AepDJPq4JqTqBQ1nZd4ego+Mgdv3gcLEg2QHa9DpUq
	 cKY4b31B3jPgEvlzlpgyxV1NAR9+QIR95Gxh9R/wXxjjlFBVPsFUP02/qD07FYzhgd
	 fNJF2aTMwhrVj96nFg7+fUjQbaXEeLy0sUzwijI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jens Remus <jremus@linux.ibm.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nathan Chancellor <nathan@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0569/1424] x86/cfi: Use symmetric SYM_START and SYM_END in __CFI_TYPE()
Date: Sat, 12 Sep 2026 08:50:01 +0200
Message-ID: <20260912065620.044932580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit 0cfdf974f133e0ff17ed80e7895adbe7889d9522 ]

Commit

  ccace936eec7 ("x86: Add types to indirectly called assembly functions")

introduced a x86-specific implementation of __CFI_TYPE() using an asymmetric
combination of SYM_START() and SYM_FUNC_END() to add a symbol to the KCFI type
identifier that precedes a function.

This asymmetric combination is an issue if SYM_FUNC_END() ever gets extended
in a way that requires it to be used symmetrically with SYM_FUNC_START*().
For instance to emit DWARF CFI directives that denote the start/end of
a function. [1]

Use SYM_END() with SYM_T_FUNC instead.  No functional change, as the generic
implementation of SYM_FUNC_END(name) expands into SYM_END(name, SYM_T_FUNC).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Closes: https://sashiko.dev/#/patchset/20260522110427.2816637-1-jremus@linux.ibm.com?part=3 [1]
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260611155716.830563-1-jremus@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/linkage.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 571fe4d2d2328..6cea7b15785a3 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -103,7 +103,7 @@
 	.byte 0xb8 ASM_NL					\
 	.long __kcfi_typeid_##name ASM_NL			\
 	CFI_POST_PADDING					\
-	SYM_FUNC_END(__cfi_##name)
+	SYM_END(__cfi_##name, SYM_T_FUNC)
 
 /* UML needs to be able to override memcpy() and friends for KASAN. */
 #ifdef CONFIG_UML
-- 
2.53.0



