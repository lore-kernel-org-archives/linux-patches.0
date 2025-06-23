Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A991E51FA;
	Mon, 23 Jun 2025 21:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713940; cv=none; b=EgcRdV+ku5m9n9l4Itddg73uqLQYCikwLs71tiAna+QIW9W55OGOWzakumP3RYpU6K1K+tMavrhVkGRTu3j/rkUVMgCv4AlGA85McGsSiEMxG5vOPvrA2LO12IlmAr++5VJ817AXBUnYonrDSp430gJmChnwX3uXNd97b0El0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713940; c=relaxed/simple;
	bh=JdLw/JZ0e66+2SySiPOaib4N8tUY1GaYjLjpuFccxYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=przd6+Ov8VGph4Wc70eFcglt/S+z+KAivUsGZdW87k3CV4Gm3WxcuJ8U1Jz5GEoxaR3gKMEMsxhxUcLLwyXnlLzntdRYZ71t035mgGJw8x1lfZik6NCOodmEw61I+g7KZimC76IbCxtKHRPgmRN4NHtRdeUooVF5feHGZH1LN9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4qC4LMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4qC4LMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C402C4CEEA;
	Mon, 23 Jun 2025 21:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713939;
	bh=JdLw/JZ0e66+2SySiPOaib4N8tUY1GaYjLjpuFccxYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4qC4LMPMjrzqk2e0VhTJ/2tHV76dm6ABdACQmjbH64D15aP1B9FbZszUxMdrAbBV
	 gvuqXM0OIEZHsaPlddiiB6Ux8zATOiddQKtPGzbNtlfhNd39m4ivcQMfYy7Kn5JeuN
	 0sA10uvqfr0R0KBNqzw6r2+8yXfRow611Mn2og/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/411] net/mlx5: Ensure fw pages are always allocated on same NUMA
Date: Mon, 23 Jun 2025 15:05:00 +0200
Message-ID: <20250623130637.568481342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ae6ac51b8ab03..fadb94e9a4bf2 100644
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



