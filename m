Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9768D157050;
	Mon, 29 Jan 2024 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548025; cv=none; b=nNRWb2U2qoyzXtSby3IEJr0l7BfP9+F4ofUeovGhMKvV8Y+nzEB99E+LdReM6d+jVq6e3UWVxv6vla51pbUV1LyCmAJaXRii2/yUIvyHiBz6DaDth8gh401lVljJ59WpF7bxNVrVF+jReQplHBY0Xei2Jxa8mZ4xXosYBUx5Lm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548025; c=relaxed/simple;
	bh=rpWXpcbCfyzNy6S0xVLb4pox1ahm5L0ywZckjd9SBhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXBojeBCbiTQWW2rfOf1dKNg5D0nmvyk6rNZozgC6XUEMMbo92OjMTh/zgOQBM3ERIewqNlhb83pySPUO2U7oPxlSBn1Vc+WuvH1YmgMKmV/co0gD453yFiyEeVjAkFiqH/C/eu/9UOhEmUGlBgG/5yGy88lQ2fzwlNjfmOq0kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WXgue7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WXgue7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09331C433F1;
	Mon, 29 Jan 2024 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548025;
	bh=rpWXpcbCfyzNy6S0xVLb4pox1ahm5L0ywZckjd9SBhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WXgue7bYaaLE25s4P5k3T731GuS0b7ieGLx/0fvVHwFyyKsZ2iEP948HEHZHm5Sl
	 oZqF3zxTzL20VyTlHzt5fg58SZNVFTRbAeDh1S4Gy0fHZjskomCYeBES1DUF5I/Emw
	 WodNRugb5/rSZP1AnhdqAUBZ1u0UF8HAM2Czmhdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@de.ibm.com>
Subject: [PATCH 6.7 019/346] crypto: s390/aes - Fix buffer overread in CTR mode
Date: Mon, 29 Jan 2024 09:00:50 -0800
Message-ID: <20240129170016.935800433@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit d07f951903fa9922c375b8ab1ce81b18a0034e3b upstream.

When processing the last block, the s390 ctr code will always read
a whole block, even if there isn't a whole block of data left.  Fix
this by using the actual length left and copy it into a buffer first
for processing.

Fixes: 0200f3ecc196 ("crypto: s390 - add System z hardware support for CTR mode")
Cc: <stable@vger.kernel.org>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewd-by: Harald Freudenberger <freude@de.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/aes_s390.c  |    4 +++-
 arch/s390/crypto/paes_s390.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -597,7 +597,9 @@ static int ctr_aes_crypt(struct skcipher
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
 	if (nbytes) {
-		cpacf_kmctr(sctx->fc, sctx->key, buf, walk.src.virt.addr,
+		memset(buf, 0, AES_BLOCK_SIZE);
+		memcpy(buf, walk.src.virt.addr, nbytes);
+		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
 			    AES_BLOCK_SIZE, walk.iv);
 		memcpy(walk.dst.virt.addr, buf, nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -693,9 +693,11 @@ static int ctr_paes_crypt(struct skciphe
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
 	if (nbytes) {
+		memset(buf, 0, AES_BLOCK_SIZE);
+		memcpy(buf, walk.src.virt.addr, nbytes);
 		while (1) {
 			if (cpacf_kmctr(ctx->fc, &param, buf,
-					walk.src.virt.addr, AES_BLOCK_SIZE,
+					buf, AES_BLOCK_SIZE,
 					walk.iv) == AES_BLOCK_SIZE)
 				break;
 			if (__paes_convert_key(ctx))


