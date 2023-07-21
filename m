Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF458200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C342C433C8;
	Fri, 21 Jul 2023 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966128;
	bh=9wUHqV2X2sdeCrpS+UNSLmXXTqCaWp+y1iS0yra1TFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux3p7ESpKhheZ7iQE8meTjPGixRRlf70/K+zi0bbObw6auAis8wr9BPGO//rVNpzM
	 a7TRIKwgo+oW2NS7/hTsK4/nGO4lAYbeJ8fyTnCRn+gQDmBTQyvjRQO7p0woVs1N3H
	 4UN4SiZvJeNpo6SBtARfeg8vzGG8bW54UKlqYKzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/532] crypto: qat - Use helper to set reqsize
Date: Fri, 21 Jul 2023 18:02:19 +0200
Message-ID: <20230721160627.113979947@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 80e62ad58db084920d8cf23323b713391e09f374 ]

The value of reqsize must only be changed through the helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: eb7713f5ca97 ("crypto: qat - unmap buffer before free for DH")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 94a26702aeae1..935a7e012946e 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -494,6 +494,8 @@ static int qat_dh_init_tfm(struct crypto_kpp *tfm)
 	if (!inst)
 		return -EINVAL;
 
+	kpp_set_reqsize(tfm, sizeof(struct qat_asym_request) + 64);
+
 	ctx->p_size = 0;
 	ctx->g2 = false;
 	ctx->inst = inst;
@@ -1230,6 +1232,8 @@ static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
 	if (!inst)
 		return -EINVAL;
 
+	akcipher_set_reqsize(tfm, sizeof(struct qat_asym_request) + 64);
+
 	ctx->key_sz = 0;
 	ctx->inst = inst;
 	return 0;
@@ -1252,7 +1256,6 @@ static struct akcipher_alg rsa = {
 	.max_size = qat_rsa_max_size,
 	.init = qat_rsa_init_tfm,
 	.exit = qat_rsa_exit_tfm,
-	.reqsize = sizeof(struct qat_asym_request) + 64,
 	.base = {
 		.cra_name = "rsa",
 		.cra_driver_name = "qat-rsa",
@@ -1269,7 +1272,6 @@ static struct kpp_alg dh = {
 	.max_size = qat_dh_max_size,
 	.init = qat_dh_init_tfm,
 	.exit = qat_dh_exit_tfm,
-	.reqsize = sizeof(struct qat_asym_request) + 64,
 	.base = {
 		.cra_name = "dh",
 		.cra_driver_name = "qat-dh",
-- 
2.39.2



