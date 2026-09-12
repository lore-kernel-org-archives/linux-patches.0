Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B061343893;
	Sat, 12 Sep 2026 09:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206398; cv=none; b=PiFNHFG/ne2E2epMIKUsssE+9cBFtbVtR7LWXwNONlrwQFPx5hvGKVneFGtoRrqkauvm2Ij7+fnHvmXtrvsLGLthLJGxcbEd/J73bHWGbd8JFH3i1PLMrBB4eiKcIZN8aWlHEGBdBK2aZoqibTIFrA6Ic6cXlHHS3GR6fF4Lvc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206398; c=relaxed/simple;
	bh=UwGTS5s9ZmM83947/9pq2xHKMQ6eRZKPw3/ck1d4kGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fml4wykXH0s4jODJ7arZoZQNp6Zi11Ny1GF3KP11dtK7BcyiPOcDzKG7Sr31UMMLWbwMBXoEQkc6Qtl6TuO+9ihAhnBa+cpldSDcWl6JynadbvOkAfTLfQHaFFcgjLNINjwnxN5pmTUS6bzRYXdxKH4b3thSGyMeZ0Rk4APWDAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVSX3aoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVSX3aoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA4C1F000FF;
	Sat, 12 Sep 2026 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206396;
	bh=xCeDZEQnzwmEYV+8P9QbOIa4JC9Y81XflzyAvfrxipA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVSX3aoKAhcbNPlWfTbvqqhZi42KKDpj43+kWUmA6WGOZ/shtPRoDgDs9er1zAodY
	 uRcdmFYy2LeDE5XmeEgm7L+7eQ7qXDicORRwCpbBSFjy38BaKrPDtvRKCAe2o1II6d
	 X67iDW7C2Su61jNOPu1JEsPdn+mzQMoCtuCgVvoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0200/1518] crypto: qat - clear AES key schedule from stack
Date: Sat, 12 Sep 2026 08:39:29 +0200
Message-ID: <20260912065628.012966333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



