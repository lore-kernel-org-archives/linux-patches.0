Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE520409A;
	Tue, 12 Aug 2025 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022435; cv=none; b=CIdZaoPvO3/9O/MoLGo025c0q3rdsiwXXd7rEFLXPk2HHjGMB3F3sz6SG8DfAwe44PjWjPi8KlLyuEqAXx6oa2tV9WgAwKmkcWYBObgZnrsWk1oTYSj5WleNwVArSxZgDB0uewvEDI/kfLDxw1wuoks9C4wYbsNzMIJ2/pbQDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022435; c=relaxed/simple;
	bh=kUwm8B94F1rDwRjrWATweMzeY016h5BCJnoy6pc9wO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmmAkD67l9rFTVKR0ybUg/FJhABqxMCXj9s7ajIf4/lJsq5c/sSCiC92kLDs5msdZLqbWxOGQg0pYMP/RipoO+z4qx/FXXLFOq5wSycdkJuq7uM0+vNhWMdS6twpgozaoJnKC7Tjub3gxW02/dAmghl/E7DMa82I3sPSWd88jdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFN2o+wG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFN2o+wG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1653DC4CEF0;
	Tue, 12 Aug 2025 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022435;
	bh=kUwm8B94F1rDwRjrWATweMzeY016h5BCJnoy6pc9wO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFN2o+wGnwWGoPtMA6m8DYqolpNWvwzqL1W1SbnJS9sAC82AwdHBwPKoy6sc4DPQv
	 7Txg5UH+mTePAa35eh0O6XshbVWK9GcyJ4CYP+1NdkfubLJRahDJr2jAbIDwv5yUy2
	 NI14sHFCcA44PUgXAbW4GNSFwoKgxjU7umgQguCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/369] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Date: Tue, 12 Aug 2025 19:27:32 +0200
Message-ID: <20250812173020.604524778@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



