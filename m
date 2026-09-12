Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C095447DF87;
	Sat, 12 Sep 2026 13:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218401; cv=none; b=h6PkmcBoFhIunO8Vo1C6gOIQRHmoDmDGmZI8XyMptJWeTDYeArNGrOXsa0OlFe4ic/ih1N66wxDHhe5np51pdYP6xBbGZs6brD3KX6mmqIY0ELqV+lDW8Idt6YPAD5QYb0sdgC+DkPGcSe2rMKLYnm5d2KTujxV+gPsQsY/Qx34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218401; c=relaxed/simple;
	bh=1oczGY6S0kyd8gpBbGiPWHGAQynFKga9yyARvWHYzsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFTpnJQjaGZa6rQLAQobJ46uIIQ5lCQn6XKOKzrUEwluc+POgKqCOGp/jIU+X+lMcRskzF2kC89eHT/MwolR/lcdYOKzY8qieFVX5m6tDOoFsNqSKHQPlHAgMLI5Ub/6qwTG72KB6uTwLsyf0QS+hfzCgQGWwSDY3PM7mnb/4gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmraXUQe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmraXUQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C546B1F000FF;
	Sat, 12 Sep 2026 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218399;
	bh=gb3RSJ2pK8R4cWVRl0oCr7X58+dHeiCYfL6NhDlx+vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmraXUQe8oBem+iXiOxujuxbPThTWXaQBixi7DAE6r19kxanUI6DdpeHNsZE5Wk8L
	 sf9Tm54UWD8yTYSMmNeiLpQL8fBtzvAaUXyG/spbm57hk3sUcmrdUtySYRSV3vzOzX
	 jkBxEiujqRy2s1Fp/HM/BIgeOZmzoqa3xxB6DUxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhushuai Yin <yinzhushuai@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1137/1376] crypto: hisilicon/sec2 - fix CCM algorithm long packet failure
Date: Sat, 12 Sep 2026 08:59:23 +0200
Message-ID: <20260912065632.901286538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cdd485fcbc5bb..760b2513db14a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -98,7 +98,6 @@
 #define IV_FLAGS_OFFSET	0x6
 #define IV_CM_OFFSET		0x3
 #define IV_LAST_BYTE1		1
-#define IV_LAST_BYTE2		2
 #define IV_LAST_BYTE_MASK	0xFF
 #define IV_CTR_INIT		0x1
 #define IV_BYTE_OFFSET		0x8
@@ -1465,7 +1464,7 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	struct sec_cipher_req *c_req = &req->c_req;
 	u32 data_size = aead_req->cryptlen;
 	u8 flage = 0;
-	u8 cm, cl;
+	u8 cm, cl, i;
 
 	/* the specification has been checked in aead_iv_demension_check() */
 	cl = c_req->c_ivin[0] + 1;
@@ -1489,15 +1488,16 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
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



