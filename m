Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F0331A6E;
	Sat, 12 Sep 2026 18:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238814; cv=none; b=hcxNJShj3MVx6bLDbBW34J/8FqsNTAHwnt8Y+GyiX1CsBII7QThNUhgmYjsuO87OqtyUjCqDNx4qCl8CLRI+biaqube9cK7rYVMKtiY0HS+amqr48Yxk1y9UTTI24Aw9t7vBnECHcbhKopGgow6yl3AjshFR1VpTJWVIuU+p4W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238814; c=relaxed/simple;
	bh=5cO1CaXLLEv9SsVOA0kmWMKz3PFA4YXDS3kXBww9n2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWBXuHFFNZVaJFVELoFxFYspJdDR58rVmBgxFcD/Z8KCUxWPfw8YLwSb41f4avDXs0btaeTHm6r3vbndP8kWcp5oWwgi+rXSZ8Pgp8Up13bKv1Uuchc8BhTQSjv3scP5eMMgikPm1U/9rMBOvidXvy0lw4OsB60FL0CoXj7G1rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XM+PdNBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XM+PdNBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF311F000FF;
	Sat, 12 Sep 2026 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238813;
	bh=JXMDySlC4n/A+mpmSUk6o8sHK2SGvNcCzlreQlb6w6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XM+PdNBut+fCVkfZx5qZ5r53JGWo2i7VbLmgesFO7m2/sNiR6W+MuMSRJGrl+CGXI
	 K561Q0vKBtzvai/PeTUShQYCk0fAKSp6bVUsxHE1dy/41I5z/2rPJeRe/Ut53SEd5a
	 kC2/blqjNMeMut9hZAanIDpG6DsLVBN6VeYa7s1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/935] RDMA/core: Avoid flush_workqueue(system_unbound_wq) usage
Date: Sat, 12 Sep 2026 08:58:45 +0200
Message-ID: <20260912065538.172135796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit ff815a89398d8bbfdc14ced98252bdae92126225 ]

Flushing system-wide workqueues is dangerous and will be forbidden.
Replace system_unbound_wq with local ib_unreg_wq.

Link: https://lore.kernel.org/r/252cefb0-a400-83f6-2032-333d69f52c1b@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 7d75592114d1 ("RDMA/core: Wait for RCU callbacks before unloading ib_core")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a55af015a9109..8f987f57a5d62 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -58,6 +58,7 @@ struct workqueue_struct *ib_comp_wq;
 struct workqueue_struct *ib_comp_unbound_wq;
 struct workqueue_struct *ib_wq;
 EXPORT_SYMBOL_GPL(ib_wq);
+static struct workqueue_struct *ib_unreg_wq;
 
 /*
  * Each of the three rwsem locks (devices, clients, client_data) protects the
@@ -1617,7 +1618,7 @@ void ib_unregister_device_queued(struct ib_device *ib_dev)
 	WARN_ON(!refcount_read(&ib_dev->refcount));
 	WARN_ON(!ib_dev->ops.dealloc_driver);
 	get_device(&ib_dev->dev);
-	if (!queue_work(system_unbound_wq, &ib_dev->unregistration_work))
+	if (!queue_work(ib_unreg_wq, &ib_dev->unregistration_work))
 		put_device(&ib_dev->dev);
 }
 EXPORT_SYMBOL(ib_unregister_device_queued);
@@ -2805,27 +2806,28 @@ static const struct rdma_nl_cbs ibnl_ls_cb_table[RDMA_NL_LS_NUM_OPS] = {
 
 static int __init ib_core_init(void)
 {
-	int ret;
+	int ret = -ENOMEM;
 
 	ib_wq = alloc_workqueue("infiniband", 0, 0);
 	if (!ib_wq)
 		return -ENOMEM;
 
+	ib_unreg_wq = alloc_workqueue("ib-unreg-wq", WQ_UNBOUND,
+				      WQ_UNBOUND_MAX_ACTIVE);
+	if (!ib_unreg_wq)
+		goto err;
+
 	ib_comp_wq = alloc_workqueue("ib-comp-wq",
 			WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
-	if (!ib_comp_wq) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!ib_comp_wq)
+		goto err_unbound;
 
 	ib_comp_unbound_wq =
 		alloc_workqueue("ib-comp-unb-wq",
 				WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM |
 				WQ_SYSFS, WQ_UNBOUND_MAX_ACTIVE);
-	if (!ib_comp_unbound_wq) {
-		ret = -ENOMEM;
+	if (!ib_comp_unbound_wq)
 		goto err_comp;
-	}
 
 	ret = class_register(&ib_class);
 	if (ret) {
@@ -2893,6 +2895,8 @@ static int __init ib_core_init(void)
 	destroy_workqueue(ib_comp_unbound_wq);
 err_comp:
 	destroy_workqueue(ib_comp_wq);
+err_unbound:
+	destroy_workqueue(ib_unreg_wq);
 err:
 	destroy_workqueue(ib_wq);
 	return ret;
@@ -2914,7 +2918,7 @@ static void __exit ib_core_cleanup(void)
 	destroy_workqueue(ib_comp_wq);
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
-	flush_workqueue(system_unbound_wq);
+	destroy_workqueue(ib_unreg_wq);
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }
-- 
2.53.0



