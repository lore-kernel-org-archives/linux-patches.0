Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20263644DE;
	Tue, 16 Dec 2025 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887928; cv=none; b=AdPWDlZXoUP0XVwPcuzZBxk/IuIvW8wi5XnmFlNelpdrIAXIkVHzYV4Oq5jwDLwgQChO8ITxorsGaTr3GNV2K9yqEwjE6bOizxc0qxxtJzXGaH/vQYwrkiMRqSrO4Y/tH3kZURLf75hlmHS2Y57MQNpogTK4h3jxS/sjBs+awVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887928; c=relaxed/simple;
	bh=P9UB1EniCeihzb6XPdzyUzIYJzjyPLZQjHsVcnyow6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2/PARt2im74Fw7gCZta1O4O6lkfy85b0AgYpXIrbsoOFlv4zYtes0D2eLlo6+XYGu71jt6f0N55nC845LTctiodlO9ZJDh7Tuh7BKn1JGqV/zTkX2RwJx6ZYMfVb5w/R1It1Bwbqtmk0+P9NPBUyBCtqAMRFbrfuCopR59Vf0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tp64vMaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tp64vMaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3359EC4CEF1;
	Tue, 16 Dec 2025 12:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887928;
	bh=P9UB1EniCeihzb6XPdzyUzIYJzjyPLZQjHsVcnyow6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp64vMaSntS0qzgPQOJ2NLcIhWkZQupqTWY6P76PqvbK54/5z1cULriXkiw9L0QRw
	 aJv+pZkbLiGjAkN2mC2Tw2y+3jv9KRreuTSf8IK0i/yDHr9up3p5t598kv/f0+6SKt
	 IOG8E64yyUKT3bV3pf3aSw09X/M1sqWJFnEevbfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/614] crypto: ahash - Fix crypto_ahash_import with partial block data
Date: Tue, 16 Dec 2025 12:12:26 +0100
Message-ID: <20251216111415.092869111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit b0356b75f42fde15d4be268c5891f2cee6eb65bf ]

Restore the partial block buffer in crypto_ahash_import by copying
it.  Check whether the partial block buffer exceeds the maximum
size and return -EOVERFLOW if it does.

Zero the partial block buffer in crypto_ahash_import_core.

Reported-by: T Pratham <t-pratham@ti.com>
Tested-by: T Pratham <t-pratham@ti.com>
Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index dfb4f5476428f..819b484a1a003 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -661,6 +661,12 @@ int crypto_ahash_import_core(struct ahash_request *req, const void *in)
 						in);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	if (crypto_ahash_block_only(tfm)) {
+		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		u8 *buf = ahash_request_ctx(req);
+
+		buf[reqsize - 1] = 0;
+	}
 	return crypto_ahash_alg(tfm)->import_core(req, in);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_import_core);
@@ -674,10 +680,14 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 	if (crypto_ahash_block_only(tfm)) {
+		unsigned int plen = crypto_ahash_blocksize(tfm) + 1;
 		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		unsigned int ss = crypto_ahash_statesize(tfm);
 		u8 *buf = ahash_request_ctx(req);
 
-		buf[reqsize - 1] = 0;
+		memcpy(buf + reqsize - plen, in + ss - plen, plen);
+		if (buf[reqsize - 1] >= plen)
+			return -EOVERFLOW;
 	}
 	return crypto_ahash_alg(tfm)->import(req, in);
 }
-- 
2.51.0



