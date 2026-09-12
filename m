Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702862882DE;
	Sat, 12 Sep 2026 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223429; cv=none; b=apetYHFFrR8StaSTgc1ws1KC5AiIA285sFgjnN0gDodcsiNxiSRVaFBqNaXJFiDB4lndsj/JrTPkhhUU2I4WdiukLMptddkz1O+x2inTeGGJoeRyQFUaumyzwJGQ64V9Dlh5qIIcKV9OzftANJx9ma/H9F8RS30o50nr6E5m9kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223429; c=relaxed/simple;
	bh=maWjWY3VNovV4tSxREguN2iWlbPJJawGlIOPAqSti1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlFVoJ9B3viP3QLUVUn+rVjYUJIveFMsJhGS5EpTyqDgVwvwvB0HIU1Xl4DVjqrfHSGMVgCEsi0BkiyUD7rlaEU/0nGdlXPbrlpVyPMSsGekuUjmQ5ia82IvCKaDtqIC2MSoWfPqiNyE/atbDKfCJyhKx+u5ZPmfiFwgaGQNSB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1r6OmdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1r6OmdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172411F000FF;
	Sat, 12 Sep 2026 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223428;
	bh=WssNqXQznMudoq6Ygiwxu2slI28gwPA6sXz5ptj0YV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1r6OmdUah4THpw+wcXvkmbVaYAP6q1oCqpbmvEh76hcJVFoHr101UPwtDj45SB4o
	 Ctxjkj5voCBKZKKVnDB2atNSinvVk4ZK1xrY5j++v6Mo64QYvcnY66MvgSAQWO0RSp
	 RJ0KdPfNXU62yy7wlYtNYhZR202IxyH+rD8+A38A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0788/1424] crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping
Date: Sat, 12 Sep 2026 08:53:40 +0200
Message-ID: <20260912065624.945534634@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 3ae59a2eba64b3648f069aa52eeaaeefdfe4bb2f ]

sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, sl3516_ce_need_fallback() checks it before the
source and destination scatterlists are mapped. Thus, a stale DMA length
that is not a multiple of 16 could incorrectly force a software fallback
when CONFIG_NEED_SG_DMA_LENGTH=y.

Remove the invalid checks; the existing scatterlist length checks are
sufficient.

Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 49dce9e0a8343..d1b4732e18e78 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -56,10 +56,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
@@ -72,10 +68,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
-- 
2.53.0



