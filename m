Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C22E537E9;
	Mon, 30 Dec 2024 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573590; cv=none; b=aoWjsk/i02PBSJ2LkW6nJelIG7SASUaoBqb9oFqCY9BBe379TuA9oKA70Yv4Bpx/GCJ8qxZHEJrma4zScrMHBWQCx7ll7QlBKrD59B15/K9LGjNZ4gQLYCQ4BXCVCpv6SYg+dfmvwna69JlhbA2O/ZvAswcWnlayLf3mdoslxBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573590; c=relaxed/simple;
	bh=Dpq5ufjA/WDFj5BJ82F3u6p6cCPVZQyBz9/i62ZXtdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXpZyl4Wyliye7wdP2zzew7ClFyaG+8f7+zoXNAp2U/1uUwT9sjLUc3yiI6wJJq9vw+lAyNjR5xAOBl1c5QMzZJR9DsP9OsmemLnIhwxFJAVjIlPhqcs7QxJ252SgLZgkKU0Y89mg2fAAbFYLLDQ7nPHlcivaaRw11+Gq7I7jcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QHSoxJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QHSoxJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8E5C4CED0;
	Mon, 30 Dec 2024 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573590;
	bh=Dpq5ufjA/WDFj5BJ82F3u6p6cCPVZQyBz9/i62ZXtdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QHSoxJEABMI68lsLNbzTeUM+yUYSINa9Pc1MHdzV1MMUEMbRzSfEOAkaVoMJmjjZ
	 UYwKj+2LcJgTS36Gv7uc54ia5RgE5wl2f+NWftXypsC6SoVNGKNosyZL3+zb3SynWT
	 2touDYGFfTdw38ycuztMMMWpcOcTaCM+7qFyqf4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>,
	Luck Tony <tony.luck@intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/60] blk-mq: register cpuhp callback after hctx is added to xarray table
Date: Mon, 30 Dec 2024 16:42:48 +0100
Message-ID: <20241230154208.727134994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4bf485a7db5d82ddd0f3ad2b299893199090375e ]

We need to retrieve 'hctx' from xarray table in the cpuhp callback, so the
callback should be registered after this 'hctx' is added to xarray table.

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Peter Newman <peternewman@google.com>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Luck Tony <tony.luck@intel.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20241206111611.978870-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a5ed12bd2b0a..373a67a630f3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3671,16 +3671,11 @@ static int blk_mq_init_hctx(struct request_queue *q,
 {
 	hctx->queue_num = hctx_idx;
 
-	if (!(hctx->flags & BLK_MQ_F_STACKING))
-		cpuhp_state_add_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
-				&hctx->cpuhp_online);
-	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
-
 	hctx->tags = set->tags[hctx_idx];
 
 	if (set->ops->init_hctx &&
 	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
-		goto unregister_cpu_notifier;
+		goto fail;
 
 	if (blk_mq_init_request(set, hctx->fq->flush_rq, hctx_idx,
 				hctx->numa_node))
@@ -3689,6 +3684,11 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	if (xa_insert(&q->hctx_table, hctx_idx, hctx, GFP_KERNEL))
 		goto exit_flush_rq;
 
+	if (!(hctx->flags & BLK_MQ_F_STACKING))
+		cpuhp_state_add_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
+				&hctx->cpuhp_online);
+	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
+
 	return 0;
 
  exit_flush_rq:
@@ -3697,8 +3697,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
  exit_hctx:
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
- unregister_cpu_notifier:
-	blk_mq_remove_cpuhp(hctx);
+ fail:
 	return -1;
 }
 
-- 
2.39.5



