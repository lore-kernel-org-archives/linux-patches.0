Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C5D1F4709;
	Tue,  3 Dec 2024 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237979; cv=none; b=XxrG4IFQGaBCvnfV3V9XCdUhYCZXlIP7VMAZRnqm6qyeDlvnV0VKi4xRQFo8Ed3Gt+/OgSOHasSexyIECgVjY7zpu/UBXYHOor1QS532hCwCs5rkESDrR45EKMJp6j5dLJQf6Pp0djquf7H8MAXKYBSMZ9aDQxaVXLUmIhkgVb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237979; c=relaxed/simple;
	bh=j7tgS2RjnBN5Y2Vd9RuMBCEc+ZFyNwe14gY5r2haIuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3OrYSLfV6rULWH/zlUy2qEIBXZzQKRtV9/ZgGgCXei5ivj0V/IH5BdEKBrsVnDczkt5Gwrb5sEY1/nRZTqN8W2TGs1Ktw2guQdfMcaBTFUwPse/xDRtvSC6vKvbzfQ13d9ZTYXWdGijpZjcjKUG9N9pg+Pw5RbRp1DS/XevRTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASqwdT1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASqwdT1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CD2C4CECF;
	Tue,  3 Dec 2024 14:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237978;
	bh=j7tgS2RjnBN5Y2Vd9RuMBCEc+ZFyNwe14gY5r2haIuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASqwdT1rWdb7Jcbux83S3c+l2wJXaY7bL3Buavd79kX9oCktULHdKOgNeDyXdZ8WX
	 sVXJug/WhWH8F/LEMvWOe7BPpN07cU7JiLanVdymDwCN6JL/T4W/3l/JRJL96W7gRF
	 Ivm0n6Yg4JPj6jxy2e+kSis8laN1C/+420PRBGAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 123/817] crypto: bcm - add error check in the ahash_hmac_init function
Date: Tue,  3 Dec 2024 15:34:55 +0100
Message-ID: <20241203144000.516451796@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1a3ecd44cbaf6..20f6453670aa4 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2415,6 +2415,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 
 static int ahash_hmac_init(struct ahash_request *req)
 {
+	int ret;
 	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
@@ -2424,7 +2425,9 @@ static int ahash_hmac_init(struct ahash_request *req)
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



