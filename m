Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75D26B973;
	Thu, 28 May 2026 19:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998389; cv=none; b=PfJ1XivyUz/Geb4w6Kyk0HhBbAzYRoeFzhCpvk+0E/oPzLwn/q8cMgAkI+eJJstQ/kn+mPyuXSRUrkcz0M+UBw0JwW80BcPzCLdP0R/sivqjhlp6CQEaSIHz4nUrQ+/sKn4c2/yo8qvGhrhH/TplnOPHAHW4ixP64T3a8gDT/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998389; c=relaxed/simple;
	bh=jgxvKA+XebcK+C2UA/2EvdzNmtuLOy6r4bWmLOZn6po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P61/aR1yhASVIL9AkZrHSbSRY93J3UgLK2OoQyvJCKHtBq809yyFEqOpEFCrDoZ97k0EoF5WGL+JMcz2Y4t+YJyqtCTgsws2DE4HSMQVjm4rP/KE73r6aBgoQmKJsrHC+zJ3mE6isvQDzib/b9PidiQyA8WzMHFWbXy+j2N50jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN83IyZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN83IyZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1804A1F000E9;
	Thu, 28 May 2026 19:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998388;
	bh=zqkd87z4iPSJBWL60MiiZC2Yv5c1OhE7PIkUk8yH5Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vN83IyZhclzLyq2Xkh02vL7/2O5gydzFbuQpTlmNGIz6AO9Qen6VbARhZrI2OlHrT
	 xiuCFf02zbq249zW9izJ486efT+cMTcP/YicCLSMuSa4xRl40vJzYJjs5VWKj3TG8D
	 QFg9C0dkLQI9EYMnL7FabsXVDDvKuqDAtCn0uu/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing7171@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.0 119/461] mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()
Date: Thu, 28 May 2026 21:44:08 +0200
Message-ID: <20260528194650.422956318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Wang <wangqing7171@gmail.com>

commit 67ea9d353d0ba12bdbc9183ff568dead9e949b80 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    2 ++
 mm/slub.c        |    1 +
 2 files changed, 3 insertions(+)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2110,7 +2110,9 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
 	if (cache_has_sheaves(s)) {
+		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
+		cpus_read_unlock();
 		rcu_barrier();
 	}
 
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4038,6 +4038,7 @@ void flush_rcu_sheaves_on_cache(struct k
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
 
 	for_each_online_cpu(cpu) {


