Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AFC38AC92;
	Sat, 12 Sep 2026 09:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203938; cv=none; b=pG6vMytgegYxM/FQ1qhbpshknN+YO8CDfLN7XPe15JrJKBSTuYfxMVNQY5aCp5sYuEoVf9LHeet+No42uH798dYab2z6gv+/qxRGxJb36atM8q0XY200AvNwWYOue+CWEj5lNek1sQJIoED0OlzgXPEl+GssfbcPKjzcseXDq/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203938; c=relaxed/simple;
	bh=/GK96aKfdfJAbHHvMTp4w5bH4gvXbOwRWB4iTSm+lOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlTfZMNdSjEfs806B6DaXUfgyfJsOivWpWOWL0r7OBsoTduxYXgAnYIRoTCI/zImKGWc/G8sq5sayGC6qPvKfOH1DEL7L/VVjHBh9nS3IHD2xij8MNgm7vzSzOCfgoCY+q1povinqdBZOlWovBA8rsYuPaGwo1UC0g6WG4y/MxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeksJbmr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeksJbmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CC21F000FF;
	Sat, 12 Sep 2026 09:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203937;
	bh=QhKK4GbgepFIe/9kJli1kXs6DUiQWOAUOq/5xXxvZ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeksJbmrUkOaOegMbKeO+YLwefPGPlTW6H5XuES5OW//FIenpJaiPmHLo4c6L42Wv
	 yD+gZZd6MOITp1CjqpI5zhYBPbY0gtgy+B++LX2HPCb0Eecyn8FjYDkt5BDO9iSOJA
	 bAhGRoTVqZAlauXC+7xnzy69tgEnig0bhpyJ6fIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1467/1815] crypto: lskcipher - propagate errors from unaligned crypt
Date: Sat, 12 Sep 2026 08:53:37 +0200
Message-ID: <20260912065723.447357700@linuxfoundation.org>
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
index e4328df6e26c0..a79c9a246e5d7 100644
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



