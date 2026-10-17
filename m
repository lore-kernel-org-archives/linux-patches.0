Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855883C8C62;
	Sat, 17 Oct 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260026; cv=none; b=HKzsq65BpAkBzHIfAW7/wASmYjiXXVm4LarU/6rw0ctmUlwz/S4JqwkjguskNWDJG48P2nyAgQnzx1t3bzekeYb8VVZq0hhTBhUAfqGU8QbUEY1n5kfaU0RzH+5uTnidJhROT+2GpqwMICUqu07TeTKbmhEFSiJUjto+OORJbfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260026; c=relaxed/simple;
	bh=KKyeEUnH8P+kAs1bXdEqJtqIdvu8WaUrIyQdQZIk0qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhDUeycxZwM5fly1W1rX92S2CmRdfBGRy/LkToWsRXsoJIO80P80FGX3BU/QiMQOZ4TaaCyYc0ghvEi1hQ1mEdHDnDlK6cBdYaHBQTnQ0PIA5+72SAQ/6MlSt26GsgykbhMCH98H5X3xGx0dJa+tSpVeRbQtjCaqz/R9EEki09E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIzd0yff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIzd0yff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DA41F000C4;
	Sat, 17 Oct 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260025;
	bh=trFKdp0fc7tCxTyTXZXeNVkUqsH+sNnAIuTcB3LzP7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIzd0yffMXJAlcr/YN/s+ml3yHroTFQfPnoPSUVwMsG+iNjpEssE6UjvXwc4AAab4
	 jXVlMhmivEYR/Y+u8GKhxTDKxQvxT9TfZ8F65rgqTRirIuaitWIFMBd4FkXZRZXjAT
	 hsHleATQxWvi4AlNjjfxe05tn+WIKJ1vPnXJO7Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1406/1674] blk-iolatency: clear delay state when freeing policy data
Date: Sat, 17 Oct 2026 18:01:18 +0200
Message-ID: <20261017160507.267662535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit 8935bf22c0a0db517a7f72f7097300e05dd852f5 ]

io.latency can throttle a group which has no latency target of its own.
When a sibling misses its target, check_scale_change() scales down its
peers, and a peer that reaches queue depth one gets blkcg_use_delay()
called on it on every further scale-down, even with min_lat_nsec == 0.

iolatency_pd_offline() resets the target through
iolatency_set_min_lat_nsec(), which clears the delay only on a nonzero
to zero transition, so it never clears such a peer.  Freeing the policy
data then leaves blkg->use_delay set and blkcg->congestion_count
elevated with nothing left that can drop it.

blk_cgroup_congested() then returns true for every task in that cgroup
and its descendants for as long as the cgroup lives: page_cache_sync_ra()
cuts readahead to a single page, page_cache_async_ra() skips it
altogether, and __folio_throttle_swaprate() takes swap_avail_lock and
schedules a throttle on anonymous folio allocation.

Clear the delay in iolatency_pd_free().  By then bio-held blkg
references have drained, or the queue is frozen for policy
deactivation, so check_scale_change() cannot re-arm it.  The free
callback can also see policy data which was never attached to a blkg,
hence the pd->blkg check.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260814165712.510132-2-usama.arif@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 432d35a7196ec..e50fc4e4240fb 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1043,6 +1043,15 @@ static void iolat_release(struct rcu_head *rcu)
 
 static void iolatency_pd_free(struct blkg_policy_data *pd)
 {
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
+
+	/*
+	 * Groups throttled as collateral have min_lat_nsec == 0, so
+	 * iolatency_pd_offline() leaves their delay set.  Drop it here, where
+	 * no in-flight bio can re-arm it via check_scale_change().
+	 */
+	if (blkg)
+		blkcg_clear_delay(blkg);
 	call_rcu(&pd->rcu_head, iolat_release);
 }
 
-- 
2.53.0



