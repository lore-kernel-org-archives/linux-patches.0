Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A902F205E24;
	Tue,  3 Dec 2024 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240255; cv=none; b=VI2UkWPCParZkDZSduvIgElbHxEYYaG/qI3iGPhpX/JIkdD3KiMrZAclRh3i0riyllwRLhUNGq+1Deo4t26BSzBzylw9DDi4S3p4FVtblCdc6OlBrHqDIx+lbBOx2GbTk5pyYHFFSMycSNEB0hqJ8Hl74bAwlhUi6kvgbhHht+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240255; c=relaxed/simple;
	bh=xFgJ/gNdD7+MvSJZWxI2TfeI82Z3z7QR0de4SMG8Q8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH+ewpRXM5D7/U9z17KCDP4+fPB8glYvy70hNKSUTgByROfIk8nPGs/BRPn41UpsLu5AIKXmINPDU+Mg32umkF1vEuA1s5myimgFliGSj2rz9VNvJ3w+vZmZGSeFES07IASfkrn/o9VdCyWNwsRc8kScsx9OLftEgGO+B+TBA3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxIv0MJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxIv0MJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B723C4CECF;
	Tue,  3 Dec 2024 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240255;
	bh=xFgJ/gNdD7+MvSJZWxI2TfeI82Z3z7QR0de4SMG8Q8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxIv0MJhhJqoamXV//A5rfM1wSDyR5RVuQDuqgJ8Z0PrNT3oFzEPHvC2Xc0rC6aY5
	 Jv6MUwZYxkhjy9FfaKBC2ezEyvpm1e8cK0yxmkQTpDzobQQYviDxOR8T+FFwyaozjY
	 xMig0LTP8mS5TBLWEDXMG1Fk5PZxy5Ii3f9Tycyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/826] crypto: bcm - add error check in the ahash_hmac_init function
Date: Tue,  3 Dec 2024 15:36:44 +0100
Message-ID: <20241203144746.473682279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



