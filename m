Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048479;
	b=ouB8Qn9adXdxRo7GSJmt3NCIyoUB/LT8ckGgdZsAKq9JaF2zbAaI02OSIzJw2DGxZMNX
	 MM21WEyWR9H+8opRC5ehySM9UAx/ejnpKyTsWvV8/Zv1p7V0oRrDsD44VlBePuqHk4oVM
	 7DRNAgSmz/zHZ8VgHTWsAEpN2cNqM7DK3AzL3ZJH1ZIP73VMXzmVTIlyDV92LjwUJDZEm
	 yUPzAtYVaNDLyLIv5ngU0tjzKFwJ5bZZPrkC5VPE+noI9gfqT+Fc3GDVLnctIzXK5mhWe
	 rb3/LJ27+OZBdahD+XtKfNMAZpSHwWV/OfOdpI0kSwG6u2qHr75Vb3ecxBUtPx1hZMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mH8GEWSdCf3Di194/+9/T6cH22C8myrXD9pplvXTGU4=;
	b=epQ4I0tDn80IV09TrI1l1YYOlFEz35iMIPViVwUXjxysQ0eUB44ddBxdmLfwxsBuEzAo
	 59PMLU+K5BaXSfXFyEwQBcoLy4uWbeeGth+TP0VMRQ7s0b05n83wdGfLtbFo6s7PDMt2X
	 VQFQd9LbGavUCzYk/ePeTF+RzgcJ8Atjt1jJYkkLYcp/vYO1HbrjfHg40eF3aWPVdz2z7
	 75VYbt4SBqRvGJp/HKJutF3E4KBXeLu6cmmk7k8OB+nd1sMyhYQYnBb9ifEH+07LUXtJt
	 GktZFhWcF1CeSoWbVCnCGG4Ys68BCWIT5SwSlGl2FLPgz+empTimwLo9wE0Ltj2CSXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbGuZnzr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B15606A325;
	Thu, 19 Nov 2026 00:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbGuZnzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979321F000C4;
	Thu, 19 Nov 2026 00:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048479;
	bh=mH8GEWSdCf3Di194/+9/T6cH22C8myrXD9pplvXTGU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbGuZnzr+MY4aFaMQS6jbUf5EudwGeySySSk/zTgt+cU3LMuxqE8pREl+ZeW2sfz7
	 KXK5cfKGcb112K2SmgAS0AlhihuInZ+1mj5V18n5JlKdw0GAeqoJa4abC8MAkHJzek
	 77HKaJzYx50bvUilcjcJ2AJSmaGv5aPgxdo8QukE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2009/2857] RDMA/mlx5: Guard steering anchor resource destruction on create error
Date: Wed, 18 Nov 2026 15:50:43 +0100
Message-ID: <20261118150313.737112389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 193aaf5b57f05d9f0403cfdaff3eda3b8d11ec13 ]

The steering anchor resources are shared between anchors with the same
priority and are protected by rule_goto_table_ref.

When steering anchor creation succeeds but uverbs_copy_to() fails, the
error path drops the reference acquired for the new anchor. However, it
unconditionally calls mlx5_steering_anchor_destroy_res(), even when
other anchors are still using the shared resources.

This can destroy the shared flow table, flow groups, and rules while
existing anchors still hold references to them, resulting in a
use-after-free when those anchors are subsequently cleaned up.

Only destroy the shared resources when dropping the reference makes
rule_goto_table_ref zero, consistent with the existing cleanup path.

Fixes: e1f4a52ac171 ("RDMA/mlx5: Create an indirect flow table for steering anchor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260917085419.1792-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 1022cebd0a46e..1070d42df312b 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2467,8 +2467,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	return 0;
 
 destroy_res:
-	--ft_prio->anchor.rule_goto_table_ref;
-	mlx5_steering_anchor_destroy_res(ft_prio);
+	if (!--ft_prio->anchor.rule_goto_table_ref)
+		mlx5_steering_anchor_destroy_res(ft_prio);
 put_flow_table:
 	put_flow_table(dev, ft_prio, true);
 free_obj:
-- 
2.53.0



