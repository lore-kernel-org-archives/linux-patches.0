Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3696FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C811C433EF;
	Tue, 10 Jan 2023 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374906;
	bh=utqPgVqT0m6zja5SQxyzGKSRlBavWojWNOKSrtgX6nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTiYYFRKx29OtHDm9VYqzNcbVXI8g7tbxNsD+NZipwP56VSPU52R8VUOxQIUixjOH
	 fyvjqayzPLGG7qptbuU3h8AvFer6ygimXgbWq+mAONv/6oEXdjMGUYvSyLQQ03Oisz
	 voYgFT28Ez7C0CHM5qIhBSyXZqmKDakuC7kO4gro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/290] nvmet: dont defer passthrough commands with trivial effects to the workqueue
Date: Tue, 10 Jan 2023 19:01:46 +0100
Message-Id: <20230110180032.103002423@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

[ Upstream commit 2a459f6933e1c459bffb7cc73fd6c900edc714bd ]

Mask out the "Command Supported" and "Logical Block Content Change" bits
and only defer execution of commands that have non-trivial effects to
the workqueue for synchronous execution.  This allows to execute admin
commands asynchronously on controllers that provide a Command Supported
and Effects log page, and will keep allowing to execute Write commands
asynchronously once command effects on I/O commands are taken into
account.

Fixes: c1fef73f793b ("nvmet: add passthru code to process commands")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 6220e1dd961a..9b5929754195 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -271,14 +271,13 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 	}
 
 	/*
-	 * If there are effects for the command we are about to execute, or
-	 * an end_req function we need to use nvme_execute_passthru_rq()
-	 * synchronously in a work item seeing the end_req function and
-	 * nvme_passthru_end() can't be called in the request done callback
-	 * which is typically in interrupt context.
+	 * If a command needs post-execution fixups, or there are any
+	 * non-trivial effects, make sure to execute the command synchronously
+	 * in a workqueue so that nvme_passthru_end gets called.
 	 */
 	effects = nvme_command_effects(ctrl, ns, req->cmd->common.opcode);
-	if (req->p.use_workqueue || effects) {
+	if (req->p.use_workqueue ||
+	    (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))) {
 		INIT_WORK(&req->p.work, nvmet_passthru_execute_cmd_work);
 		req->p.rq = rq;
 		queue_work(nvmet_wq, &req->p.work);
-- 
2.35.1



