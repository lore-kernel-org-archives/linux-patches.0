Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590394;
	b=1iAcE4v4NYeAZ+k2i7o1H1ipqQ4fid/Cw/kkRQJCU8hzRHC9FPx4xOH7dFEOFWrsDx2q
	 wXyNU8zr/enHx1rh3o3osNGHCPJZqFx85dz8OMIA70eYnXP6KoDUMfQaac6QG+sP498yf
	 Ujs9zHg7chyPNpef14XeCr4t3KgO12agOln82QxqEOVv3o5UVF+mXEzsVns+c5sztogV/
	 UFScKqcSXfWLbuiYqdOavghqzlh0AY2cZMPX/ORto2oTWLQjTbEnxkoqAJEDAmlxdT5jg
	 ryaTfB7jciQxz5jFMP5pnTxlczsMT7P/XoOFlRTlvscOgCRfQF+GPgsmXbU8o7oYDhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1ZO8NGsgl07cdZ0+dxRNjSc6a2PDnsAtOCayz+7T7U=;
	b=qar2whATeeoQxWR9FvgFs8fM1eu2gG2DhdWzhHyyutb06A01vveST8QBGHCDM57c+42j
	 6erxjX3ojT+9OnqOBzsBRSs3ubor8c8acehL1OQLGMy2ZeXFX0ajl7RJ+Z0ErXp4s2jda
	 3s/dJ2krPaf/DmdTh3AwP7WMvQl+HJ6jcKzFpPfC4XLMRtLvPuSfZ2Kj45E6ODeM6dV5F
	 sX0MzGtrcVpBIg0g5GofUYTRATTUPs/8Zpl/TiwrsUJzG2KVS7x3HhUDOXJ9/wk93EEKu
	 jmFSuTEX7xfYLtMO1Mm6s5DNZlW995YLZZllRo1VJR9/ZuEXqEi5+rIP/EG/WkJUnNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9w+prOE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737C606B444;
	Fri, 13 Nov 2026 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9w+prOE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B808B1F000C7;
	Fri, 13 Nov 2026 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590393;
	bh=q1ZO8NGsgl07cdZ0+dxRNjSc6a2PDnsAtOCayz+7T7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9w+prOEeHv2yjSrngFhO/ZT6bOI2fKCCkWo9e4GadCpXTENgYK6P54+Be/tQjZMg
	 axFzYPfYmSL8+FPtL/rO7AEwrB1lWJsVUid0BcMyvjC+LwiGgN6KHqh2dk4XpUJjwo
	 EzR/ALZ4qc/ASiZKK6CkSJ8oXRNTtYEo0wYm2EPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yingjie Wang <1075151112@qq.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/686] nvmet: reject keep-alive timeouts that would overflow
Date: Fri, 13 Nov 2026 10:48:14 -0500
Message-ID: <20261113153833.138115242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 96ae13f40ce5930cd58c43128e385131476f2a66 ]

nvmet_set_feat_kato() and nvmet_alloc_ctrl() convert the 32-bit
millisecond KATO from the host to seconds with DIV_ROUND_UP(kato, 1000).
The addition in DIV_ROUND_UP() is done in 32 bits, so any KATO above
4294966296 ms wraps around and rounds to 0 seconds. A Set Features
command with KATO 0xffffffff then succeeds but disables the keep-alive
timer: Get Features returns 0 and Keep Alive fails with Keep Alive
Timeout Invalid. A Connect command with such a KATO creates a controller
without a keep-alive timer.

The converted value has more consumers that can overflow. Get Features
multiplies it by 1000, and the timer paths multiply it by HZ in 32 bits
and arm a delay that must not exceed MAX_JIFFY_OFFSET.

Reject a KATO whose rounded value does not fit all of these. Return Keep
Alive Timeout Invalid from both Set Features and Connect. Validate Set
Features before stopping the current timer so a failed update leaves its
timeout unchanged. Round in 64 bits. A KATO of 0 keeps its current
meaning.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 7 ++++++-
 drivers/nvme/target/core.c      | 8 +++++++-
 drivers/nvme/target/nvmet.h     | 8 ++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 623b5303de2aa..f86336c79056d 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1228,8 +1228,13 @@ u16 nvmet_set_feat_kato(struct nvmet_req *req)
 {
 	u32 val32 = le32_to_cpu(req->cmd->common.cdw11);
 
+	if (val32 > NVMET_MAX_KATO * MSEC_PER_SEC) {
+		req->error_loc = offsetof(struct nvme_common_command, cdw11);
+		return NVME_SC_KA_TIMEOUT_INVALID | NVME_STATUS_DNR;
+	}
+
 	nvmet_stop_keep_alive_timer(req->sq->ctrl);
-	req->sq->ctrl->kato = DIV_ROUND_UP(val32, 1000);
+	req->sq->ctrl->kato = DIV_ROUND_UP_ULL(val32, MSEC_PER_SEC);
 	nvmet_start_keep_alive_timer(req->sq->ctrl);
 
 	nvmet_set_result(req, req->sq->ctrl->kato);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 9b64c313c7039..36b3dab59e212 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1588,6 +1588,12 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	u8 dhchap_status;
 	int ret;
 
+	if (kato > NVMET_MAX_KATO * MSEC_PER_SEC) {
+		args->status = NVME_SC_KA_TIMEOUT_INVALID | NVME_STATUS_DNR;
+		args->error_loc = offsetof(struct nvmf_connect_command, kato);
+		return NULL;
+	}
+
 	args->status = NVME_SC_CONNECT_INVALID_PARAM | NVME_STATUS_DNR;
 	subsys = nvmet_find_get_subsys(args->port, args->subsysnqn);
 	if (!subsys) {
@@ -1655,7 +1661,7 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 		kato = NVMET_DISC_KATO_MS;
 
 	/* keep-alive timeout in seconds */
-	ctrl->kato = DIV_ROUND_UP(kato, 1000);
+	ctrl->kato = DIV_ROUND_UP_ULL(kato, MSEC_PER_SEC);
 
 	ctrl->err_counter = 0;
 	spin_lock_init(&ctrl->error_lock);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 45fc188412d28..6a0d9b37443e8 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -7,6 +7,7 @@
 #define _NVMET_H
 
 #include <linux/dma-mapping.h>
+#include <linux/jiffies.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/kref.h>
@@ -694,6 +695,13 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 #define NVMET_KAS		10
 #define NVMET_DISC_KATO_MS		120000
 
+/*
+ * Largest keep-alive timeout in seconds that can be reported back in
+ * milliseconds and converted to jiffies without overflowing.
+ */
+#define NVMET_MAX_KATO	\
+	min3(U32_MAX / MSEC_PER_SEC, U32_MAX / HZ, MAX_JIFFY_OFFSET / HZ)
+
 int __init nvmet_init_configfs(void);
 void __exit nvmet_exit_configfs(void);
 
-- 
2.53.0



