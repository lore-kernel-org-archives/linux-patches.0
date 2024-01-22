Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B83984D;
	Tue, 23 Jan 2024 00:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970518; cv=none; b=gqbt3js7hSlW9j8bq+4A67JeaWPp6DSvmIXddLSWdUxhLdvSjdwSGMg55bPD+2+iE/zxb8B8DN9Dnh0waCnGjc0KAnklxlPW4KJGzPYNU+bIk1vXimOSMsFh8ufbtMsdWwXoQN1KFdBR6HFM/kiZx0J5FniahEE1wpyZ/M/uqO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970518; c=relaxed/simple;
	bh=SDORy2u3CAHHUKgTbtK/z/rwWoHs5y6xpGL+hXZDnRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzRIi2TwLj3f6X619fxkTpJPVVAeMsYlF7+c63GfXqR3l8TbmO0qUyyPOtCYSWxJ08IqJ4hEZm4lsC1G8lB8ZTqzemGCcReFRlyJLSXxfAVMQ5lfMTpD7QSrnmtPiajDp17/EEMlWtZoEG3a60jOSLQAQDTUFotl7pr861TrLpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CDejbGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CDejbGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F89C43390;
	Tue, 23 Jan 2024 00:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970518;
	bh=SDORy2u3CAHHUKgTbtK/z/rwWoHs5y6xpGL+hXZDnRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CDejbGname9lOLB8lSnF99sx6YNvYYd5Yl9p60NokSTgqO+VL2f7JqhjbW5NmeB/
	 N139hAqylvqkRFEj5V/3DJohJ6d/oS2EE4rqS1BjjoweMjWtRWUiXlF9PxwdZC+gp+
	 VUqculJLRdLVtRGlhbJrqm/3GmugYkydlFBBguSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/417] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:53:29 -0800
Message-ID: <20240122235753.061708674@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit afffcf3db98b9495114b79d5381f8cc3f69476fb ]

update() calls should not modify the result buffer, so add an additional
check for "rctx->last" to make sure that only the final hash value is
copied into the buffer.

Fixes the following selftest failure:
alg: ahash: sahara-sha256 update() used result buffer on test vector 3,
cfg="init+update+final aligned buffer"

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index aa9c45ff0f5a..5e0b26f36319 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1048,7 +1048,7 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
-	if (req->result)
+	if (req->result && rctx->last)
 		memcpy(req->result, rctx->context, rctx->digest_size);
 
 	return 0;
-- 
2.43.0



