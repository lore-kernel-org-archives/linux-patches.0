Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585676;
	b=KxcI0Cc3cU8ZBFcoCt8xjLMA4V1I5WiV6JRovMz8s65TD9WYZWBQ3YgWK+KeeCmorVcu
	 8krAZHJZkVIA6vdk9pPcwd/IHPPBIHL++YGFRdgmtDhpK9Ont+j5fOzGGxmNUQOw1XKUY
	 5u3m82/2aa2cXALp2rYOvG3t5F/fzhT3KlO7/cS/fz9YvkoxCw5OJ+SEofFlkUUxxPxpm
	 y5VKhrlj/xU77/BTs+iO24RCMkQlFFfcpN0A2/5Af3h1Ra5zZp0vJeMeBkHQ7saUeJA3r
	 OmV9E47mAaOe7cGF3ctr6EcXFumjwgcK8Yl8VChVPESwxs4HDGjtN7xTRGDKEorFygQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8MhXjob2f763rEH340qt48He0rkZa7hOOIIt4QV+PqA=;
	b=mghaq6tgcH7cvlYW5icZpepHXmq+7aM3/XOxYyMXXRaw91sbHkwOL5KkLteTlVqHY9ku
	 JGIzkL2iLVto2YEGz093c/teU7wjlEuoIQ2uRsZ8WFV7JO/yfyNt8Mcxl9BPskp8HICXj
	 19JuIWX8jHUqHbVNKI98ZEOyzbcYztxfwVr2COeCy3O4RA5F4dFhSCmGq1ZwKwNLCPbcy
	 NtWN/yndNEVayclgwwBrB71ktM8mY+lVF8AUijUSV8rVYgpIOXXIE8xgmRpvw0lw2gxma
	 ZSssXVG4dKCNZ4zsXHfcEx4mJ9SES/7FpsgITBpXTIgu0mjjSBTS/YL0uNxrWlrbAZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtk7xrlJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8493606A8A0;
	Fri, 13 Nov 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtk7xrlJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6439B1F000C4;
	Fri, 13 Nov 2026 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585676;
	bh=8MhXjob2f763rEH340qt48He0rkZa7hOOIIt4QV+PqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtk7xrlJqncnOe0PQo/KG/1OlhL3QnRywxyaB7SDXAbAh+gTCBZRyOl4nPTgj3OoO
	 cg9ZL3VV0DvWKOJNX1v/R8IINthRYiR80+lsS9w46o/kI8akFgWzZioUOC5ki0NaWj
	 Kql4Ixg3URXJmSR7Fot9F0BWvlNqH7aiKdSX1CYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yingjie Wang <1075151112@qq.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 289/507] nvmet: reject keep-alive timeouts that would overflow
Date: Fri, 13 Nov 2026 10:49:53 -0500
Message-ID: <20261113153805.056500694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7764a3c0195c9..e76d4f7453004 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1225,8 +1225,13 @@ u16 nvmet_set_feat_kato(struct nvmet_req *req)
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
index 07a74c2e1f587..0f5e94bf12bdf 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1612,6 +1612,12 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
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
@@ -1678,7 +1684,7 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 		kato = NVMET_DISC_KATO_MS;
 
 	/* keep-alive timeout in seconds */
-	ctrl->kato = DIV_ROUND_UP(kato, 1000);
+	ctrl->kato = DIV_ROUND_UP_ULL(kato, MSEC_PER_SEC);
 
 	ctrl->err_counter = 0;
 	spin_lock_init(&ctrl->error_lock);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 2032db380f99e..215315ebe42de 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -7,6 +7,7 @@
 #define _NVMET_H
 
 #include <linux/dma-mapping.h>
+#include <linux/jiffies.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/kref.h>
@@ -702,6 +703,13 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
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



