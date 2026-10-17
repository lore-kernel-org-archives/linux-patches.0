Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C84B37F01B;
	Sat, 17 Oct 2026 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258689; cv=none; b=mjqMDuH3EP8EAvtWbcsB8s3YtDdlnl8ILFdRzFoNIqYETy/IsLOXo8rN1Bk89isagYZ511izYonxkDEFvSQEKd0397Uz58jyuexqt42dexcI5jmP//Y/XiHhbZNrOSXItYHeqTDRxvLifqSEB0Crn/BvD4dprSrknXbgr+6qWWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258689; c=relaxed/simple;
	bh=CoEKtyG+u6/330arxLU8hgv4UMytgbOd3jhqMpx+t94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifFvzASsPvdJZFzuvSbZJNQfr/m5yaawTFAPIT9YsOw7ma2utX0VemE+YUcEwjU7Bq9fHJAQQPmqdDNBoWBKu/nOIaRJtzvTkswbGlSGKWppNiz2HlE+88uSftlnhckvH6CXlXJVnhPXXJWkJpaIA7l8Dt5FzIOtmC5Y2sY4cdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2ybjJnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2ybjJnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B469A1F000C4;
	Sat, 17 Oct 2026 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258688;
	bh=edkLRMBb3bUHjDk2JdPGR/+WnxdkhVoR7f8s4IoAZqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2ybjJnRN06YQEmTbQzn0LEQnQVjErm2AyCKP+jKDxR6j9Eo01P3omHAhMbu8n5nx
	 WVpWIsPx7XLZsS23InOUhiS/9skvvN7W/1WE4upXLG398sHCkk6Loo5nnX658QzixB
	 DtWA/5tJjktq7werqAFM53YYDWE6b8ltF2oIBJAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0966/1674] RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()
Date: Sat, 17 Oct 2026 17:53:58 +0200
Message-ID: <20261017160455.919812667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



