Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D4943C7A2;
	Thu, 30 Jul 2026 15:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425331; cv=none; b=LkUV3sVmFmQgSplOpUwTPGltLYEDu5k/ZPfqNZPUXfS0ZjWWgXcasDVuQ7lD9CIfcInVQD+mUoKUTziOV7v+CzTOf4h5u440GaMR10PNxes/fqDP4XWVgCcIO75QzfWsWGSjJa4Msc6Y/1fcrIBUjcjVhxq02f2HeW1lK2DqD7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425331; c=relaxed/simple;
	bh=GdhVbId8zoU5Uo7rO+zKnPWsplwQQmOo1Vx1jSj5FCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9j+fqS4yHnp1W8k+PdMy533RGSTVtWQL3EAQKVw5RdDBcK31m78h6HOeMmgk4UngjUlgAEFfX1Z0fse9kkCZcNRsnAbQR23zv2HVLlfoYsEX9DVhNxk92+RrGrvG47amXQnGL1QoscyjFwfwC4OvyVaHjfgma0cdt9iEmEViDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5sCw6o9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5sCw6o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945B31F000E9;
	Thu, 30 Jul 2026 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425330;
	bh=W+8wau+0DZxaJ2kAFcYV7nFCrFDb1JLtdqx8o9rlENc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5sCw6o9rZcyPB9VnE3QFdCi2DA6Mvui0imFT2i85ZIwOwzmtfYlD3IA/tkuQofZ8
	 PScfo3i1W0DaYUM6bPaJx3xsB3E+nLO33vQDat4SnrzNIWqmhKZWN/nMiAn5UJ/Rmi
	 B0ZyKo8qgAdXGtowzpiKgiLoJ9aYcrspn1qcsIog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/602] crypto: tegra - Dont touch bo refcount in host1x bo pin/unpin
Date: Thu, 30 Jul 2026 16:07:03 +0200
Message-ID: <20260730141436.662714505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3c3b9f18d8cf50..e5ff4fe66a4b88 100644
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



