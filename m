Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE7129EFE;
	Mon, 18 Dec 2023 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pw7gid3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35193C433C7;
	Mon, 18 Dec 2023 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907511;
	bh=ZmzK/NeyK20zdoDZEPxFIw7EyY1zlvqtSq91O/fcpsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pw7gid3f2D++1RkCjsZOFDRXTKLcVIaD7E1kU8DVjsYRNG7Yba3moDHmiOqeCTdJU
	 jxVkf8DBzowvUhtozdgawQxTxOxDM/i/KdkeYaT1g7dEHpo6H88oVKUT+3IT/XCZqa
	 wy2mkgnMc4IKBupvebBHgVRf9CeFtP5rqBkZjCjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhui Zhong <czhong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/26] blk-throttle: fix lockdep warning of "cgroup_mutex or RCU read lock required!"
Date: Mon, 18 Dec 2023 14:51:16 +0100
Message-ID: <20231218135041.199566056@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135040.665690087@linuxfoundation.org>
References: <20231218135040.665690087@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 27b13e209ddca5979847a1b57890e0372c1edcee ]

Inside blkg_for_each_descendant_pre(), both
css_for_each_descendant_pre() and blkg_lookup() requires RCU read lock,
and either cgroup_assert_mutex_or_rcu_locked() or rcu_read_lock_held()
is called.

Fix the warning by adding rcu read lock.

Reported-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20231117023527.3188627-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index fcbbe2e45a2bb..e52a9632993a7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1391,6 +1391,7 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 		   tg_bps_limit(tg, READ), tg_bps_limit(tg, WRITE),
 		   tg_iops_limit(tg, READ), tg_iops_limit(tg, WRITE));
 
+	rcu_read_lock();
 	/*
 	 * Update has_rules[] flags for the updated tg's subtree.  A tg is
 	 * considered to have rules if either the tg itself or any of its
@@ -1418,6 +1419,7 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 		this_tg->latency_target = max(this_tg->latency_target,
 				parent_tg->latency_target);
 	}
+	rcu_read_unlock();
 
 	/*
 	 * We're already holding queue_lock and know @tg is valid.  Let's
-- 
2.43.0



