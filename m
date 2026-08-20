Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7D3803E8;
	Thu, 20 Aug 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239127; cv=none; b=LCLiYA0n1uIXg0H+bkqD8oKECrjviOFVyADl/TYZwfoWMjG+AkRPfJJIlfb3OSded0vQCqUNp/wVGuUnPZzzXD99YUnwGfvJPySdBtkp1QkyER9ks6hXZxtMM8JaP/u97z2bgOU3xBBBFiG2ZQevTUd2NThuSopXvQbIYvJPBl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239127; c=relaxed/simple;
	bh=jj+D5GXYeCHCAKMqfcSBCxApfAcgN6/oMBjLwCXPJ+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsw8OMfNoarbo3SeO//h34Yk+TPHwMziZybXdj5tStGQJ8kvjRveezsZLKwBZvUnjkOlI54UvFX6N2+52xus2ORNfDVRkOvYLldJipb0xbnH1Nxthkt6E+TL+4kJP9N6oExO1Rh6La/e2wPW5xK5thMhRRgLxQc4bx58G6YL1s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXW0vcYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXW0vcYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8744B1F000E9;
	Thu, 20 Aug 2026 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239124;
	bh=BZP5oqu2YOf+69fm19wfE/ZYcGaN4wFyhbMqwGrFpfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXW0vcYWTTjtFt6Jqj22OMzO3SiustHJmmt6/q7HaN1LCIwUqnynxFMrpy3D3AzJi
	 EgdO643pfU/BG87DqHEoNjVouPTXtZTxlla4fRYLBwE6LR/AxzUL6E2okhAJauBE2X
	 gexJ0+mRhND8AYIXUi/IexQ9m7yPO/sDLnlH8BJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/217] sched_ext: Update p->scx.disallow warning in scx_init_task()
Date: Thu, 20 Aug 2026 16:55:25 +0200
Message-ID: <20260820145242.481371583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 0454a604b98a9bf301e82860cd216ec4ac563668 ]

- Always trigger the warning if p->scx.disallow is set for fork inits. There
  is no reason to set it during forks.

- Flip the positions of if/else arms to ease adding error conditions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: 5f8b69642d18 ("sched_ext: Take cgroup_lock() first in scx_cgroup_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2841,7 +2841,10 @@ static int scx_init_task(struct task_str
 	scx_set_task_state(p, SCX_TASK_INIT);
 
 	if (p->scx.disallow) {
-		if (!fork) {
+		if (unlikely(fork)) {
+			scx_error(sch, "ops.init_task() set task->scx.disallow for %s[%d] during fork",
+				  p->comm, p->pid);
+		} else {
 			struct rq *rq;
 			struct rq_flags rf;
 
@@ -2860,9 +2863,6 @@ static int scx_init_task(struct task_str
 			}
 
 			task_rq_unlock(rq, p, &rf);
-		} else if (p->policy == SCHED_EXT) {
-			scx_error(sch, "ops.init_task() set task->scx.disallow for %s[%d] during fork",
-				  p->comm, p->pid);
 		}
 	}
 


