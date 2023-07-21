Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8FC200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88DFC433CA;
	Fri, 21 Jul 2023 19:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966191;
	bh=Das22z4GLBnvRGB9TZFJek2UaW1AHz7fRpx9uomxse8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHUM2FOj2ar2neq02QaWi19Y/ILQoqf4UA7AJNOyH4OyelUntF2P6NedpHdxESr0k
	 FUy/LIEiFGentTxGqz1vY9UuXAJwPfZKqo7PKvQNiXvcOcmuo20FagyVvJ+lcOTDDe
	 cE2pANHdHZbOE8fTqfqzCQ7siMykLZesEUsOT65Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/532] crypto: marvell/cesa - Fix type mismatch warning
Date: Fri, 21 Jul 2023 18:02:12 +0200
Message-ID: <20230721160626.746149158@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit efbc7764c4446566edb76ca05e903b5905673d2e ]

Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") uncovered
a type mismatch in cesa 3des support that leads to a memcpy beyond the
end of a structure:

In function 'fortify_memcpy_chk',
    inlined from 'mv_cesa_des3_ede_setkey' at drivers/crypto/marvell/cesa/cipher.c:307:2:
include/linux/fortify-string.h:583:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  583 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is probably harmless as the actual data that is copied has the correct
type, but clearly worth fixing nonetheless.

Fixes: 4ada48397823 ("crypto: marvell/cesa - add Triple-DES support")
Cc: Kees Cook <keescook@chromium.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index c6f2fa753b7c0..0f37dfd42d850 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -297,7 +297,7 @@ static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
 				   const u8 *key, unsigned int len)
 {
-	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
+	struct mv_cesa_des3_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
 	err = verify_skcipher_des3_key(cipher, key);
-- 
2.39.2



