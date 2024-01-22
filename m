Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCEA2940A;
	Tue, 23 Jan 2024 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971107; cv=none; b=ewT6ReTF+vLIeRDhGRg3ol/jfnyCHTBhOv6WGfUZ97zIzN9+wMLY14M8lCEqCNVsySgGfCPEETfERd/8v2Xs94IyyhivHj1dN1xcwjnaSJpxTfnJYOZQ8jW4IYzAtyuzI2irQXQOAh3tvjMLMK2ekCgS991TNF6CEe9ZeAOBXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971107; c=relaxed/simple;
	bh=APgeTZxuXDCenUxD23Jc1RBV5Y7nfCZSQfUpuVDWl5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgup4AGGpIfxp0X903idrCXp4APwAOg5KZmN6NyADPNKALmdhjqsL3ZQS8dTv+JQwEGM4xydogevIcanBTS4tQ/vuNPWX8nVVYcrD3mdrDssDAh5CxmEFMdkUdDStMnNzmgOaDrq3sbMbPPjojA/js3z0A8ShndgNGdZl1ZRMY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBStRmk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBStRmk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92C4C433F1;
	Tue, 23 Jan 2024 00:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971107;
	bh=APgeTZxuXDCenUxD23Jc1RBV5Y7nfCZSQfUpuVDWl5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBStRmk+5023MzYjGCNNKjJAEjEeweP3IBRHOtZObmYE4nmIfBq5QWeIeQuKQCxJt
	 bA1dCe+AtVmMGGrvCThVSNFUokydHia1qBnD/lZJjEITl97plDfjlcFGi/fnUVEvA0
	 /vNhqUQlDhOu/EGGx3YokD4ThkLsJysRp8bVWP+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/286] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:56:35 -0800
Message-ID: <20240122235735.455188630@linuxfoundation.org>
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
index 0b6e63a763ca..2ef177680b2f 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1047,7 +1047,7 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
-	if (req->result)
+	if (req->result && rctx->last)
 		memcpy(req->result, rctx->context, rctx->digest_size);
 
 	return 0;
-- 
2.43.0



