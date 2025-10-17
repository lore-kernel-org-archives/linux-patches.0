Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A51330B22;
	Fri, 17 Oct 2025 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716109; cv=none; b=Z9axj0t141grX7MTC2NV00ZtGpyutBIniA//KomvTqr0DxfDOi0wgGF9IA8HzEft9hqKf/OugBj8yasx2HK/NBW//phSybf/BaL7Rsshmu+7r7lmxvcnanhT5WOMAife7pX+O2nw3Adv9J856NgFWUBEidPqzrTL7AHk2vcfpGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716109; c=relaxed/simple;
	bh=CpC3NOPKw3hUvicdXL7odml6Tml+wP730cOFA7TNhew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ekK1A/ETCInXbtnFocCL0n3PasGs3f42cGCPnK3FmPpnvpFV3l5P84TqbyeyWucoqcCTk33o/khyT8zlzyg2uqGdhjUzKwoTWl/+f5hXhjB3SB3aZplFn0BV4k8AUmfLH8W9MB3whfsK1OBn+1YKMX+U9S3oUrMZTQWryUS5qxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBtjUOPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBtjUOPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8883C113D0;
	Fri, 17 Oct 2025 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716109;
	bh=CpC3NOPKw3hUvicdXL7odml6Tml+wP730cOFA7TNhew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBtjUOPoiUYmb5d9h96Er3CBK7+xw/TNZh3WnBKsR094VON7DPA3j1R3DIp5Lp8ir
	 nsKB9wwFTnMNRbmKGW4ka7EIZ8eO6ymR6a8P8f30pXT/+e/vBxwLEYcE9CS4yBxX94
	 WkVrfV2B148U3/bvckGvyDk+LMDPb1em9Z9wGsEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/276] nvmet-fc: move lsop put work to nvmet_fc_ls_req_op
Date: Fri, 17 Oct 2025 16:52:16 +0200
Message-ID: <20251017145143.977421156@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit db5a5406fb7e5337a074385c7a3e53c77f2c1bd3 ]

It’s possible for more than one async command to be in flight from
__nvmet_fc_send_ls_req. For each command, a tgtport reference is taken.

In the current code, only one put work item is queued at a time, which
results in a leaked reference.

To fix this, move the work item to the nvmet_fc_ls_req_op struct, which
already tracks all resources related to the command.

Fixes: 710c69dbaccd ("nvmet-fc: avoid deadlock on delete association path")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 812d085d49c99..4c4b528b89ebe 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -54,6 +54,8 @@ struct nvmet_fc_ls_req_op {		/* for an LS RQST XMT */
 	int				ls_error;
 	struct list_head		lsreq_list; /* tgtport->ls_req_list */
 	bool				req_queued;
+
+	struct work_struct		put_work;
 };
 
 
@@ -111,8 +113,6 @@ struct nvmet_fc_tgtport {
 	struct nvmet_fc_port_entry	*pe;
 	struct kref			ref;
 	u32				max_sg_cnt;
-
-	struct work_struct		put_work;
 };
 
 struct nvmet_fc_port_entry {
@@ -236,12 +236,13 @@ static int nvmet_fc_tgt_a_get(struct nvmet_fc_tgt_assoc *assoc);
 static void nvmet_fc_tgt_q_put(struct nvmet_fc_tgt_queue *queue);
 static int nvmet_fc_tgt_q_get(struct nvmet_fc_tgt_queue *queue);
 static void nvmet_fc_tgtport_put(struct nvmet_fc_tgtport *tgtport);
-static void nvmet_fc_put_tgtport_work(struct work_struct *work)
+static void nvmet_fc_put_lsop_work(struct work_struct *work)
 {
-	struct nvmet_fc_tgtport *tgtport =
-		container_of(work, struct nvmet_fc_tgtport, put_work);
+	struct nvmet_fc_ls_req_op *lsop =
+		container_of(work, struct nvmet_fc_ls_req_op, put_work);
 
-	nvmet_fc_tgtport_put(tgtport);
+	nvmet_fc_tgtport_put(lsop->tgtport);
+	kfree(lsop);
 }
 static int nvmet_fc_tgtport_get(struct nvmet_fc_tgtport *tgtport);
 static void nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
@@ -368,7 +369,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 				  DMA_BIDIRECTIONAL);
 
 out_putwork:
-	queue_work(nvmet_wq, &tgtport->put_work);
+	queue_work(nvmet_wq, &lsop->put_work);
 }
 
 static int
@@ -389,6 +390,7 @@ __nvmet_fc_send_ls_req(struct nvmet_fc_tgtport *tgtport,
 	lsreq->done = done;
 	lsop->req_queued = false;
 	INIT_LIST_HEAD(&lsop->lsreq_list);
+	INIT_WORK(&lsop->put_work, nvmet_fc_put_lsop_work);
 
 	lsreq->rqstdma = fc_dma_map_single(tgtport->dev, lsreq->rqstaddr,
 				  lsreq->rqstlen + lsreq->rsplen,
@@ -448,8 +450,6 @@ nvmet_fc_disconnect_assoc_done(struct nvmefc_ls_req *lsreq, int status)
 	__nvmet_fc_finish_ls_req(lsop);
 
 	/* fc-nvme target doesn't care about success or failure of cmd */
-
-	kfree(lsop);
 }
 
 /*
@@ -1407,7 +1407,6 @@ nvmet_fc_register_targetport(struct nvmet_fc_port_info *pinfo,
 	kref_init(&newrec->ref);
 	ida_init(&newrec->assoc_cnt);
 	newrec->max_sg_cnt = template->max_sgl_segments;
-	INIT_WORK(&newrec->put_work, nvmet_fc_put_tgtport_work);
 
 	ret = nvmet_fc_alloc_ls_iodlist(newrec);
 	if (ret) {
-- 
2.51.0



