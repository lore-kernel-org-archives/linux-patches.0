Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3EF337B81;
	Wed,  8 Apr 2026 18:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674363; cv=none; b=nIXfO/wW1vmWNHzzsLE8QbNoEeg9+dyHzkChjFEyrCYdwwEWRTVhCbbOw2oSxbDIh8crWgYqUaxxifi8khXI/QTuJXjUnev94rce2bE5Ie252Y0MzWE0KLb4zQQJnOtmWDOJG12V4F2UoaHBO35WQLLrkwiF+kh94VCmSJqD5w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674363; c=relaxed/simple;
	bh=yU6jnoN1RZ6CZlvMfI/77iw7hjCrZddJsHH0F5tbLlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eUnH3SamYgjMPqFq6i88Tj0oMQCYrVfy0ZLxV/yhMLY4jIAK6KyRhNU+yJW0BglGOArQWbZXrSV939VQV/k7v7ro7a4NEotyyHWSSakkYATRKlItz5h8raZv915Z8ML9ymsr/YzuoRomUgDiN7quxqMrtm98+TmhBFZ7ByOkUEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2sUs7tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2sUs7tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45584C19421;
	Wed,  8 Apr 2026 18:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674363;
	bh=yU6jnoN1RZ6CZlvMfI/77iw7hjCrZddJsHH0F5tbLlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2sUs7tlk6ATe7H+I5IZCaHoTQA07RYh2VIE/eDGjAyJq/J+ThrD+vG14dspJeiD4
	 9Z6oWnwZJoivYN20ZwrAFaPo/zDy8JrSU7+NPYlERl3YY5PcCp0YuBHXlX2ud+v7B6
	 Zdk120Bm5zY83mMS1vSLQm0cKmv06zunGZUfaG7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Bunyan <pbunyan@redhat.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 036/311] crypto: caam - fix DMA corruption on long hmac keys
Date: Wed,  8 Apr 2026 20:00:36 +0200
Message-ID: <20260408175940.763491504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



