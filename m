Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEA73B19B3;
	Thu, 30 Jul 2026 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428243; cv=none; b=kkcJ9KL+2cnKxp4xODDmJmCyjV+LA0PegSwVCULU6/YQT25bpJoRUvytVUBcbOwmoN7mur7KYNSLPedcl71bb/v8D8Rupcaz/xD/7hF4eYUtf6TFo3Va05kYvhW5WOx1WyXhWEzfAZN3ZCq0uvtE1qkFVUJraJlEZ2LKcoBBnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428243; c=relaxed/simple;
	bh=44O1qOW/6YDPsfF6I/aVLKdQ1fk/f9TAtSB07s96HbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWx1TZ22OW3R2UqB5Yl83gZGV+nWNEyQAjxFvkimU4DmVERgxbF1LeLWasAkN4+kAViXtg4HQ/Gm+lm/9+EgP6ThS4CadZ24N9yEopyxlSkWm+4fM16hu77taC780j4sEp63zZw2s5e3X0MPT8iy/q0fGl+OGIrSuuADVo7VOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RjisZbn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RjisZbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546911F000E9;
	Thu, 30 Jul 2026 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428241;
	bh=GBMnzQQzPfVf+5JaMUSPKNFN/GqtNfmTRS2ybndnByg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RjisZbnixR3VXqADt7jy9bEt6CDBf61HrcMt9osm/KONWIjmmlrlNj2YGupAZDXn
	 8hWwvE7wOHLTZLAsj57Iv2X6x7yEc756D0IWTRk7hkqgz22h0XphP/BspdhT8wVmjY
	 5wqzvLLex3UAMYyScu+saKCaqdq4gkR+wrPg+JYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Allen Pais <allen.lkml@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 452/484] workqueue: Factor out init_cpu_worker_pool()
Date: Thu, 30 Jul 2026 16:15:49 +0200
Message-ID: <20260730141433.300981231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 2fcdb1b44491e08f5334a92c50e8f362e0d46f91 ]

Factor out init_cpu_worker_pool() from workqueue_init_early(). This is pure
reorganization in preparation of BH workqueue support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Allen Pais <allen.lkml@gmail.com>
Stable-dep-of: 50fd6dd755c6 ("tracing/user_events: Fix use-after-free in user_event_mm_dup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6609,6 +6609,22 @@ static void __init restrict_unbound_cpum
 	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, mask);
 }
 
+static void __init init_cpu_worker_pool(struct worker_pool *pool, int cpu, int nice)
+{
+	BUG_ON(init_worker_pool(pool));
+	pool->cpu = cpu;
+	cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
+	cpumask_copy(pool->attrs->__pod_cpumask, cpumask_of(cpu));
+	pool->attrs->nice = nice;
+	pool->attrs->affn_strict = true;
+	pool->node = cpu_to_node(cpu);
+
+	/* alloc pool ID */
+	mutex_lock(&wq_pool_mutex);
+	BUG_ON(worker_pool_assign_id(pool));
+	mutex_unlock(&wq_pool_mutex);
+}
+
 /**
  * workqueue_init_early - early init for workqueue subsystem
  *
@@ -6657,20 +6673,8 @@ void __init workqueue_init_early(void)
 		struct worker_pool *pool;
 
 		i = 0;
-		for_each_cpu_worker_pool(pool, cpu) {
-			BUG_ON(init_worker_pool(pool));
-			pool->cpu = cpu;
-			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
-			cpumask_copy(pool->attrs->__pod_cpumask, cpumask_of(cpu));
-			pool->attrs->nice = std_nice[i++];
-			pool->attrs->affn_strict = true;
-			pool->node = cpu_to_node(cpu);
-
-			/* alloc pool ID */
-			mutex_lock(&wq_pool_mutex);
-			BUG_ON(worker_pool_assign_id(pool));
-			mutex_unlock(&wq_pool_mutex);
-		}
+		for_each_cpu_worker_pool(pool, cpu)
+			init_cpu_worker_pool(pool, cpu, std_nice[i++]);
 	}
 
 	/* create default unbound and ordered wq attrs */


