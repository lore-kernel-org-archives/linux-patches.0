Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4E021018A;
	Tue, 17 Jun 2025 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177103; cv=none; b=cCwhDJRjEAFU0TnYVDtOs5lanyY6ATJb2DNF6SXjAJW4oO01ufeVIqFaxcV/XxaaAhy1CL2Jr3IeZ97Qm1MyQ+4kUaNIT7euxax3fciYIywdBtZLAgEy97uR0nmouRZhkzaaOrhZtgUN64ZjpRjN03bV+0P9vK2AkaS5kQaJQbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177103; c=relaxed/simple;
	bh=UyAGmIbAbaz3mu3aGSuoc93VjX+QHMeFydAwLe8Vrq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvJ2PiMpgwV9F9P538+Y/7yMEvnEgSWzW+baGmQnyaOdZKZW2g5k/LQftmYf0LfTSAIoMKeGm5TQ6kVVTsETCrz4KnBvXsjwgc8jFYaWcfMH6gjroB13u/TUuOqjNwe1BN7woODhkpVz9mUfKuPXFyK4004bQOBlE+fYGf4SBFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOq2AeE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOq2AeE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA9FC4CEE3;
	Tue, 17 Jun 2025 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177103;
	bh=UyAGmIbAbaz3mu3aGSuoc93VjX+QHMeFydAwLe8Vrq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOq2AeE91goJhqVggqwpTPJZ7N/Bi9VAiB7ffmouAmergZ3/W1n/yV2vIhUUjukFc
	 qV2idFlCbNepkZ3OEeZFmkAIKr2jksEUw3sojZSidK8x7v56l/tgaZ7okxTE7HYbeG
	 oLcmet3Wcv4kCgywo5+u94lWzmrjP+cN9YDM3uDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/356] net/mlx5: Ensure fw pages are always allocated on same NUMA
Date: Tue, 17 Jun 2025 17:27:18 +0200
Message-ID: <20250617152351.153998527@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index dcf58efac159c..e0581c6f9cecd 100644
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



