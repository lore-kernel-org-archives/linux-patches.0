Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325F43CEED;
	Mon, 17 Aug 2026 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973884; cv=none; b=qja6S97ZHMyclbPMbg8WKrJMEAVj8ksQ8IYEP+zOHzc+7KgsTW/oUyIGkDcwr7uII4lBp3PPzXQCBfR1m3TYgZzfdKLDvVSfLPq+X9Nyqqhv2Tum2LFu9XXzrbNdmqVqXNvq8vSA5dzYCZ0lIC/6T06YM2PFTI4YFrZhq80Bg1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973884; c=relaxed/simple;
	bh=DiPI852GGKaSP/Fj0xJgOhmZdFBKCJXwV6tcCbsE7oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slsjFnh3XxEzTb/bhZUoEizCNL9gabTa9gqvOGDYcbelxnf9ci0C1jNtbsdYvmja1scv6v4yabWlfCQENu+/6cfxRFT1kcyIoC4rREpfKotP7vBpDVArkEi9ffZr0aiArj25+7JFZqbD4O1KmZSVQyZZmV/1Bffs6FxXLRU12R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajew7n8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajew7n8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3011F00A3E;
	Mon, 17 Aug 2026 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973880;
	bh=3wd7StVCUQgcb31vC/HylovVVSysghmmJB1EhwjlXho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajew7n8l58xtC3MYtNfHUL0F3HgIFU3lsEE8bCygCHRq20W0a7wW+brsAbYIhW1d0
	 NMCT30LczHkfMh6WZAy483y7oODFbTv024VcUHq8X5Vwz5cLvnU9uiN8WyA589MTt3
	 PXx9lQJB83B77+iPcR0EJoygr4Df8Rmfm4l4KYWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 014/271] sched_ext: Skip sub-disable teardown for never-linked sub-schedulers
Date: Mon, 17 Aug 2026 15:28:59 +0200
Message-ID: <20260817132537.359593946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 8c13364db9c9a43ed286f3a8d0fb9477b1adc43c ]

A sub-scheduler enable can fail before scx_link_sched() links the sched into
the hierarchy, e.g. when the parent is already being disabled, and cleanup
still runs the full scx_sub_disable().

That is racy against root disable: drain_descendants() is the only ordering
between a sub's disable-time task walk and root disable's all-task teardown,
and an unlinked sub is invisible to it. Root's teardown can thus run between
the never-linked sub's drain and its walk, exiting every task to no
scheduler.

The walk then trips the membership WARN and re-homes the exited tasks onto
the dying hierarchy, a use-after-free.

Skip the cgroup ownership reset and the task walk if @sch was never linked,
indicated by the empty ->sibling as unlinking only happens later in the same
function. The membership WARN remains valid: a linked sub is always waited
on by an ancestor's drain.

Fixes: 337ec00b1d9c ("sched_ext: Implement cgroup sub-sched enabling and disabling")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 6904d65d2b852..a8c4f665d173c 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5798,6 +5798,15 @@ static void scx_sub_disable(struct scx_sched *sch)
 	percpu_down_write(&scx_fork_rwsem);
 	scx_cgroup_lock();
 
+	/*
+	 * An enable that failed before scx_link_sched() never owned a cgroup or
+	 * task and won't be waited on by an ancestor's drain_descendants().
+	 * Nothing to reparent and walking the tasks can misbehave as the task
+	 * ownership invariant (either owned by self or parent) does not hold.
+	 */
+	if (list_empty(&sch->sibling))
+		goto dump;
+
 	set_cgroup_sched(sch_cgroup(sch), parent);
 
 	scx_task_iter_start(&sti, sch->cgrp);
@@ -5810,8 +5819,8 @@ static void scx_sub_disable(struct scx_sched *sch)
 			continue;
 
 		/*
-		 * By the time control reaches here, all descendant schedulers
-		 * should already have been disabled.
+		 * By the time control reaches here, all linked descendant
+		 * schedulers should have been disabled.
 		 */
 		WARN_ON_ONCE(!scx_task_on_sched(sch, p));
 
@@ -5881,6 +5890,7 @@ static void scx_sub_disable(struct scx_sched *sch)
 	}
 	scx_task_iter_stop(&sti);
 
+dump:
 	scx_disable_dump(sch);
 
 	scx_cgroup_unlock();
-- 
2.53.0



