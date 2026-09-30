Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A942E1E5B9A;
	Wed, 30 Sep 2026 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786762; cv=none; b=a5Dbt9Saq72CQRKuEgjNdZs8Agkw9011EElPIdwqkhsYfdFeCOcVvwq6pP/nb1hwtnHUjx4Jk7amVqjM6lR9gVE589UQM3vkvvgyBKcICCAKRerITLXyRodPqRPfHOR1Jdtj71cbN1vzJGcYoksHLqSmFbJ6DdZxDelv0TTDxwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786762; c=relaxed/simple;
	bh=dCiHLGI6dnthdW/j1BH5sqZCXB+P/5Gbr1YoZw2zooA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSaKSd/igbB9V36nbnrBByv7UfwWnK9fVfOBwjpkpLVQu/z4wf1xc7tFlFDVaOQqZTVpw+ZHso0pXLhb4OIyvxYma4WiUOuN+YfNyrdXd3R2wtt2cpkKlGbiFHXxsRn997cVifrUyygETKo+wPLIUD1XsJ78DGF6CiwINBGOzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lb1xmyl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lb1xmyl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2941F000FF;
	Wed, 30 Sep 2026 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786761;
	bh=VBCvu08Wa5iTMtvxMV7voRk1OsxOk09+5za4TOEuOpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lb1xmyl+ZqAQyBHr2kwE6e4hPibCe98qKDCTki+mOdzUAAXExxz+99DBm6Sch7YsZ
	 MF51ROotHd3xCi42tYgE5S/SC1+CoD7d79c5SXCWfOTM8QhjMWcENMo/a9GIJBspPC
	 2s1BQpBtSLSNA8szmR6gWuiel80YRou8sKg4vxfM=
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
Subject: [PATCH 6.1 931/982] writeback: report a Tasks-RCU quiescent state per cgwb drain pass
Date: Wed, 30 Sep 2026 17:27:47 +0200
Message-ID: <20260930152436.737792039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -694,8 +694,9 @@ static void cleanup_offline_cgwbs_workfn
 			continue;
 
 		spin_unlock_irq(&cgwb_lock);
-		while (cleanup_offline_cgwb(wb))
-			cond_resched();
+		do {
+			cond_resched_tasks_rcu_qs();
+		} while (cleanup_offline_cgwb(wb));
 		spin_lock_irq(&cgwb_lock);
 
 		wb_put(wb);


