Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473E4627E3;
	Tue, 23 Jan 2024 00:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971189; cv=none; b=pY1y/4J6nZmtXRfF9jSaZC954FFSYYO6KxtAzDuezyDVuwtg+vGo4vbCX5I6TMofmsEiVB34mXG38QZTU3wHAPuDXM5NYfZaPF2TpVpTW4zSnurxJRo9topMOxn5oWkNvXvz+PLRoH5BvzXdr82wW+6JYoifeKxMtPEH/gEBsFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971189; c=relaxed/simple;
	bh=7CwhQcKz7Gpwpjqwo8hjcDrBK4wbvslPI+QShvf+ztc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poKUub8ZHEh8fmzhW4+5RJaeYM3ySJyipit3HzNZGTeoLckxMDLtFZU+ts1iB1x3D862D36N/HZzrzr7ZRsA0+eArtEpyOeKTHeASCKI/heqabaeaAYaRmGtCmr1h1Vs7AZ9F4wox4NX2TxsEl3/4KROBAX9ripxw2EfM6+G2OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOFY+HfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOFY+HfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23799C43394;
	Tue, 23 Jan 2024 00:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971189;
	bh=7CwhQcKz7Gpwpjqwo8hjcDrBK4wbvslPI+QShvf+ztc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOFY+HfCh3gnoAqwfS8B3kA9ej1g2aINZRI6Oy/7agSw0x8ZDo4+FIiWfKCe4Bxgl
	 er4yK3vN+Efp2NiACGpa3yIKanW6Lsdymefa9w0942rtWfvUpajPmggoS9xBZ0+AS4
	 j6ht1wZQD67cqLI7ZnirrVg5gVOcKhlhwke7L3x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/286] crypto: sahara - handle zero-length aes requests
Date: Mon, 22 Jan 2024 15:56:45 -0800
Message-ID: <20240122235735.888835913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit d1d6351e37aac14b32a291731d0855996c459d11 ]

In case of a zero-length input, exit gracefully from sahara_aes_crypt().

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index b584dd086989..d6510e169c8e 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -676,6 +676,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.43.0



