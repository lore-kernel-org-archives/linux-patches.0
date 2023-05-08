Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5767D168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D34C4339B;
	Mon,  8 May 2023 10:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543405;
	bh=RuTvxuKgghcUCtjqWOFRvAdkvXk8bTsR6H4on0Jn9WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjhXPNsYWHFVu41ZcfxcEc+34mGmv9p59Z1q2bZt60LBW1MBFlorU3p9cpU/RNYpR
	 VastalgIiSOeCkZMaFUAsF8D6t8C4SPLZ6S8adQv0dUgI0WHaRbNy3ayUCyBaaHn9l
	 YRTV3EyRJ+wUbvKTojCdSHnIj/kFjk2D3/P1De1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.3 050/694] crypto: arm64/aes-neonbs - fix crash with CFI enabled
Date: Mon,  8 May 2023 11:38:05 +0200
Message-Id: <20230508094434.237127736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

commit 47446d7cd42358ca7d7a544f2f7823db03f616ff upstream.

aesbs_ecb_encrypt(), aesbs_ecb_decrypt(), aesbs_xts_encrypt(), and
aesbs_xts_decrypt() are called via indirect function calls.  Therefore
they need to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause
their type hashes to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure if
the compiler doesn't happen to optimize out the indirect calls.

Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/aes-neonbs-core.S |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -15,6 +15,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 	.text
@@ -620,12 +621,12 @@ SYM_FUNC_END(aesbs_decrypt8)
 	.endm
 
 	.align		4
-SYM_FUNC_START(aesbs_ecb_encrypt)
+SYM_TYPED_FUNC_START(aesbs_ecb_encrypt)
 	__ecb_crypt	aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
 SYM_FUNC_END(aesbs_ecb_encrypt)
 
 	.align		4
-SYM_FUNC_START(aesbs_ecb_decrypt)
+SYM_TYPED_FUNC_START(aesbs_ecb_decrypt)
 	__ecb_crypt	aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
 SYM_FUNC_END(aesbs_ecb_decrypt)
 
@@ -799,11 +800,11 @@ SYM_FUNC_END(__xts_crypt8)
 	ret
 	.endm
 
-SYM_FUNC_START(aesbs_xts_encrypt)
+SYM_TYPED_FUNC_START(aesbs_xts_encrypt)
 	__xts_crypt	aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
 SYM_FUNC_END(aesbs_xts_encrypt)
 
-SYM_FUNC_START(aesbs_xts_decrypt)
+SYM_TYPED_FUNC_START(aesbs_xts_decrypt)
 	__xts_crypt	aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
 SYM_FUNC_END(aesbs_xts_decrypt)
 


