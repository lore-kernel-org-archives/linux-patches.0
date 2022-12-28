Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC1B1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A38C433D2;
	Wed, 28 Dec 2022 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244277;
	bh=5xxjbcH2bGXAFn8hvpJJwxugZ9mAmxHZSybqTbCYwm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP8UfnVmkIWWpBsiBd0wDwCwPuYw1vAdV7lVwZQtpQlZBNnyekGoek+WL1KXOq0iz
	 GkPTN+lIL2OOzd7cR2FPZvOxa2mK+dXU/viNeMo4c5rjwL+3KWaRrulmuhgOHyHa9Z
	 zXTiXI3a9EezFwFL/6UFVjgcQNacPfu4qpAK+Wjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0640/1146] crypto: x86/sm3 - fix possible crash with CFI enabled
Date: Wed, 28 Dec 2022 15:36:19 +0100
Message-Id: <20221228144347.545606462@linuxfoundation.org>
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

[ Upstream commit 8ba490d9f5a56f52091644325a32d3f71a982776 ]

sm3_transform_avx() is called via indirect function calls.  Therefore it
needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause its
type hash to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sm3-avx-asm_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sm3-avx-asm_64.S b/arch/x86/crypto/sm3-avx-asm_64.S
index b12b9efb5ec5..8fc5ac681fd6 100644
--- a/arch/x86/crypto/sm3-avx-asm_64.S
+++ b/arch/x86/crypto/sm3-avx-asm_64.S
@@ -12,6 +12,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 /* Context structure */
@@ -328,7 +329,7 @@
  *                        const u8 *data, int nblocks);
  */
 .align 16
-SYM_FUNC_START(sm3_transform_avx)
+SYM_TYPED_FUNC_START(sm3_transform_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: data (64*nblks bytes)
-- 
2.35.1



