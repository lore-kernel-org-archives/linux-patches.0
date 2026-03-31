Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEEB2D63E8;
	Tue, 31 Mar 2026 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976626; cv=none; b=RSiRDITejdKXjkMm/0lNkMXMkJisgeFpC/ZsGtZNftxyMN7bAkyIdxQTZIPkufPfZR1rCsThhE6r2bG2tkmfBCaD2KkIVTVyadQL7ikicuSsGIQvuYH+YPTTwIWGq8mCeriiRjhiT2ieOcolM6qKJC4z622+uLGFJ5r28mHC6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976626; c=relaxed/simple;
	bh=VwgX6lFzG1g48a76pKjWFJf3E9idE4Go+hFs+j8FaXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1zqw5cU/aTFnod376lOCecLZbTQHNa6tvbc+MoMGe1m2SbrTTrMCN0h+Qa2pwT80VgTnCbRhia/DFh8Upd1MGJzPniNNNMG+oXB4bMyYAuehyGiWxSNpokdHBFjjGr3Gq80hKrHNdUTfGeSzBMAUzk6i6OI4yPHkI/ZybBJl9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHuIl8Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHuIl8Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C630BC19423;
	Tue, 31 Mar 2026 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976626;
	bh=VwgX6lFzG1g48a76pKjWFJf3E9idE4Go+hFs+j8FaXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHuIl8QwHRHCeBKpkz7TtZedQfAzlvCX4eLAcWbC4e6s0nZE98Bb0I/WQO+puYcNK
	 jCXloV7vcn8o737m753+Aa6wBJ5EYv1kEKh/D3libvLBV0B2ig8ZTELMgCwByi9Ax2
	 wSiha5xKPZD+dZelOCfjSuq88E1Tqjs8lycop1mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kranzdorf <dkkranzd@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/309] RDMA/efa: Check stored completion CTX command ID with received one
Date: Tue, 31 Mar 2026 18:20:36 +0200
Message-ID: <20260331161758.372870147@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Nachum <ynachum@amazon.com>

[ Upstream commit 4b01ec0f133b3fe1038dc538d6bfcbd72462d2f0 ]

In admin command completion, we receive a CQE with the command ID which
is constructed from context index and entropy bits from the admin queue
producer counter. To try to detect memory corruptions in the received
CQE, validate the full command ID of the fetched context with the CQE
command ID. If there is a mismatch, complete the CQE with error.
Also use LSBs of the admin queue producer counter to better detect
entropy mismatch between smaller number of commands.

Reviewed-by: Daniel Kranzdorf <dkkranzd@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
Link: https://patch.msgid.link/20251210130614.36460-2-ynachum@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ef3b06742c8a ("RDMA/efa: Fix use of completion ctx after free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 0e979ca10d240..b31478f3a1212 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -3,6 +3,8 @@
  * Copyright 2018-2025 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
+#include <linux/log2.h>
+
 #include "efa_com.h"
 #include "efa_regs_defs.h"
 
@@ -317,7 +319,7 @@ static struct efa_comp_ctx *__efa_com_submit_admin_cmd(struct efa_com_admin_queu
 
 	/* cmd_id LSBs are the ctx_id and MSBs are entropy bits from pc */
 	cmd_id = ctx_id & queue_size_mask;
-	cmd_id |= aq->sq.pc & ~queue_size_mask;
+	cmd_id |= aq->sq.pc << ilog2(aq->depth);
 	cmd_id &= EFA_ADMIN_AQ_COMMON_DESC_COMMAND_ID_MASK;
 
 	cmd->aq_common_descriptor.command_id = cmd_id;
@@ -418,7 +420,7 @@ static int efa_com_handle_single_admin_completion(struct efa_com_admin_queue *aq
 			 EFA_ADMIN_ACQ_COMMON_DESC_COMMAND_ID);
 
 	comp_ctx = efa_com_get_comp_ctx(aq, cmd_id, false);
-	if (comp_ctx->status != EFA_CMD_SUBMITTED) {
+	if (comp_ctx->status != EFA_CMD_SUBMITTED || comp_ctx->cmd_id != cmd_id) {
 		ibdev_err(aq->efa_dev,
 			  "Received completion with unexpected command id[%d], sq producer: %d, sq consumer: %d, cq consumer: %d\n",
 			  cmd_id, aq->sq.pc, aq->sq.cc, aq->cq.cc);
-- 
2.53.0



