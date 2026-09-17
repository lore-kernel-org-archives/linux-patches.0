Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED9F4ABBAA;
	Thu, 17 Sep 2026 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660524; cv=none; b=Mo5xQNVWzKoYBwewlnNM0makgBMiHbCezOa62QUtaXFtdnxldJMdegvkjYGkcKto41BhgvYsR5RceqqfT9A3kLMN/hJBxPDn/BWVF9KfuRrKj4HwFTbzUZtK4899n74iVKbYHAS3KeqBxRUT6W+yqXSJK4o6V4JlhImaz9d4sSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660524; c=relaxed/simple;
	bh=4D5H1SFxafWXNqD7srnrqW4jG94ludvG/3qERsWRxgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0HJhCZWMrk+D2gp2aeLZceCqsjiQcJoN2ijoumRZvYwO3AIwybDfFtuWfwd+jMdtcMu/UlZM2V8c/yHdWFd9pRo8NJRuiGrXWGbrjRNUgg1SRyw8WDR0km1//wHdKeLREQxvGJEEJqHZSxqr2TLFfF86CJq3qOCAg/9vSzkLxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIjn2+un; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIjn2+un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4238C1F00893;
	Thu, 17 Sep 2026 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660522;
	bh=RRF/gmNmH48dHG+/nTd7p0YIJY7sG1q2ewYoBf3sua4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIjn2+unJWKOvIuwiAaJyAxfUbY286brt96uiv8nEYFLid6w567hveD82eMxJ6lT7
	 GlumInHfAtnfsF4iK/4ccYFu1aRQxXxdoM6CDYWNrZVUuLGU4c3VA5nQPWjXk+AH6u
	 8eF8/ZmcshdqLOnME8qJmI69YK/T2jDSujN4IwIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.2 581/733] s390/crypto: Fix wrong return code to engine in asynch callbacks
Date: Thu, 17 Sep 2026 16:14:49 +0100
Message-ID: <20260917151406.876450015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit ac1481320110b803ab9b79ab4d2ca11a74fc05f2 upstream.

When crypto_finalize_hash_request() or
crypto_finalize_skcipher_request() explicitly completes a request, the
do_one_request callback must return 0 to indicate successful
handling. Returning a negative error code causes the crypto engine to
assume the driver failed to take ownership and triggers a second
completion via crypto_request_complete(), resulting in a double
completion. This pattern occurs in paes_s390.c 4 times and once in
phmac_s390.c.

Fixed in phmac_do_one_request() and all four paes do_one_request
callbacks (ecb, cbc, ctr, xts) by returning 0 after explicit
finalization instead of propagating the error code.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/paes_s390.c  |    8 ++++----
 arch/s390/crypto/phmac_s390.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -568,7 +568,7 @@ static int ecb_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg ecb_paes_alg = {
@@ -835,7 +835,7 @@ static int cbc_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg cbc_paes_alg = {
@@ -1145,7 +1145,7 @@ static int ctr_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg ctr_paes_alg = {
@@ -1589,7 +1589,7 @@ static int xts_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg xts_paes_alg = {
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -945,7 +945,7 @@ out:
 	atomic_dec(&tfm_ctx->via_engine_ctr);
 	crypto_finalize_hash_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 #define S390_ASYNC_PHMAC_ALG(x)						\


