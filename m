Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0912F4A0A;
	Tue, 12 Aug 2025 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024210; cv=none; b=Q+pZM/aTmhpg8cXoA0YsjFR+sJAKB1piEGup1zJNiDRKjVlMj2gRAyqd/MVoFi/t9X9f6Q5Hk5EmL3SzgeHpUqEWfuOO6wQDFWXcETYF1H+7ni/zqrfq5xv27/jBKDC5edBM63Mym0a5VG7NqxMldAKAegjRGFBtVU6g4/eafM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024210; c=relaxed/simple;
	bh=awJDRcdCgaTe8R30AvBtaxYs5t0z9rZbXtbpC5BGPCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0JsodAzO1joovlE1IQRHGBxMmisbu213IQbOwdTScdqsHqylYXmbIRrJ8LNIviNv5VG85qsQq+hZr1SAI77ysgzdtB/8VmDBI3ey5zgbp1XOujjPGdmmjS30mMOHwI70Lj93QhHtEyQDN1VoSqc1iBAjHXb57CDoANu57daT+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd1SEmza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd1SEmza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A030C4CEF0;
	Tue, 12 Aug 2025 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024210;
	bh=awJDRcdCgaTe8R30AvBtaxYs5t0z9rZbXtbpC5BGPCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd1SEmzalIyUUW01jiFGsvri7swCeUUB8rfXQrAtLqQRcBCf+hRdvVxKRv3w662hG
	 GmdrRI5aQrRpVkrEwmpDCKVcUl+t0oC1zycRyWn2tP1wkIet4DkECELTdAoKy7xuD8
	 sZm0YiSFGR8AI7IqGUdGOkZsfdgNm44BEWIj31HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 305/627] crypto: s390/hmac - Fix counter in export state
Date: Tue, 12 Aug 2025 19:30:00 +0200
Message-ID: <20250812173430.915737575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1b39bc4a703a63a22c08232015540adfb31f22ba ]

The hmac export state needs to be one block-size bigger to account
for the ipad.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: 08811169ac01 ("crypto: s390/hmac - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/hmac_s390.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index 93a1098d9f8d..58444da9b004 100644
--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -290,6 +290,7 @@ static int s390_hmac_export(struct shash_desc *desc, void *out)
 	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int bs = crypto_shash_blocksize(desc->tfm);
 	unsigned int ds = bs / 2;
+	u64 lo = ctx->buflen[0];
 	union {
 		u8 *u8;
 		u64 *u64;
@@ -301,9 +302,10 @@ static int s390_hmac_export(struct shash_desc *desc, void *out)
 	else
 		memcpy(p.u8, ctx->param, ds);
 	p.u8 += ds;
-	put_unaligned(ctx->buflen[0], p.u64++);
+	lo += bs;
+	put_unaligned(lo, p.u64++);
 	if (ds == SHA512_DIGEST_SIZE)
-		put_unaligned(ctx->buflen[1], p.u64);
+		put_unaligned(ctx->buflen[1] + (lo < bs), p.u64);
 	return err;
 }
 
@@ -316,14 +318,16 @@ static int s390_hmac_import(struct shash_desc *desc, const void *in)
 		const u8 *u8;
 		const u64 *u64;
 	} p = { .u8 = in };
+	u64 lo;
 	int err;
 
 	err = s390_hmac_sha2_init(desc);
 	memcpy(ctx->param, p.u8, ds);
 	p.u8 += ds;
-	ctx->buflen[0] = get_unaligned(p.u64++);
+	lo = get_unaligned(p.u64++);
+	ctx->buflen[0] = lo - bs;
 	if (ds == SHA512_DIGEST_SIZE)
-		ctx->buflen[1] = get_unaligned(p.u64);
+		ctx->buflen[1] = get_unaligned(p.u64) - (lo < bs);
 	if (ctx->buflen[0] | ctx->buflen[1])
 		ctx->gr0.ikp = 1;
 	return err;
-- 
2.39.5



