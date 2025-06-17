Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE302E264E;
	Tue, 17 Jun 2025 16:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178201; cv=none; b=elfw2YSc0POVTEuYN6NwF56TF0iKYM2uN4tQLy1u2rDHmJOQcn/+12CiSg0kBH+hVX/zPsldOl/XfZEJ/llQkULmkoTlAvFTg8b292Txd0B1lSVctEDi/FwImiHw+UeBNyTeeGjnlfcOOiTXpl0P2xy+QudjZUWO7E7GQ0ViK6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178201; c=relaxed/simple;
	bh=i6/EGNGfAUK81RAGjm6iZPNZW8jOrG5clD4s0eQaelA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiVnraw2Ww4chXGIegMv5GttE8FwxNiH5Dy3nw5ehMViVMuzceevXIgDtJgMqB4jnqMsZV28hpvG87CKDm4j1K1cqsmOuchGoOS48rZYJde4H2rVShebPKu01a0jTiERWQWuIKuhYdFh1oY+MaTYIrzwvvh0bRle3F+FUNKXZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dUEDb3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dUEDb3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D949FC4CEE3;
	Tue, 17 Jun 2025 16:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178201;
	bh=i6/EGNGfAUK81RAGjm6iZPNZW8jOrG5clD4s0eQaelA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dUEDb3kZwgRf/ARb7HOl2FtGSCe7o29zhmxIhrIh4QJR9wCVGU+eG7N2GNsuLM7H
	 8J1mrPpDxRHKsu10AvNJJZZH4CNYXpXbY8ez3heM9NZf9GpAx/LyTsKp7HT50b4yVt
	 8FkqeVqBSlkyNOWExAQ0wnenO5Tqycv1ReCDfiKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/512] net/mlx5: Ensure fw pages are always allocated on same NUMA
Date: Tue, 17 Jun 2025 17:27:06 +0200
Message-ID: <20250617152438.209901929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit f37258133c1e95e61db532e14067e28b4881bf24 ]

When firmware asks the driver to allocate more pages, using event of
give_pages, the driver should always allocate it from same NUMA, the
original device NUMA. Current code uses dev_to_node() which can result
in different NUMA as it is changed by other driver flows, such as
mlx5_dma_zalloc_coherent_node(). Instead, use saved numa node for
allocating firmware pages.

Fixes: 311c7c71c9bb ("net/mlx5e: Allocate DMA coherent memory on reader NUMA node")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250610151514.1094735-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 972e8e9df585b..9bc9bd83c2324 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -291,7 +291,7 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 function)
 static int alloc_system_page(struct mlx5_core_dev *dev, u32 function)
 {
 	struct device *device = mlx5_core_dma_dev(dev);
-	int nid = dev_to_node(device);
+	int nid = dev->priv.numa_node;
 	struct page *page;
 	u64 zero_addr = 1;
 	u64 addr;
-- 
2.39.5



