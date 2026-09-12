Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038E12D5C68;
	Sat, 12 Sep 2026 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229077; cv=none; b=Cf/edn3h5HRxn8MVJTss89HPaxSOKY3YIgdHZR4mPaPwZZnyRQlXycXF60x7fdkDFjskDrijUV2/EQLA2pi+k6ySbzSjBTlfwgZd5fTwFtBCllebC+GhIlXeB8lFl6oz35ThLwgbq3cssccvzCciBn9Q0m6hB/zf3PQgaUXRsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229077; c=relaxed/simple;
	bh=b602P/pU79NDxaCitXNUisZLPFFgVQhTCD4skG8XvHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ck2h2Ch9QXCk7RpA33jjHov3bZO0hBa5qx94cCrFfktdHdCCvfhmR3x+d6DDwV2qoY67cIw5DAYO0g37VINPxkZTwLRCF2Hq1OZwVRwjMpcNMYjnL+5ukBIRAyLcloi0ZYYqWK1jmqvkEo73OBD3AEoKkeFiyvThVsF0Pr3MZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSNYuW2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSNYuW2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32471F000FF;
	Sat, 12 Sep 2026 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229075;
	bh=UZR2YSOqmdW7e9wWJTe1ysY1hbUhjvLlVYVABXudrNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSNYuW2N24t18ihYaTpF+iWGJyS91Fi/qZZNx35Ew5dosRQXNBydzg7DVxTTCvzWR
	 x6/iwtvQAHTJqDhLd1dYcTrIeOjIFsuWbjVYjs0sHLQ83kD3bGzrdBOUxHVTjDVq2Y
	 U17J8Fqq/JV76wT+UE8iXkS4s5+vZSuqRmpWuvMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0517/1191] crypto: qat - clear AES key schedule from stack
Date: Sat, 12 Sep 2026 08:54:05 +0200
Message-ID: <20260912065559.860499841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b61ada5591586..1e3bc170bf2d0 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -482,6 +482,7 @@ static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
 		       AES_BLOCK_SIZE);
 	}
+	memzero_explicit(&aes_expanded, sizeof(aes_expanded));
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-- 
2.53.0



