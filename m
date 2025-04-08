Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDDD26A1BC;
	Tue,  8 Apr 2025 12:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116337; cv=none; b=VqT5LdGSq8RwSyz15s6a5USsS60TZGupH7po1x/C2vdKBDO5joCoYWCZyHcpPrDu/gUjohuRVAGWqJGqVXLhVLN9IhmFjAtlN3MFLjhFh3qoaO5xvNaBiVSwd7XrRdP44wC0xVaLotD31FRDr9cFGYsWg6l8ERCHKQ1rPg4WaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116337; c=relaxed/simple;
	bh=sAAA+S8RvrxULllvjYtmBVo73iHVvsya5K4JYDiMPhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vsb1Clkqnc+HL/7RUXWtdpXpzWL2HD1VCOq5lkvmDepvY/44Mm1pTLUyRuKN5kHNSItKyft++TbPJPE8az2/Ti/kZu+RbUArf68oonjZ+NugYLevzFcmCkDaVBkoaQoBuC8Lij8vuYvjTcWl9X0VODWAqqzCc9EG+3GLtttDdiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1aup2XP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1aup2XP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D14BC4CEEC;
	Tue,  8 Apr 2025 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116337;
	bh=sAAA+S8RvrxULllvjYtmBVo73iHVvsya5K4JYDiMPhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1aup2XPSNfspPVtx1ORcjOagcsNAKvwEEC3SxLp23287tWsw/9CPkxuOQl49pWwQ
	 sUT3JwVkD5xTkjMDJEV0dMMzSmT9P/zP9JiAu9axg8EV9+OzoRHA3sQ/ChdeO5d1YT
	 7TYU9E3yoZ1kfuQ8MY1VyL8ogdX9qVEMdPn70mu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/423] crypto: hisilicon/sec2 - fix for aead authsize alignment
Date: Tue,  8 Apr 2025 12:47:10 +0200
Message-ID: <20250408104848.159016232@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wenkai Lin <linwenkai6@hisilicon.com>

[ Upstream commit a49cc71e219040d771a8c1254879984f98192811 ]

The hardware only supports authentication sizes
that are 4-byte aligned. Therefore, the driver
switches to software computation in this case.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index a9b1b9b0b03bf..ff9ad7f02cefe 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -57,7 +57,6 @@
 #define SEC_TYPE_MASK		0x0F
 #define SEC_DONE_MASK		0x0001
 #define SEC_ICV_MASK		0x000E
-#define SEC_SQE_LEN_RATE_MASK	0x3
 
 #define SEC_TOTAL_IV_SZ(depth)	(SEC_IV_SIZE * (depth))
 #define SEC_SGL_SGE_NR		128
@@ -80,16 +79,16 @@
 #define SEC_TOTAL_PBUF_SZ(depth)	(PAGE_SIZE * SEC_PBUF_PAGE_NUM(depth) +	\
 				SEC_PBUF_LEFT_SZ(depth))
 
-#define SEC_SQE_LEN_RATE	4
 #define SEC_SQE_CFLAG		2
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
 #define SEC_ICV_ERR		0x2
-#define MIN_MAC_LEN		4
 #define MAC_LEN_MASK		0x1U
 #define MAX_INPUT_DATA_LEN	0xFFFE00
 #define BITS_MASK		0xFF
+#define WORD_MASK		0x3
 #define BYTE_BITS		0x8
+#define BYTES_TO_WORDS(bcount)	((bcount) >> 2)
 #define SEC_XTS_NAME_SZ		0x3
 #define IV_CM_CAL_NUM		2
 #define IV_CL_MASK		0x7
@@ -1175,7 +1174,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
-	if (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK) {
+	if (ctx->a_ctx.a_key_len & WORD_MASK) {
 		ret = -EINVAL;
 		dev_err(dev, "AUTH key length error!\n");
 		goto bad_key;
@@ -1583,11 +1582,10 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 
 	sec_sqe->type2.a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
-	sec_sqe->type2.mac_key_alg = cpu_to_le32(authsize / SEC_SQE_LEN_RATE);
+	sec_sqe->type2.mac_key_alg = cpu_to_le32(BYTES_TO_WORDS(authsize));
 
 	sec_sqe->type2.mac_key_alg |=
-			cpu_to_le32((u32)((ctx->a_key_len) /
-			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET);
+			cpu_to_le32((u32)BYTES_TO_WORDS(ctx->a_key_len) << SEC_AKEY_OFFSET);
 
 	sec_sqe->type2.mac_key_alg |=
 			cpu_to_le32((u32)(ctx->a_alg) << SEC_AEAD_ALG_OFFSET);
@@ -1639,12 +1637,10 @@ static void sec_auth_bd_fill_ex_v3(struct sec_auth_ctx *ctx, int dir,
 	sqe3->a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
 	sqe3->auth_mac_key |=
-			cpu_to_le32((u32)(authsize /
-			SEC_SQE_LEN_RATE) << SEC_MAC_OFFSET_V3);
+			cpu_to_le32(BYTES_TO_WORDS(authsize) << SEC_MAC_OFFSET_V3);
 
 	sqe3->auth_mac_key |=
-			cpu_to_le32((u32)(ctx->a_key_len /
-			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET_V3);
+			cpu_to_le32((u32)BYTES_TO_WORDS(ctx->a_key_len) << SEC_AKEY_OFFSET_V3);
 
 	sqe3->auth_mac_key |=
 			cpu_to_le32((u32)(ctx->a_alg) << SEC_AUTH_ALG_OFFSET_V3);
@@ -2234,8 +2230,8 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct device *dev = ctx->dev;
 	int ret;
 
-	/* Hardware does not handle cases where authsize is less than 4 bytes */
-	if (unlikely(sz < MIN_MAC_LEN)) {
+	/* Hardware does not handle cases where authsize is not 4 bytes aligned */
+	if (c_mode == SEC_CMODE_CBC && (sz & WORD_MASK)) {
 		sreq->aead_req.fallback = true;
 		return -EINVAL;
 	}
-- 
2.39.5



