Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD4535B142;
	Fri,  9 Jan 2026 12:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962370; cv=none; b=FzGwKHp+Tem2wVyDI2GB6hB4732tQ8aE453bxiBi6J580/A67MDMqH5cQEvli0eAsDHyFW9fvwEMfI7jkuTDOD6YkwrmVYGGON8Q2cVO3WR/wGKxiDzu30oDw/LzFvOjfTWhqIjVGoMb6XKB+G41n1DxB5M2z+ya9Lko8WxuwV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962370; c=relaxed/simple;
	bh=pW22243bXcnuFubO7JGwjBF8u6uC5DTjI3ZStWA7gTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3pj2mjUVgDng726hqNSVGoANLfV/j1Aus919bmdXxMbYiWgPnML4Wbr8PDpDZXIfgC+pfxyr7zTgfvGqhN8Ku9T7iU68wNh3cP+3YivTGh1+3pv1wtvpP2I12ugbAYkXblnRwbMQvEvhTH8q8VCMeNsOXsnhms+ru+69K9iz4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1bKLhXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1bKLhXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489C0C4CEF1;
	Fri,  9 Jan 2026 12:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962370;
	bh=pW22243bXcnuFubO7JGwjBF8u6uC5DTjI3ZStWA7gTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1bKLhXoLl2swxeChgZ1B5X4HFGe2Id3DofLUJneYCqRC0En6GUMA/BbAh4+Mo1AK
	 AXsTvbi6dR+ZTK8YpJGwLx0f7j0YUTikqw+Dg3idrYJfOs131o8UcHBzwUtNdvCAtz
	 8pN4379VYfAIUelUPKHktUgZ94pNjzzAzgqfh6/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/634] nvme-fc: dont hold rport lock when putting ctrl
Date: Fri,  9 Jan 2026 12:39:52 +0100
Message-ID: <20260109112129.347778472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f5b1378839a7..87a9801ac9f2 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1501,14 +1501,14 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
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
@@ -1521,7 +1521,9 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
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



