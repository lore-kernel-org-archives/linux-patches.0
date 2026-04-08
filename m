Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402B732A3FD;
	Wed,  8 Apr 2026 18:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673748; cv=none; b=S6F+PILtjJMNpStLrX8k+XqPFCluzyugYm10q6TkoAcAEh22YKxVKRQbeZxb94eWiWznbPWqzZXMOFk1x6xjIm0RsS8gTvO+0v5HYQPylZCP881GtspNLZRBT8pSBdwyvxyCt6nZHWVkTGBMJOfFDJKm9VIGmXmqf0jwbcSg3jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673748; c=relaxed/simple;
	bh=MJRX5jtGZqkPxkORI1Z8gbepOkBmEuDZQllDaZO1H/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RWs1YSICKlAlXkRdxmg0dcbFlaKWhePowwZ5zh5GhW65CoUGE8UtdZlUhOymADJkHFOeMRDs+Bbj1C/70BFLAc7YKtojdH2fPwdlOLw9aJHYAFWVAs5jZHhtGQVppPq9Y041tmmtLirsrFzVHdSqvjhQDjdLFsvo5WOdxfnbVZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wgf+r9D4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wgf+r9D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93F4C19421;
	Wed,  8 Apr 2026 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673748;
	bh=MJRX5jtGZqkPxkORI1Z8gbepOkBmEuDZQllDaZO1H/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wgf+r9D4Iyt6ITKHnuxIX3NY2vTgO5kSbZEfJpjBwCVpTB0PpsqrXOrtXdkyt+/Rt
	 UjohCgdx17x4bgbFDPpTv64iGS6QFpmDJq672YbbhNiDTaS14aeLajoJdCaYP+2GAs
	 0xmyE72cFZw2pUgwrxyg0hmsl/UARIEJyMsedcv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Bunyan <pbunyan@redhat.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/242] crypto: caam - fix DMA corruption on long hmac keys
Date: Wed,  8 Apr 2026 20:01:22 +0200
Message-ID: <20260408175928.647320990@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit 5ddfdcbe10dc5f97afc4e46ca22be2be717e8caf ]

When a key longer than block size is supplied, it is copied and then
hashed into the real key.  The memory allocated for the copy needs to
be rounded to DMA cache alignment, as otherwise the hashed key may
corrupt neighbouring memory.

The rounding was performed, but never actually used for the allocation.
Fix this by replacing kmemdup with kmalloc for a larger buffer,
followed by memcpy.

Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
Reported-by: Paul Bunyan <pbunyan@redhat.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamhash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 25c02e2672585..053af748be86d 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -441,9 +441,10 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		if (aligned_len < keylen)
 			return -EOVERFLOW;
 
-		hashed_key = kmemdup(key, keylen, GFP_KERNEL);
+		hashed_key = kmalloc(aligned_len, GFP_KERNEL);
 		if (!hashed_key)
 			return -ENOMEM;
+		memcpy(hashed_key, key, keylen);
 		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
-- 
2.53.0



