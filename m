Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060150;
	b=OAFrIMKwQ3GuFZGQgWVPg25TAUoJfbBv5BvMqLZPZlciy3VGcRHxFJj1lFjbGleQllQL
	 j7C52wnuvjpm0x6IN7BU+Dnk64xvPoB2YU4Z9tRcIabr7Kw2mq19S22+uPaTc0Jfvooia
	 avYJfbCqWqKmO1n4wIdtcyojwJlj2zSAElH6cNR1FDh67l3z+2i9U6VolS8zxCozqm7YH
	 HSV8BnMBzPG0UJMRB6/2pz6Le+43bcYlRS8Jo8kf2H2Yo2TMuoRCE5K5Gz4T+aSjH5dvx
	 BbjaJ8X69yzhIZxS+sdqv9i6/PL1dbThmdY2gEAyvSiSgKHkn28aS5nGAY8I2CXX4qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0HTFVe//TNR+ak7lrzSeuUERgIUdLj4pN7nwkpniuPM=;
	b=4zEuNhLVLg3AS0jlcoy0Z5Yx3keWx72spPJ5UDty+MwRDzZRhwIDMh9MoMlzsRAY5ABR
	 jRLePJAmSoq1Z8AGvH/TFfUaH0ROwg1vBKu4QF3oJ+cUz2mwqhZlyMBuPxMPyjiRuOKhX
	 JDAHo7OXFh/wsYbXJtvfeoV2uev4cP2ecQ8TC2zHFyaxCmE92+OF05PXvVTBUUEuBg3yy
	 G8DMPtDBjl/NODjLITmFSMWz8olGvfsfDNEnrFNDFnE7roTRqW0ZIouST3sx38Jolp+Fv
	 3OsW4bMGqclyCU/rnIUk1URIBb02g0fMiFK3v6nvmXA+UMZiGFDmsfTtGDUII+fkt9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Szkkzpwr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839B606A325;
	Thu, 19 Nov 2026 03:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Szkkzpwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0071F000C4;
	Thu, 19 Nov 2026 03:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060150;
	bh=0HTFVe//TNR+ak7lrzSeuUERgIUdLj4pN7nwkpniuPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzkkzpwrYDhEjlTt3ggqkS6ygJO/4zgKiHWzIPaxLCFr5kH58XS/KUYDz4dZRqvHd
	 5sPVU/bFM+7EApf4fW9nw3VoKp8H+pXXtEeKDilkmZ42Mb5+gWtWeLSLT2mdyDkqMy
	 m7fXCXYSIGZ4fgsP1QXSSYXIjEcuWrrV4CbhuOOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yingjie Wang <1075151112@qq.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1095/1848] nvmet: reject keep-alive timeouts that would overflow
Date: Wed, 18 Nov 2026 15:52:13 +0100
Message-ID: <20261118150004.745572677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted controller allocation error handling to return status directly and set req->error_loc. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 7 ++++++-
 drivers/nvme/target/core.c      | 7 ++++++-
 drivers/nvme/target/nvmet.h     | 8 ++++++++
 include/linux/nvme.h            | 1 +
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 835ff574f80b9..93efea9de3259 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -739,8 +739,13 @@ u16 nvmet_set_feat_kato(struct nvmet_req *req)
 {
 	u32 val32 = le32_to_cpu(req->cmd->common.cdw11);
 
+	if (val32 > NVMET_MAX_KATO * MSEC_PER_SEC) {
+		req->error_loc = offsetof(struct nvme_common_command, cdw11);
+		return NVME_SC_KA_TIMEOUT_INVALID | NVME_SC_DNR;
+	}
+
 	nvmet_stop_keep_alive_timer(req->sq->ctrl);
-	req->sq->ctrl->kato = DIV_ROUND_UP(val32, 1000);
+	req->sq->ctrl->kato = DIV_ROUND_UP_ULL(val32, MSEC_PER_SEC);
 	nvmet_start_keep_alive_timer(req->sq->ctrl);
 
 	nvmet_set_result(req, req->sq->ctrl->kato);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 61e96097bfe9c..068e490098aa9 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1325,6 +1325,11 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 	int ret;
 	u16 status;
 
+	if (kato > NVMET_MAX_KATO * MSEC_PER_SEC) {
+		req->error_loc = offsetof(struct nvmf_connect_command, kato);
+		return NVME_SC_KA_TIMEOUT_INVALID | NVME_SC_DNR;
+	}
+
 	status = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 	subsys = nvmet_find_get_subsys(req->port, subsysnqn);
 	if (!subsys) {
@@ -1401,7 +1406,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		kato = NVMET_DISC_KATO_MS;
 
 	/* keep-alive timeout in seconds */
-	ctrl->kato = DIV_ROUND_UP(kato, 1000);
+	ctrl->kato = DIV_ROUND_UP_ULL(kato, MSEC_PER_SEC);
 
 	ctrl->err_counter = 0;
 	spin_lock_init(&ctrl->error_lock);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index ef162b64fabef..90bb5352c4cc8 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -7,6 +7,7 @@
 #define _NVMET_H
 
 #include <linux/dma-mapping.h>
+#include <linux/jiffies.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/kref.h>
@@ -503,6 +504,13 @@ void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
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
 
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 5727185ffe423..ff756283b9230 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1485,6 +1485,7 @@ enum {
 	NVME_SC_SGL_INVALID_OFFSET	= 0x16,
 	NVME_SC_SGL_INVALID_SUBTYPE	= 0x17,
 
+	NVME_SC_KA_TIMEOUT_INVALID	= 0x1A,
 	NVME_SC_SANITIZE_FAILED		= 0x1C,
 	NVME_SC_SANITIZE_IN_PROGRESS	= 0x1D,
 
-- 
2.53.0



