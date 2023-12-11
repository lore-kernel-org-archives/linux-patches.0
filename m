Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C1F5102A;
	Mon, 11 Dec 2023 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8tBxe8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44359C433C7;
	Mon, 11 Dec 2023 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320657;
	bh=gZT7XdqcupaebN3npWzq+6vKGykB+koMJJavOTUAThs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8tBxe8GKcUoPS9D+kNz6E7uU2QRmS/friEZ70syvSeIrbMw9r3RRyaqURjg2NBd6
	 iRZJbxwdIr2w1WbcxYIyQi1FtjfDu9+CZvwLu/c9P1X35+JIF1rMzOYdeiJEBqwpFF
	 dDtqRTRb7bb2BiNxTMhooCxFRcbr2qauIXkQsiYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Van Patten <timvp@google.com>,
	Mark Hasemeyer <markhas@chromium.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 113/194] cgroup_freezer: cgroup_freezing: Check if not frozen
Date: Mon, 11 Dec 2023 19:21:43 +0100
Message-ID: <20231211182041.547236219@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Van Patten <timvp@google.com>

commit cff5f49d433fcd0063c8be7dd08fa5bf190c6c37 upstream.

__thaw_task() was recently updated to warn if the task being thawed was
part of a freezer cgroup that is still currently freezing:

	void __thaw_task(struct task_struct *p)
	{
	...
		if (WARN_ON_ONCE(freezing(p)))
			goto unlock;

This has exposed a bug in cgroup1 freezing where when CGROUP_FROZEN is
asserted, the CGROUP_FREEZING bits are not also cleared at the same
time. Meaning, when a cgroup is marked FROZEN it continues to be marked
FREEZING as well. This causes the WARNING to trigger, because
cgroup_freezing() thinks the cgroup is still freezing.

There are two ways to fix this:

1. Whenever FROZEN is set, clear FREEZING for the cgroup and all
children cgroups.
2. Update cgroup_freezing() to also verify that FROZEN is not set.

This patch implements option (2), since it's smaller and more
straightforward.

Signed-off-by: Tim Van Patten <timvp@google.com>
Tested-by: Mark Hasemeyer <markhas@chromium.org>
Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/legacy_freezer.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index 122dacb3a443..66d1708042a7 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -66,9 +66,15 @@ static struct freezer *parent_freezer(struct freezer *freezer)
 bool cgroup_freezing(struct task_struct *task)
 {
 	bool ret;
+	unsigned int state;
 
 	rcu_read_lock();
-	ret = task_freezer(task)->state & CGROUP_FREEZING;
+	/* Check if the cgroup is still FREEZING, but not FROZEN. The extra
+	 * !FROZEN check is required, because the FREEZING bit is not cleared
+	 * when the state FROZEN is reached.
+	 */
+	state = task_freezer(task)->state;
+	ret = (state & CGROUP_FREEZING) && !(state & CGROUP_FROZEN);
 	rcu_read_unlock();
 
 	return ret;
-- 
2.43.0



