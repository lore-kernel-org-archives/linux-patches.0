Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC34C359708;
	Fri,  9 Jan 2026 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960445; cv=none; b=o1wx1wbFGqJ7X0VxYX1HSe/NnzrfLc5C22zD9mawUD5ZYxHIsS5B0oTWFI+/VZgespCxeS6H2EeZpWfIRjiKg6/YmkYrnaIejifFoU38sR9bEo9khyRMyBCznxdJ22lpr+MF7yl/V57TMjtxnVfiT1zGSDUWNrVujQcV1MYbVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960445; c=relaxed/simple;
	bh=EY0xjmUJMVqgi5RwXjUsWNnvdoOVI4z6owUlaQrKfkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3DeU6L3vXJ2FCcvIWNvTBkZgOU++Po6G87vEMmyWibs5fcu7P4JLBywUckcRl5oY6AdUqC2WsUKQke1hoqLv1+jZJsU88aMJQh5rCUsJPYP/7aRIR86X8K3CHfMiFvLturMdSIpx3FBs7ow0dT2gLS7OTbkcr65JF12i3HWMIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YR2ZcLU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR2ZcLU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CACC4CEF1;
	Fri,  9 Jan 2026 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960445;
	bh=EY0xjmUJMVqgi5RwXjUsWNnvdoOVI4z6owUlaQrKfkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YR2ZcLU1OlYST/5iGtv8OGKx8hmUMY3jLt3f5WfVRdtBunC9MLxP5MdjEarfn2pp6
	 fJlms4q23FOcULHEuJZFDHY/5F4msleMb9x0Sss+6UlxD8O1mD0+LK6Oarrh9Md809
	 Ohajb6bwZ+9p+DRHTA0ommYXvHj7rq7mn5Ug3Y9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 407/737] nvme-fc: dont hold rport lock when putting ctrl
Date: Fri,  9 Jan 2026 12:39:06 +0100
Message-ID: <20260109112149.309203167@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit b71cbcf7d170e51148d5467820ae8a72febcb651 ]

nvme_fc_ctrl_put can acquire the rport lock when freeing the
ctrl object:

nvme_fc_ctrl_put
  nvme_fc_ctrl_free
    spin_lock_irqsave(rport->lock)

Thus we can't hold the rport lock when calling nvme_fc_ctrl_put.

Justin suggested use the safe list iterator variant because
nvme_fc_ctrl_put will also modify the rport->list.

Cc: Justin Tee <justin.tee@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 37fede155b92..2954f0a27474 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1462,14 +1462,14 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
 {
 	struct fcnvme_ls_disconnect_assoc_rqst *rqst =
 					&lsop->rqstbuf->rq_dis_assoc;
-	struct nvme_fc_ctrl *ctrl, *ret = NULL;
+	struct nvme_fc_ctrl *ctrl, *tmp, *ret = NULL;
 	struct nvmefc_ls_rcv_op *oldls = NULL;
 	u64 association_id = be64_to_cpu(rqst->associd.association_id);
 	unsigned long flags;
 
 	spin_lock_irqsave(&rport->lock, flags);
 
-	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
+	list_for_each_entry_safe(ctrl, tmp, &rport->ctrl_list, ctrl_list) {
 		if (!nvme_fc_ctrl_get(ctrl))
 			continue;
 		spin_lock(&ctrl->lock);
@@ -1482,7 +1482,9 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
 		if (ret)
 			/* leave the ctrl get reference */
 			break;
+		spin_unlock_irqrestore(&rport->lock, flags);
 		nvme_fc_ctrl_put(ctrl);
+		spin_lock_irqsave(&rport->lock, flags);
 	}
 
 	spin_unlock_irqrestore(&rport->lock, flags);
-- 
2.51.0



