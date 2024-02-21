Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BA778B70;
	Wed, 21 Feb 2024 13:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523662; cv=none; b=jZINkrB/ZSXCU66Ubz8O2ciHikeUe8zUQWAVsNolPG+qsSGQbUwIE9ds95yWqI7Vc4sRTUW0s9Sh4YWAcoF4bJJA91dVm3mOrckmh23uOi32seTgbq/3vQZ7ZZKr4QvHdjEkwjpNPlnSpNiXENvW/MUycRyAKYLTOKbPX86qdew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523662; c=relaxed/simple;
	bh=nSfliVwsS/gVgP9M9bW8H6GdtdyKetx50HG2XKtjYlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqL9tQvKvTl1qqz6wDtnMyC5MzwnKwF3GWTkwhLMLW3Wvohl802WKMeCL+xgWpj29pim8yAqftWe6ggw+7lkwalCXsewzKwaoSrt3Mli5+3FgNd0cOplfmKKMOlZwoOpLHZAOabgtmkOW8jIsvjOac91mfawMEtj7rWeKYP7ri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgI66SfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgI66SfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87762C433C7;
	Wed, 21 Feb 2024 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523661;
	bh=nSfliVwsS/gVgP9M9bW8H6GdtdyKetx50HG2XKtjYlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgI66SfVoRMerdaTi5OpDzGmr7LImC9SJ7Tnzh8wYk+jwfaMFOL0kTf7tD/JGT3Jl
	 78Rqr3t0Y95UWtdTRgOoCcwuK5qZcXfT7yVldNH9P8GgwVkheAVbdXXOSf7zqIcqrh
	 eYW85LsE9M+QBqMvZWnLD3Yq3kCgHWUZbJp68zTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@de.ibm.com>
Subject: [PATCH 5.10 021/379] crypto: s390/aes - Fix buffer overread in CTR mode
Date: Wed, 21 Feb 2024 14:03:20 +0100
Message-ID: <20240221125955.546487983@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -600,7 +600,9 @@ static int ctr_aes_crypt(struct skcipher
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
@@ -676,9 +676,11 @@ static int ctr_paes_crypt(struct skciphe
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


