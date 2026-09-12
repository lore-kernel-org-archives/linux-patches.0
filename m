Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5C33BCD19;
	Sat, 12 Sep 2026 07:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196917; cv=none; b=g4/+JHOknTG9uncaAsriHASCWNftuWjcMabSzuyuS8kcla0xKFPTXMeHRWTaSuNwGlh3U77NWWmCe8qgihDADvwlezKI6YAjTxWrwH0Q+b48i8fQcVvHIAEpw+/vfS4jfgh3g2zJYp/j5HLZLEiXAiBQOgoMBnhVu5f7FInhkHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196917; c=relaxed/simple;
	bh=7601rEpACXIGb6jx34J6+ei9b0QJrSf5wTPUEDHORvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn3nq30UeBWgmooR3ft0ZbIu7ND4lXShfHKZbbsyiEHeOlTjbglWOACWHwrzENLbvsnupoVmrIgZb3AYTdon6yZFyAURgSnXS+X166i4oJBoPEkRv+5AkdeGETcY5UGArs2J3jG0Wh9ydSr3wRo4O50rLx9szxRLDs8LO2Co7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=He38nQxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="He38nQxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289D41F000FF;
	Sat, 12 Sep 2026 07:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196916;
	bh=TBrfyy78hHzvDj4+0dIoZdjyVkVsR0GLWxT36G6qEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=He38nQxwvUCN/qYXbv3HkZhEFNVaG52qLI3xyIY5S7gFHH7qelHF1CafD3zJI5c5j
	 6KHFes0Zq5iP7/asB5z9ERxhB1ALWJywC/l3ABn4+gXIq92pKjWSuY7YoQpVisiWsU
	 FLjCnuycJ8y3mU1fN7AqSOaNa0JZXiXgySa3bwtM=
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
Subject: [PATCH 7.2 0063/1815] x86/cfi: Use symmetric SYM_START and SYM_END in __CFI_TYPE()
Date: Sat, 12 Sep 2026 08:30:13 +0200
Message-ID: <20260912065650.488628064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a7294656ad908..c9769a7b6e66c 100644
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



