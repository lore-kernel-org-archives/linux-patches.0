Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9380D14900B;
	Tue, 23 Jan 2024 00:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969185; cv=none; b=FXctn0D0bQ2xaJ31Aa5s2nDkVpUjKyMqoGsFo/PqPDoZj/8aGIwrrL57o4tEzI47YRkzHau4Z6VwnJ1rX5Irlq+8TQSzXRAswgX4CPS725QQxkEcpijGEa+R00Jw8BpPSNKCX9h2h28EdZE+ThMSXxXKQAtn0BOdkowknBvYXQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969185; c=relaxed/simple;
	bh=2P7x1dLhpfLLYsOgp0X+o+1EEbfNWGkjyVUi6qo2N6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4C5LYeb1/wKWUCXBabC1nvvlD85Awp9Iuc3DPoVhKCxFbi17OT09RcTQDYo46wb7NngamunFn0ehMlLCPG1+W425K3rMCxpefPjJQvh1SgomMGOjPd6lvws07qkOiMSudSH/0u2SBL/rK2IK24xQBQSPrVnJLPZPvObdQphQKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVTCMwll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVTCMwll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BD4C433A6;
	Tue, 23 Jan 2024 00:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969185;
	bh=2P7x1dLhpfLLYsOgp0X+o+1EEbfNWGkjyVUi6qo2N6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVTCMwllUcsceXny48xNc7MUg79oxEGvN0NJG+Dm7TGixfWjSSl8yj8VVb+1n7Aqc
	 zG892uW8rn6sLQF8nhQweQchoO3cTc4FDWH/1JbE4q3MjwlGPmLF56iE2Zs20STSHU
	 RgOMTar24cj7JoFSpCbLwo+uZ10XLqCPOVyOuNz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 059/641] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:49:23 -0800
Message-ID: <20240122235819.916822633@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 888e5e5157bb..863171b44cda 100644
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



