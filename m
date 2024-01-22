Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883FD131748;
	Tue, 23 Jan 2024 00:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969422; cv=none; b=jVZytKSbpiicPdBv2ximqZ4tOh1O+khdclN2ajW/JcoVyJLFgvJTM8j0o24YFA7ZTF9F9UqS8/LVUqOqofqJmbjrwsECQa6gsMT1hqjuADXTLzl1vMrT7urMgSFoDt7+hqldAD3mIyfifzvkaVEObqSyQlsS+1aQ/RVIU+z6F7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969422; c=relaxed/simple;
	bh=M83FQz5zTHHhqG73uXu9CnRFpixDeSmZNyor9ZamnzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnpZ9ArG+1YVmEYc07iZ8EGhxmWO/lj4H2RxmSlkM7HlVjfhlA9HFFJem8ymWYPuwQUSSjngrRNuyASA6amffaZevTBZw1A2AuG7+/8NjA7rSQx9jmFUZQrR54KFUdSm4j07XriC1X6SsqfGYC61A3zp1i1Uvt48ZRZaTLtLSFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYF1TxP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYF1TxP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F49C43390;
	Tue, 23 Jan 2024 00:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969422;
	bh=M83FQz5zTHHhqG73uXu9CnRFpixDeSmZNyor9ZamnzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYF1TxP6rtxKIzPDVhOSq4pdWB/EzH55XHtRhcFa4UjOt1mXKn/iQHvo010vAFwKI
	 TApg9r849DzE3W+ncE1AdlPH1YSBQ4SLJeh1FGeK/tBY3GC6QLZJZtc/IaUc+WP9ab
	 Z9GBR2BivCcxPw5GQ7H6vX0bbMigC44Zu9U6T0IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhui Zhong <czhong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 235/641] blk-cgroup: fix rcu lockdep warning in blkg_lookup()
Date: Mon, 22 Jan 2024 15:52:19 -0800
Message-ID: <20240122235825.280928948@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 393cd8ffd832f23eec3a105553eff622e8198918 ]

blkg_lookup() is called with either queue_lock or rcu read lock, so
use rcu_dereference_check(lockdep_is_held(&q->queue_lock)) for
retrieving 'blkg', which way models the check exactly for covering
queue lock or rcu read lock.

Fix lockdep warning of "block/blk-cgroup.h:254 suspicious rcu_dereference_check() usage!"
from blkg_lookup().

Tested-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Fixes: 83462a6c971c ("blkcg: Drop unnecessary RCU read [un]locks from blkg_conf_prep/finish()")
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20231219012833.2129540-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index fd482439afbc..b927a4a0ad03 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -252,7 +252,8 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 	if (blkcg == &blkcg_root)
 		return q->root_blkg;
 
-	blkg = rcu_dereference(blkcg->blkg_hint);
+	blkg = rcu_dereference_check(blkcg->blkg_hint,
+			lockdep_is_held(&q->queue_lock));
 	if (blkg && blkg->q == q)
 		return blkg;
 
-- 
2.43.0



