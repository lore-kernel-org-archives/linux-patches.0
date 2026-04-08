Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6072937F01B;
	Wed,  8 Apr 2026 18:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672460; cv=none; b=iUE+k5NNVttdpAGUSHVIEla8HDe4cVluwsGZTSEYV/Hq1ykjKwMv5KM3mno7TzUMKh0sIEZLbYv7J31Cu9BFuTIHH8W/92Dflvi4UmgPRRQNnkDBx2SzPEw77lvrjYoMB6XH6m9MosUnaBiyHcDdBcgVkv26DDT/kXX0X3krnow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672460; c=relaxed/simple;
	bh=01my9KtNNP35ajPrnD5aBBN2h0/V5A8dmTXb7vySWXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vzgt/Ri31ljfAs2EsQesOdifpcybI5+9zo0IamMSe5IbgO0DnA5loyizvbiVNTpHVlrsqvG4tWbb9JXc3dDZDIIezcOfxEqfA2KMe4mafiwA0SgoSBX6bJFH7r+6T6RVsYBkRFk+LD0D7Vi8zkTuTKk6eg7R1OGvrjnDlUy1PUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw8gJPvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw8gJPvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA883C19421;
	Wed,  8 Apr 2026 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672460;
	bh=01my9KtNNP35ajPrnD5aBBN2h0/V5A8dmTXb7vySWXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw8gJPvbkjda0a6fUwM4umY7o0Y6Kv/JUfjFgQJ0l3nlpahpu/Bi1O8cU4Fqb6hY3
	 rPP3+vMPNStebU38DFrEZ3RJTvAtoiFTElzCqHochHQ7bUvgXBYsYqk1sCB7c3iFNl
	 PS/V1TUnHrWvM1AX4KGlFNfd4+LXFDvzGiSWot8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/160] crypto: caam - fix overflow on long hmac keys
Date: Wed,  8 Apr 2026 20:01:43 +0200
Message-ID: <20260408175913.803083450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit 80688afb9c35b3934ce2d6be9973758915e2e0ef ]

When a key longer than block size is supplied, it is copied and then
hashed into the real key.  The memory allocated for the copy needs to
be rounded to DMA cache alignment, as otherwise the hashed key may
corrupt neighbouring memory.

The copying is performed using kmemdup, however this leads to an overflow:
reading more bytes (aligned_len - keylen) from the keylen source buffer.
Fix this by replacing kmemdup with kmalloc, followed by memcpy.

Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg_qi2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a148ff1f0872c..06e0681fdbe15 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3325,9 +3325,10 @@ static int ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		if (aligned_len < keylen)
 			return -EOVERFLOW;
 
-		hashed_key = kmemdup(key, aligned_len, GFP_KERNEL);
+		hashed_key = kmalloc(aligned_len, GFP_KERNEL);
 		if (!hashed_key)
 			return -ENOMEM;
+		memcpy(hashed_key, key, keylen);
 		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
-- 
2.53.0



