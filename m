Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C6D1CFA9;
	Tue, 27 Feb 2024 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040666; cv=none; b=uE/3nQ1HRbE9YM3uJVLGDazy9uVhQGs1MBkO1C+IflFr9AxI55bQq+HM8Pm1llyQY8qZq4QW2m32yOBAkaifyh8TEUJwvNSODcNHOQRArcoGsui1tzbbKOTj0DIlil5Z+dVRN46hECDwCts3BTMazZb48ClaJm7RI2RexBND2a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040666; c=relaxed/simple;
	bh=iciby3dcJjObmMIKUKc8lyAevFSNB0bQxMwpK/k4x3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcjq1PbZnw7naVTYrg3ucRYhh+ToegwcZwKUPu0qtVDGMqwvdMBgJlnmuyS2kdo1/UUxeZbwxC8dxxKV1TrNKU7KxmiYGAastyvIsZAMsQRac9FoP92zApVsBMQCAtYkNFS1JBLr4A1p3+K6VAJE8Sb+dmSv8CT4CQgj8amTrIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btDKu95o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btDKu95o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DFFC433F1;
	Tue, 27 Feb 2024 13:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040666;
	bh=iciby3dcJjObmMIKUKc8lyAevFSNB0bQxMwpK/k4x3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btDKu95ok6+9VpY3IATU+dAYgQPH9BrRfX4pcUiAWZevHu7ZcG5/FTiFpJ1G7iSLL
	 sdD8e8l/DgFQ+wjpncW/aNZYgQkZR+N5hIHUeln1PIiTGEsfHbv1ICMCBmSDbs1Kw1
	 LKgjmiMhulZntJtYjF1sFxVkvMwid8sdBtC9S/yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 067/334] nvmet-fc: free queue and assoc directly
Date: Tue, 27 Feb 2024 14:18:45 +0100
Message-ID: <20240227131632.720647452@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit c5e27b1a779ec25779d04c3af65aebaee6bd4304 ]

Neither struct nvmet_fc_tgt_queue nor struct nvmet_fc_tgt_assoc are data
structure which are used in a RCU context. So there is no reason to
delay the free operation.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index bb0791c9c0e3a..5fd37e989106c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -145,7 +145,6 @@ struct nvmet_fc_tgt_queue {
 	struct list_head		avail_defer_list;
 	struct workqueue_struct		*work_q;
 	struct kref			ref;
-	struct rcu_head			rcu;
 	/* array of fcp_iods */
 	struct nvmet_fc_fcp_iod		fod[] __counted_by(sqsize);
 } __aligned(sizeof(unsigned long long));
@@ -169,7 +168,6 @@ struct nvmet_fc_tgt_assoc {
 	struct nvmet_fc_tgt_queue 	*queues[NVMET_NR_QUEUES + 1];
 	struct kref			ref;
 	struct work_struct		del_work;
-	struct rcu_head			rcu;
 };
 
 
@@ -852,7 +850,7 @@ nvmet_fc_tgt_queue_free(struct kref *ref)
 
 	destroy_workqueue(queue->work_q);
 
-	kfree_rcu(queue, rcu);
+	kfree(queue);
 }
 
 static void
@@ -1185,8 +1183,8 @@ nvmet_fc_target_assoc_free(struct kref *ref)
 	dev_info(tgtport->dev,
 		"{%d:%d} Association freed\n",
 		tgtport->fc_target_port.port_num, assoc->a_id);
-	kfree_rcu(assoc, rcu);
 	nvmet_fc_tgtport_put(tgtport);
+	kfree(assoc);
 }
 
 static void
-- 
2.43.0



