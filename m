Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF30D472F66;
	Sat, 12 Sep 2026 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218406; cv=none; b=FMi1cBHsLsa/ITwc84DnjGBbJxCgTwa0B95mN6o4+kOFXVFaj6c2igucIqgEXP8HF2cpqpLFPxGvqlQpDIODijXhcN90qN9WoSQv7wKfTM0aMwSSWwztRLmMuZfCXIUuKCs0O2Um8Q8fiIxEMnGBEDU9TJNMbfHSaCfzNTX8gow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218406; c=relaxed/simple;
	bh=oTI7dWyVf/CX58Et4SzE7aG6CfXVGZ58NqIS57viF+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKhmYL+lNI7+tdcU1Ae5G0HoKMQUGNWi22QCJmNY0DsZ8AeCi+Jv65/mv5sZax6t0A3emtR1g7qkk7IYKiXFPikWAV3mC2S+1c871twcC22n1gr/x2rFKHfJibINEBbTcgSoWCBgmWSGsp+tu3K8TmIdX89/lo+vR5hsQbI0GPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pT1fQYPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pT1fQYPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E4E1F000FF;
	Sat, 12 Sep 2026 13:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218404;
	bh=kEvopTLI+1yG2c+8tmZrgyvPUA4QTtJGzN8eU4gQUiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pT1fQYPBOnKi5bXfQP5nmXSbHOOUqLD9oztb5oPGAVpUPRGiPzM0kaVjX9jYGdv11
	 0Yx099Shw9lRMi5qVaKgZkzLzkoL2yYrWpWM2M2NXc1KMynZ2rUIwJfFV+B0QfFoS8
	 DxCkxJlyIag8hXhiA7JdKR9G8PS6Hd0tMdw6CYSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1138/1376] crypto: lskcipher - propagate errors from unaligned crypt
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065632.922819819@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 7537036a2e6fe96f8ed82034f755c54714a0e417 ]

The while loop declares a second err variable that shadows the outer
one. When the crypt callback fails, the goto out path returns the outer
err, which still holds the -ENOMEM value assigned before the successful
allocation check. The real error from the cipher is discarded and the
caller sees -ENOMEM instead.

Drop the inner declaration so the callback error reaches the caller.

Verified with a test module that registers an lskcipher whose encrypt
callback fails with -EIO and calls it through a misaligned buffer.
An unpatched kernel returns -ENOMEM, a patched kernel returns -EIO.

Found with Clang's -Wshadow.

Fixes: 31865c4c4db2b ("crypto: skcipher - Add lskcipher")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lskcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index cdb4897c63e6f..b4537be3b2a8c 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -95,7 +95,6 @@ static int crypto_lskcipher_crypt_unaligned(
 
 	while (len >= bs) {
 		unsigned chunk = min((unsigned)PAGE_SIZE, len);
-		int err;
 
 		if (chunk > cs)
 			chunk &= ~(cs - 1);
-- 
2.53.0



