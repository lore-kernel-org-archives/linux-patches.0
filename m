Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBF013B79B;
	Tue, 27 Feb 2024 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040675; cv=none; b=SHRNdUAAb0F4VucOweEy6RuAhdsU2wFolRrUnRzvORZKDIDG5+f0PpbCwVspTiyX8y9lMOGUaRVRAV1X4TQlmzdiJ62KE4vAKMQD6WCXcb+bO0dNrbkHbKLiFQhRoU9bEZU+9H9OgDPcoXR/Q4dVRNqct2vD/et4TOdawIzZEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040675; c=relaxed/simple;
	bh=MTv4P7R6jxyp7UxxN4aiT3dzzehXkugOZ1SoXzmc+u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGtnKAbFl3ebazZ6tEkjkr+DYEWuU77116TbF+E+MulffbqPrJfnc9FPfNbPmzh6o6Kiw1WAUmH0k5NHmpd9Bi8AEVoaonvT+Agfkbmiw3/v8F7yaa4qWgmar7/+h2P51V1xYlxaus94kG9tKKNYoizIjy+K28/92ti3rTaDkjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0S22X6cL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0S22X6cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCA2C433C7;
	Tue, 27 Feb 2024 13:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040674;
	bh=MTv4P7R6jxyp7UxxN4aiT3dzzehXkugOZ1SoXzmc+u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0S22X6cLoxnsS/hM/R6pIO9Aq9g6kL8fxcsivdLcS07OymMkYwNSyq9Dg6NgKT7yY
	 i+Yutp1r2SdM4r+i8ZDkLy0vfWI8PhTqdngDTKR2hC8H8M6nt3qWxB8Gd4ZjhF5FYM
	 XPnEtrdGmddEk1k5Z/ePkt3Eh/gdrIQzOHlHfCZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 070/334] nvmet-fc: avoid deadlock on delete association path
Date: Tue, 27 Feb 2024 14:18:48 +0100
Message-ID: <20240227131632.811186737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 710c69dbaccdac312e32931abcb8499c1525d397 ]

When deleting an association the shutdown path is deadlocking because we
try to flush the nvmet_wq nested. Avoid this by deadlock by deferring
the put work into its own work item.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 686843eb2ebf3..eaed465bae3bd 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -111,6 +111,8 @@ struct nvmet_fc_tgtport {
 	struct nvmet_fc_port_entry	*pe;
 	struct kref			ref;
 	u32				max_sg_cnt;
+
+	struct work_struct		put_work;
 };
 
 struct nvmet_fc_port_entry {
@@ -247,6 +249,13 @@ static int nvmet_fc_tgt_a_get(struct nvmet_fc_tgt_assoc *assoc);
 static void nvmet_fc_tgt_q_put(struct nvmet_fc_tgt_queue *queue);
 static int nvmet_fc_tgt_q_get(struct nvmet_fc_tgt_queue *queue);
 static void nvmet_fc_tgtport_put(struct nvmet_fc_tgtport *tgtport);
+static void nvmet_fc_put_tgtport_work(struct work_struct *work)
+{
+	struct nvmet_fc_tgtport *tgtport =
+		container_of(work, struct nvmet_fc_tgtport, put_work);
+
+	nvmet_fc_tgtport_put(tgtport);
+}
 static int nvmet_fc_tgtport_get(struct nvmet_fc_tgtport *tgtport);
 static void nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
 					struct nvmet_fc_fcp_iod *fod);
@@ -358,7 +367,7 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 
 	if (!lsop->req_queued) {
 		spin_unlock_irqrestore(&tgtport->lock, flags);
-		goto out_puttgtport;
+		goto out_putwork;
 	}
 
 	list_del(&lsop->lsreq_list);
@@ -371,8 +380,8 @@ __nvmet_fc_finish_ls_req(struct nvmet_fc_ls_req_op *lsop)
 				  (lsreq->rqstlen + lsreq->rsplen),
 				  DMA_BIDIRECTIONAL);
 
-out_puttgtport:
-	nvmet_fc_tgtport_put(tgtport);
+out_putwork:
+	queue_work(nvmet_wq, &tgtport->put_work);
 }
 
 static int
@@ -1403,6 +1412,7 @@ nvmet_fc_register_targetport(struct nvmet_fc_port_info *pinfo,
 	kref_init(&newrec->ref);
 	ida_init(&newrec->assoc_cnt);
 	newrec->max_sg_cnt = template->max_sgl_segments;
+	INIT_WORK(&newrec->put_work, nvmet_fc_put_tgtport_work);
 
 	ret = nvmet_fc_alloc_ls_iodlist(newrec);
 	if (ret) {
-- 
2.43.0



