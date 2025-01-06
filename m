Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3DA1A8F79;
	Mon,  6 Jan 2025 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177151; cv=none; b=B8a3GTMJ5zdXfR18fNyA5ttuMJSXOxxRj/EVBCHtfEVSNRbyAoX9CuBb9wyeuLkGr60ye0ROGnCxdd+o0dzhlb1gyZ7UttZt4HOoQbl4Rizeb0zTJRQDlr55hbQbyXmAgJ9S8k1/HUBFTRVaRsEzI6sxlAdrmU8I6JzYvKwZhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177151; c=relaxed/simple;
	bh=NfcNOx/X+B16p1UHetPqUfmI85GhzCyBU0CWGCGUhJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC/v2KVxespFPA5hCqB4zUSbkjLCxNDLyfFJyuNLOGiJsa7fA+xaDGbruQIB16fscpaTTeHbsxWALsQJrTlbGv5VAGEZvXqQrJGa/8/rll/HYDTGSS48oytvRllZ75qYt0HUvJTrnqS97mGiHi7k77dq/XXR3cNZJ55q098OhVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZDIiBdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZDIiBdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4361BC4CED2;
	Mon,  6 Jan 2025 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177151;
	bh=NfcNOx/X+B16p1UHetPqUfmI85GhzCyBU0CWGCGUhJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZDIiBdJ6U0juKaH95fnNRU9rH9GKpA/tKOKxQDQMEd7Cb9dOAl5wJgvg4wnqyc9e
	 xXXieCxjpiACkThtu99lfhqS8FQ1j9HdBD9CNERiOwpX0IrfMUmIvml1btN0ktSeDr
	 tJ3y2389pB2UF37tE4r06ezLrLj1uZMiwtwjF+kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/222] Revert "nvme: make keep-alive synchronous operation"
Date: Mon,  6 Jan 2025 16:14:33 +0100
Message-ID: <20250106151153.216570225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 84488282166de6b6760ada8030e87aaa08bce3aa ]

This reverts commit d06923670b5a5f609603d4a9fee4dec02d38de9c.

It was realized that the fix implemented to contain the race condition
among the keep alive task and the fabric shutdown code path in the commit
d06923670b5ia ("nvme: make keep-alive synchronous operation") is not
optimal. The reason being keep-alive runs under the workqueue and making
it synchronous would waste a workqueue context.
Furthermore, we later found that the above race condition is a regression
caused due to the changes implemented in commit a54a93d0e359 ("nvme: move
stopping keep-alive into nvme_uninit_ctrl()"). So we decided to revert the
commit d06923670b5a ("nvme: make keep-alive synchronous operation") and
then fix the regression.

Link: https://lore.kernel.org/all/196f4013-3bbf-43ff-98b4-9cb2a96c20c2@grimberg.me/
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ae494c799fc5..4aad16390d47 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1178,9 +1178,10 @@ static void nvme_queue_keep_alive_work(struct nvme_ctrl *ctrl)
 			   nvme_keep_alive_work_period(ctrl));
 }
 
-static void nvme_keep_alive_finish(struct request *rq,
-		blk_status_t status, struct nvme_ctrl *ctrl)
+static enum rq_end_io_ret nvme_keep_alive_end_io(struct request *rq,
+						 blk_status_t status)
 {
+	struct nvme_ctrl *ctrl = rq->end_io_data;
 	unsigned long rtt = jiffies - (rq->deadline - rq->timeout);
 	unsigned long delay = nvme_keep_alive_work_period(ctrl);
 	enum nvme_ctrl_state state = nvme_ctrl_state(ctrl);
@@ -1197,17 +1198,20 @@ static void nvme_keep_alive_finish(struct request *rq,
 		delay = 0;
 	}
 
+	blk_mq_free_request(rq);
+
 	if (status) {
 		dev_err(ctrl->device,
 			"failed nvme_keep_alive_end_io error=%d\n",
 				status);
-		return;
+		return RQ_END_IO_NONE;
 	}
 
 	ctrl->ka_last_check_time = jiffies;
 	ctrl->comp_seen = false;
 	if (state == NVME_CTRL_LIVE || state == NVME_CTRL_CONNECTING)
 		queue_delayed_work(nvme_wq, &ctrl->ka_work, delay);
+	return RQ_END_IO_NONE;
 }
 
 static void nvme_keep_alive_work(struct work_struct *work)
@@ -1216,7 +1220,6 @@ static void nvme_keep_alive_work(struct work_struct *work)
 			struct nvme_ctrl, ka_work);
 	bool comp_seen = ctrl->comp_seen;
 	struct request *rq;
-	blk_status_t status;
 
 	ctrl->ka_last_check_time = jiffies;
 
@@ -1239,9 +1242,9 @@ static void nvme_keep_alive_work(struct work_struct *work)
 	nvme_init_request(rq, &ctrl->ka_cmd);
 
 	rq->timeout = ctrl->kato * HZ;
-	status = blk_execute_rq(rq, false);
-	nvme_keep_alive_finish(rq, status, ctrl);
-	blk_mq_free_request(rq);
+	rq->end_io = nvme_keep_alive_end_io;
+	rq->end_io_data = ctrl;
+	blk_execute_rq_nowait(rq, false);
 }
 
 static void nvme_start_keep_alive(struct nvme_ctrl *ctrl)
-- 
2.39.5



