Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA513DEAEC;
	Thu, 17 Sep 2026 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666472; cv=none; b=WnqNnE2sMXYPfi1JfCpAlZ7RT7KNTPmjuZbP5ceM75K/mOYcXJc+TQm2Pw5I5WZXqnhkrIccIlYbGGnmSeB3WBdbIHbd2v3/CNk9gO6TZzvN+42qHYkQSSN6paRcxAwOJ1t631467GeoSlkUX7scajI0bpeG+Tfryj1hJmB5ba4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666472; c=relaxed/simple;
	bh=gSHf3Zdhr9kaDeHpffrz9QJVER7T1OkszzrTDLlxEj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR/pUXQ0Nqs0TbWV09hOQPSh6AGAzI22RytDiQi4mPq/hQE0ZQu7J/0ijOQe+xnE7ZvcfZ6rfLPg6vf6RUf/VgzyibWfuTw+yEcDQ0nAPAUYEgrSr8sjFKAKVZpO1rMijspPg1N+990Id8RN+rjN9nmyANHAkJQlY6eJQpYrVtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JE4yxas7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JE4yxas7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B201F00893;
	Thu, 17 Sep 2026 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666470;
	bh=drN3+afwk/bhYHQQBxOZTw3sPnYsZVttFDMmuqU+Tdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JE4yxas7Nmj4TjV5DJ/j0icOPkT0mB674dhMWWfBEusvV13e5IenGfJSzCgJ9oQR/
	 lzdR4mbN77iBE5hptw20Rexf9PadMMB8MHITS68wq2VR1lghL0lklDmWb4SDBWJp5m
	 ZuZyarKv7XkWjLthxMpouDim8NXUp99dHUXAl+hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1048/1250] s390/crypto: Fix wrong return code to engine in asynch callbacks
Date: Thu, 17 Sep 2026 16:14:03 +0100
Message-ID: <20260917151620.505540522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -558,7 +558,7 @@ static int ecb_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg ecb_paes_alg = {
@@ -822,7 +822,7 @@ static int cbc_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg cbc_paes_alg = {
@@ -1129,7 +1129,7 @@ static int ctr_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg ctr_paes_alg = {
@@ -1569,7 +1569,7 @@ static int xts_paes_do_one_request(struc
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg xts_paes_alg = {
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -935,7 +935,7 @@ out:
 	atomic_dec(&tfm_ctx->via_engine_ctr);
 	crypto_finalize_hash_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 #define S390_ASYNC_PHMAC_ALG(x)						\


