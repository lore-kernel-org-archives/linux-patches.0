Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4338D18DB17;
	Wed, 23 Apr 2025 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420121; cv=none; b=LxwCHeTACik6JkizT/lBEhw7zez9TI2Tr6sTy7ue3ZXTKyMmMqkte45MQY3il2BHRGvFpQpZI6Z4DvDhZcVpNvBKN4xiW7H7dAEpdVeU8oVIZdDcznjWyIVaKAu5JwVH2xUOddMUsrSTY/X4MZJZI5+HJK8EiVcG70wyo+8upIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420121; c=relaxed/simple;
	bh=Glx7QZb3iCVP5gHgWOl6FvGSjZarnasYeIjL8bAElAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgcXWQNJF2CBqR0h11FZmBLCQtkjJ0dYPx/UlKu5KqRF4OvQ6Uv+qHUasdze/MzXR12nkXAvHy2eAWfnJUlVYUyYN+XPkiarig7jlhbTsEXF4z+SMpvpB5/WYyNsIKGtQPMWpq1WPSgQufG367h9oi4BwIKbZcaa/+yAAJO0vVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqcWZYjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqcWZYjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F7C4CEE3;
	Wed, 23 Apr 2025 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420121;
	bh=Glx7QZb3iCVP5gHgWOl6FvGSjZarnasYeIjL8bAElAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqcWZYjgXsRrgxM+PVX0avZgjBdIRs8LkEwV0gWUOdA8nRfn3JkO9wANApLVaNsDa
	 XBQ3ZgIDsKhH7IF+ofRTN/mkx6OyM3a15VEXhkBPhvyE4XY8enIYhcbZ/Zlv2vU07P
	 Grdaw8FHzMKrz1A1vtrZwbSjDYWraVz+yKtECgn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 061/241] nvmet: pci-epf: always fully initialize completion entries
Date: Wed, 23 Apr 2025 16:42:05 +0200
Message-ID: <20250423142623.097181536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ffe0398c7d6a38af0584d4668d3762b7a97e2275 ]

For a command that is normally processed through the command request
execute() function, the completion entry for the command is initialized
by __nvmet_req_complete() and nvmet_pci_epf_cq_work() only needs to set
the status field and the phase of the completion entry before posting
the entry to the completion queue.

However, for commands that are failed due to an internal error (e.g. the
command data buffer allocation fails), the command request execute()
function is not called and __nvmet_req_complete() is never executed for
the command, leaving the command completion entry uninitialized. For
such command failed before calling req->execute(), the host ends up
seeing completion entries with an invalid submission queue ID and
command ID.

Avoid such issue by always fully initilizing a command completion entry
in nvmet_pci_epf_cq_work(), setting the entry submission queue head, ID
and command ID.

Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pci-epf.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 99563648c318f..70855bb9823af 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -1655,16 +1655,17 @@ static int nvmet_pci_epf_process_sq(struct nvmet_pci_epf_ctrl *ctrl,
 {
 	struct nvmet_pci_epf_iod *iod;
 	int ret, n = 0;
+	u16 head = sq->head;
 
 	sq->tail = nvmet_pci_epf_bar_read32(ctrl, sq->db);
-	while (sq->head != sq->tail && (!ctrl->sq_ab || n < ctrl->sq_ab)) {
+	while (head != sq->tail && (!ctrl->sq_ab || n < ctrl->sq_ab)) {
 		iod = nvmet_pci_epf_alloc_iod(sq);
 		if (!iod)
 			break;
 
 		/* Get the NVMe command submitted by the host. */
 		ret = nvmet_pci_epf_transfer(ctrl, &iod->cmd,
-					     sq->pci_addr + sq->head * sq->qes,
+					     sq->pci_addr + head * sq->qes,
 					     sq->qes, DMA_FROM_DEVICE);
 		if (ret) {
 			/* Not much we can do... */
@@ -1673,12 +1674,13 @@ static int nvmet_pci_epf_process_sq(struct nvmet_pci_epf_ctrl *ctrl,
 		}
 
 		dev_dbg(ctrl->dev, "SQ[%u]: head %u, tail %u, command %s\n",
-			sq->qid, sq->head, sq->tail,
+			sq->qid, head, sq->tail,
 			nvmet_pci_epf_iod_name(iod));
 
-		sq->head++;
-		if (sq->head == sq->depth)
-			sq->head = 0;
+		head++;
+		if (head == sq->depth)
+			head = 0;
+		WRITE_ONCE(sq->head, head);
 		n++;
 
 		queue_work_on(WORK_CPU_UNBOUND, sq->iod_wq, &iod->work);
@@ -1772,8 +1774,17 @@ static void nvmet_pci_epf_cq_work(struct work_struct *work)
 		if (!iod)
 			break;
 
-		/* Post the IOD completion entry. */
+		/*
+		 * Post the IOD completion entry. If the IOD request was
+		 * executed (req->execute() called), the CQE is already
+		 * initialized. However, the IOD may have been failed before
+		 * that, leaving the CQE not properly initialized. So always
+		 * initialize it here.
+		 */
 		cqe = &iod->cqe;
+		cqe->sq_head = cpu_to_le16(READ_ONCE(iod->sq->head));
+		cqe->sq_id = cpu_to_le16(iod->sq->qid);
+		cqe->command_id = iod->cmd.common.command_id;
 		cqe->status = cpu_to_le16((iod->status << 1) | cq->phase);
 
 		dev_dbg(ctrl->dev,
-- 
2.39.5



