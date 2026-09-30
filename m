Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF3547142F;
	Wed, 30 Sep 2026 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797093; cv=none; b=EwSNqWAwQ4A7IIuto/RjU9/JK9+iBjK4iO4I8TeqyPvN68lamvjsg4SdHM6Qn3plagnbjpAShkfabqcsTFdV0iJfkbkP6z3GruHuutmIUmCqc1GyCXfg9Kkqn4HYMW802y7HiRFUBiJeer5ejTUCT5mT3W2l1VZlAJkFRKOQqWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797093; c=relaxed/simple;
	bh=UX+Gt+OrS6lKkWNyhGUga5PvQql6F8caghL6diHvnvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meCVobf1rdk7KZzenZ0whdGOACmgK3db6rn+Y9atZsiuizy/oSrdWS2qi0nIn+kiWXsFMEel9ytV6Q0l6YH981yBKakT+Qq+EBG6g2FkbcR4Vet1/h5mYa1AIa8LQqigMLQMyW1i6dzFZHxMPit2kzx61hmnczxO9atde9/lGD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ywDEfvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ywDEfvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88F61F000FF;
	Wed, 30 Sep 2026 19:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797091;
	bh=Ll6CUIgO5+Bmc715vdJpW47yWDSTRnP8El8E24Jcj5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ywDEfvAwIHKGvlddlhzmYnLfKmza2CT7FcGHGf/xEVQFDHnsBEZPlSW+fri8rH0q
	 ePGmoqjST2tsXrw6KNzatvlECY24XdLHds/kdK/3NvNbQgN+kIOqJjDsp8LmTSJ+d8
	 VDJL4Y1xNPUVn1IspsAef9D0jPUPbBRI1YkJAu5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jan Kara <jack@suse.cz>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH 6.6 1099/1193] writeback: report a Tasks-RCU quiescent state per cgwb drain pass
Date: Wed, 30 Sep 2026 17:29:43 +0200
Message-ID: <20260930152458.650528385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 407a5d205179a4ab186571b0e16ec42725dc77bc upstream.

cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
cleanup_offline_cgwb() until it returns false, with a cond_resched()
between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
nothing: _cond_resched() is a plain "return 0", and under PREEMPT_DYNAMIC
the full and lazy modes disable it.  Since commit 7dadeaa6e851 ("sched:
Further restrict the preemption modes") those are the only two models on
the architectures with PREEMPT_LAZY support, arm64 and x86 among them, so
the drain loop never reports a Tasks-RCU quiescent state.

A worker draining a cgwb with millions of attached inodes runs for
minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
dying cgroup's writeback domain for over 11 minutes.  A BPF program unlink
(bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
waited on that grace period while holding the trampoline mutex, 42 tasks
queued behind it in D state, and the hung task detector fired at 614 s and
panicked the host.  Any BPF or ftrace detach during a long drain inherits
the drain's length.

Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
loop because if we have many small cgroups cleanup_offline_cgwb() will
return false and we will never call cond_resched_tasks_rcu_qs(), creating
the same problem.

Link: https://lore.kernel.org/20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com
Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
Assisted-by: LLM
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/backing-dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -821,8 +821,9 @@ static void cleanup_offline_cgwbs_workfn
 			continue;
 
 		spin_unlock_irq(&cgwb_lock);
-		while (cleanup_offline_cgwb(wb))
-			cond_resched();
+		do {
+			cond_resched_tasks_rcu_qs();
+		} while (cleanup_offline_cgwb(wb));
 		spin_lock_irq(&cgwb_lock);
 
 		wb_put(wb);


