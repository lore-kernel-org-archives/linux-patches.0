Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2132BCF4C;
	Sat, 12 Sep 2026 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238316; cv=none; b=YlEX757Jgwwtu7YCks1Ebc3+NDbzHFa4ZokpgfnAHBz803ol+vODwbqUuwj2n8sRQzFctPXpNvU3usOiBOQhmiQAQY5h3CJbDnfruY6JkyTP2PF1NCfEGID7br4iFYIfhXPR1nS41L8LskA66F6PjW/1wGarQc4vSLVNlcjVmg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238316; c=relaxed/simple;
	bh=ycjrSXOXOCVS6ffQwSADpw25IbImGSIACT+Jk3SOJHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/kkm6kYUZGorzEGmlp0XHnu/iJHL8KkJZp8gVwrRi5swaIwfNCNEx4dOCCKsDthHmiNPfwA3El9SaAmgUZ7iC+IetoNYV+HBW4Euor2sAs3onX1mdhHaipKL23dAfZFZ7WW7zS096yN8urG73UYrsK+5ojvxaXn/ZqtM8oTXfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pJjqneM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pJjqneM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF93B1F000FF;
	Sat, 12 Sep 2026 18:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238315;
	bh=JYG8rQ9ADwybTdzdJf7uX1oDsuz/mq415Q86CP2KGy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pJjqneMeNmNIou9yG0kDkKGgF3JItQQ1xotRx4HEld33eqC5IGno5FuECzLgjIn3
	 ECqENRHVnZbHwlhZgQnNPVxYdA5Puzm8oeEswwjAoFNwSMii6wh5s/hkn7bwynDgM0
	 WyR2pnxmMcBmlnLZ5J8z5raKFyeZr/ZiyPd3Oz0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/935] crypto: qat - clear AES key schedule from stack
Date: Sat, 12 Sep 2026 08:57:46 +0200
Message-ID: <20260912065536.830273972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/qat/qat_common/qat_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f56ee4cc5ae8b..695800cd689d7 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -481,6 +481,7 @@ static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
 		       AES_BLOCK_SIZE);
 	}
+	memzero_explicit(&aes_expanded, sizeof(aes_expanded));
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-- 
2.53.0



