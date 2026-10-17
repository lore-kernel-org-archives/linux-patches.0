Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253533A6B92;
	Sat, 17 Oct 2026 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254119; cv=none; b=Eb6NCjUrkTzsXx+k/sSmpdexeerl/Cd+G3UNGRd3iiOD4PmqFVldaS3LxUJkn1rxrAX8vGaMaVtQ2ij1ojvtwWB0RzRmH08Hzejmp/RkBHnCRc0ffW/f36n8A5fxaFnDkmGoGEcnbh5xah9s4i4mwZd362xfJtvnBNplFN9WLVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254119; c=relaxed/simple;
	bh=1tAmP4+8lPOJH44p8CfKl9oUAXRvpnKfbgglEYg9xlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjK/geC1mYo02h0gLqOZFAm8SKxTy9sEuvVBEl4SXLdn6iVkj7ZidXQihbbPi2kujmm66ezGD97r0wERciCePdOLyqBUdVvCohxqgoSJF/YUw+hzGncTT7fSUGwS2KHzX3puf0uKZtwM0WPT2qkz0KIRi9TLiJkvagG4OrU1gR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaXCWmKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaXCWmKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE87B1F000C4;
	Sat, 17 Oct 2026 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254113;
	bh=LGMUH/3aFVPKHXgaOIasvoEuWd8CEqo5J9Mu700xlE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaXCWmKHugvJFla52c6nkVFaML5Sk3M2FT8+QLt9e693f3UQQddi7a/NVvW7BaUFY
	 BtqOJ2FPGJ3OAZuSWGYDM0CDXVhWh6YXLLpKA+NdAKP/rv3jsJAGe3adK4ahOPmWiR
	 SIECDT8Nx9FSuu39d+SBejsjmvk4KIl1cLrjTeyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/869] RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()
Date: Sat, 17 Oct 2026 17:52:16 +0200
Message-ID: <20261017160044.638630348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit c9341307ea16b9395c2e4c9c94d8499d91fe31d0 ]

Sashiko points out the radix_tree itself is RCU safe, but nothing ever
frees the mlx4_srq struct with RCU, and it isn't even accessed within the
RCU critical section. It also will crash if an event is delivered before
the srq object is finished initializing.

Use the spinlock since it isn't easy to make RCU work, use
refcount_inc_not_zero() to protect against partially initialized objects,
and order the refcount_set() to be after the srq is fully initialized.

Cc: stable@vger.kernel.org
Fixes: 30353bfc43a1 ("net/mlx4_core: Use RCU to perform radix tree lookup for SRQ")
Link: https://sashiko.dev/#/patchset/0-v2-1c49eeb88c48%2B91-rdma_udata_rep_jgg%40nvidia.com?part=5
Link: https://patch.msgid.link/r/12-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/srq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index dd890f5d7b725..8711689120f30 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -44,13 +44,14 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
 {
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
 	struct mlx4_srq *srq;
+	unsigned long flags;
 
-	rcu_read_lock();
+	spin_lock_irqsave(&srq_table->lock, flags);
 	srq = radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - 1));
-	rcu_read_unlock();
-	if (srq)
-		refcount_inc(&srq->refcount);
-	else {
+	if (!srq || !refcount_inc_not_zero(&srq->refcount))
+		srq = NULL;
+	spin_unlock_irqrestore(&srq_table->lock, flags);
+	if (!srq) {
 		mlx4_warn(dev, "Async event for bogus SRQ %08x\n", srqn);
 		return;
 	}
@@ -203,8 +204,8 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
 	if (err)
 		goto err_radix;
 
-	refcount_set(&srq->refcount, 1);
 	init_completion(&srq->free);
+	refcount_set_release(&srq->refcount, 1);
 
 	return 0;
 
-- 
2.53.0



