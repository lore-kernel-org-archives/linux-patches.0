Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70BC4E1C76;
	Thu, 17 Sep 2026 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668406; cv=none; b=qKLFx0cLjQkRqLLIpH1l2eEXbqLeb+ixbGbG8BII/8UjV2V8cOwnyT87lDxA+wMMcwQZXDyBNen/Hzejokc4SjJ+zKw8Wwu4u69xK6Tz8frUFcpTvd2sSvyz47AH59adwZHVsBb3ldmiQVZQN++HZtyiiJGfA2GWRGrT/EOclEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668406; c=relaxed/simple;
	bh=iwfkwbozj+DIX+hU4pu6xVpuVcPOe2ofYOfnfrImGbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSlxsvpHLsuc1fbpGcdjM2ENlNNtQpP8EzDY8Y/Rcf2iwG7i9lnzVefJ7MOINa2e4uO6vdp1r1f57gphh0zh0niqFoAaPf0GR8k9nALIWl9EMSSrb3x5s3ipp2WLku3hYmBP3vYKPgh8KO8CR3YXWkpz+E9zQ+CPHng5BZa9J50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGx06GZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGx06GZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB4B1F000FF;
	Thu, 17 Sep 2026 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668404;
	bh=T+GRmvoZ+bj5tZ+hMPgcWd3OSLdoN5+Q+xXicmVCsjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGx06GZ6HDMczn1jQCkVqeZud+4hyc82EubMvagiPI5GW9BpE/QwJkC1M2ed2rk8f
	 x7GLqgcr3hvuzCYz/hCs4g8JkAo6et1I2OxDJM7ZfZlAG149Y/Cb6soMrNmXNCNSMx
	 IwleHoOi040iizOgFeuTXxT4iYu3UXaSpe2AlKX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0364/1102] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Thu, 17 Sep 2026 16:05:07 +0100
Message-ID: <20260917151548.787797250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 25656304dabd26198ec69460c594a19d086ef099 ]

blkcg_print_one_stat() will be called for each blkg:
- access blkg->iostat, which is freed from rcu callback
  blkg_free_workfn();
- access policy data from pd_stat_fn(), which is freed from
  pd_free_fn(), while pd_free_fn() can be called by removing blkcg or
  deactivating policy;

Take blkcg->lock while iterating so the blkgs stay online and both
blkg->iostat and policy data for activated policies stay valid.  Use
irq-safe locking because blkcg->lock can be nested under q->queue_lock,
which is used from IRQ completion paths.

Prepare to convert protecting blkgs from request_queue with mutex.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/05799877e720dcd300e2ddd4625e8e162959d7cc.1780621988.git.yukuai@fygo.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8e7e2db4d1c27..7f00e9e9cc061 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1194,13 +1194,10 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	else
 		cgroup_rstat_flush(blkcg->css.cgroup);
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
+	guard(spinlock_irq)(&blkcg->lock);
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
-	rcu_read_unlock();
+
 	return 0;
 }
 
-- 
2.53.0



