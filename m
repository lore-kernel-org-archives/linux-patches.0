Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA7D4C74;
	Mon, 23 Jun 2025 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716191; cv=none; b=lnh41a8W0ZMQC6e+AGR+yZVpr5bcqFvMyk3B17Yiz5WTE0t8b1/BdBNIwDsqzP3PBukn7x0zItULg8/B6G8MRaWJYt9vxWrFpPRpNkkOOHhGd4OhtaVlN9tBuc0KfSup3zMYD1uGljfHqg8TiDvmkV6mnOtAjw+Iz0ERsRat3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716191; c=relaxed/simple;
	bh=YrofZ9LSgjdgHrtY+Z4ShQqhzVF/CJjIRWmYN1I5US4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGmMW8Bdnlw99AkNyFQ2IG8rZ+QNXZ8SIq2xzCUbmm8nFes+twwLqJiYbyq/wzBK+wxgMzqt773/ytBHMoawNUiKBY0qKzKFSAq/BtNJi6L5OqKZMbpPs7Ym7wzdL3S66M6zMNpbxnbPtql3D40o+vouy5VfxCm0nX14ykoFVMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rPmrdUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rPmrdUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC424C4CEEA;
	Mon, 23 Jun 2025 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716191;
	bh=YrofZ9LSgjdgHrtY+Z4ShQqhzVF/CJjIRWmYN1I5US4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rPmrdUTQ6/7/l6JtQphRmabxTLOunLLw6WJXkaTG+cDR4BofyPFmvnFNNX7wttuH
	 IIOUuyvpuY3lDKxf40ZTg2iuzGk71MMUYAfVL7c17WSvRD2u2F0C3Ajp+eeNEdC8gx
	 JJaGT7RXTdIn13qWkghYjKW4F9O6E04Z3UmpBEHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 528/592] workqueue: Initialize wq_isolated_cpumask in workqueue_init_early()
Date: Mon, 23 Jun 2025 15:08:06 +0200
Message-ID: <20250623130712.993301480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit 261dce3d64021e7ec828a17b4975ce9182e54ceb ]

Now when isolcpus is enabled via the cmdline, wq_isolated_cpumask does
not include these isolated CPUs, even wq_unbound_cpumask has already
excluded them. It is only when we successfully configure an isolate cpuset
partition that wq_isolated_cpumask gets overwritten by
workqueue_unbound_exclude_cpumask(), including both the cmdline-specified
isolated CPUs and the isolated CPUs within the cpuset partitions.

Fix this issue by initializing wq_isolated_cpumask properly in
workqueue_init_early().

Fixes: fe28f631fa94 ("workqueue: Add workqueue_unbound_exclude_cpumask() to exclude CPUs from wq_unbound_cpumask")
Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ea62b8c76b32..c8083dd300167 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7756,7 +7756,8 @@ void __init workqueue_init_early(void)
 		restrict_unbound_cpumask("workqueue.unbound_cpus", &wq_cmdline_cpumask);
 
 	cpumask_copy(wq_requested_unbound_cpumask, wq_unbound_cpumask);
-
+	cpumask_andnot(wq_isolated_cpumask, cpu_possible_mask,
+						housekeeping_cpumask(HK_TYPE_DOMAIN));
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
 
 	unbound_wq_update_pwq_attrs_buf = alloc_workqueue_attrs();
-- 
2.39.5



