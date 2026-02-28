Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBC433F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300940; cv=none; b=iE1AkyR3TBXOobYBneNa+RoCOFavN4+6HdsjrXt2u/lWFQEbn3Hn6Qay8c4EECFsZs6MG80ZS+wWo71njBKEHBY0W1rSQCXDMWywoAWdI18r9Qhm9AgTOw2CAcKExYMeMU+/zPMDwwIi2U9feZRB/BBBu+i5i5sK1vzJNyLlhbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300940; c=relaxed/simple;
	bh=sUj53CCzyRZ+Nl+bD3YaS0/JzC1/MC3O53QNnmpsXGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGQ9Hp0ZrMpxtSc29F9HPl/DvT/4S9hWxjEVuop4rPEEcDanCRyNSWXK2gTdiPf/oUhR9SIONgmGO8OIB0zHT2Von3p5PdoAoj5sKYV0aKJSsTOTA6BiR8OFPcKGgEcw3ZbO4s327BKZRcKabZI0BM6bL8ndug0RIINScsrML08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDEfTdvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDEfTdvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A61C19424;
	Sat, 28 Feb 2026 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300940;
	bh=sUj53CCzyRZ+Nl+bD3YaS0/JzC1/MC3O53QNnmpsXGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDEfTdvU7y3O1DgZM5tp2hm2rZrjU4zz0tiMyM5/5YpHY6LBARjEAhbdNpDu0WE2d
	 abYrBi6KO062zBsJNNvnci/jtGfXQCJ8EnnnC44ta9CmVTOHZ0gyuuuMIGcL94k0uW
	 qnk1XXC9TGBhslW0fncO8uBZIWYs4wF+63vEEa8L+sU5DB68Vg4IZvo2PlPrF7aUvE
	 QcDY/rJUF5XaaVBEyP0nFDJ57e3P5wNUrBaqTEBhG4vY1IG1XYSd7uhmSunNCyL3Sn
	 wQf2toT26haGBfyi9JuvPyTNdb0zQX1I6Vtlx3QrMesPiQuqI9o95tEawK5hB8R43x
	 ym9zj9PIMB5WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/752] md-cluster: fix NULL pointer dereference in process_metadata_update
Date: Sat, 28 Feb 2026 12:36:12 -0500
Message-ID: <20260228174750.1542406-61-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit f150e753cb8dd756085f46e86f2c35ce472e0a3c ]

The function process_metadata_update() blindly dereferences the 'thread'
pointer (acquired via rcu_dereference_protected) within the wait_event()
macro.

While the code comment states "daemon thread must exist", there is a valid
race condition window during the MD array startup sequence (md_run):

1. bitmap_load() is called, which invokes md_cluster_ops->join().
2. join() starts the "cluster_recv" thread (recv_daemon).
3. At this point, recv_daemon is active and processing messages.
4. However, mddev->thread (the main MD thread) is not initialized until
   later in md_run().

If a METADATA_UPDATED message is received from a remote node during this
specific window, process_metadata_update() will be called while
mddev->thread is still NULL, leading to a kernel panic.

To fix this, we must validate the 'thread' pointer. If it is NULL, we
release the held lock (no_new_dev_lockres) and return early, safely
ignoring the update request as the array is not yet fully ready to
process it.

Link: https://lore.kernel.org/linux-raid/20260117145903.28921-1-jiashengjiangcool@gmail.com
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-cluster.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 11f1e91d387d8..896279988dfd5 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -549,8 +549,13 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 
-	/* daemaon thread must exist */
 	thread = rcu_dereference_protected(mddev->thread, true);
+	if (!thread) {
+		pr_warn("md-cluster: Received metadata update but MD thread is not ready\n");
+		dlm_unlock_sync(cinfo->no_new_dev_lockres);
+		return;
+	}
+
 	wait_event(thread->wqueue,
 		   (got_lock = mddev_trylock(mddev)) ||
 		    test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
-- 
2.51.0

