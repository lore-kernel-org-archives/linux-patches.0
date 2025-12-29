Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E9623D2B2;
	Mon, 29 Dec 2025 16:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025512; cv=none; b=Pt5SwGOdyZDVvjgQIthfBgkeEiG7ErbfJGFok5nnCHqYMk8S421NikKVfOcRypNyNgOZDyo/Gcz+XoSzNGxyQ+KE3OxSmOnrOg1AaxZXpWWLiFtzgwJsY3b2doBAKoI/74tx++/ObKspRii8ZLwC1WYpOtLHVWLWRv03MS8wIJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025512; c=relaxed/simple;
	bh=sdRdRpQ2o+DvzHudSPyHr+DFG650jhLCi8coBbQQz1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad65K8vOblIHTW3qcGpOXnX0JitoD/ABV7/Y/QrEOi+v8HJenW+jW9WO00eE4vrgluyalh8ZsWn9X7IBFvjefs79L7cb7c8aw77aDxjjjUgroHhiKFwVIyaD8L/D7fwjovwvPjA+gQLSiYjtlMulTzaWtSjdI1AFST9nGrFE+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXAfGZxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXAfGZxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C14C4CEF7;
	Mon, 29 Dec 2025 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025511;
	bh=sdRdRpQ2o+DvzHudSPyHr+DFG650jhLCi8coBbQQz1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXAfGZxVcUgl7d2cT98C2eRy2UPIQrKmWzJMmVsBW/1M4AbKYKHDbfQ3uG3Srig8l
	 Oe1MNIl8/RYuKkhubWuT8czXxB5LI/JDTM2Ov+TB85JuKjB8H1ND2Qo8oMJQ8abm7c
	 Y8qwpk1218bmDPn7o6JOQkBdjbfx2XDNL24xsqmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/430] nvme-fc: dont hold rport lock when putting ctrl
Date: Mon, 29 Dec 2025 17:10:09 +0100
Message-ID: <20251229160731.971549966@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2c903729b0b9..8324230c5371 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1468,14 +1468,14 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
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
@@ -1488,7 +1488,9 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
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



