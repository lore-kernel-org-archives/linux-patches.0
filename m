Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787669953;
	Wed, 21 Feb 2024 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521853; cv=none; b=CWDWrKO9eYAhePJpc8+hodtRu/rZvONFqlbEhQI/XXqDjQPucNulRKwZbzDSYI4qpOCM3xdkthYs/xk6Ry9z0z6Bi+MAE0dSLUjVV26yKUyyq9GJxYnYkFZM4BF1Y/6y0uQVSkb53acZ4Amc1vU2lv1KG2UI7hDBJ9RApoxv+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521853; c=relaxed/simple;
	bh=BmEz3MzjqHTeBfmhraHfKJWezHA1X1gIPoVHa9wtVeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcIiH1L3GhfiTFnJQTRjkgZqj7D4VmzvEvHPto4Ggj/tD4i+NHZmMZK35yWE20ywMa6VAXko2t9pLVWEBmvocodRrMKUbEaUy8aZ+tbmretxnQuaYMqkLMsinki6Uu5GxbG0H166jttpLuGVKVoZwqjWfZmTJRh94Umn28zJtrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVtNUEw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVtNUEw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D55C433F1;
	Wed, 21 Feb 2024 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521853;
	bh=BmEz3MzjqHTeBfmhraHfKJWezHA1X1gIPoVHa9wtVeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVtNUEw7JlCFrW9BXVzYp1iI1rQ7aRw6CsKIc1SKQ45w/3GBBEbg7qQhHbMEVN8Ur
	 U7PVJH5OEM0sHZyxDWgTPaCPDHcMrfgkSOs/5oEedUvetcfflnvDKouSjW8WrMyJKI
	 3ia1XXVK5NvbH7WRz78EoA++9pcM7GcHWvdXI/i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@de.ibm.com>
Subject: [PATCH 5.15 018/476] crypto: s390/aes - Fix buffer overread in CTR mode
Date: Wed, 21 Feb 2024 14:01:09 +0100
Message-ID: <20240221130008.570384372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -601,7 +601,9 @@ static int ctr_aes_crypt(struct skcipher
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
@@ -688,9 +688,11 @@ static int ctr_paes_crypt(struct skciphe
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


