Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3A53382C8;
	Sun,  7 Jun 2026 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830112; cv=none; b=FxbsQRMt7uc+/Br6Yq6ucOhgNPoY5TdGASN6fcI+yyzprhQ108Li2fkMh+z3z7IQn+vioBWjvDZfwW2fVl+pnPW5CNvnt6m7alCwWsGZ/ggFplkf52OI1wkP50m5BiPxgGgLJiUc2h1cYS/guuxMXxJS6z9mtGFHZQjdkgmpGnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830112; c=relaxed/simple;
	bh=qoTgSQhVhsQYZuFlGiwEqnB2C5Wuihrx08J+DNDqZ6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/0iaE8Ecv8C9y/3c2C1oje4nIdfLOf0dKgMe+rhOA2sYnd+Aegcd+yRa3j58mFJo3EomJUIhaaLy0fAPbSKRc0OwaOHSYMZ8iYPsgfniHfGLJCH8Lt5HzVBOAT8Wn+c8QBzBNYInmgkHkaXTXvZQpbGHnNuyicxyFDmnYLY0zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q/V58eB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q/V58eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F7D1F00893;
	Sun,  7 Jun 2026 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830110;
	bh=5IafX1g93oduRvZAJzmDGoKvJgU79IMqWWI9H7LmWRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0q/V58eBF2N/GjjGaSQVaz9//S9Lzb3YyNFUoR4haZKjfzGu/8qx+TK2Em6r2dCNw
	 Bzw/B2/+sAM20JSYWBjFtNhzWhWHXMNxc3xFUIcsCerfuzEn8SfCqHTg114Pr6kYKI
	 DNPoXDdblQFK3NNcRIJcyi44j4x26v3sWbjxVXZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing7171@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 310/315] mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()
Date: Sun,  7 Jun 2026 12:01:37 +0200
Message-ID: <20260607095739.003476876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Qing Wang <wangqing7171@gmail.com>

[ Upstream commit 67ea9d353d0ba12bdbc9183ff568dead9e949b80 ]

flush_rcu_sheaves_on_cache() calls queue_work_on() in a
for_each_online_cpu() loop, which requires the cpu to stay online.
But cpus_read_lock() is not held in kvfree_rcu_barrier_on_cache() and the
set of "online cpus" is subject to change.

There are two paths that call flush_rcu_sheaves_on_cache():

  // has cpus_read_lock()
  flush_all_rcu_sheaves()
    -> flush_rcu_sheaves_on_cache()

  // no cpus_read_lock()
  kvfree_rcu_barrier_on_cache()
    -> flush_rcu_sheaves_on_cache()

Fix this by holding cpus_read_lock() in kvfree_rcu_barrier_on_cache().

Why not move cpus_read_lock() from flush_all_rcu_sheaves() into
flush_rcu_sheaves_on_cache()? The reason is it would introduce a new lock
order (slab_mutex -> cpu_hotplug_lock). The reverse order
(cpu_hotplug_lock -> slab_mutex) is established by

- cpuhp_setup_state_nocalls(..., slub_cpu_setup, ...)
- kmem_cache_destroy()

The two orders together would form an AB-BA deadlock.

Finally, add lockdep_assert_cpus_held() in flush_rcu_sheaves_on_cache()
to catch the same problem in the future.

Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
Link: https://patch.msgid.link/20260512035035.762317-1-wangqing7171@gmail.com
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    2 ++
 mm/slub.c        |    1 +
 2 files changed, 3 insertions(+)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2135,7 +2135,9 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
 	if (s->cpu_sheaves) {
+		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
+		cpus_read_unlock();
 		rcu_barrier();
 	}
 
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4203,6 +4203,7 @@ void flush_rcu_sheaves_on_cache(struct k
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
 
 	for_each_online_cpu(cpu) {


