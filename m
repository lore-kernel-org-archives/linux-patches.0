Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783E91A189B;
	Thu,  6 Jun 2024 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683730; cv=none; b=hwsMitI/aQK8nIZSaAOQ4wmBS4TCHjF/VQpGtB++LeiUMXUUZsFqM3IepPlKAe2MTAu2wNsm/pAllHMbx+LBP6pcosLU5eMnwf7AQ1PwKq6v1ismGdh7j0lZR6I8ZykPZ836EjZS1DkJA2QEyL1RiXRV6G5jcRfBxhU1wPBFwEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683730; c=relaxed/simple;
	bh=Qfyv//P5+UoordB5HvfMWbpMYQewG88hcCUX1x2Ljac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDAzu+hjfA8z2oIbhXscclIL6xXsvIoV3M3iOoZ6R1EJydzC9/IEez/uwafbH0KnJZz5RZ8jVkyN+cEh67AtY4RIZIUaFkwZo3CmzwYHo5tOoV6s1k3SZdr5u5fXVxuLlRvrGowt6KCywRxh4OpJc6PLmgCLqOv1BxH+aSYfKwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FJfFYGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FJfFYGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E8BC2BD10;
	Thu,  6 Jun 2024 14:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683730;
	bh=Qfyv//P5+UoordB5HvfMWbpMYQewG88hcCUX1x2Ljac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FJfFYGxw8d3rF7dh7qR3BnDAqjOIgs8wJbf+G4JP0lH4OLokFpU4+Spr+xaM+uEx
	 wULT1ygbxwVt7dKZ1cOe6bPdOKV44lS3nQmA8uRbMdAd/5CACKyxmdhgCI607v1VXg
	 D9x6hMluzUigKe78AYoursvASh5iINvLuPUqlrzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 681/744] nvme-multipath: fix io accounting on failover
Date: Thu,  6 Jun 2024 16:05:53 +0200
Message-ID: <20240606131754.330638525@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a2e4c5f5f68dbd206f132bc709b98dea64afc3b8 ]

There are io stats accounting that needs to be handled, so don't call
blk_mq_end_request() directly. Use the existing nvme_end_req() helper
that already handles everything.

Fixes: d4d957b53d91ee ("nvme-multipath: support io stats on the mpath device")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 2 +-
 drivers/nvme/host/multipath.c | 3 ++-
 drivers/nvme/host/nvme.h      | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 35eaa5c6c0c15..94a0916f9cb78 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -377,7 +377,7 @@ static inline void nvme_end_req_zoned(struct request *req)
 			le64_to_cpu(nvme_req(req)->result.u64));
 }
 
-static inline void nvme_end_req(struct request *req)
+void nvme_end_req(struct request *req)
 {
 	blk_status_t status = nvme_error_status(nvme_req(req)->status);
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index b39553b8378b5..3ac0cc22207dc 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -118,7 +118,8 @@ void nvme_failover_req(struct request *req)
 	blk_steal_bios(&ns->head->requeue_list, req);
 	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
 
-	blk_mq_end_request(req, 0);
+	nvme_req(req)->status = 0;
+	nvme_end_req(req);
 	kblockd_schedule_work(&ns->head->requeue_work);
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 2c510c4e21c66..fd67240795e3a 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -761,6 +761,7 @@ static inline bool nvme_state_terminal(struct nvme_ctrl *ctrl)
 	}
 }
 
+void nvme_end_req(struct request *req);
 void nvme_complete_rq(struct request *req);
 void nvme_complete_batch_req(struct request *req);
 
-- 
2.43.0



