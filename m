Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113DA384CE9;
	Sat, 12 Sep 2026 07:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197711; cv=none; b=p5YcDZzFTpMGSSfH+KkGc3ZNnZcAhudUiShAd2JaoZHg6DFZ2WHP770yIvCZ1E94EBl1I/0/LwiOSrBCzwynSMs1PHqM4uGbDD0ZtVm3CjLwwYec/mOHPftm5s9UiKEAbzPIqOwKK3EU9SGGv4qxmB6MjOz34Rnw5Tl3rPrnuw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197711; c=relaxed/simple;
	bh=YVX8VSaL+WEQxlJ7/m9F5c/Fxs9ytpouSZdzJty0pok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAI+cLRl58vfc4tAfKnxqOi4RLgAsRyX4rQU35NQ7+BB9PiDYW2SU0Yh8OP/7B7mV+9R7jOp61wKFhneT3ajjCZKxTiTYfmb4DC8keT3pXOn+tjVtdLmHaKwcafNZX4FnLe06jME6RyPJv9WFLXIQlKKMra0o/NV7YH/U9KjM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUinfy7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUinfy7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464661F000FF;
	Sat, 12 Sep 2026 07:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197710;
	bh=luhnABOaTRcCJ1mw5Naz/iq6ts7NjAPWRtV+JPbemeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUinfy7WRsf4WN6C0gNYIC8bZC35tGK/8ePttUf1Z0AGJFzv5P7zdA6jJZqSUDmJ9
	 sk5Sq8W44aMO+85dV9/iOa/8eh+sbOccmsTUnT7yrSdhNUN4+NBOxn/Z65za17MszJ
	 hlIqUNUpcJTsOPzy2TkNYJRxrufhy5aa+6dpgw/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0189/1815] crypto: qat - clear AES key schedule from stack
Date: Sat, 12 Sep 2026 08:32:19 +0200
Message-ID: <20260912065653.440848083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7f638a62e3ade..91663805d9e60 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -405,6 +405,7 @@ static void qat_alg_xts_reverse_key(const u8 *key_forward, unsigned int keylen,
 		memcpy(key_reverse + AES_BLOCK_SIZE, key - AES_BLOCK_SIZE,
 		       AES_BLOCK_SIZE);
 	}
+	memzero_explicit(&aes_expanded, sizeof(aes_expanded));
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-- 
2.53.0



