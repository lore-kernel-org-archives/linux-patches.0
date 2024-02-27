Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BFA2F2D;
	Tue, 27 Feb 2024 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041509; cv=none; b=g4ZKDtE3tIcMquHOigYCiHbciA0LB20jCNMrThymDu0eOUm9bYSEKNJ6znOi2lMkjH75pGzJvZtXbdP2rtH1m0/hqoPn2tyDVHm9wrYpWrgvNRXFHYFvJdEnUt9N+xc2w5Hhw9SsSuz5Iwzw6wJuemVUK/l+d3HSZTB43WPcNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041509; c=relaxed/simple;
	bh=xn0QEjseChGTpEWqz1yIqczusZo6oOSW6uCaQUBpBrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnaClDY353gmrANo1vacEN1CILZs4hOgJsP0W4HQJd7GwUzWR71AUQOcVloD7Zb7XI40r8HjQMlGSM+zmBWKO+8vptcK8K7+BHx1NsnLS/YtAQ6lyAmkUhdDA2RcXZi2EwaoJaTy8yyZRnNCep0w1xJujqKO61WpapWZNCOcdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J36pvHm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J36pvHm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F384C43394;
	Tue, 27 Feb 2024 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041509;
	bh=xn0QEjseChGTpEWqz1yIqczusZo6oOSW6uCaQUBpBrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J36pvHm6+h20NhzCgw3KLKaJP96o56EtyqzAQU/+XDa3pdxgJNpcD8d3jqnWALs5A
	 6cg+cu07Cq9YLJ/SajibhCpQrq/hFnuI7FA1/Qm5GJiys/YlATkB7jS1BBEGyNoBX9
	 KYiR3MLTlXwIZ2Zg8DHJwo3tD4ac9JmZiDSW474s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Gushchin <guro@fb.com>,
	Michal Hocko <mhocko@suse.com>,
	Hillf Danton <hdanton@sina.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"GONG, Ruiqi" <gongruiqi1@huawei.com>,
	GONG
Subject: [PATCH 4.19 28/52] mm: memcontrol: switch to rcu protection in drain_all_stock()
Date: Tue, 27 Feb 2024 14:26:15 +0100
Message-ID: <20240227131549.456694608@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <guro@fb.com>

commit e1a366be5cb4f849ec4de170d50eebc08bb0af20 upstream.

Commit 72f0184c8a00 ("mm, memcg: remove hotplug locking from try_charge")
introduced css_tryget()/css_put() calls in drain_all_stock(), which are
supposed to protect the target memory cgroup from being released during
the mem_cgroup_is_descendant() call.

However, it's not completely safe.  In theory, memcg can go away between
reading stock->cached pointer and calling css_tryget().

This can happen if drain_all_stock() races with drain_local_stock()
performed on the remote cpu as a result of a work, scheduled by the
previous invocation of drain_all_stock().

The race is a bit theoretical and there are few chances to trigger it, but
the current code looks a bit confusing, so it makes sense to fix it
anyway.  The code looks like as if css_tryget() and css_put() are used to
protect stocks drainage.  It's not necessary because stocked pages are
holding references to the cached cgroup.  And it obviously won't work for
works, scheduled on other cpus.

So, let's read the stock->cached pointer and evaluate the memory cgroup
inside a rcu read section, and get rid of css_tryget()/css_put() calls.

Link: http://lkml.kernel.org/r/20190802192241.3253165-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: cdec2e4265df ("memcg: coalesce charging via percpu storage")
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2094,21 +2094,22 @@ static void drain_all_stock(struct mem_c
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
+		bool flush = false;
 
+		rcu_read_lock();
 		memcg = stock->cached;
-		if (!memcg || !stock->nr_pages || !css_tryget(&memcg->css))
-			continue;
-		if (!mem_cgroup_is_descendant(memcg, root_memcg)) {
-			css_put(&memcg->css);
-			continue;
-		}
-		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
+		if (memcg && stock->nr_pages &&
+		    mem_cgroup_is_descendant(memcg, root_memcg))
+			flush = true;
+		rcu_read_unlock();
+
+		if (flush &&
+		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
 			if (cpu == curcpu)
 				drain_local_stock(&stock->work);
 			else
 				schedule_work_on(cpu, &stock->work);
 		}
-		css_put(&memcg->css);
 	}
 	put_cpu();
 	mutex_unlock(&percpu_charge_mutex);


