Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2565A168C4;
	Mon, 27 May 2024 19:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837684; cv=none; b=PqMdPOy2dNNNGCZycDqFSuwJrYL9/hauIdutdjWsmv9FOHWJjwIV/aDCcjAM1DaX4z+PxaVHqDPz6NQLzsiJf1iwKdFQB7s7zufeIm1TOCAHqmw6xklsdsXXAqWi+jrBR41Zmrtb3MnDwoxu9H47sJUItKpqkSNpNrfYz+maeFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837684; c=relaxed/simple;
	bh=4tMWSN89NgsK5bCJ7emhBkhVmywai1+MEsFTgzLQiBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig0kNT9FR/0+UihJifUQbrxN27YaDFwZGh+oS4xyL4NtcLXHZ8fTk+scMQaefTojib4+vK0ywUml2yBU/cqgFN2Bi5YwIUO7urtNaZOw0OKJcMK7vKUr+Bi5sZ6QsJRQYOsHHa2+r/LtuZcvTzKJkf+eCIpXSrbGkdjkvv/wnsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9NNsvZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9NNsvZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5E8C2BBFC;
	Mon, 27 May 2024 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837684;
	bh=4tMWSN89NgsK5bCJ7emhBkhVmywai1+MEsFTgzLQiBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9NNsvZgFEDLUqaxP1+JcNAGu95HSsYGcEnSkI9LyxJTbk5kODDVRYp0SJJ7gHlT8
	 tOWRf1PJDD0yJ5IqjcVZuSrrGwlDmtKu1t93UIo4rYqLMEcnLm5ZBQmLZb972r0nE2
	 mZhtv4kWkYKgcNWiYOq1JX9yFpmEEZgo0NPcHG+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 104/493] nvme: cancel pending I/O if nvme controller is in terminal state
Date: Mon, 27 May 2024 20:51:46 +0200
Message-ID: <20240527185633.917614256@linuxfoundation.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 25bb3534ee21e39eb9301c4edd7182eb83cb0d07 ]

While I/O is running, if the pci bus error occurs then
in-flight I/O can not complete. Worst, if at this time,
user (logically) hot-unplug the nvme disk then the
nvme_remove() code path can't forward progress until
in-flight I/O is cancelled. So these sequence of events
may potentially hang hot-unplug code path indefinitely.
This patch helps cancel the pending/in-flight I/O from the
nvme request timeout handler in case the nvme controller
is in the terminal (DEAD/DELETING/DELETING_NOIO) state and
that helps nvme_remove() code path forward progress and
finish successfully.

Link: https://lore.kernel.org/all/199be893-5dfa-41e5-b6f2-40ac90ebccc4@linux.ibm.com/
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 21 ---------------------
 drivers/nvme/host/nvme.h | 21 +++++++++++++++++++++
 drivers/nvme/host/pci.c  |  8 +++++++-
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 26153cb7647d7..3cc79817e4d75 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -619,27 +619,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 }
 EXPORT_SYMBOL_GPL(nvme_change_ctrl_state);
 
-/*
- * Returns true for sink states that can't ever transition back to live.
- */
-static bool nvme_state_terminal(struct nvme_ctrl *ctrl)
-{
-	switch (nvme_ctrl_state(ctrl)) {
-	case NVME_CTRL_NEW:
-	case NVME_CTRL_LIVE:
-	case NVME_CTRL_RESETTING:
-	case NVME_CTRL_CONNECTING:
-		return false;
-	case NVME_CTRL_DELETING:
-	case NVME_CTRL_DELETING_NOIO:
-	case NVME_CTRL_DEAD:
-		return true;
-	default:
-		WARN_ONCE(1, "Unhandled ctrl state:%d", ctrl->state);
-		return true;
-	}
-}
-
 /*
  * Waits for the controller state to be resetting, or returns false if it is
  * not possible to ever transition to that state.
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 738719085e054..2a7bf574284f6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -745,6 +745,27 @@ static inline bool nvme_is_aen_req(u16 qid, __u16 command_id)
 		nvme_tag_from_cid(command_id) >= NVME_AQ_BLK_MQ_DEPTH;
 }
 
+/*
+ * Returns true for sink states that can't ever transition back to live.
+ */
+static inline bool nvme_state_terminal(struct nvme_ctrl *ctrl)
+{
+	switch (nvme_ctrl_state(ctrl)) {
+	case NVME_CTRL_NEW:
+	case NVME_CTRL_LIVE:
+	case NVME_CTRL_RESETTING:
+	case NVME_CTRL_CONNECTING:
+		return false;
+	case NVME_CTRL_DELETING:
+	case NVME_CTRL_DELETING_NOIO:
+	case NVME_CTRL_DEAD:
+		return true;
+	default:
+		WARN_ONCE(1, "Unhandled ctrl state:%d", ctrl->state);
+		return true;
+	}
+}
+
 void nvme_complete_rq(struct request *req);
 void nvme_complete_batch_req(struct request *req);
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 02565dc99ad85..710043086dffa 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1286,6 +1286,9 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 	u32 csts = readl(dev->bar + NVME_REG_CSTS);
 	u8 opcode;
 
+	if (nvme_state_terminal(&dev->ctrl))
+		goto disable;
+
 	/* If PCI error recovery process is happening, we cannot reset or
 	 * the recovery mechanism will surely fail.
 	 */
@@ -1390,8 +1393,11 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 	return BLK_EH_RESET_TIMER;
 
 disable:
-	if (!nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_RESETTING))
+	if (!nvme_change_ctrl_state(&dev->ctrl, NVME_CTRL_RESETTING)) {
+		if (nvme_state_terminal(&dev->ctrl))
+			nvme_dev_disable(dev, true);
 		return BLK_EH_DONE;
+	}
 
 	nvme_dev_disable(dev, false);
 	if (nvme_try_sched_reset(&dev->ctrl))
-- 
2.43.0



