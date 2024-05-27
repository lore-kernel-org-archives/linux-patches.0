Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33617E90E;
	Mon, 27 May 2024 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837293; cv=none; b=nCCAkrR3wqJQjAt/puchGTyruBUeP+N+CFwtvPbYmEknB1SapObJgUU7EOexuie9rIEFfOY+0ACyufNGMk4untwV0Aj5fWrHcaO72st0H/fjmWIsLNJnK+RCKhHvALANGB8KCZ7pf2KyKtVFy1y11eG8+ZcZyfVK13czg/yunJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837293; c=relaxed/simple;
	bh=d/g7+FG1nyP+CPrPyreO1X76pZnovHMOc5gKT8PX7ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSP57llh7ahl2eyGF3V5sQmtHml3CZSFAEloftugP8o4N6FD1AA7AXJh8Ou9VApdEZJdSVRAMNvT0jsNuqMwT+SkfgJnPbZE2WpYFUQ5amwNQzOXhpDPBuR2eazuLpqyev2arK1NJeZ9263lbaBSPq3GHPqfaCpZXpO8zIUngrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CG0Adu06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CG0Adu06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77C8C2BBFC;
	Mon, 27 May 2024 19:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837293;
	bh=d/g7+FG1nyP+CPrPyreO1X76pZnovHMOc5gKT8PX7ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CG0Adu06KuGN+6yOiAeYVxB6wC4SkHPqOTo5/uO9/Dw2ZJl2MHaQ1bmsYw3pXI5fu
	 kIxicnkuTuQ8LppRu6r3i1MQxpTmmqSkbJ2nkh1k3ycesPIaBV8Zelhg7b6uFF4fWF
	 FRQT2eY5z5KMiskOnUNEGOkOoR4OIWwDReipYxNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 385/427] RDMA/mana_ib: boundary check before installing cq callbacks
Date: Mon, 27 May 2024 20:57:12 +0200
Message-ID: <20240527185634.647108145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit f79edef79b6a2161f4124112f9b0c46891bb0b74 ]

Add a boundary check inside mana_ib_install_cq_cb to prevent index overflow.

Fixes: 2a31c5a7e0d8 ("RDMA/mana_ib: Introduce mana_ib_install_cq_cb helper function")
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://lore.kernel.org/r/1714137160-5222-5-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/cq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index c9129218f1be1..89fcc09ded8a4 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -81,6 +81,8 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct gdma_queue *gdma_cq;
 
+	if (cq->queue.id >= gc->max_num_cqs)
+		return -EINVAL;
 	/* Create CQ table entry */
 	WARN_ON(gc->cq_table[cq->queue.id]);
 	gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
-- 
2.43.0



