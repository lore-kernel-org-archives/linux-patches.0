Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BF41A239A;
	Tue, 21 Jul 2026 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648718; cv=none; b=GHZlDyPhfkSdV3WxLbh9s7+gh9DWYzAkL0QEiml/lRIiYO+IMIl5y6Q1RBx+61AIEHTqH3hWgwr0iYKqjPlIDCRc/D0aGo9K2q0mnCmcDeHR8oVYDoBP5rhKBHDB9smZ5o7TIklgCiq+HsJE2RpzTkQmxJJqBbQdodIVObht43o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648718; c=relaxed/simple;
	bh=RgG4Eh6iICww7oX+mtcKtByAVu94mtV2xntvg6ea5tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddX+xUQcJ9e0B0VVFXqot2mc5LGnYYAHEUHa1Sov219cSjaTIKPACfb2CdA6NMxGK1m2pYSaJ5anyC+OhyjfYgMD8DuOQaqbHTJ/2GowucrzbSprXd4ZcwbmggedeeUbX9YihWPc+tFOsVu5Rr926BhIUS22NM4LGliR8AB6/CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zw9/r94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zw9/r94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF99C1F000E9;
	Tue, 21 Jul 2026 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648717;
	bh=QIJBCA37JMe5zmrT8guvfyd/zbuVpgPQULycY94hufU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zw9/r94e9b80CnrqHuF2JvVwU1h7RDFsu0oOg0uzawXsITeM4UH9lprz6YVAG0nv
	 JooPtSxaVQbX1x4ps5oNfueUqlKQt6JyurWEzj2mmdnsIwfrBSsSw6/gdJcvoIJ9mI
	 d2LHWLjhSvRV9SWBQ9PSqDhuhNXRmfWmV0sUXASY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianfa Weng <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0304/2077] RDMA/hns: Fix warning in poll cq direct mode
Date: Tue, 21 Jul 2026 16:59:37 +0200
Message-ID: <20260721152559.849144329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianfa Weng <wenglianfa@huawei.com>

[ Upstream commit 3f19c2a3852e6ba75f3e92dd5edc4e07f3d07f4a ]

CQs allocated by ib_alloc_cq() always have a comp_handler. Though
in direct mode this handler is never expected to be called, it
is still called when the driver is reset, triggering the following
WARN_ONCE():

Call trace:
ib_cq_completion_direct+0x38/0x60
hns_roce_cq_completion+0x54/0x90 (hns_roce_hw_v2]
hns_roce_handle_device_err+Ox1c8/0x340 [hns_roce_hw_v2]
hns_roce_hw_v2_uninit_instance.constprop.0+0x34/0x70 [hns_roce_hw_v2]
hns_roce_hw_v2_reset_notify+0xc4/0xe0 [hns_roce_hw_v2]
hclge_notify_roce_client+0x60/0xbc [hclge]
hclge_reset_rebuild+0x48/0x34c [hclge]
hclge_reset_subtask+0xcc/0xec [hclge]
hclge_reset_service_task+0x80/0x160 [hclge]
hclge_service_task+0x50/0x80 (hclge]
process_one_work+0x1cc/0x4d0
worker_thread+0x154/0x414
kthread+0x104/0x144
ret_from_fork+0x10/0x18

Fixes: f295e4cece5c ("RDMA/hns: Delete unnecessary callback functions for cq")
Link: https://patch.msgid.link/r/20260520055759.2354037-3-huangjunxian6@hisilicon.com
Signed-off-by: Lianfa Weng <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 0dbe99aab6ad21..1e54710354542e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -1113,7 +1113,7 @@ static void check_and_get_armed_cq(struct list_head *cq_list, struct ib_cq *cq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hr_cq->lock, flags);
-	if (cq->comp_handler) {
+	if (cq->comp_handler && hr_cq->ib_cq.poll_ctx != IB_POLL_DIRECT) {
 		if (!hr_cq->is_armed) {
 			hr_cq->is_armed = 1;
 			list_add_tail(&hr_cq->node, cq_list);
-- 
2.53.0



