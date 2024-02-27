Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E314113B2B8;
	Tue, 27 Feb 2024 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042570; cv=none; b=mQENroRammUKBMjUCXjhmD/s+IEsv2WpbiWAU4VCkRcwWkMgYODjUAJJCqoVfdd0CydaLCzLwS+30aMSA6PBMfqegEanqt5UxldBguQ2Jk64DIP9ZFbvixMQh8JPEj5Gp8LaRDykQBKCbGcJdV9V7wO4/Y1dGOjCPp0D1pXbKfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042570; c=relaxed/simple;
	bh=OqG0G3NsI2S9AtfL4nFHNCU5emXHf16vQbJRJHgQTCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzmwT/l3LydnY3XY/OnYql/yO2n1Fo+mNgsuGumkshuCb/BcxeHZG6uk5QAbgbCqff3rt/PO5c+ZAE7xciiV7ucx858rem2RKGPbRsH+unM8oBQ/cujn08Bl5H0ga/9CeX+MheY25hZupDd+URhFj95Q3JqugPmfXJXO/qBDI7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nKLPoPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nKLPoPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7109CC433C7;
	Tue, 27 Feb 2024 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042569;
	bh=OqG0G3NsI2S9AtfL4nFHNCU5emXHf16vQbJRJHgQTCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nKLPoPBLtmgZFNO+PIJHjjl77B2FOYzDcJB12ACh6+uwEYeGhqvyt39JJs7l2MNe
	 o5EUTBfqUTKh+LMi9Z1Awlz30dxXO2eVo2J321hB9JVebj95j0Dt/l8TDVCz6z7zpb
	 uQnPbFe+p3wvzTA4pjAHwcuutA2MbmpiabH1Fw6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/245] nvme-fc: do not wait in vain when unloading module
Date: Tue, 27 Feb 2024 14:23:50 +0100
Message-ID: <20240227131616.491377191@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 70fbfc47a392b98e5f8dba70c6efc6839205c982 ]

The module exit path has race between deleting all controllers and
freeing 'left over IDs'. To prevent double free a synchronization
between nvme_delete_ctrl and ida_destroy has been added by the initial
commit.

There is some logic around trying to prevent from hanging forever in
wait_for_completion, though it does not handling all cases. E.g.
blktests is able to reproduce the situation where the module unload
hangs forever.

If we completely rely on the cleanup code executed from the
nvme_delete_ctrl path, all IDs will be freed eventually. This makes
calling ida_destroy unnecessary. We only have to ensure that all
nvme_delete_ctrl code has been executed before we leave
nvme_fc_exit_module. This is done by flushing the nvme_delete_wq
workqueue.

While at it, remove the unused nvme_fc_wq workqueue too.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 47 ++++++------------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index aa14ad963d910..8dfd317509aa6 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -220,11 +220,6 @@ static LIST_HEAD(nvme_fc_lport_list);
 static DEFINE_IDA(nvme_fc_local_port_cnt);
 static DEFINE_IDA(nvme_fc_ctrl_cnt);
 
-static struct workqueue_struct *nvme_fc_wq;
-
-static bool nvme_fc_waiting_to_unload;
-static DECLARE_COMPLETION(nvme_fc_unload_proceed);
-
 /*
  * These items are short-term. They will eventually be moved into
  * a generic FC class. See comments in module init.
@@ -254,8 +249,6 @@ nvme_fc_free_lport(struct kref *ref)
 	/* remove from transport list */
 	spin_lock_irqsave(&nvme_fc_lock, flags);
 	list_del(&lport->port_list);
-	if (nvme_fc_waiting_to_unload && list_empty(&nvme_fc_lport_list))
-		complete(&nvme_fc_unload_proceed);
 	spin_unlock_irqrestore(&nvme_fc_lock, flags);
 
 	ida_simple_remove(&nvme_fc_local_port_cnt, lport->localport.port_num);
@@ -3904,10 +3897,6 @@ static int __init nvme_fc_init_module(void)
 {
 	int ret;
 
-	nvme_fc_wq = alloc_workqueue("nvme_fc_wq", WQ_MEM_RECLAIM, 0);
-	if (!nvme_fc_wq)
-		return -ENOMEM;
-
 	/*
 	 * NOTE:
 	 * It is expected that in the future the kernel will combine
@@ -3925,7 +3914,7 @@ static int __init nvme_fc_init_module(void)
 	ret = class_register(&fc_class);
 	if (ret) {
 		pr_err("couldn't register class fc\n");
-		goto out_destroy_wq;
+		return ret;
 	}
 
 	/*
@@ -3949,8 +3938,6 @@ static int __init nvme_fc_init_module(void)
 	device_destroy(&fc_class, MKDEV(0, 0));
 out_destroy_class:
 	class_unregister(&fc_class);
-out_destroy_wq:
-	destroy_workqueue(nvme_fc_wq);
 
 	return ret;
 }
@@ -3970,45 +3957,23 @@ nvme_fc_delete_controllers(struct nvme_fc_rport *rport)
 	spin_unlock(&rport->lock);
 }
 
-static void
-nvme_fc_cleanup_for_unload(void)
+static void __exit nvme_fc_exit_module(void)
 {
 	struct nvme_fc_lport *lport;
 	struct nvme_fc_rport *rport;
-
-	list_for_each_entry(lport, &nvme_fc_lport_list, port_list) {
-		list_for_each_entry(rport, &lport->endp_list, endp_list) {
-			nvme_fc_delete_controllers(rport);
-		}
-	}
-}
-
-static void __exit nvme_fc_exit_module(void)
-{
 	unsigned long flags;
-	bool need_cleanup = false;
 
 	spin_lock_irqsave(&nvme_fc_lock, flags);
-	nvme_fc_waiting_to_unload = true;
-	if (!list_empty(&nvme_fc_lport_list)) {
-		need_cleanup = true;
-		nvme_fc_cleanup_for_unload();
-	}
+	list_for_each_entry(lport, &nvme_fc_lport_list, port_list)
+		list_for_each_entry(rport, &lport->endp_list, endp_list)
+			nvme_fc_delete_controllers(rport);
 	spin_unlock_irqrestore(&nvme_fc_lock, flags);
-	if (need_cleanup) {
-		pr_info("%s: waiting for ctlr deletes\n", __func__);
-		wait_for_completion(&nvme_fc_unload_proceed);
-		pr_info("%s: ctrl deletes complete\n", __func__);
-	}
+	flush_workqueue(nvme_delete_wq);
 
 	nvmf_unregister_transport(&nvme_fc_transport);
 
-	ida_destroy(&nvme_fc_local_port_cnt);
-	ida_destroy(&nvme_fc_ctrl_cnt);
-
 	device_destroy(&fc_class, MKDEV(0, 0));
 	class_unregister(&fc_class);
-	destroy_workqueue(nvme_fc_wq);
 }
 
 module_init(nvme_fc_init_module);
-- 
2.43.0



