Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214978;
	b=sbRTkXVyitLjB6E/FVRIjqMH5CknQWbC0/YIimhgn2kSORPifoQi1cDC6tXhLe60VD5a
	 wnsFrCNPtjL7gA1rX+nt6jJvRlV0IBI3EvQNXmjhTTj/7uBiYI0LeNImZf/v0U0NgfPm/
	 BR3JxrcX3cNJuuB5OkAF4sbVbMJ0wsyftSWDocSbMB+bKjsPEkKenUz45fICaA3GQc3S9
	 vjHApGy8Voyy8mXClfwfYKkF1HCb4XTrFKEXUzt6t87m67jHpfAkmWZBFrrkxqxJ8UlXM
	 VVhp8dOikWLiVgXDEV16b7hx7t26hBPI2YDCw1kkAH83NuNd5D/Z8Q9W2yunTFABkxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cke3bMKKHtqC34qH0WDCIB09R0+ktt+6p09ZqN6WtK4=;
	b=3rORse9f3J6n0tpb/pDJOqCtUP/v+bbd8YpIeXVYb05/YcC58R+p2sRzIwyEvTPjboTx
	 6P4xVyrGyH7I0OB+YocxyXXpEzr8LW256ML9MiXDSPpFtcGZGqAygP7Ip0JsJyGVIDYIJ
	 DaGWxzivCSp7t3KpUc3xX0zq0iHv3ogoiK5kKQ8X5itLJnyxsLNKEdD+SgDCWIePR5YZq
	 9Z+90BWn+Zjds1A2fUELXeTE0sQyTjJbBz7Ra6mfMezM77Ut2XXqYy+SEO0TGqTxXJeha
	 5Xp66npgeXT5sK155ciBO6JtznQQMUGx2a7EzLocIdR+7supDZUaNVSK11o1W05hYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdQm8n0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8BC606A31C;
	Wed, 28 Oct 2026 19:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdQm8n0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544841F01825;
	Wed, 28 Oct 2026 19:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214977;
	bh=Cke3bMKKHtqC34qH0WDCIB09R0+ktt+6p09ZqN6WtK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdQm8n0Gl5Ek2lQDlqkS9SmzHiLm20baiEX7OYNTeS6WxT/YNlUq+J5bzY1gwtK/l
	 t17xQHuysOfC3I5uBw8dzOzbrtoBEYmtbg0q69ulFl4NBA68IYMsPjB0CI2ryv4cMj
	 tzMR2vVwX7IFJ2geJl0qo3njWxxY9onmsKHC3cdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1050/1887] RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()
Date: Wed, 28 Oct 2026 17:52:26 +0100
Message-ID: <20261028170523.303235249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
 drivers/net/ethernet/mellanox/mlx4/srq.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index dd890f5d7b725..39a01aee3bef3 100644
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
@@ -203,8 +204,9 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
 	if (err)
 		goto err_radix;
 
-	refcount_set(&srq->refcount, 1);
 	init_completion(&srq->free);
+	smp_wmb();
+	refcount_set(&srq->refcount, 1);
 
 	return 0;
 
-- 
2.53.0



