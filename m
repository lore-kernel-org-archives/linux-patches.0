Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F9228EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF02C433D2;
	Mon, 30 Jan 2023 14:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087593;
	bh=NusBK45PXs0DCRScUDi9uENmjrOFltWEJUZDoxF46Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vondJPcp2J3U/2M2B78CAnLgS92wnJN0qRMj3Mzoj45Xh9Tw3e6jCvMZmA97bvHNH
	 wqXP8DisDH3QZSM4G+8s+34P1VSlfE4e397UC5VgfrZmWlyyLWwhF4mkSCI7pIB3xR
	 j9kR6P9LQnUFx6As/ZVEkX6MH+FmTfBbhSWbXmPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/313] nvme-fc: fix initialization order
Date: Mon, 30 Jan 2023 14:51:34 +0100
Message-Id: <20230130134348.791073812@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 98e3528012cd571c48bbae7c7c0f868823254b6c ]

ctrl->ops is used by nvme_alloc_admin_tag_set() but set by
nvme_init_ctrl() so reorder the calls to avoid a NULL pointer
dereference.

Fixes: 6dfba1c09c10 ("nvme-fc: use the tagset alloc/free helpers")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5f07a6b29276..6c3d469eed7e 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3508,13 +3508,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	nvme_fc_init_queue(ctrl, 0);
 
-	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
-			&nvme_fc_admin_mq_ops,
-			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
-				    ctrl->lport->ops->fcprqst_priv_sz));
-	if (ret)
-		goto out_free_queues;
-
 	/*
 	 * Would have been nice to init io queues tag set as well.
 	 * However, we require interaction from the controller
@@ -3524,10 +3517,17 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_fc_ctrl_ops, 0);
 	if (ret)
-		goto out_cleanup_tagset;
+		goto out_free_queues;
 
 	/* at this point, teardown path changes to ref counting on nvme ctrl */
 
+	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
+			&nvme_fc_admin_mq_ops,
+			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
+				    ctrl->lport->ops->fcprqst_priv_sz));
+	if (ret)
+		goto fail_ctrl;
+
 	spin_lock_irqsave(&rport->lock, flags);
 	list_add_tail(&ctrl->ctrl_list, &rport->ctrl_list);
 	spin_unlock_irqrestore(&rport->lock, flags);
@@ -3579,8 +3579,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	return ERR_PTR(-EIO);
 
-out_cleanup_tagset:
-	nvme_remove_admin_tag_set(&ctrl->ctrl);
 out_free_queues:
 	kfree(ctrl->queues);
 out_free_ida:
-- 
2.39.0



