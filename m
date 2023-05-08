Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE28E171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59311C433D2;
	Mon,  8 May 2023 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546012;
	bh=qznDBF0JfbDQfbY9KNh07heROaI+kw1480fE08ZH6iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdYHvQg3nKt2684mKify5F8C8WQMKQ73zStkUU2G6uoJIQimMfBcli3PgsZX0j6CT
	 44nHeDoM3o/AVupx9KlTm87dQqOH9hhUePmGxapJP3MiwbuU/Ko48ZsGVRHEsJQEyU
	 X4QKYHN8x9JFMbtL/G4es20R2/XL0rMwmKfjcEk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nate Thornton <nate.thornton@samsung.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Minwoo Im <minwoo.im@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/371] nvme: fix async event trace event
Date: Mon,  8 May 2023 11:46:40 +0200
Message-Id: <20230508094820.004252474@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit 6622b76fe922b94189499a90ccdb714a4a8d0773 ]

Mixing AER Event Type and Event Info has masking clashes. Just print the
event type, but also include the event info of the AER result in the
trace.

Fixes: 09bd1ff4b15143b ("nvme-core: add async event trace helper")
Reported-by: Nate Thornton <nate.thornton@samsung.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Minwoo Im <minwoo.im@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c  |  5 +----
 drivers/nvme/host/trace.h | 15 ++++++---------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2ad1e4acc0d6b..e5318b38c6624 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4374,8 +4374,6 @@ static void nvme_handle_aen_notice(struct nvme_ctrl *ctrl, u32 result)
 {
 	u32 aer_notice_type = nvme_aer_subtype(result);
 
-	trace_nvme_async_event(ctrl, aer_notice_type);
-
 	switch (aer_notice_type) {
 	case NVME_AER_NOTICE_NS_CHANGED:
 		set_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events);
@@ -4407,7 +4405,6 @@ static void nvme_handle_aen_notice(struct nvme_ctrl *ctrl, u32 result)
 
 static void nvme_handle_aer_persistent_error(struct nvme_ctrl *ctrl)
 {
-	trace_nvme_async_event(ctrl, NVME_AER_ERROR);
 	dev_warn(ctrl->device, "resetting controller due to AER\n");
 	nvme_reset_ctrl(ctrl);
 }
@@ -4422,6 +4419,7 @@ void nvme_complete_async_event(struct nvme_ctrl *ctrl, __le16 status,
 	if (le16_to_cpu(status) >> 1 != NVME_SC_SUCCESS)
 		return;
 
+	trace_nvme_async_event(ctrl, result);
 	switch (aer_type) {
 	case NVME_AER_NOTICE:
 		nvme_handle_aen_notice(ctrl, result);
@@ -4439,7 +4437,6 @@ void nvme_complete_async_event(struct nvme_ctrl *ctrl, __le16 status,
 	case NVME_AER_SMART:
 	case NVME_AER_CSS:
 	case NVME_AER_VS:
-		trace_nvme_async_event(ctrl, aer_type);
 		ctrl->aen_result = result;
 		break;
 	default:
diff --git a/drivers/nvme/host/trace.h b/drivers/nvme/host/trace.h
index aa8b0f86b2be1..b258f7b8788e1 100644
--- a/drivers/nvme/host/trace.h
+++ b/drivers/nvme/host/trace.h
@@ -127,15 +127,12 @@ TRACE_EVENT(nvme_async_event,
 	),
 	TP_printk("nvme%d: NVME_AEN=%#08x [%s]",
 		__entry->ctrl_id, __entry->result,
-		__print_symbolic(__entry->result,
-		aer_name(NVME_AER_NOTICE_NS_CHANGED),
-		aer_name(NVME_AER_NOTICE_ANA),
-		aer_name(NVME_AER_NOTICE_FW_ACT_STARTING),
-		aer_name(NVME_AER_NOTICE_DISC_CHANGED),
-		aer_name(NVME_AER_ERROR),
-		aer_name(NVME_AER_SMART),
-		aer_name(NVME_AER_CSS),
-		aer_name(NVME_AER_VS))
+		__print_symbolic(__entry->result & 0x7,
+			aer_name(NVME_AER_ERROR),
+			aer_name(NVME_AER_SMART),
+			aer_name(NVME_AER_NOTICE),
+			aer_name(NVME_AER_CSS),
+			aer_name(NVME_AER_VS))
 	)
 );
 
-- 
2.39.2



