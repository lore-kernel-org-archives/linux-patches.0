Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8C3472529;
	Tue, 21 Jul 2026 20:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664810; cv=none; b=VGvhTXRa9yNZXmzKbIaK5wYlMJfzRSDIiiCMbiwudr3vGlPgR12PShV4A8SroouXhhruwjPgPQeBS0BvszcusQVnY3KM1RHIyryGhz/RkzjkB7WSaXblgjYGFFuW33BbPvPdSzzlwUKEtOa9yglGOaYuXVRPexf+qV+SzYV+Cqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664810; c=relaxed/simple;
	bh=5sbvUyOQHdF0PrEf1z1nwqUUMu3S4bxPwAQF9lz/6AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1unm3LAKIJSPfiFOpiXIlVL/M2P4ZMMaDLctaMn6YFASCjoYAryTaIPjNeoXnrvZkGNeeTgj0/bTJx5+x0QwCHElS4GrmlRFKwtodFYgeCjNrb+uRQbEoPhm1sh07NVCEbkAtVE/vKbAcz2A/v68U61BJP33vVjoqIigBrPrag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QX4miyUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QX4miyUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E27F1F000E9;
	Tue, 21 Jul 2026 20:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664809;
	bh=cSxoABjYa/sWYNPLQ4H7kM7V2JQBvRyK0RyLDeKCnpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QX4miyUbPd2FZ0HSNaCVDsIjZTJaFVYMTyJZFj0ESDTzzn7Gf0owfPeW3/45HaCt3
	 tlNHHZNqoj3i/Wuelgut8v2GSWfaNo5XwXu2g6G2qN9VAnrAbSYJnMnRQNqdyK88SI
	 yZ30Q5bmVrLGSJu5hAkhHZbjyHj7y5w+qEo7QVwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0067/1266] crypto: talitos - stop using crypto_ahash::init
Date: Tue, 21 Jul 2026 17:08:24 +0200
Message-ID: <20260721152443.302083711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 9826d1d6ed5f86cb3d61610b3b1fe31e96a40418 upstream.

The function pointer crypto_ahash::init is an internal implementation
detail of the ahash API that exists to help it support both ahash and
shash algorithms.  With an upcoming refactoring of how the ahash API
supports shash algorithms, this field will be removed.

Some drivers are invoking crypto_ahash::init to call into their own
code, which is unnecessary and inefficient.  The talitos driver is one
of those drivers.  Make it just call its own code directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ca4fbd227bce1..a941ec08817eb4 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2119,13 +2119,14 @@ static int ahash_finup(struct ahash_request *areq)
 
 static int ahash_digest(struct ahash_request *areq)
 {
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
-
-	ahash->init(areq);
-	req_ctx->last = 1;
+	ahash_init(areq);
+	return ahash_finup(areq);
+}
 
-	return ahash_process_req(areq, areq->nbytes);
+static int ahash_digest_sha224_swinit(struct ahash_request *areq)
+{
+	ahash_init_sha224_swinit(areq);
+	return ahash_finup(areq);
 }
 
 static int ahash_export(struct ahash_request *areq, void *out)
@@ -3242,6 +3243,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		    (!strcmp(alg->cra_name, "sha224") ||
 		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
 			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
+			t_alg->algt.alg.hash.digest =
+				ahash_digest_sha224_swinit;
 			t_alg->algt.desc_hdr_template =
 					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
 					DESC_HDR_SEL0_MDEUA |
-- 
2.53.0



