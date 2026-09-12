Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364693264F5;
	Sat, 12 Sep 2026 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222902; cv=none; b=lLAARuvul+E/E47VfEvhPYhN2n61bl+tPlGARx5/BPwnKJkpAyH/QKoH8emu++8TOlcsXFpDIKnhRf5q/OhhXRoz1kljBsJ3CEB6Zu2Oyl+2fgvyXBHS+W0FJ9VxHqA2c+0Qq4ELRQkIIjNadtFgUf/c5Tves8YIcbrdRONKEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222902; c=relaxed/simple;
	bh=g8Nt7G5gfqmadQnQS45RZWSM160tFJdZff+rj2vTcDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxTCJ7YmRibmyvDxHwhmkedEYTgPEUsVffT6J2cW/8b9WSOi8exgEXjyHa7wgbFk1hFqux0NU5pwlJ3KnoSDBJfdjIiUvs8xCEKoj7aCwPfcGwga5sW+JKaXX2yegACSMHPmO/JBFDqGBjIqEfWu3Pqhb/mprvDT+/4DNhDP5ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpmSaQOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpmSaQOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B841F000FF;
	Sat, 12 Sep 2026 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222901;
	bh=LI+mQyTGZilbqpm5ktJF0N1Aw/h+dnCRSF4Ra06W6vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpmSaQOR4eeLjA00jV3H+RsyQbp0J/5pcyCHbS/V+kPXcvuCyhKyUH1ZPaVwkZUn/
	 wHnQ1vATu0px8c6OT5+Fy1/2B/jw/urCT+HeCgJ7hUJE4MC0SsJ2AtFI7ecr54dZL8
	 HCqnq2TnhiONl29dxnm+iLDfD/QdxtivGbCNIA4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0637/1424] crypto: qat - clear AES key schedule from stack
Date: Sat, 12 Sep 2026 08:51:09 +0200
Message-ID: <20260912065621.555432063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



