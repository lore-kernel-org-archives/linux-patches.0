Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD9A3AEF51;
	Sat, 12 Sep 2026 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214804; cv=none; b=BqjhViF2OQeA94ZLgc+utAS5Red8jXXY/ySiHJc17zfEs9rLLzOjxBfFdIJ+xlhzijmNtNhTNWAtbWR15tm8nxG+W7C+qtzF9nvnqM+GGtU7h9QQYz+CBeHikT1TgWhDJ+wYi9W/w1GJBt5HP9F6N41Km+Hu9t3Q6V8QFvFm5HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214804; c=relaxed/simple;
	bh=u4b2f7h2SsMji802vorvHbK25ouB1EwWRDk9lz2VcTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5or2Qf/vLqWlR5nn1qEr4ZPLGdVnYBclefTGR/GfprC3l6/sqOxZGc11pEntfefxsuVIkHBsfyimZdA0KlEqhEB2HCsV2yxksiljiVxVRWxLDgu2i5T1zH55r1sKiW9Vj6gKxmQthSJA4AsUZR/ZuGX3GyRLDAJ1vGeZXHBWDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oO1xj3sa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oO1xj3sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A71F000FF;
	Sat, 12 Sep 2026 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214803;
	bh=7D04iBd19XWsDX/4D8BHdlDjiilH1bNcxzaV3qPFTNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oO1xj3savib1hpZvbO6NULZThVnnR8iRTyv8R0JzUxJumuHTwbrvMzGuRVNCiS7T5
	 +Aw2mYwpwJbHsGXzs3kZf6rJHNjDAQMve5c5o6b2Zg5D8nJEhCDUyr46G9tTLlwzcX
	 Hb3ehxDGBuY0k/QYTSbWYHeBnP6dhHjvVKkYoZsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0401/1376] crypto: qat - clear AES key schedule from stack
Date: Sat, 12 Sep 2026 08:47:07 +0200
Message-ID: <20260912065616.480249083@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit d41a9fcfb7f9ee36e4a4aaf5e7996bca6be1e7a9 ]

qat_alg_xts_reverse_key() expands the forward XTS AES key on the stack.
That schedule contains key material and can remain in the stack frame.

Clear the temporary crypto_aes_ctx with memzero_explicit() after the copy.

Fixes: 5106dfeaeabe ("crypto: qat - add AES-XTS support for QAT GEN4 devices")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index d69cc1e5e0239..274bcc83a1fc2 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -481,6 +481,7 @@ static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
 		       AES_BLOCK_SIZE);
 	}
+	memzero_explicit(&aes_expanded, sizeof(aes_expanded));
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-- 
2.53.0



