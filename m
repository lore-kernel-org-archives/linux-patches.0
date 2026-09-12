Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E75F457E7A;
	Sat, 12 Sep 2026 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211504; cv=none; b=dG11TpOYpYwu8WPs+trvl9IHNkIlY5mfQOB/qE1tSFYB0GgTT2Ast6MNLWB21g98/z3MgxfWzaBwxUbvUzPjMPNzjH9T56+BzPYLWTBq6AXRol80tVl0uLg49B7/KVCEPB6kPtmTOefwLhsHlIzQXuWzdToUR/bIr9pR1VTlZtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211504; c=relaxed/simple;
	bh=iJfEEN99PdS5i0HqFAxLEeZL7TL9m+szeXUfAFM1pXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgqrBxdTrMu36pA3XXRNnvKP99KCEY/JgsFG1dKytmNmbBnUfXSOBdwqnWC0DE9GFrzBZDCyRfutbQNiLocwlDoHaPaVOjx8+4sr4wQU4tPTxrkFbqLRoZUuE6n8w9xuLLBfLyMJZs2IYx0ZyEYbiyJ3CxoZV3hOqXOUwQbCYsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW3HgelA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW3HgelA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204B01F000FF;
	Sat, 12 Sep 2026 11:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211503;
	bh=pnTMefDqdQKn64fkq3Q/EmDCeXO4Onxam1QzWoK/jvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qW3HgelAW1eHcpAghVaVqH1U09/6SNC959wBAJy/1rM793Su3LQtjfIhOnyRr+ftI
	 ABbN+MbfwN8dxKm78eSrE2sRsAkr2GaDak5bBQV7ZftU4Cx5P99VLUOBZ1T94kOpU9
	 HH59zd3dwXoBQpujBddheGMB0uMjmS+tngN9YSCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1201/1518] crypto: lskcipher - propagate errors from unaligned crypt
Date: Sat, 12 Sep 2026 08:56:10 +0200
Message-ID: <20260912065650.653699301@linuxfoundation.org>
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
index c2e2c38b5aa8d..091761d6ca0bf 100644
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



