Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1212222AF;
	Mon,  2 Jun 2025 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874244; cv=none; b=jf9eMY/YDdwsaRPuw/tjXmJ80r9Jr/JiUVdMBuRYijMh7ZGNUinrc+uGJtkZtIKHsV/4ILQZwgkCmEvt4X428JnCqHukLjwVslHHS4GDTxOxIQNiomIW4lIZlLhFA0y4Qbf+DXpiagH8t6gHlZwc+vXpHbQS0VRucRbTqoO9ioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874244; c=relaxed/simple;
	bh=3H7ZJhd6MI5anA1GR7tJdEfArwEeR0SlCLCM1qehG9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCvvJ+Ym6ImzFZD/1gSXSc/5c6ATo2+8ogD5vHkLPuv7jFRsbEqSCo2BYiwaI50am6j45sZKx0Uy+uWLiJXrS1bUfatec/K2g1nEgC+lwKS9a/6uJ1XXJ1DIzH/06i7x6ANPa9nClArEuN80LDx/7cFy20e47xYqhav7+fv15FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwkVrHn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwkVrHn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30254C4CEEB;
	Mon,  2 Jun 2025 14:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874244;
	bh=3H7ZJhd6MI5anA1GR7tJdEfArwEeR0SlCLCM1qehG9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwkVrHn9eQEz0RexYYGCBFO8t2Z9HbdRcKGPAP+8ysYGfNjzdL5H56rY6ddlG+CtW
	 CxepikWR6Ll4mo4oF6q/twPlwiLqUMATb+/cf+Ipeztq0oxWq3A/qoe9w5f53x+iCs
	 Oub5PiYv4oPJNtd/IdZ77kG0zor48FF6F7wq8Wu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michael van der Westhuizen <rmikey@meta.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Chen Ridong <chenridong@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 376/444] memcg: always call cond_resched() after fn()
Date: Mon,  2 Jun 2025 15:47:20 +0200
Message-ID: <20250602134356.178851847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 06717a7b6c86514dbd6ab322e8083ffaa4db5712 upstream.

I am seeing soft lockup on certain machine types when a cgroup OOMs.  This
is happening because killing the process in certain machine might be very
slow, which causes the soft lockup and RCU stalls.  This happens usually
when the cgroup has MANY processes and memory.oom.group is set.

Example I am seeing in real production:

       [462012.244552] Memory cgroup out of memory: Killed process 3370438 (crosvm) ....
       ....
       [462037.318059] Memory cgroup out of memory: Killed process 4171372 (adb) ....
       [462037.348314] watchdog: BUG: soft lockup - CPU#64 stuck for 26s! [stat_manager-ag:1618982]
       ....

Quick look at why this is so slow, it seems to be related to serial flush
for certain machine types.  For all the crashes I saw, the target CPU was
at console_flush_all().

In the case above, there are thousands of processes in the cgroup, and it
is soft locking up before it reaches the 1024 limit in the code (which
would call the cond_resched()).  So, cond_resched() in 1024 blocks is not
sufficient.

Remove the counter-based conditional rescheduling logic and call
cond_resched() unconditionally after each task iteration, after fn() is
called.  This avoids the lockup independently of how slow fn() is.

Link: https://lkml.kernel.org/r/20250523-memcg_fix-v1-1-ad3eafb60477@debian.org
Fixes: ade81479c7dd ("memcg: fix soft lockup in the OOM process")
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Rik van Riel <riel@surriel.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michael van der Westhuizen <rmikey@meta.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1266,7 +1266,6 @@ void mem_cgroup_scan_tasks(struct mem_cg
 {
 	struct mem_cgroup *iter;
 	int ret = 0;
-	int i = 0;
 
 	BUG_ON(mem_cgroup_is_root(memcg));
 
@@ -1276,10 +1275,9 @@ void mem_cgroup_scan_tasks(struct mem_cg
 
 		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			/* Avoid potential softlockup warning */
-			if ((++i & 1023) == 0)
-				cond_resched();
 			ret = fn(task, arg);
+			/* Avoid potential softlockup warning */
+			cond_resched();
 		}
 		css_task_iter_end(&it);
 		if (ret) {


