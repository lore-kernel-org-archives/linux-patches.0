Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED8C1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D3FC433C1;
	Wed, 23 Nov 2022 09:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195669;
	bh=SsFWBR3HZ9wgA3nMbPY5ENwrqvXCbyOID5Q0i/49Ms4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYY3UvaDUZlBeTh09aZx1+6lxqGDhVs1CBIb17im/Et56As5GNr4Zgd5EjLy1lpHN
	 E60JKjLDxe2Qmy4tpuVgmEUM1l4/1QEnG6ww2VhggRnJhUUED4o/Hh1AnHDIbSUGWS
	 qEpZBjkBxO75+ZEOAlBXwavMG/7858hn7mam6Bao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 127/149] nvme: ensure subsystem reset is single threaded
Date: Wed, 23 Nov 2022 09:51:50 +0100
Message-Id: <20221123084602.485839010@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

commit 1e866afd4bcdd01a70a5eddb4371158d3035ce03 upstream.

The subsystem reset writes to a register, so we have to ensure the
device state is capable of handling that otherwise the driver may access
unmapped registers. Use the state machine to ensure the subsystem reset
doesn't try to write registers on a device already undergoing this type
of reset.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214771
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/nvme.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -544,11 +544,23 @@ static inline void nvme_fault_inject_fin
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -635,7 +647,6 @@ void nvme_cancel_tagset(struct nvme_ctrl
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -688,7 +699,6 @@ int nvme_set_queue_count(struct nvme_ctr
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,


