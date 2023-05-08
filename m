Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6326168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF82C433D2;
	Mon,  8 May 2023 09:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539635;
	bh=mPkr//c79LSJHYWR7e9Y1r6ZiPKoPgbJhxbpkJZJhng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvPGw3b2viNriVMc0t8pBesau3fn0CPE5/tPa+QeNpVDjiaPiZWaDAOPPAvbqSw3+
	 KWs1QITLyMeTnXyPTKpKf8m9Xwt2UYwKir2F8Ovm7KJghlxY91tK9Df6C4bPsBxIIQ
	 lhChgcRhIp1U+S/Kl9nHxkLDVlTRSOqyYOBQmlK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 071/611] crypto: arm64/aes-neonbs - fix crash with CFI enabled
Date: Mon,  8 May 2023 11:38:33 +0200
Message-Id: <20230508094424.316611845@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
 arch/arm64/crypto/aes-neonbs-core.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index 7278a37c2d5c..baf450717b24 100644
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
 
-- 
2.40.1



