Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBBE15FCF0;
	Mon, 27 May 2024 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838591; cv=none; b=LQnDbGgQFRLKCMmfYiyxiA3JHL8Zpz6VdOYPSJvBz+Tr8IO3yL7RCLj8XVjdxyp/IfJfxzu732K7+thkMsZzybRlwcMhKnhjQbDC55mdnlvNBnmrVaycqZfA6eVs9GTMn/YcGZfAwB+kkk8BRdk+YwU1YyI+H4rTfUm2Qbu+5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838591; c=relaxed/simple;
	bh=4nlgFrMXrBJLnIOWibZP7Ju9D1Z4UETtg2Jd/1VmmAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqiSVTxyVjtiVO+8sAUR0Wlzf/UOwxDWJYza0JVPFopZpt2nCp/i0EoNjjVcI37JB0jr/q99S79/Hai1FZ3fNLIili3sgLEdbXjglSA4IjuMgefEfNNwe3iilPvg/aIxR9NcmwQ3vCiID3WXw7N246zmV1gKNnYtvW3woq0kEqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFOR84GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFOR84GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93158C2BBFC;
	Mon, 27 May 2024 19:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838590;
	bh=4nlgFrMXrBJLnIOWibZP7Ju9D1Z4UETtg2Jd/1VmmAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFOR84GBcwHPZUNNUzpZEzGNb4IAUV1n0ZYtxWL4XILhV/n0Vj9n0gpqFfVp9OPzd
	 ojmseWY4YDHhcb3g0GrD5XTzhx3gd00KSCtQ1NQcjgUqNzJ1VsyWDdP0353hLf5vCX
	 4R7wEfoR6yUlJMIbOtm2TVxr3DbqiBQXyn8EKaNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 453/493] RDMA/mana_ib: boundary check before installing cq callbacks
Date: Mon, 27 May 2024 20:57:35 +0200
Message-ID: <20240527185645.041020514@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



