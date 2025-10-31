Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D26F34C159;
	Fri, 31 Oct 2025 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919594; cv=none; b=V65d+oiA5c/QkwGMLYuBqgiPqcAzuHzL2GBXvnw9cvYx0l4eZpkW1G4xNBSItbmYfGW9eLKlQvGr6+fPjcJ5UGlRMA38JA4KE7mC1gzb8AoZuLEXOo2tum6HZXede4ieGih6R2rE7zZvEofj7hU8jxq/PvVhAVn0a94qi3PJaKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919594; c=relaxed/simple;
	bh=Ef2owvk/oLkFQc6AbI3y2tf0cSCENskTUY3VAIPx0Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJCk7vWze+atTd2sAXaUb+HiPpSlFbCgUN9ee3YoPFD0iGV3jIUIO6KvqHgYtPbkjCYrXm1NQ11EXNqEuusaHecmnVxGaiCup1f7bU5jX0+x5y/1lf0x+8yoxPEngG3JtzPWRWhdOu6bkcvFtl0MZMaIOZwHYRJIYA6EiVBMrPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i54laz/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i54laz/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC129C4CEFB;
	Fri, 31 Oct 2025 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919594;
	bh=Ef2owvk/oLkFQc6AbI3y2tf0cSCENskTUY3VAIPx0Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i54laz/hbhDVdF6zirA667xyyjc2tQs3sifaZXIUThx/ILcUM86QxyXy/vMiujbVH
	 qDQmeN6E2rw19jlNkkD06mHTy86NqvV4/qDgxV6SMqn759zTjGZqi9+mCax9s6ZKN4
	 3h0poUH973YUVhGjwq1wFGnaTGxOXWkK/NGNZUgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 03/35] sched_ext: Sync error_irq_work before freeing scx_sched
Date: Fri, 31 Oct 2025 15:01:11 +0100
Message-ID: <20251031140043.644725543@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit efeeaac9ae9763f9c953e69633c86bc3031e39b5 ]

By the time scx_sched_free_rcu_work() runs, the scx_sched is no longer
reachable. However, a previously queued error_irq_work may still be pending or
running. Ensure it completes before proceeding with teardown.

Fixes: bff3b5aec1b7 ("sched_ext: Move disable machinery into scx_sched")
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 46029050b170f..f89894476e51f 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3537,7 +3537,9 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 	struct scx_dispatch_q *dsq;
 	int node;
 
+	irq_work_sync(&sch->error_irq_work);
 	kthread_stop(sch->helper->task);
+
 	free_percpu(sch->pcpu);
 
 	for_each_node_state(node, N_POSSIBLE)
-- 
2.51.0



