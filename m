Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC74738A720;
	Tue, 10 Mar 2026 11:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142117; cv=none; b=VPH2TbZyIz01J53wjFFgu6OdYntvL9w1HEm1+9EuNMDyxUPlNuLz6jR75MEzbkvd5e/HhBnng+BfMn+huLnznGsIias2eDrEsoAMmcp93FWFYt3NuJNhI+oOl2Qly1KifmrF8Kga+iMxPqHC/9G/Qptpi8vJ34nbqsOUftdz+90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142117; c=relaxed/simple;
	bh=lTwYv3JoZRHFrHcLL+wUT0Y/QFQTAxP6bPUzf2EKA+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEnAEyWdCMgr7gsqHPTa2F6cWWa0csqgNkZev7PltbAD2EqCUr0CAl+OKKaWRz85MYUTx1UKJ8eY7q47a9n9eYZbNLJBZJC2Lxz3qJtpMEs1tbdESOr7qypDp4i1B0SCwT+QF4KWbtO3m0CnK5UvsnHWHF+Qe5JlqzjN8PPIdv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrToYc/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrToYc/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98518C19423;
	Tue, 10 Mar 2026 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142117;
	bh=lTwYv3JoZRHFrHcLL+wUT0Y/QFQTAxP6bPUzf2EKA+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrToYc/iuGh1tGjtGPaIVc+3WxRpovwd+2D6qcUkA2/9TTH81ItMgwXRIbTT3rDdh
	 k7OS7rIvoQLJWASsvr428NQ8BwwEwBhehXSQoQc9gsBqfAwWIET7f0RYN82ij+rPuI
	 rd2MsbmFjO/21I4GVlMf3zUwH+xB+AXeVFL1OI8vqeNr63lqne3xjBlYyEeLvph3zG
	 s+UI9EwzWBIhAmg/2otSoOdLe2mpq3mLBYcN5qw5rDnrUEzVSorqOw4o2ymzKUxRTV
	 K8Y08qBg1/M4f6poTjDAmnAZnkc9+NcTVyXjrA6KwfGdWDYCMza0jNZHgH6YgYPnlE
	 9MwN8AYgfuCTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Yi Zhang <yi.zhang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/314] nvme: fix admin queue leak on controller reset
Date: Tue, 10 Mar 2026 07:17:44 -0400
Message-ID: <5e1177e707ef17169274e8b46e268bfb6c24cfd5.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b84bb7bd913d8ca2f976ee6faf4a174f91c02b8d ]

When nvme_alloc_admin_tag_set() is called during a controller reset,
a previous admin queue may still exist. Release it properly before
allocating a new one to avoid orphaning the old queue.

This fixes a regression introduced by commit 03b3bcd319b3 ("nvme: fix
admin request_queue lifetime").

Cc: Keith Busch <kbusch@kernel.org>
Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime").
Reported-and-tested-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-block/CAHj4cs9wv3SdPo+N01Fw2SHBYDs9tj2M_e1-GdQOkRy=DsBB1w@mail.gmail.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f1f719351f3f2..2ba7244fdaf1c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4865,6 +4865,13 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 	if (ret)
 		return ret;
 
+	/*
+	 * If a previous admin queue exists (e.g., from before a reset),
+	 * put it now before allocating a new one to avoid orphaning it.
+	 */
+	if (ctrl->admin_q)
+		blk_put_queue(ctrl->admin_q);
+
 	ctrl->admin_q = blk_mq_alloc_queue(set, &lim, NULL);
 	if (IS_ERR(ctrl->admin_q)) {
 		ret = PTR_ERR(ctrl->admin_q);
-- 
2.51.0

