Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D8F1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57CBC433D2;
	Wed, 28 Dec 2022 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244258;
	bh=DptcddMtWuF4Jnw4rgtwhEVBSnTWB1EX1/FTGRdmbt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsBAiTYjLu4tIYM1+nQGdLEX+bmWZbyl9QUA2TOukzAoC6HEBHpUhWo3OxmvBc04W
	 JRDxZTZLf0GT4ObYmDtxdq99bhqtMa8aIdZlv1rcI8ARdxP9Gu/LnwOZ42bCaYa400
	 RSbcSKiNs5B5DBTNZbdB7ZW6XPvn4ruMUJB6CpGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0637/1146] crypto: x86/sha1 - fix possible crash with CFI enabled
Date: Wed, 28 Dec 2022 15:36:16 +0100
Message-Id: <20221228144347.466091460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 32f34bf7e44eeaa241fb845d6f52af5104bc30fd ]

sha1_transform_ssse3(), sha1_transform_avx(), and sha1_ni_transform()
(but not sha1_transform_avx2()) are called via indirect function calls.
Therefore they need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause their type hashes to be emitted when the kernel
is built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a
CFI failure (if the compiler didn't happen to optimize out the indirect
calls).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha1_ni_asm.S    | 3 ++-
 arch/x86/crypto/sha1_ssse3_asm.S | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index 2f94ec0e763b..3cae5a1bb3d6 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -54,6 +54,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define DIGEST_PTR	%rdi	/* 1st arg */
 #define DATA_PTR	%rsi	/* 2nd arg */
@@ -93,7 +94,7 @@
  */
 .text
 .align 32
-SYM_FUNC_START(sha1_ni_transform)
+SYM_TYPED_FUNC_START(sha1_ni_transform)
 	push		%rbp
 	mov		%rsp, %rbp
 	sub		$FRAME_SIZE, %rsp
diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index 263f916362e0..f54988c80eb4 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -25,6 +25,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define CTX	%rdi	// arg1
 #define BUF	%rsi	// arg2
@@ -67,7 +68,7 @@
  * param: function's name
  */
 .macro SHA1_VECTOR_ASM  name
-	SYM_FUNC_START(\name)
+	SYM_TYPED_FUNC_START(\name)
 
 	push	%rbx
 	push	%r12
-- 
2.35.1



