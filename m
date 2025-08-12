Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEC81F429C;
	Tue, 12 Aug 2025 19:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026119; cv=none; b=BQS/iDf0MRMR+C8JJ0I7FGpzGc5gCu2+ba91cMpTpfKLIXq0QYMxvjXJENcxsY3Pw42gwWIzhjQ5rUg9V1qIQAEy613+mLeRGylCauDMHT44xrrVT842TPoyZdoclCHKCwq3aEV9Z8kXZ/XY8m8VMNiK1lwaFZQ9uksZysTMZb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026119; c=relaxed/simple;
	bh=DdR71dpNz8/ZPwPJsE4y+ls/tH8kBbh9Su/Ycsg6t1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swLwnH4tVqRJeAYrMCozzRsnFkmjdeMouijnscbhuRMDeBJ6ZegxNofubhsFI4Wcme1qzv0fAityatsK9LPB3DFHcSboNAToZC1swT84oYdbgcg8/r/k29N0Ajxh+J7/k+EU53kul/GLk4zyQ00GvETLE8UjT9yG/Bd3pxMfHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMnDMISc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMnDMISc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBE9C4CEF0;
	Tue, 12 Aug 2025 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026117;
	bh=DdR71dpNz8/ZPwPJsE4y+ls/tH8kBbh9Su/Ycsg6t1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMnDMIScXOmdNvcuNL02jdoLhc0rHfw5uEiBnV5i+44vDK4IEk2S4ZtQoNCRQyRZi
	 aOl7i95muFMvsLhIxc8ei7xN+zlaPcInPug7To/VYzpzeGWHusucvoi0UqAT5K6k4p
	 TedM+ljGVCWMLrdMICmvLmHyo7S9xi3TqkqDXo6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 241/480] crypto: arm/aes-neonbs - work around gcc-15 warning
Date: Tue, 12 Aug 2025 19:47:29 +0200
Message-ID: <20250812174407.394554531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d5fa96dc5590915f060fee3209143313e4f5b03b ]

I get a very rare -Wstringop-overread warning with gcc-15 for one function
in aesbs_ctr_encrypt():

arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
arch/arm/crypto/aes-neonbs-glue.c:212:1446: error: '__builtin_memcpy' offset [17, 2147483647] is out of the bounds [0, 16] of object 'buf' with type 'u8[16]' {aka 'unsigned char[16]'} [-Werror=array-bounds=]
  212 |                         src = dst = memcpy(buf + sizeof(buf) - bytes,
arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
arch/arm/crypto/aes-neonbs-glue.c:218:17: error: 'aesbs_ctr_encrypt' reading 1 byte from a region of size 0 [-Werror=stringop-overread]
  218 |                 aesbs_ctr_encrypt(dst, src, ctx->rk, ctx->rounds, bytes, walk.iv);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 2 of type 'const u8[0]' {aka 'const unsigned char[]'}
arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 3 of type 'const u8[0]' {aka 'const unsigned char[]'}
arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 6 of type 'u8[0]' {aka 'unsigned char[]'}
arch/arm/crypto/aes-neonbs-glue.c:36:17: note: in a call to function 'aesbs_ctr_encrypt'
   36 | asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],

This could happen in theory if walk.nbytes is larger than INT_MAX and gets
converted to a negative local variable.

Keep the type unsigned like the orignal nbytes to be sure there is no
integer overflow.

Fixes: c8bf850e991a ("crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f6be80b5938b..2fad3a0c0563 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -232,7 +232,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 	while (walk.nbytes > 0) {
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
-		int bytes = walk.nbytes;
+		unsigned int bytes = walk.nbytes;
 
 		if (unlikely(bytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(buf + sizeof(buf) - bytes,
-- 
2.39.5



