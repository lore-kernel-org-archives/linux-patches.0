Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363701C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7BCC433D2;
	Wed, 28 Dec 2022 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244414;
	bh=0vuYdpv/hdcD+4QKCTXqaiBNEPGinL4DTMC3vrWhyZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJDHX5II8ULRBppQ2/gGH9GewG9Rr605rm187Zh2N3spwd7GWmS8cVmPgGsH4OXye
	 qNmUS5jemKwkfJywPeOF4da55/b8Tw5BNPl1A9RiUeJlGJc87VHHflJSivtVojA+71
	 7iANkvzIOrLk9cTVpuGPuINqrbn35/taJRIqz8Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0643/1146] crypto: arm64/sm3 - fix possible crash with CFI enabled
Date: Wed, 28 Dec 2022 15:36:22 +0100
Message-Id: <20221228144347.626018253@linuxfoundation.org>
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

[ Upstream commit be8f6b6496076588fd49cbe5bfaaf3ab883eb779 ]

sm3_neon_transform() is called via indirect function calls.  Therefore
it needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause
its type hash to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/crypto/sm3-neon-core.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm3-neon-core.S b/arch/arm64/crypto/sm3-neon-core.S
index 3e3b4e5c736f..4357e0e51be3 100644
--- a/arch/arm64/crypto/sm3-neon-core.S
+++ b/arch/arm64/crypto/sm3-neon-core.S
@@ -9,6 +9,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 /* Context structure */
@@ -351,7 +352,7 @@
 	 */
 	.text
 .align 3
-SYM_FUNC_START(sm3_neon_transform)
+SYM_TYPED_FUNC_START(sm3_neon_transform)
 	ldp		ra, rb, [RSTATE, #0]
 	ldp		rc, rd, [RSTATE, #8]
 	ldp		re, rf, [RSTATE, #16]
-- 
2.35.1



