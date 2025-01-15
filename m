Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D255C248BAF;
	Wed, 15 Jan 2025 11:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938867; cv=none; b=VLsyWNPRcGyGAceNR8FltwBgtJVp0mzobSBuUnyM7NW2VhcplVGkepCmBg3ieDc5PIYVhKg44Lt6CsHCr3jXOZR63P/dYZIFLSNJlpWH4ydAnedcCkAZOmdFDy6jYdagBxsNAhBuxJ9TtBWqCzCYWeYP86RwuJKMoGaI/ca6hgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938867; c=relaxed/simple;
	bh=pPclPDVKe2Q2fWob1tkuzPoASDu3/YWNYDuevLUNNVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4uH37tB7w0BQxbI8oVs3YhmxmKV0uTUXhkpMtWfOAI+Tk/n4s6n9GooBqQaRKBcdMmRV/YnEhpimRa9i9+RbHWKa4E9TDYlbvTEcH9AA1i2tnKbsh0/CqaRVSmgc7MG3IYIuF9/AjoTTf3CGdg4Ac8wXA2MquyPTd9QpJ0okcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye94z9qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye94z9qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8361C4CEDF;
	Wed, 15 Jan 2025 11:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938866;
	bh=pPclPDVKe2Q2fWob1tkuzPoASDu3/YWNYDuevLUNNVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye94z9qeOfMk8gL04pf7geO1UDG5ae/eF44D3z7MKJxvlk7pKPnG0DM9po8RHj0fn
	 L2z+p3RaI3JO9eKYY2/+BXjrTCp2r0/gcMJ0pM3coQJc7r/V03S3YBG7tkXycL7nAj
	 GqW35JaIm6CJXW/oMsDWw/08F2Y3eGeIjVxs9PRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/129] workqueue: Add rcu lock check at the end of work item execution
Date: Wed, 15 Jan 2025 11:38:16 +0100
Message-ID: <20250115103559.180030768@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit 1a65a6d17cbc58e1aeffb2be962acce49efbef9c ]

Currently the workqueue just checks the atomic and locking states after work
execution ends. However, sometimes, a work item may not unlock rcu after
acquiring rcu_read_lock(). And as a result, it would cause rcu stall, but
the rcu stall warning can not dump the work func, because the work has
finished.

In order to quickly discover those works that do not call rcu_read_unlock()
after rcu_read_lock(), add the rcu lock check.

Use rcu_preempt_depth() to check the work's rcu status. Normally, this value
is 0. If this value is bigger than 0, it means the work are still holding
rcu lock. If so, print err info and the work func.

tj: Reworded the description for clarity. Minor formatting tweak.

Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: de35994ecd2d ("workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_MEM_RECLAIM worker")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7fa1c7c9151a..2d85f232c675 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2638,11 +2638,12 @@ __acquires(&pool->lock)
 	lock_map_release(&lockdep_map);
 	lock_map_release(&pwq->wq->lockdep_map);
 
-	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d\n"
+	if (unlikely(in_atomic() || lockdep_depth(current) > 0 ||
+		     rcu_preempt_depth() > 0)) {
+		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d/%d\n"
 		       "     last function: %ps\n",
-		       current->comm, preempt_count(), task_pid_nr(current),
-		       worker->current_func);
+		       current->comm, preempt_count(), rcu_preempt_depth(),
+		       task_pid_nr(current), worker->current_func);
 		debug_show_held_locks(current);
 		dump_stack();
 	}
-- 
2.39.5



