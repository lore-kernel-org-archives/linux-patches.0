Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77EF2CA2;
	Tue, 23 Jan 2024 01:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972174; cv=none; b=Wa6KIu6/llYIDoQJevZerbYjevVo+RB3FS6zV/XEuR5WRDUVtTP+gN095VC4w6TkPM+MfMRaDN+DQBVJX4Sw1Usje/Q3Q01HmP/B7F52XCPvdo2FBaXyM8wCV2aD+HFgDXZpsDetvb9KM3tvf/hkLkaTHXOJX23XiN0+MwdGtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972174; c=relaxed/simple;
	bh=+8i7QxRLihdHxk6waVs/xovbOIBJXb0a/u/mP1raGkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HucuEO14AuGDAvvkazOytfkfQdMr5x7zo3O/6tNRYABwclPpani/YiPrhSppT+5a4BYxLxIjJ7VyxnPBRcfUUU4ptc23UQLrb+JQT4l4xHb1yGHS4azF67ROLJSYeogwq7fKz8K0Dybxn0OLN0Nb3bzlpT5smRLV8J3TeCi7bMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpKNrjGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpKNrjGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E811C43390;
	Tue, 23 Jan 2024 01:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972174;
	bh=+8i7QxRLihdHxk6waVs/xovbOIBJXb0a/u/mP1raGkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpKNrjGOXiJoVkzW6z/nvBXsh96moHHEKd1eHdNUCSOcibujopmL7LQc7JOybJWc5
	 dCe5Ps5WNkbi61NkG9rShkJanOHu1MJeJtQ/51H9JvpEIR7E+o2c/KxOkxySqiccT1
	 grqliHDwIs4n/cKbbegqfr9nqJDTfkokFewbleVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/374] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:55:56 -0800
Message-ID: <20240122235748.080829920@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1f41c8eeb8fc..2b20d1767ef9 100644
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



