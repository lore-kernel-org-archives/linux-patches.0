Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDAA442139;
	Thu, 30 Jul 2026 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421232; cv=none; b=uAA2SBrVId+MJcRuC+HMEjnWiqccB5ogw4SRSjUTL8HmB3BcNTBUwO/9+uw6YEmLvoZ6ne7XFkDGlq8R9nFjjL5JrvLj6Be7FVQaBj9Gkx198wfwqDJ6O0g8FORkfkiorI8v9R8mg0JFpY28RMZGnTYR87L2tP+mu3eQtVSV7M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421232; c=relaxed/simple;
	bh=z5UOBzjxXXe9U5ibQXUyZdMDBLWQcE7YXhBP5WX5Tdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWBEYOrMyQJCqa16qT226MteU9LqucxgdcIoMl3mRMaiMuFTjxoM9fB5YkaCIzs38hcHg+jfE1BkB2f1ZBmauPmk0TWTTTxzqpnlR8Sk8KL9s+sb+wtEUCuMxSme2OtxMHtD1rE5lFdjOC8ycKwsC2/xn/R3Jsh7e2+Wwqq+c0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpfn1JBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpfn1JBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D91F000E9;
	Thu, 30 Jul 2026 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421230;
	bh=s8ML0OnEKRlRndiGmiygkA+mqytms6LRqiBXhE7Q/wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpfn1JBZKW56bCKlYkiAAzD5U3CzU3593Fi9XnqfIXQIhNzOZjasRGGAvQEf1FJHO
	 wAX/+Cnji9SWevymBkUG+nri57dlO+hiBkna3cTTTEllVAvjEST7X1vKPK2dcIUSwa
	 RbW3aQKn9IHVis9gckAXSaUsHgng/CMJKwuERNl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 010/744] crypto: tegra - Dont touch bo refcount in host1x bo pin/unpin
Date: Thu, 30 Jul 2026 16:04:43 +0200
Message-ID: <20260730141444.500724840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit f8c9c57d750346abd213ffed2ae3cacb0268e9f1 ]

Since commit "gpu: host1x: Allow entries in BO caches to be freed",
host1x_bo_pin() and host1x_bo_unpin() handle the bo's refcount
themselves. .pin/.unpin callbacks should not adjust it.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index e8d8c3a23d7adb..d2f518ef9a103f 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -52,7 +52,7 @@ tegra_se_cmdbuf_pin(struct device *dev, struct host1x_bo *bo, enum dma_data_dire
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&map->ref);
-	map->bo = host1x_bo_get(bo);
+	map->bo = bo;
 	map->direction = direction;
 	map->dev = dev;
 
@@ -93,7 +93,6 @@ static void tegra_se_cmdbuf_unpin(struct host1x_bo_mapping *map)
 	dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
 	sg_free_table(map->sgt);
 	kfree(map->sgt);
-	host1x_bo_put(map->bo);
 
 	kfree(map);
 }
-- 
2.53.0



