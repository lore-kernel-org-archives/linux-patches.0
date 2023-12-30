Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193278473;
	Sat, 30 Dec 2023 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAY/rKcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A2EC433C7;
	Sat, 30 Dec 2023 12:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938240;
	bh=RH/g3ptj0zhJXWeFUQqi7mZr7AGHRd/Gp8EHW5q9XgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAY/rKcCtGU9eaYDQ0sYUeRV2wa/0jJd0IVPV1FhUpuJP/lptY7o+wAlQ7eG0QVOw
	 GoMhqZD5i6GS+T+JRy6nXodJUQENMt7MYwuSRY9NWcj0CO7l1F0nx0Flp2C6iljVQH
	 4H2usY7ACfwqmvgf8Hqoyio/4hJrb2QJ0/JibDO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/112] nvme-pci: fix sleeping function called from interrupt context
Date: Sat, 30 Dec 2023 11:59:20 +0000
Message-ID: <20231230115808.227909289@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f6fe0b2d35457c10ec37acc209d19726bdc16dbd ]

the nvme_handle_cqe() interrupt handler calls nvme_complete_async_event()
but the latter may call nvme_auth_stop() which is a blocking function.
Sleeping functions can't be called in interrupt context

 BUG: sleeping function called from invalid context
 in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/15
  Call Trace:
     <IRQ>
      __cancel_work_timer+0x31e/0x460
      ? nvme_change_ctrl_state+0xcf/0x3c0 [nvme_core]
      ? nvme_change_ctrl_state+0xcf/0x3c0 [nvme_core]
      nvme_complete_async_event+0x365/0x480 [nvme_core]
      nvme_poll_cq+0x262/0xe50 [nvme]

Fix the bug by moving nvme_auth_stop() to fw_act_work
(executed by the nvme_wq workqueue)

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index eb7c87b344b8f..5b906dbb1096c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4835,6 +4835,8 @@ static void nvme_fw_act_work(struct work_struct *work)
 				struct nvme_ctrl, fw_act_work);
 	unsigned long fw_act_timeout;
 
+	nvme_auth_stop(ctrl);
+
 	if (ctrl->mtfa)
 		fw_act_timeout = jiffies +
 				msecs_to_jiffies(ctrl->mtfa * 100);
@@ -4890,7 +4892,6 @@ static bool nvme_handle_aen_notice(struct nvme_ctrl *ctrl, u32 result)
 		 * firmware activation.
 		 */
 		if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING)) {
-			nvme_auth_stop(ctrl);
 			requeue = false;
 			queue_work(nvme_wq, &ctrl->fw_act_work);
 		}
-- 
2.43.0



