Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA01347CC9C;
	Sat, 12 Sep 2026 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219638; cv=none; b=hvHm9w9I0oAktQBVi88jDDLz6xyV7Fnx0EYtZpYWCCLrsfoPMeh8uX13AxbL7cf/OIOByzShY+B9i79OYQKdd/s5pqHFquXYcxnCmMeaex+wtdCu+hP/Z/AjMzegPDlB0kZp8bUI7jbtEiPMpWW72AWz0KHpWY/k5B9duoIOm6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219638; c=relaxed/simple;
	bh=dXSW3wVc2PVccuNLDhnQVtIplDYig6ko1txGE8TVkl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQWRfkyfRdaRYwpm5v/CmjcaDoS9USj/JsQfuHqRhEfI3VBQKD9o6o4iK/dk01kYqrVLER+VGYb3kiQlS0E4Njt2AWfy02U7syQS6yyb3/gGCeGWzvIZeQy3HNIgY4TIReEwTHIeE02yQJIA+J8pQnogc9rTU4k0cCHjOGyp9Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIQ/vj46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIQ/vj46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0E1F000FF;
	Sat, 12 Sep 2026 13:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219636;
	bh=nd1SczQaQpGy+eFn+Y1lA6Bk1xZsNx0xy+0R6RvMbwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIQ/vj46244cCh8aMhJOS3AsgrwPK3dMI3FbKht6RDEeNmCZn/J15yxD77tFWQDQc
	 1zphbtdsPPFCuGNfMvjuwJsf6dtIlNGW9VE13p2+g61FBxNyCgmyLNMY9TttBewBpQ
	 Xy4Ny1QfL+eRAhwhman3wlAA/5py3JqD71kr28fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0015/1424] mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()
Date: Sat, 12 Sep 2026 08:40:47 +0200
Message-ID: <20260912065607.637164096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit efe8f86c0916f0f74eea74ae21a3b37f728c6bad upstream.

migrate_pages_batch() unmaps each folio before moving it, and every
unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
the CPU busy for a long time.

The loop already calls cond_resched(), but on PREEMPTION kernels that is
a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.

A long batch therefore never reports a quiescent state, and the
migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
Tasks-RCU grace period for minutes, which is common at Meta fleet:

  INFO: rcu_tasks detected stalls on tasks:
  0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
  Call Trace:
   tdp_mmu_zap_leafs
   tdp_mmu_next_root
   gfn_to_pfn_cache_invalidate_start
   kvm_mmu_notifier_invalidate_range_start
   __mmu_notifier_invalidate_range_start
   try_to_migrate_one
   try_to_migrate
   migrate_pages_batch
   migrate_pages
   compact_zone
   compact_node
   kcompactd
   kthread

Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
when cond_resched() does nothing.

This has also been discussed at [1]

Link: https://lore.kernel.org/20260727-kcompact-v1-1-bdfefddd6874@debian.org
Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1644,7 +1644,7 @@ static int migrate_pages_batch(struct li
 			is_thp = is_large && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 
 			/*
 			 * Large folio migration might be unsupported or


