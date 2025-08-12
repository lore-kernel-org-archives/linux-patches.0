Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81E22F291B;
	Tue, 12 Aug 2025 18:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024196; cv=none; b=k8/DR2MxeKzWdaMZ6ZdFMrXlmztRE18HIDLhjc9JTf0PzVeRb1VgMBKZYTJ2QA65SiT4xaxb7lf71e61IlCi3MW1Xi05JnYNPpTZvkBJ7EKsiebIEnvz6Ydqq3hKlxVOj689MlplsaQfy/nKHPlUx7u0oCcVdwCOwPfeFG5nHvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024196; c=relaxed/simple;
	bh=GOURYElt9+bhJ1pfDapgWx46mHp1q4et6vrW1jLD/GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaBnsmlvXYDZJy4/BmEBrU+PSSgydnVjoVpIS0PLrU1HKBUg3XsZ13QukPbOxsV84Y6R7XMaV7YILSX6L2q/SMLlkf7QfnvPVSLMfe32BztqLjHqCIkvizRec1ROr8mVOW+wEWX2yxYyV3rS+qc+O2Zqx+qXn1DJazWp0wT/Dxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dz4voz4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dz4voz4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47726C4CEF0;
	Tue, 12 Aug 2025 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024196;
	bh=GOURYElt9+bhJ1pfDapgWx46mHp1q4et6vrW1jLD/GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dz4voz4HsBK2RYNtzuN/No5VeVbmqFcmptN8rdbhRkOjBNhCPorHBTJBeZuOG1rkS
	 jqhe6T5zylBnR67j9p7F2IXsLssfYPbU/j/WLUIw9c1rn6wlpmNAuFB+Qj95nONWzC
	 gZ2SMF1yyQGcCq8NtBmXbFhE7NW8Mg2pkU0Tst7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 302/627] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Date: Tue, 12 Aug 2025 19:29:57 +0200
Message-ID: <20250812173430.790893091@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f9cf00d690e2..7cd3b13f3bdc 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -278,8 +278,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
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



