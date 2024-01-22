Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8741852;
	Tue, 23 Jan 2024 00:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968224; cv=none; b=iPJkoKWd5nGrE0cgJdtdg9cy5sqzslbdoEb054vL1jd6d5SJ97o83u0TbBiwrIIwhhaeQwQ8zVes2jt6xkx7CMI0YyM5njXJZNOGXhhH6qaFdhlmU/johHlZEDP9L2Jy0D7pNHebqERs+3cNMY/NlGgrYaZoMEvQcpYFqT/3AcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968224; c=relaxed/simple;
	bh=c3qCkmRLfbzzR07JmOfbT+IZtCJUKNOL/qEQ8G02WEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwRK2LjJI0zWNwrL7jg6IS97R6myebWr6g/AwP8g7W28SBhwnLz+KWWkux8q6mCbLeRt6xCJZfY0HJWg5o0SeaIFRVCKNq4O1XXJPw8ykj/kBkfuGhvp+8ynKUzRtt79HNe7SORMYz6/ChYNmyr2cN7stwl3sNaLsuDfnirJYo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTAlIbYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTAlIbYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2365DC433F1;
	Tue, 23 Jan 2024 00:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968223;
	bh=c3qCkmRLfbzzR07JmOfbT+IZtCJUKNOL/qEQ8G02WEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTAlIbYYvZXbXdlZmOHE6ItDFLZZeE0Nrmo2nBzun91UfP45Dt3o0p+8UlJU3zHc7
	 ceO8UwOUlapmg24zSls4F3WP/nV4pwAMKkOslZGs3DFAyHL0CxbFH71YKIUdwa5Sp4
	 GHh1j9FqcUq2hOdN4BieiyPaHq5hq2bthjB49l2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/148] crypto: sahara - fix ahash selftest failure
Date: Mon, 22 Jan 2024 15:56:45 -0800
Message-ID: <20240122235714.415743719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5bd2c34a9ceb..5232e6a849cc 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1035,7 +1035,7 @@ static int sahara_sha_process(struct ahash_request *req)
 
 	memcpy(rctx->context, dev->context_base, rctx->context_size);
 
-	if (req->result)
+	if (req->result && rctx->last)
 		memcpy(req->result, rctx->context, rctx->digest_size);
 
 	return 0;
-- 
2.43.0



