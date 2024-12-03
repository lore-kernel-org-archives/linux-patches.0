Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76451F4704;
	Tue,  3 Dec 2024 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236467; cv=none; b=vAJVG73gbRO6TNb2Xy5vQcn6ITNRP4DUsbDoZ3aRdBSN7/j67vqclylDx9GLCgU3O6sBuiS+wswKcGcQQvH8/NpGJVTLN7991OTvoqbCbBEdLzlzH9xJmJIhXf67lfPzZb8HgQmA2zpg4ovzSIn1NoJAKFsixfxgE82XU1uDDws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236467; c=relaxed/simple;
	bh=J2bEWlbxF0iFM0DAbZ1HPRu6loGq9VASk5nR4fdg/9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XM+LaONRY3fN7azt+luqIFTFFDh9qCdlJkk1jr0zwMH7sT5adp3YYTdcvGI4CfuHhQvB0c5gZsE2etJB9YDKaZpl/9UdZ9oOUSNmNpBl3wcW54bHeBqC/gk6VmIF1PhsJyfn4ISGvKuoy9J6+Lkwpm1VSwNpcM1+7KMMXrePwwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHvYKXld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHvYKXld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0DCC4CED9;
	Tue,  3 Dec 2024 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236465;
	bh=J2bEWlbxF0iFM0DAbZ1HPRu6loGq9VASk5nR4fdg/9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHvYKXldFcKxnIWGtueCfrpOoPEa5g403/uRcyI0emjL9e94FQr13iUX8JRj3whlQ
	 KE685klZ3uDiuDBWnCnabhUSBnuZcobLdOcszXTpO5JvDIkZ9C2wDCcJPOXlwGN5bs
	 gN8ECSKUiVYGDeUzpEqkDozKTfYIM3tGexxs8dwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/138] crypto: bcm - add error check in the ahash_hmac_init function
Date: Tue,  3 Dec 2024 15:30:56 +0100
Message-ID: <20241203141924.588567308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 19630cf57233e845b6ac57c9c969a4888925467b ]

The ahash_init functions may return fails. The ahash_hmac_init should
not return ok when ahash_init returns error. For an example, ahash_init
will return -ENOMEM when allocation memory is error.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index c63992fbbc988..4349961982cc9 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2510,6 +2510,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 
 static int ahash_hmac_init(struct ahash_request *req)
 {
+	int ret;
 	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
@@ -2519,7 +2520,9 @@ static int ahash_hmac_init(struct ahash_request *req)
 	flow_log("ahash_hmac_init()\n");
 
 	/* init the context as a hash */
-	ahash_init(req);
+	ret = ahash_init(req);
+	if (ret)
+		return ret;
 
 	if (!spu_no_incr_hash(ctx)) {
 		/* SPU-M can do incr hashing but needs sw for outer HMAC */
-- 
2.43.0



