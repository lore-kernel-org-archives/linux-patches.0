Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7066128001F;
	Tue, 27 May 2025 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368581; cv=none; b=Gelk8n1VbM2BaHkCIQSMqdtSlLPsn42c/6sXQ7asD9gXnjO9EVCx9hUOYmz3A+JMxfKgqxmX11fodKhThM4w6TtdF3JMzAk2sZ87LosU/IrC2T6rv4NeH7v+hH68GJ3fcw3e5ImRCfHYJBIshUjzE/YeynVMiC0UMO9MC0yJf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368581; c=relaxed/simple;
	bh=0F/pR/KR9egpWJnPmstOJbpH5g+qMtlQsoE8+mWozeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8j+9/GBJ9MMCSE/GfO3eNpN1XOo8kWB2QxwC2AuT4a466+ZRIAwOR79ZW7OzbBu20d6MNlO0izwO7msXKiITiQL070sBnvcgPvrCP2ErT3jHR2NfN8jhfSUNOq0eEvmjmN6xnTy/lkTHVAYE5ZpTyZLLxk9ODOC4FntxvK5YtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5ABR0g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5ABR0g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D089DC4CEEA;
	Tue, 27 May 2025 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368581;
	bh=0F/pR/KR9egpWJnPmstOJbpH5g+qMtlQsoE8+mWozeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5ABR0g9KN3kFtRsk5uymPPhv6L5Dk+MGjL2r5lfadFq3NfdwVW8FfOjTT2+JTlZo
	 glP9nCyMKCpA52xdzsHt3HFU6UNYy1Y3SoEDXAlTTWKR1Yq7PM82XoYn++rQwFrm85
	 4U/yJv3tNyPbCy9+NiDHhm8xePXeVurwCjYGOVEg=
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
Subject: [PATCH 6.14 754/783] memcg: always call cond_resched() after fn()
Date: Tue, 27 May 2025 18:29:11 +0200
Message-ID: <20250527162543.832723635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1161,7 +1161,6 @@ void mem_cgroup_scan_tasks(struct mem_cg
 {
 	struct mem_cgroup *iter;
 	int ret = 0;
-	int i = 0;
 
 	BUG_ON(mem_cgroup_is_root(memcg));
 
@@ -1171,10 +1170,9 @@ void mem_cgroup_scan_tasks(struct mem_cg
 
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


