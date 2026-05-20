Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53532F0C62;
	Wed, 20 May 2026 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295238; cv=none; b=TnjsV5NfK/+7PzZOiNMBkRAVEfVLYzcsMBLnffIOCc4fS1Up7WXecTY48/CI17rJAbiDEsqJ4iQq07miZQGOpsa/JqnTPDcgC2I24ylema9TdCIC/E0gAuwLRmoGWAz/sUT7E0lgVCbZ+9WCwa+3RINt4aCbWmGcDNajGlasj8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295238; c=relaxed/simple;
	bh=ymF8jMN+rgIW3jVZJTYVkmBle5XF9rYUEPxNV81VsTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+1mcE59zaWCZbmbtpOYrdJXsx0G/vuaQThE1bYmviZXRDQ4xzgB8nvgRtqao9sTYPLtJFoA4XvjrE7qkaXF+kYlHBJeQS/WGviFwNo/6CUAFaH1bTKlFn+jLUafX38n1vfTODrGblSATpavDYqeKWzuXq6yi3GOHLQHbBHARTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtzeckDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtzeckDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262941F000E9;
	Wed, 20 May 2026 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295237;
	bh=Xuqs7OTAxYOyQ759RMCIsoVlOwyfLhndpTtuKkRu6Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtzeckDipN9K+AngBslk4oKl32UUGQ7VhXHSblRtFJUx91ZyaV1SpjIAnw4zwXg93
	 kxZFmSpWjVzK5taKEQnA2y334EJlP/vgJBlGZpbQQtyUKri6Dzm+xlsQ2GUq2Id5Kd
	 P/nMlIal04IuqWVKLxytmbNOh4kWvoMLGCWBCSaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Atwell <atwellwea@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0303/1146] crypto: simd - reject compat registrations without __ prefixes
Date: Wed, 20 May 2026 18:09:13 +0200
Message-ID: <20260520162155.065670704@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Atwell <atwellwea@gmail.com>

[ Upstream commit e0ce97f781c78b717b00493630a9e34caf04f79b ]

simd_register_skciphers_compat() and simd_register_aeads_compat()
derive the wrapper algorithm names by stripping the __ prefix from the
internal algorithm names.

Currently they only WARN if cra_name or cra_driver_name lacks that prefix,
but they still continue and unconditionally add 2 to both strings. That
registers wrapper algorithms with incorrectly truncated names after a
violated precondition.

Reject such inputs with -EINVAL before registering anything, while keeping
the warning so invalid internal API usage is still visible.

Fixes: d14f0a1fc488 ("crypto: simd - allow registering multiple algorithms at once")
Fixes: 1661131a0479 ("crypto: simd - support wrapping AEAD algorithms")
Assisted-by: Codex:GPT-5
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/simd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index f71c4a334c7d0..4e6f437e9e778 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -214,13 +214,17 @@ int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
 	const char *basename;
 	struct simd_skcipher_alg *simd;
 
+	for (i = 0; i < count; i++) {
+		if (WARN_ON(strncmp(algs[i].base.cra_name, "__", 2) ||
+			    strncmp(algs[i].base.cra_driver_name, "__", 2)))
+			return -EINVAL;
+	}
+
 	err = crypto_register_skciphers(algs, count);
 	if (err)
 		return err;
 
 	for (i = 0; i < count; i++) {
-		WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
-		WARN_ON(strncmp(algs[i].base.cra_driver_name, "__", 2));
 		algname = algs[i].base.cra_name + 2;
 		drvname = algs[i].base.cra_driver_name + 2;
 		basename = algs[i].base.cra_driver_name;
@@ -437,13 +441,17 @@ int simd_register_aeads_compat(struct aead_alg *algs, int count,
 	const char *basename;
 	struct simd_aead_alg *simd;
 
+	for (i = 0; i < count; i++) {
+		if (WARN_ON(strncmp(algs[i].base.cra_name, "__", 2) ||
+			    strncmp(algs[i].base.cra_driver_name, "__", 2)))
+			return -EINVAL;
+	}
+
 	err = crypto_register_aeads(algs, count);
 	if (err)
 		return err;
 
 	for (i = 0; i < count; i++) {
-		WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
-		WARN_ON(strncmp(algs[i].base.cra_driver_name, "__", 2));
 		algname = algs[i].base.cra_name + 2;
 		drvname = algs[i].base.cra_driver_name + 2;
 		basename = algs[i].base.cra_driver_name;
-- 
2.53.0



