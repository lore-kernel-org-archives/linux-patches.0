Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB4830568E;
	Sat, 12 Sep 2026 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222668; cv=none; b=lIvGmqDQMxv3ufSi2aNjzI3k7owKKpTVVkizvpl2ImoVX3dyj+Z3xbE7gzNJ3mt8Byfzh38RkqsiH80Pj/h+HUhIjBQfYIcVu/+9ie3KiYbHA8C2NJs0eBuKrcb/bCCc90mK0CDNzIqF7kjSmb1vm/CxeYzLLGr21UxSg6OgJvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222668; c=relaxed/simple;
	bh=YmMKeTFCKDa7uWYuP0Or0ETbGJeKgZ8gjN9ZQWfGLzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW2xzXBw2ii6mcwgBUvDfdG1hyULQCazKyJzhMTmk4FAmzJCImS3vk/UidUD+l7RqgxmyjF7nw1OHT8F3EsrY8ru9rJXDMWit3BkGvEjzaNCB6ihQZf8vir/CUwBqra2s8Pt+gBzMJJrOI4sAGgErvPoq2QpgK/6bqKp6tdys1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U71tUlCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U71tUlCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBF91F000FF;
	Sat, 12 Sep 2026 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222667;
	bh=Qc0Xd6uVUcXdU6HphHxqjF6LX/QQktEdxQWuzFK2F7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U71tUlCbZb7mHtt7yPDXl4jDwwIafErj7melQf0Bb3cWjbowrYw/tjGMZ1yeEQfxv
	 1V1DR8ZrGcZCjNenDM/2DS4xCEQO5R1s6DSzVT1DMUoZj45UNg/0KNUIN7zsbjacqv
	 OXSXKcjyKZPD7lyvoC2Hzz1YSk8KM8RfFgIZ3TT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0590/1424] sched/fair: Fix overflow in update_tg_cfs_runnable()
Date: Sat, 12 Sep 2026 08:50:22 +0200
Message-ID: <20260912065620.504265049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Chen, Yu C <yu.c.chen@intel.com>

[ Upstream commit 4f166adb5cb0525d9e32d45729fd8f28c80acbee ]

A divide-by-zero crash is observed when running hackbench:

   [14697.488452] CPU: 112 UID: 0 PID: 124791 Comm: hackbench Not tainted 7.1.0-rc2+
   [14697.492627] RIP: 0010:propagate_entity_load_avg+0x35f/0x3e0
   [14697.506799]  <TASK>
   [14697.507411]  __dequeue_task+0x2b4/0xc70
   [14697.508677]  dequeue_task_fair+0x36/0x370
   [14697.509047]  dequeue_task+0x101/0x2f0
   [14697.509426]  __schedule+0x1b1/0x1a00
   [14697.510868]  anon_pipe_read+0x3da/0x450
   [14697.511400]  vfs_read+0x361/0x390
   [14697.512053]  __x64_sys_read+0x19/0x30

The divide-by-zero happens here:

  if (scale_load_down(gcfs_rq->load.weight)) {
           load_sum = div_u64(gcfs_rq->avg.load_sum,
                              scale_load_down(gcfs_rq->load.weight));
  }

gcfs_rq->load.weight is an insane large value and is truncated
to the lower 32 bits by div_u64, which happen to be 0.

Using AI for investigation, the cause is a u32 overflow in
update_tg_cfs_runnable(), and flat pickup became a victim when using
tg_tasks():

   u32 new_sum, divider;
   ...
   new_sum = se->avg.runnable_avg * divider; <-- boom

The following sequence shows how this triggers the crash:

   propagate_entity_load_avg()
     update_tg_cfs_runnable()     # u32 overflow corrupts runnable_sum

   __update_load_avg_cfs_rq()
     ___update_load_avg()         # computes insane runnable_avg
   update_tg_load_avg()           # propagates to tg->runnable_avg

   update_cfs_group()
     calc_concur_shares()
       tg_tasks()                 # long-to-int truncation, negative nr
     reweight_entity()            # corrupted se->load.weight
       update_load_add()          # corrupted cfs_rq->load.weight

   propagate_entity_load_avg()
     update_tg_cfs_load()
       div_u64()                  # divide-by-zero

Fix by widening new_sum from u32 to u64 (no need to force tg_tasks()
to return unsigned long after this fix)

Fixes: 95246d1ec80b ("sched/pelt: Relax the sync of runnable_sum with runnable_avg")
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/a22eea2b-4c4a-4623-9a44-d7b18c0c91c8@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c3a6b66b836c0..a36ee92e3075a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4312,7 +4312,8 @@ static inline void
 update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
 	long delta_sum, delta_avg = gcfs_rq->avg.runnable_avg - se->avg.runnable_avg;
-	u32 new_sum, divider;
+	u64 new_sum;
+	u32 divider;
 
 	/* Nothing to update */
 	if (!delta_avg)
@@ -4326,7 +4327,7 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cf
 
 	/* Set new sched_entity's runnable */
 	se->avg.runnable_avg = gcfs_rq->avg.runnable_avg;
-	new_sum = se->avg.runnable_avg * divider;
+	new_sum = (u64)se->avg.runnable_avg * divider;
 	delta_sum = (long)new_sum - (long)se->avg.runnable_sum;
 	se->avg.runnable_sum = new_sum;
 
-- 
2.53.0



