Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A55D8EF;
	Tue, 23 Jan 2024 01:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974383; cv=none; b=bTnW3C6Pz8C89VVgAbU+SqBleB0sLEOQFJKpr56LwO5Hy0z7ihqxGWGbBlqVBxLX44QKmSBcM3veEmEsL1c0YUSjAobprkqSgX8/Shi6GjD6QI3QbSHtKb6RFayLpbX0jE+5giY6OBonussJeD9WMP9tZsx4ouLtmQSn7FjP0LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974383; c=relaxed/simple;
	bh=141h7cgToWFuyY+B+yOWr+P+iFF4wextq8bhHDj1d5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/Hyhvw+l9t26kVINbs16eCCiJ7NMnjFzGKpg0nRcPIiTTaspttrAyCdCEeyIPNM/Dl1xLa5///s+DnvJTKFDksY7ZP7G6TcW2xYfX7Jvk+iNUG2mWyQjvwoMLXhuK6cQQ1EOQfsKARjOwDmsQFab5pe6496um987ewBQsD1Z4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8rMySua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8rMySua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF93FC43399;
	Tue, 23 Jan 2024 01:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974383;
	bh=141h7cgToWFuyY+B+yOWr+P+iFF4wextq8bhHDj1d5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8rMySuatRWlOiTT1FTpIfkx0VwjPG+DRuTfwXHm0fEffpFR+6GNnfAw5x6D3B2aa
	 a/aCOPww6dvKmKaygk+XP4nDNWO2Ac6pUvXyoxYxHNejW74I+pt34pL19Y6ugZdkvU
	 ir3gddy9bWB2FQtxLdSoEbp9GWr578ce3GDFu0Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/583] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:51:42 -0800
Message-ID: <20240122235813.700848222@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 037a623271f3..2f8c81763bd4 100644
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



