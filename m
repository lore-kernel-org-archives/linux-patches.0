Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E336320E023;
	Tue, 12 Aug 2025 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026177; cv=none; b=h5KoLMRL6peyOvDHV5IqP+n+I+qSiSy20rQKwGw9nCnEBHvmSQzIoQ1QawlpQqPyHmoQEa3bf1Dr+oX+EzAcO5SacKuBdIA8gwEj+7XYSs6/ukHePr+WSMRsnRj6mB4khO6YCknLSPGkpwSb8SeCcJn+3gg518Xx7VO9yXmjZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026177; c=relaxed/simple;
	bh=RYTIExPxixxO8P8L+mc+lMmIM67NqEuhf7q8sh4LMA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0I9s/6ia3143AAAnoVFAQ8cZdL/NdJ/Lrm4Y1vhzkiXWIO4JrfcTnbXweyv/AgRxjvToBYWENRvG/9DDMt+ZdbmLO7GKxvq3Tx/6KGIpQNDTSC8rF2M2q42BRFLXFtMEYv042MyjRcdOlOqevgTj2rl9/J38HEwbt/THGYeez8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqT6l3dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqT6l3dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADEEC4CEF0;
	Tue, 12 Aug 2025 19:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026176;
	bh=RYTIExPxixxO8P8L+mc+lMmIM67NqEuhf7q8sh4LMA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqT6l3dtYgMju4LyvqPIl6GSkSJ1ZEOepHoOXFjgukuMOSEQ1me4UA9mzPscn5ffh
	 MZJrPB75SqwWW4FJDkpxCK23x61Eg6hFP0uNwhFzvxHC0gD5r5auFvFZomW24zQbj6
	 IlMDeo2ZYqaYz0hq9GrMoS7+MMyXSZ26xFGiQfI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 226/480] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Date: Tue, 12 Aug 2025 19:47:14 +0200
Message-ID: <20250812174406.770934102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit b6cd3cfb5afe49952f8f6be947aeeca9ba0faebb ]

In sun8i_ce_cipher_unprepare(), dma_unmap_sg() is incorrectly called with
the number of entries returned by dma_map_sg(), rather than using the
original number of entries passed when mapping the scatterlist.

To fix this, stash the original number of entries passed to dma_map_sg()
in the request context.

Fixes: 0605fa0f7826 ("crypto: sun8i-ce - split into prepare/run/unprepare")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 05f67661553c..63e66a85477e 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -265,8 +265,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	}
 
 	chan->timeout = areq->cryptlen;
-	rctx->nr_sgs = nr_sgs;
-	rctx->nr_sgd = nr_sgd;
+	rctx->nr_sgs = ns;
+	rctx->nr_sgd = nd;
 	return 0;
 
 theend_sgs:
-- 
2.39.5



