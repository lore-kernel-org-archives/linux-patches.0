Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787512153FA;
	Thu, 12 Dec 2024 16:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021932; cv=none; b=VSIGs2E0ppTTU39ynRScMrhVuE0/GOvQIeNj/Fa+hzJjHLibCVOrPnoVgseYuhKf5mH/u0zlSeMO+N3I52rv27Z2F8hvsj1Hdr2BduVaktKgTUBRADxTg4Dh+GJKqvbZTaVm/9EOLd8MR8B4y3fkG0VCpbQo9JTiqRf3BQcYppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021932; c=relaxed/simple;
	bh=ZtVHVnl7MsilfKwYE+s18UG0n8CQeAWKtQtjdPNpgiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJHKp83/uZia3UPtCfqCxmNk/a5zk3o8Rz66UHAMqlscpjDP2OryrBnq2D6712AwCUnE1O/VF+b0Qy208K7mehvz+f/lj7KZ8y0oQQMPios0aDB6pOvwGlZuWO9552/3gEWJy+8AG79o4K6eiPpZLPS61NbuhZJf8/sBXZm4+sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkLzEEoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkLzEEoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7D0C4CED3;
	Thu, 12 Dec 2024 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021932;
	bh=ZtVHVnl7MsilfKwYE+s18UG0n8CQeAWKtQtjdPNpgiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkLzEEoKQDjhlOBlzRmQPFj+pzl2fOkpdb8PLJaOHrWzVtTdRVQs3lgCsBVv/XuIl
	 F4sRRpkBf/0jYyRbtbZTBX29fFoKcd0CWFFNNkZM6I7Pt/31LjTPFU9ZN0bnSUKn8j
	 PwyvQUgmnmV+YpQweNJReaaw9IdJFdW/0YWEIBKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/565] crypto: bcm - add error check in the ahash_hmac_init function
Date: Thu, 12 Dec 2024 15:54:57 +0100
Message-ID: <20241212144315.515742503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 053315e260c22..e86b268d42f32 100644
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



