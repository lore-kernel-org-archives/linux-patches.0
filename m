Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79E2FD1D6;
	Tue, 12 Aug 2025 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020640; cv=none; b=dPmZpqqWLpQSs/pym5g0rSwpZmbWuIKEMQs+wfr/W/OYxXBgmKLkMXyNK0RYQAXZ+f1Faa7N4K9lRzbpTGwNFNGezIzsUL1aoIXBrShYGpuHJRGoxP23/wzVNLVglHyiowZ9Fgixhjp/HOpdfE4TP+4t8x86zEce20JnnKA0B90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020640; c=relaxed/simple;
	bh=wK+RHmAQfVXJvpIS0IUfmPZqz8mLXbb4YOCfZs1/j1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIFt2wIbZPBYnUM/zNE/uLQle9yLf42GSaI0YJ7DANN6JuOTz3nv6AOd+ZvUn83rSCZlLGVG8Xds+ejRuY0cCY1X6YncnVGWuHILFcIotjLueOMeXMsSKeGQ6JJduLatXEOTeMY943lTcGIqSHTelwbtCDDh5Tqh3k3YpSWIzlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr6jdi17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr6jdi17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1382C4CEF0;
	Tue, 12 Aug 2025 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020640;
	bh=wK+RHmAQfVXJvpIS0IUfmPZqz8mLXbb4YOCfZs1/j1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr6jdi17YnyUb9z8OZjSFo1WHrQ9maZUGPaqOE4orOJVd8x7v/Coz/Xd3dcd2h5bq
	 6fSuukAo1imVlE2CLd1I2ZMNnJVy7Tkflnb3ant6/tk5/jXIdLQJTlPaC/enP+MwFz
	 UOQaKruhnqUY1ofv6lSoBI04YitFq8PqnzRdE4s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/253] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Date: Tue, 12 Aug 2025 19:28:48 +0200
Message-ID: <20250812172954.649041436@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c6afc736723..f7b6dfc3170a 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -260,8 +260,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
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



