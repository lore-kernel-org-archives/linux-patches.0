Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5232612A17F;
	Tue, 23 Jan 2024 00:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968892; cv=none; b=Zt+JRqIxrfenEQW/rKGCIPgjn2XmOpGu6JCsEwLw2+eTgCUPX9bahAaDQPEJwVARtlKVBzbH5FLlkfjpDWCDcoutrPW0Q54hbWTOGq+wUeNJb/xgHnMXjqK0V/Q6tBH8OCKuyYGcmoSecy50wHQDQ/eTTdKJuDB6M4Mtu9ApHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968892; c=relaxed/simple;
	bh=YLvg66x/ICkxjXinu8DR0Sjao/gspXQ2vyuQFKx5zrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH/eBPnnVxcNnlfCQk+ZYNcARCnETzQVOHUyYfOUAIszPda9DjBksk+X9Pdd48LOdZEtyaW3LiMHZcBNsuew5YZQxyyKzWfFRUiIkuL+PpdMF7yMIEt7h8zAZxGNHr+Zd3/DUrOhGOq7aAmu/l28EMOet6kaa5WgY8BDGt/AYrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F03GG4as; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F03GG4as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9849C43390;
	Tue, 23 Jan 2024 00:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968892;
	bh=YLvg66x/ICkxjXinu8DR0Sjao/gspXQ2vyuQFKx5zrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F03GG4as9OAKAaH2xMoAPJ05+oMAvsup3ez/+LJMCEhrfblB+c8lCn21BRQ1aA5yY
	 tSZTOB1oCAs5IVfzAmBOM0GeYe3taW8aCx3YOoN0AJWLvL93zLWtIJfJiDvsboMK4G
	 f8LSPGU/FFPMEsHcvSQRwcAGfkzY1gLUlXiG3bU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/194] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:56:36 -0800
Message-ID: <20240122235722.035271045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e44dd34f8559..b48f92c8cd0f 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1031,7 +1031,7 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
-	if (req->result)
+	if (req->result && rctx->last)
 		memcpy(req->result, rctx->context, rctx->digest_size);
 
 	return 0;
-- 
2.43.0



