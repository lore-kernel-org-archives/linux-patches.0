Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3521FCF5B;
	Fri,  6 Dec 2024 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496776; cv=none; b=qkWLTG5Gl8lzlzpdUXeYIJFWldfzta8Q57EZx4a7AP1R6EDVkDum1PW/QHVPhWSF4eP56mHrBggdr/fLFGJTHRET+OEmrGPbnBHR42dUuUqDv2rKq1wNUl7edMz+adfBjNWrCYhjSVa4S9eGso/UN/nG8/2juKCixAJZditF5PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496776; c=relaxed/simple;
	bh=NG4OoVtCqUvlakHoByPEFTnVye0tYQTn7Oa7l1eiTLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLxOE7yOW+9ipM2aFewxUIQBSvzsFLXmLg85cuGWYaMO1UxJktcltJK1c87h5R3oO5Wgmxf0A9HalZHWIuPRkwZ0XlH5rW/Ad37a4dE3qp4yp1lnd5R+jFXG/b49EHLeXx/gr6P0A7aUxvXAaUlyF5uH2ECYRoDo2BpwvfxTGkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0i4ZAeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0i4ZAeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EB6C4CED1;
	Fri,  6 Dec 2024 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496775;
	bh=NG4OoVtCqUvlakHoByPEFTnVye0tYQTn7Oa7l1eiTLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0i4ZAeMhsTi91Okl0fni3leCsp0Wv0mAJZlQ6Mjadkyz7JT0uLGVnlkWvhCmKjPi
	 MBj0ZG6/i3v2MMmrHZeMlMwlJ/gUUfHyvzLMUdMkux3PSAz7FRUbfgfRxucsGj0yOQ
	 VDE7is72NdPLLejm9bx2BxaE3ZRkRfBtLiQm9F+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/676] crypto: bcm - add error check in the ahash_hmac_init function
Date: Fri,  6 Dec 2024 15:28:39 +0100
Message-ID: <20241206143657.263626972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 689be70d69c18..1d1ff3b1b0d5a 100644
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



