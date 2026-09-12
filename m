Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36103AFD15;
	Sat, 12 Sep 2026 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203933; cv=none; b=GGyff6yKrAeeptQnZR5A7NShiCK9XFfCiRCHgiHs36N0ePl5hSbJDPBSDT0QtoTl5//JddEAmLpHFYAd8VJXBtC9I+Ex53yPoWBuzSvGHSUSBpLkXYPpTuD4lgWXXRJYq4xS/NOnazVJ411EGnatSPznTEVDJm1ryQO28VpB868=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203933; c=relaxed/simple;
	bh=BZ4x8FNGT+FzOeLXJva7xoa+HXC6oIY/tvDm1iRj3iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCQcp3xrYzfmWuc3Whhd81/lSDfzC+HyNSort3DOI5dy9KLqq/ApYQURUcaVLsGwiPudmOEZlybGsxRbUC1AuqRPlcl7iBAHwdf5+C5oRWLtuGtIJuY571LL1A8UXGVXuhuCRRl9Nt3+sLopPKVbRsONIHpgqr4OfGU5cHnH5UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7JGjeoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7JGjeoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7A51F000FF;
	Sat, 12 Sep 2026 09:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203932;
	bh=k6UaQ7yaS7OjIiMGi91UwhdY2co3H6ek4z50Ei6dd+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7JGjeooLUcL9Lf7TDH6wSx0r0AjVnVJ5JxZ7fzoUL9CfTIbipYTxgLCRvaRD9V6B
	 8FRDyqUeqp20Fq6BxebiRakcAP+AXGdRmv3NhCZpdruRSCxqOs9yBynl1Ks1q1VC6F
	 Lbl5i7VzxUJ1+0OQPjhtRmxb3sXMLXpawQOrrREY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhushuai Yin <yinzhushuai@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1466/1815] crypto: hisilicon/sec2 - fix CCM algorithm long packet failure
Date: Sat, 12 Sep 2026 08:53:36 +0200
Message-ID: <20260912065723.424694633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Zhushuai Yin <yinzhushuai@huawei.com>

[ Upstream commit b82f60be50c87b3d75e207852c5ca74fa18f66cf ]

In the CCM B0 block the message-length field Q spans L bytes, where
L (cl in the driver) is derived from the cipher IV flags byte as
c_ivin[0] + 1. set_aead_auth_iv() hardcoded writing only the last 2
bytes of a_ivin with cryptlen, implicitly assuming cl = 2.

When cl = 3 (a shorter nonce yielding a 3-byte length field) and the
packet is longer than 65535 bytes, cryptlen no longer fits in 2 bytes.
The dropped high byte made the auth IV built by the driver differ from
the one consumed by the hardware, so the software/hardware comparison
failed and the CCM request errored out.

Write the last cl bytes of a_ivin in a loop driven by the IV's CL
value, so the length-field width always matches the algorithm
configuration instead of assuming a fixed 2-byte field.

Fixes: c16a70c1f253 ("crypto: hisilicon/sec - add new algorithm mode for AEAD")
Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 77e0e03cbcab9..a7354fd10dc0f 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -96,7 +96,6 @@
 #define IV_FLAGS_OFFSET	0x6
 #define IV_CM_OFFSET		0x3
 #define IV_LAST_BYTE1		1
-#define IV_LAST_BYTE2		2
 #define IV_LAST_BYTE_MASK	0xFF
 #define IV_CTR_INIT		0x1
 #define IV_BYTE_OFFSET		0x8
@@ -1696,7 +1695,7 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	struct sec_cipher_req *c_req = &req->c_req;
 	u32 data_size = aead_req->cryptlen;
 	u8 flage = 0;
-	u8 cm, cl;
+	u8 cm, cl, i;
 
 	/* the specification has been checked in aead_iv_demension_check() */
 	cl = c_req->c_ivin[0] + 1;
@@ -1720,15 +1719,16 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	 * the last 32bit is counter's initial number,
 	 * but the nonce uses the first 16bit
 	 * the tail 16bit fill with the cipher length
+	 * When CL is 3, the tail 24bit fill with the cipher length.
 	 */
 	if (!c_req->encrypt)
 		data_size = aead_req->cryptlen - authsize;
 
-	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE1] =
-			data_size & IV_LAST_BYTE_MASK;
-	data_size >>= IV_BYTE_OFFSET;
-	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE2] =
+	for (i = 1; i <= cl; i++) {
+		a_req->a_ivin[ctx->c_ctx.ivsize - i] =
 			data_size & IV_LAST_BYTE_MASK;
+		data_size >>= IV_BYTE_OFFSET;
+	}
 }
 
 static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
-- 
2.53.0



