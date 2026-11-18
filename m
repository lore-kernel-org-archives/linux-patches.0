Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039636;
	b=Y97px7Jv/tZjCzpSAOuNIP6mcUl6y6Ozfob7eqiol+f1L4cnPtVTmGal0GQzuzrjJcwB
	 rNg7+q4vLbQmqYLYfFx53b6VhAdDvnmjbnY9rIvex03NCzg0m+OQzlbUTjiXcROOr4z3L
	 BQdoxyRej8tqpCmolfaxxivD/kG7LYiXg5zV7pLq9ULuSpO+zqn/4J7YbdC1cDX/+Rs9m
	 4mu9vXtii382JMG3dXMuNtmFq/D/tXLMGW4jMdyPDNvykd/o9P71dCeujcLaV0NmmwTxR
	 R1rk6cKX09JthlxOWRM4OFEW8YHs/tNsbr3au83Q/b/4kzcoCCCJDHapnm90UP77JsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/PDmjLex4hJWBIzqrQw3EUNkmxnEEZuQrTKY9xrQXlw=;
	b=U0HNPDFhY3FVwgJ7TYsio7suiQvFbwjhp/OUJ62m0R6Gy/yMP1cYxCUqPS1ll8vsS9Z0
	 r/l8h3fDyoaL0ts9mIDDgN09crNCif/8rWEtE8hlx4wsP9A6RoCOCpQ+s9JQSwOxMDgm4
	 rtM4dWn6XeEi8xJNTzq/4qFozvbnm2Aa2h/aijB7fI2AZvuQXgBMDCDzE0EK3ktzGtZxT
	 JuOI+LP5pwdQcL8Gn9JMdgaOeUTrLzZBzr8aECxgZYFo96fXBUI4r7RgqdpXQptjGBLHY
	 74f7IwW9rhH1Ys5bjORTZT6WpJ02NFYcdolGAYvEHVM8KhESu8eFOTeKzvQUNjbGvow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PaX6pEcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40043606A31C;
	Wed, 18 Nov 2026 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PaX6pEcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FB61F000C4;
	Wed, 18 Nov 2026 22:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039636;
	bh=/PDmjLex4hJWBIzqrQw3EUNkmxnEEZuQrTKY9xrQXlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PaX6pEcmYGng5uLV26ejIwQA4MlT73sHMfafHUrceg+vh/3daVc3HQ8mNbMMTh2GS
	 Rb4ZMvOra7OmSgMYXafVi9uaGu7bgn0is7+Ay7+x9rhoINuPZaF/t+axipvYGGdvMR
	 nRwqDCGq0Qin1xBkNd67qNkKVPMu3Q4In39Xqr6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2170/3318] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:46:32 +0100
Message-ID: <20261118150427.089944540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit ac508238898058f0b09b18a7891fb31279617781 ]

The logical AND operator uses short-circuit evaluation: the first
operand is always evaluated, while the second is evaluated only if
the first is true. Because the first operand dereferences a pointer,
it may cause an out-of-bounds access before the bounds check in the
second operand is evaluated.

Resolve this by checking the vlen prior to the pointer being dereferenced.

Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 4437c3a5c6dd7..fc0613f37b7e1 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -934,7 +934,7 @@ static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -965,7 +965,7 @@ static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -991,7 +991,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1014,7 +1014,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 
 static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



