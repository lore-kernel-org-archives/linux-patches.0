Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA3F18C344;
	Tue, 10 Sep 2024 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964688; cv=none; b=vAQ1MsQ3ORI53OGUDXO9GjDrUZdD1IbuR1rL6lDbK5QUjBQg0jehSTlfCcSIoKWTow4uRvcVKFVVBec/iqIIyD8pb7aOoyfTD1uK2sW+wxRc6kMzGvXAqLaXSGYcONXBbn+5QERyPHV06SJA9Mh7Z1HQpshrTZoBTl7j1Yi6oqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964688; c=relaxed/simple;
	bh=vLsvtNQTyLhy/hLdSOQPs4jU1Me6tIK+vuuHXRLb/2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng4c3d+FoSHa64z9FJA7h0ySXzgq7OrfBiwVxYqicA/qUjrLZ4ovY2N1AL0S/vmWQ0MvJw4wqzv8zranL0ZBGFEre2sCgmfhmhSfXc1tvktBMjlZJ7GmBgllDvvI0mdDE+bP8qd4oIIdEoxxh/OI8hc26A8msTSPHMDpPABcYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXKNItIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXKNItIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4655DC4CEC3;
	Tue, 10 Sep 2024 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964688;
	bh=vLsvtNQTyLhy/hLdSOQPs4jU1Me6tIK+vuuHXRLb/2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXKNItIvfOVIC4oLkdFGOLPzOmRWBMTiCcXib16I787Ei3svDnp7xHH7J/uRr4loi
	 WDGuI3LUVUVOAgAP20LUD/D9VJk6ZwMieiTw/C4lH2585yd11IRJEfrLIEPZZgJrgq
	 kC+3TAQxeg6l7dvsrE5+cTx2JHoAtxwnOFP9x/HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/269] crypto: starfive - Align rsa input data to 32-bit
Date: Tue, 10 Sep 2024 11:33:48 +0200
Message-ID: <20240910092616.449533773@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

[ Upstream commit 6aad7019f697ab0bed98eba737d19bd7f67713de ]

Hardware expects RSA input plain/ciphertext to be 32-bit aligned.
Set fixed length for preallocated buffer to the maximum supported
keysize of the hardware and shift input text accordingly.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.h |  3 ++-
 drivers/crypto/starfive/jh7110-rsa.c  | 12 ++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index fe011d50473d..f386e9897896 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -30,6 +30,7 @@
 #define MAX_KEY_SIZE				SHA512_BLOCK_SIZE
 #define STARFIVE_AES_IV_LEN			AES_BLOCK_SIZE
 #define STARFIVE_AES_CTR_LEN			AES_BLOCK_SIZE
+#define STARFIVE_RSA_MAX_KEYSZ			256
 
 union starfive_aes_csr {
 	u32 v;
@@ -217,7 +218,7 @@ struct starfive_cryp_request_ctx {
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
 	unsigned char				*adata;
-	u8 rsa_data[] __aligned(sizeof(u32));
+	u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ] __aligned(sizeof(u32));
 };
 
 struct starfive_cryp_dev *starfive_cryp_find_dev(struct starfive_cryp_ctx *ctx);
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index f31bbd825f88..fbc06f8ee95f 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -37,7 +37,6 @@
 // A * A * R mod N ==> A
 #define CRYPTO_CMD_AARN			0x7
 
-#define STARFIVE_RSA_MAX_KEYSZ		256
 #define STARFIVE_RSA_RESET		0x2
 
 static inline int starfive_pka_wait_done(struct starfive_cryp_ctx *ctx)
@@ -91,7 +90,7 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
 {
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
-	int count = rctx->total / sizeof(u32) - 1;
+	int count = (ALIGN(rctx->total, 4) / 4) - 1;
 	int loop;
 	u32 temp;
 	u8 opsize;
@@ -274,12 +273,17 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
 	struct starfive_rsa_key *key = &ctx->rsa_key;
-	int ret = 0;
+	int ret = 0, shift = 0;
 
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
+	if (!IS_ALIGNED(rctx->total, sizeof(u32))) {
+		shift = sizeof(u32) - (rctx->total & 0x3);
+		memset(rctx->rsa_data, 0, shift);
+	}
+
 	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
-					rctx->rsa_data, rctx->total);
+					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
 		key->bitlen = key->e_bitlen;
-- 
2.43.0



