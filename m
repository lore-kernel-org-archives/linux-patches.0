Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157404CCDC7;
	Fri,  4 Sep 2026 05:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500288; cv=none; b=dK6JUzDrjcvoujLlV5w/hUdPE7w7BZoKLkq1unHwfXmhk+X8QLSQIcYpLi0sEv7r1Z7fSY+ntY5VE4BE0x97zw/WurxG3XAOPxTcn27ULXfLGVpXhMg9pB3xLt3bVUqfP7xl5F2whx+z/DRNQ18UbQjqf3U5wE4HyhleyIQ9Qo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500288; c=relaxed/simple;
	bh=ldEpsdlJzpM9rL2PfnGzGv78VbANPjCfC/F8+bIwLdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rv0PTSdcQe8wFAu9df8AgD3ASR+qQbim/UgUwQYWNaHfKu1wMHhMTiUklSTBCquYuBta683m5n1UdYCjwE2L8D6bcD8MotvTtA4h5pP6H0e8M9lMC+jmfSNVnOvjEKvNoL9biEWoBt6vIujLGGUIsPD+CIXlTJ1YaQftI9VL2G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdyNr2fJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdyNr2fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746311F00A3D;
	Fri,  4 Sep 2026 05:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500287;
	bh=/aDtz6hsh+IgbHrQTj5k1rDSbO4VYjoxptKJZLhetNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdyNr2fJ33mqnfxIiDJkQjiokkEEmP6DI8zHThlX4Q98XI+o/rs53lDV+3Hh8NhN6
	 pEtDOFQDPqS9JO1OpmvuiZzObk+9baNNn0GeFv18v8AW+03SHPGvGWeZ6uYDZjKkOU
	 cDilAPI3EV5bcOZvejcd7Ycioh2gUHgYVS8TKH4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	SJ Park <sj@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 684/713] mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Fri,  4 Sep 2026 07:00:52 +0200
Message-ID: <20260904045819.173255373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3541a2b06ecd78ba333188df04368dcf97273d6a ]

kmemleak_scan() can run for ages on large debug kernels. It was
causing some soft-lockups which I got fixed with commit
3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
stacks") with our beloved cond_resched().

I've got the fix above deployed in the Meta fleet, and now I am seeing:

  INFO: rcu_tasks detected stalls on tasks:
    task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
     scan_block
     scan_gray_list
     kmemleak_scan

and, worse, blocks the callers waiting on that grace period.  Here a BPF
struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
call_rcu_tasks), is stuck long enough to also trip the hung task check:

  INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
     __wait_rcu_gp
     bpf_struct_ops_map_free

Then I've learned that cond_resched() is not an RCU-tasks quiescent
state, so, we need to use stronger primitives.

Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
reports an RCU-tasks quiescent state as it proceeds.

Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
quiescent state for task rcu").

Link: https://lore.kernel.org/20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org
Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted scan_large_block() to the branch’s existing void implementation without interruption propagation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1569,7 +1569,7 @@ static void scan_large_block(void *start
 		next = min(start + MAX_SCAN_SIZE, end);
 		scan_block(start, next, NULL);
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 }
 #endif
@@ -1604,7 +1604,7 @@ static void scan_object(struct kmemleak_
 			scan_block(start, end, object);
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 			if (!(object->flags & OBJECT_ALLOCATED))
 				break;
@@ -1626,7 +1626,7 @@ static void scan_object(struct kmemleak_
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else {
@@ -1654,7 +1654,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1689,7 +1689,7 @@ static void kmemleak_cond_resched(struct
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1734,7 +1734,7 @@ static void kmemleak_scan_task_stacks(vo
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !stop);
 }
 
@@ -1908,7 +1908,7 @@ static void kmemleak_scan(void)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;


