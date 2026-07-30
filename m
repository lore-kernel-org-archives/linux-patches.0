Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDDD3B6366;
	Thu, 30 Jul 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423389; cv=none; b=giBYi2alPYtJmY9I5NEhNbdBvv+oSwmRjYNAms5wEGNkdldYLMp6/FI0kveM12YIRT6zwHIsSodHOe8kMBJQCYOvdcET77mQ/gADM5W9fafYNC92Hht5gpA4p+GMshwbouneq9KivvNojAreM+S3DGajEuoiFHCEZ5R7Gni9bF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423389; c=relaxed/simple;
	bh=c6o+2rv1rIe03p9+m73GB6Lo/14dkNHglEZHtMfxKDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsBzjKeNpvCWyhgn+4qpcf++XKD1pKtbkb5FuSlfaLvD8V0lugRob+rvr4dLI4h0yIsWSp8Fvvay8FR4rVLsucC3IAEFjR3cmd1bwYQkKtPTPZCxJdA632ad21CH6ax+hZQTvdLyKjMsA/1FLAzvfhgC/mukfCvdwTaFcmGfdKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T670W75w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T670W75w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9191F000E9;
	Thu, 30 Jul 2026 14:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423387;
	bh=npsmakKQC5dSdo58lEibm6rynvqk+KdbGj19gMXExD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T670W75wevsT+vk4f9QrE3ZXFO1G4cALN1usEjnje+ma18E95ORkt8KNfV5UkdKfE
	 9rkZcdhsNt6E7bV2Bg3SjxkbLEtT7rOPwO3QfNJ+4y2tPl/frwdT622JKL/Uuflvrg
	 3nJeg3cwkXypu7AjyL1+3ClMpF6yOhngCfPUM/vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/675] crypto: tegra - Dont touch bo refcount in host1x bo pin/unpin
Date: Thu, 30 Jul 2026 16:05:56 +0200
Message-ID: <20260730141445.676071891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2755f19ad05e92..77b923a6b7c18c 100644
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



