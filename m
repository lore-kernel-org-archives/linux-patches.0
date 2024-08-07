Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E407D3E4;
	Wed,  7 Aug 2024 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043019; cv=none; b=KCvyTVXMMLW+qsF4qyf8DQ645iuAFFQ2xfMYjeDjwV5GK3DcF86vnG2Ec3HB7H7uDkUv6r7cvDV/HyScMVTChlEBYG4xo4/pMRJmz6Ytx1fuSZwLJSz4mXsXsxohbGHlxzgmWxRxyxMYqkzk6zCTOxTjbx27IvWRNRJgHjJiSRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043019; c=relaxed/simple;
	bh=TMOSGl0sYZcrfYgXskz3hM/gYoUu3PEZeFC6p7/IZvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgkVNf0JGmkCr9eOI3wwZi/werjFpQxmtAhaDd9cp8s047y8S7HekmWUD0jrfLsOgizneXRb079/bX7bsefomMytCdBurwvf/6TDvAm7cVRL6V8gP/nG9PY++mX65DK0+PAEGHUPzRRU7Bjn6rnZRJYNp7MU0vvczT/7Txdyggc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeJ0PwP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeJ0PwP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E01C32781;
	Wed,  7 Aug 2024 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043019;
	bh=TMOSGl0sYZcrfYgXskz3hM/gYoUu3PEZeFC6p7/IZvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeJ0PwP94Qdy6k3MWk5cfO/RYCIZNFhhG7YR6oA630I6GvMyKbHIO4gltLkAEwAM/
	 HqX+aFIHQak1jwbXfXLnesyYINNDyQuEl+/Qgg4Pk/20nxez8FHP6OTdktie5+dBu6
	 s482i1ovOyXOBh//xLJVs1phHHHYIqOOdYTq0w6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/123] net/mlx5: Fix error handling in irq_pool_request_irq
Date: Wed,  7 Aug 2024 16:59:39 +0200
Message-ID: <20240807150022.741561430@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit a4557b0b57c40871ff00da4f623cf79211e052f3 ]

In case mlx5_irq_alloc fails, the previously allocated index remains
in the XArray, which could lead to inconsistencies.

Fix it by adding error handling that erases the allocated index
from the XArray if mlx5_irq_alloc returns an error.

Fixes: c36326d38d93 ("net/mlx5: Round-Robin EQs over IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 612e666ec2635..e2230c8f18152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -48,6 +48,7 @@ static struct mlx5_irq *
 irq_pool_request_irq(struct mlx5_irq_pool *pool, struct irq_affinity_desc *af_desc)
 {
 	struct irq_affinity_desc auto_desc = {};
+	struct mlx5_irq *irq;
 	u32 irq_index;
 	int err;
 
@@ -64,9 +65,12 @@ irq_pool_request_irq(struct mlx5_irq_pool *pool, struct irq_affinity_desc *af_de
 		else
 			cpu_get(pool, cpumask_first(&af_desc->mask));
 	}
-	return mlx5_irq_alloc(pool, irq_index,
-			      cpumask_empty(&auto_desc.mask) ? af_desc : &auto_desc,
-			      NULL);
+	irq = mlx5_irq_alloc(pool, irq_index,
+			     cpumask_empty(&auto_desc.mask) ? af_desc : &auto_desc,
+			     NULL);
+	if (IS_ERR(irq))
+		xa_erase(&pool->irqs, irq_index);
+	return irq;
 }
 
 /* Looking for the IRQ with the smallest refcount that fits req_mask.
-- 
2.43.0



