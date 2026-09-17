Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171D04D179A;
	Thu, 17 Sep 2026 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664730; cv=none; b=J6Za0KyFd5kdaA6oFulxHlphM+rRniRe4cpUZ36VkTM88QfhVOx1kwfJDiWhs0k5h109ByopC65iDyT+G83s/A6C4pQ1pVoN9VeMeANcHujLzutp4iFhXEa0LHqptqO0KnjfeNZ4z+ApEn/V5evEw/WhdmCWoQwfWNKW1UzNPug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664730; c=relaxed/simple;
	bh=6xXlIiB5RSbeLyfRUyAoMGeOUXgLwr0lSyyKlr8tsW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9U/44Z6d2VHcnyc1d42ySKhHnEzqsYl2y7LBuh0C7BlHlpkAZIXPiOm9nFawVFooMCcEbwQmruuPPSKqaPluYAgiT/H1znZbIPcZqlYjh1FjNSW8YGSG0BIZ6Nl2JRxXnR2jSRZSuHT/StonfA56NxyDC2scygIq4pmjOV3lBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLSJ6J0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLSJ6J0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E391F000FF;
	Thu, 17 Sep 2026 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664728;
	bh=2zqZzAsC7e/Zenj57hfb3FsqiSRYkG9CIEZ9ae/KO0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLSJ6J0VtJAVljUHxC6gWJ6GNX2EogpAW1blqnYyZaRC+yhj1dlcs8gYQuasibRL7
	 DoLG8KVW/oAzRNNQQTM4xEn370YndlxphNzpdTW3S6Efw0Z4QvD2ZxebI7+YCBUMj8
	 +EEZq2Z13WcT+fItwB0Y6K2ep0OciRJ3Oc22rMIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0468/1250] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Thu, 17 Sep 2026 16:04:23 +0100
Message-ID: <20260917151604.660885638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f605df3991c38..f638d3dd5ebcf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1241,13 +1241,10 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	else
 		css_rstat_flush(&blkcg->css);
 
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



