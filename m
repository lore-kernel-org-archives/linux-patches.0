Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E944324C077;
	Tue, 29 Apr 2025 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945914; cv=none; b=uY7Twca1bVvsGBAGyOL/QsF5y2KD5l4IeHr+gwfQIkYoZQ0T9MZLYq48JryTkSbxfM3ujwJrSBiWJRjWVWgNxtjLY67fQO4r2XG/FYmsTsdsHbEmiCxL9UH1bPwIvjO5ZTQ23oREFkz1hxJSmuT1HnRV5C+5VJe5N0WXCQ/uoSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945914; c=relaxed/simple;
	bh=bD+LIsbNJLlJjt24/WP1+zbI36AzraLD/oO5VE8zYU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPq1JoM6G2yZEyUaQWhbUovjQAkSUNnYM5s2mHsIopou1ZGLbBntV5t06FpElQhcq44eSneCo5hXTiQ4zkfqV2/vRxWkUZ9WuUspl8Ea/PxWoo57ZcKvVU+dxtYSNzfMX3jKGuGG69SJuU0pKlFCrVlbEOkNYzB73dGQs8e2+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPpnHSmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPpnHSmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E65C4CEE9;
	Tue, 29 Apr 2025 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945913;
	bh=bD+LIsbNJLlJjt24/WP1+zbI36AzraLD/oO5VE8zYU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPpnHSmpierMvt+Fk4ZWcA6R9M4lUWOUij7FoHPVrSuEVTLQjpCVNjYN5Zn4WEdzt
	 8MzeNplaBL9bNFFHpVe+RBqQ9rzmZAOic4EUe4nhpQuCppR4BeaeeF5xNpqWxmCLzH
	 nOggfEXTYOYnbTsGUIYMGdVny8UzF1NWcfKsAGnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Holzman <jholzman@nvidia.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling UBLK_U_IO_NEED_GET_DATA
Date: Tue, 29 Apr 2025 18:38:49 +0200
Message-ID: <20250429161124.815951989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]

We call io_uring_cmd_complete_in_task() to schedule task_work for handling
UBLK_U_IO_NEED_GET_DATA.

This way is really not necessary because the current context is exactly
the ublk queue context, so call ublk_dispatch_req() directly for handling
UBLK_U_IO_NEED_GET_DATA.

Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
Tested-by: Jared Holzman <jholzman@nvidia.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 437297022dcfa..c7761a5cfeec0 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 	mutex_unlock(&ub->mutex);
 }
 
-static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
-		int tag)
-{
-	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
-	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
-
-	ublk_queue_cmd(ubq, req);
-}
-
 static inline int ublk_check_cmd_op(u32 cmd_op)
 {
 	u32 ioc_type = _IOC_TYPE(cmd_op);
@@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
 			goto out;
 		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
-		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
-		break;
+		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
+		ublk_dispatch_req(ubq, req, issue_flags);
+		return -EIOCBQUEUED;
 	default:
 		goto out;
 	}
-- 
2.39.5



