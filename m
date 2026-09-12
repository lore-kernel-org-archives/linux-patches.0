Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C5627EC7C;
	Sat, 12 Sep 2026 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205999; cv=none; b=eyYtpv7Wb3dUcmHMuXq167NOONFg/rW3LFW3+MhZPDsuYUGd0MJCYwyk2GzqA/jXFe93F04j//OnVXC1Y5FGCmt8sMU+///cEQAl6PdTB62URQyZMI/yKWuS3T80/UebanidheycomT2KOIdMI6YYXuMnebdRyGMNXhEJvkvi6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205999; c=relaxed/simple;
	bh=iXJVBIhTRQrsKsQIjjMwNs3ycCiS0ex6L67sXC4o6BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwqupifaCEta5JvtTydSx+GOjcOs7/fee7RX2LwF5FylDtVcJ1K1fA2Mx1JvvcrEDeJaUkfhj1n3Rm0J7sDhxRHjwVFwpl33mR4YKpQVbTDGCpNemhBez8qHZElzLaYDkGHAsNt1YizDIRjozGLL1VJRAg1vQirAcZJmvoKDAtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXRcO1M+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXRcO1M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3751F000FF;
	Sat, 12 Sep 2026 09:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205998;
	bh=XZHahrvyM0yl44Mh4a/qxVTbdaHiIkVN/dp6MbYMc5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXRcO1M+sNV4JmDoIVEkK7FkoJZJoK0TMaYJbjaAMRY5P+oHzAFsR9/tCo+krCh4J
	 7TV8c41hVHJPki/vJWipOoBjazvP1PCBXUjIG6EEVIK++Sut4/ENsUJT4soMJ2Tin9
	 cqAX8iZehvr1Vc0b/7DbWtw3JLKW+ewQZg0jKtJY=
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
Subject: [PATCH 6.18 0116/1518] x86/cfi: Use symmetric SYM_START and SYM_END in __CFI_TYPE()
Date: Sat, 12 Sep 2026 08:38:05 +0200
Message-ID: <20260912065626.111623363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



