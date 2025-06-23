Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5229B1E8324;
	Mon, 23 Jun 2025 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713219; cv=none; b=DmIb5gVUp3as+gjI4pGyOZAYvt3X9Xf49zFRnnyI+hEr/orHBlLMbHjFM2w58fyGUtx9wg6XjbaMQsutlQj+nDw08yOmMVzOG79Zw2YwC/bqAc3C1rp+QfDxDdq2EOxsX+4fBFvMj0/dLFD+WfC4lcz7i5ni72Ha9vEbYKk4Izk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713219; c=relaxed/simple;
	bh=TAdRQj+HISuBpCLf3cuKLEt5yoXkGvss6XCumPeEkz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaRyRYsf87RiipEwo7kSUFq7xevj7iLrSvOssRpQVa/OCPH0ebfYwDjA9e0YcbgU7h2UInN6weWI6O1BjLB5WYF/D6R+QF4T2NzaXxVRQMjatIogb9SyQSanC8KG72b33XnkQqNhWADj3C+AiFAaUcA5JU8+duNNZXBlAoACffA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dNNkcvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dNNkcvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCE1C4CEEA;
	Mon, 23 Jun 2025 21:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713219;
	bh=TAdRQj+HISuBpCLf3cuKLEt5yoXkGvss6XCumPeEkz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dNNkcvYfoSfZ+DpbR/LUsC9H+PRTOj8NnOsEgP171KXGxNleX3HtkGvncJBO0oG9
	 m1uma4TjuEr0cz5bCwWnrCK2quKQjyD5WJI8deXH5Z5tqBQta7PaxoHubNB46xVsiU
	 PynikrrZq6ASC8hGfF7mvYnBgqnB2rFtYd944rSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/355] net/mlx5: Ensure fw pages are always allocated on same NUMA
Date: Mon, 23 Jun 2025 15:05:33 +0200
Message-ID: <20250623130630.704462119@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1ea71f06fdb1c..b7ccdef697fd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -272,7 +272,7 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 function)
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



