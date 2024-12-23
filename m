Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7008013BC0C;
	Mon, 23 Dec 2024 16:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969964; cv=none; b=diR8xb0pEWJLzhwOGmbdm2mQhZxvVv0Yj801hyM1a3Y6qfME47cZ4+xVvy8odXBZRhwRD/PzxJEqdytTFHgK+99PyMD9riTBhT6M8AyGUtKaetLWDR0CiX/tPT3Qnw27df1eGMdZeqjsD55XQDCSFf4kTgYBTLgJgm3m+VNOM4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969964; c=relaxed/simple;
	bh=rdiHS0AZ1fDpKcfplnNAD9VIXzSVQ9Mx3h3d+wVlxRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du5uLGSCrS27Ez8XGYMpkV+eMWR5OQoEUgEjdhHhOYDb36SrW2BwtNY4FjWgfAJ+t6A/eE6FKs5XIhwmwlaRLFJapk8USlelzbAWB1deuiNhApCjGZprInNwHvtXPDgzKRVcnu12EzCxbVBUvweOXAPkMv6aWCGrbaiAPWi/Y9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cizvLaq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cizvLaq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0453DC4CED3;
	Mon, 23 Dec 2024 16:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969964;
	bh=rdiHS0AZ1fDpKcfplnNAD9VIXzSVQ9Mx3h3d+wVlxRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cizvLaq8FGZISRrSAE0JFnSHlQapHdP6uxzRGT6HRus6b8cGK7AfOEx7IuWVBa/Tk
	 dXJ5ZjYz4LX6I7krSpP24G7mmcGX8sJTFZzuQrjlBFa4libZyoGoIUqwFFEMd6HhgH
	 gWBNR+zigkuZDWUVHq7Pxq0hKAuplRYU/Mr6zGf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/160] block: avoid to reuse `hctx` not removed from cpuhp callback list
Date: Mon, 23 Dec 2024 16:58:35 +0100
Message-ID: <20241223155412.697000695@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 85672ca9ceeaa1dcf2777a7048af5f4aee3fd02b ]

If the 'hctx' isn't removed from cpuhp callback list, we can't reuse it,
otherwise use-after-free may be triggered.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412172217.b906db7c-lkp@intel.com
Tested-by: kernel test robot <oliver.sang@intel.com>
Fixes: 22465bbac53c ("blk-mq: move cpuhp callback registering out of q->sysfs_lock")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241218101617.3275704-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1030875a3e95..d5995021815d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4421,6 +4421,15 @@ struct gendisk *blk_mq_alloc_disk_for_queue(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_mq_alloc_disk_for_queue);
 
+/*
+ * Only hctx removed from cpuhp list can be reused
+ */
+static bool blk_mq_hctx_is_reusable(struct blk_mq_hw_ctx *hctx)
+{
+	return hlist_unhashed(&hctx->cpuhp_online) &&
+		hlist_unhashed(&hctx->cpuhp_dead);
+}
+
 static struct blk_mq_hw_ctx *blk_mq_alloc_and_init_hctx(
 		struct blk_mq_tag_set *set, struct request_queue *q,
 		int hctx_idx, int node)
@@ -4430,7 +4439,7 @@ static struct blk_mq_hw_ctx *blk_mq_alloc_and_init_hctx(
 	/* reuse dead hctx first */
 	spin_lock(&q->unused_hctx_lock);
 	list_for_each_entry(tmp, &q->unused_hctx_list, hctx_list) {
-		if (tmp->numa_node == node) {
+		if (tmp->numa_node == node && blk_mq_hctx_is_reusable(tmp)) {
 			hctx = tmp;
 			break;
 		}
-- 
2.39.5



