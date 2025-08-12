Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA072FA0DB;
	Tue, 12 Aug 2025 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021393; cv=none; b=q9dTitfdmkMUD46XB2RLdxspkmltj5cWZWPTLnbrFmJJyHYPEN2bjWjgVPMRcOy6BXjZFtUm8V2Zv+r1AE94RNVMfGG5thLigPRZw+iE5y46F6KhwmsJeRrGCr6lcz+BnO6XAOrkb4mTqhKDjVRPi7P02PUEKXOzRcRnrDjbJA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021393; c=relaxed/simple;
	bh=Lkq53+noy8fEIdk/opS7hP5JZXR6RCFKFVADQ++2fWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro3eMsuxp65UrpEf1Db1G4cbCewQVQTfF6T2B2shaI+GbNK+B/LZLO2F4uqB6QEHdrE8Xa+GX+Hd+wowotGOtQtNTLHqhMW3VBHQhvsSfsdIT268OFtGR62aJw3+BR+1H2aNoZoic2nCduqupZXO31I65YuDq2CVKex31+kovDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFPlXY1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFPlXY1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B539AC4CEF0;
	Tue, 12 Aug 2025 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021393;
	bh=Lkq53+noy8fEIdk/opS7hP5JZXR6RCFKFVADQ++2fWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFPlXY1pxw8YTkHf9/juLcZ9Axi/GPvEOT/Sm+07uIqttsA6w1op6UIIYyu1MOQGy
	 8yTLLUQF5N3PqusNLXD87cQzSn9UGU6FCgRGpN+bPL2/UW/1UEboNkkKBYHmIwSLB+
	 auC364zPdSr+VnpY50Z4Kyih7OOihdOmSP75LYDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/262] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Date: Tue, 12 Aug 2025 19:28:16 +0200
Message-ID: <20250812172957.688012678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 70434601f99b..9e093d44a066 100644
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



