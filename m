Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F9FA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150C0C433F0;
	Tue, 10 Jan 2023 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374277;
	bh=3iJDEg26w5JXxeO2spyA4n8QeKcUd/6tuQpHV6WNuig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPeXH3y9wFO9QpfcKED679jTCoDW4dvgsQ+lJlxFURULsjMJR5NVeJhzSCLLB89HR
	 AV+dREsM9U++HfxFW1mW/FwxvwH9q6Q/iNERen1o+pglLz84obXbig+SWMBA3eOStt
	 wLEoirHzTbL2PxXgLnBeJXZ6LZhTXiIKrcAKDvvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 113/148] nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it
Date: Tue, 10 Jan 2023 19:03:37 +0100
Message-Id: <20230110180020.770495691@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 61f37154c599cf9f2f84dcbd9be842f8645a7099 ]

Use NVME_CMD_EFFECTS_CSUPP instead of open coding it and assign a
single value to multiple array entries instead of repeated assignments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 35 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index fc8a957fad0a..4aaa27cc8d2b 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -164,26 +164,29 @@ static void nvmet_execute_get_log_page_smart(struct nvmet_req *req)
 
 static void nvmet_get_cmd_effects_nvm(struct nvme_effects_log *log)
 {
-	log->acs[nvme_admin_get_log_page]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_identify]		= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_abort_cmd]		= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_set_features]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_get_features]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_async_event]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_keep_alive]		= cpu_to_le32(1 << 0);
-
-	log->iocs[nvme_cmd_read]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_write]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_flush]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_dsm]			= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_write_zeroes]	= cpu_to_le32(1 << 0);
+	log->acs[nvme_admin_get_log_page] =
+	log->acs[nvme_admin_identify] =
+	log->acs[nvme_admin_abort_cmd] =
+	log->acs[nvme_admin_set_features] =
+	log->acs[nvme_admin_get_features] =
+	log->acs[nvme_admin_async_event] =
+	log->acs[nvme_admin_keep_alive] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
+
+	log->iocs[nvme_cmd_read] =
+	log->iocs[nvme_cmd_write] =
+	log->iocs[nvme_cmd_flush] =
+	log->iocs[nvme_cmd_dsm]	=
+	log->iocs[nvme_cmd_write_zeroes] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 }
 
 static void nvmet_get_cmd_effects_zns(struct nvme_effects_log *log)
 {
-	log->iocs[nvme_cmd_zone_append]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_zone_mgmt_send]	= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_zone_mgmt_recv]	= cpu_to_le32(1 << 0);
+	log->iocs[nvme_cmd_zone_append] =
+	log->iocs[nvme_cmd_zone_mgmt_send] =
+	log->iocs[nvme_cmd_zone_mgmt_recv] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 }
 
 static void nvmet_execute_get_log_cmd_effects_ns(struct nvmet_req *req)
-- 
2.35.1



