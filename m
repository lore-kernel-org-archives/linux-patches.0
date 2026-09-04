Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ECF30C160;
	Fri,  4 Sep 2026 05:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498423; cv=none; b=KUxH4kPyWZMVRbjxyW++U4qKb55w0hrjx2T+w4tOqk+u4pOLusUZwty3QrvBGPEQRC9YqZbkxri1/2FWM26NZtnOXJuc5wtKPmWisAYMjvp8niozh1bCuPpkVuub/GU5ecmW0bnk8zj44BX3mEx21V1eG8vL5w2QeFsOtue+Ik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498423; c=relaxed/simple;
	bh=uOqT4mEPXzA34DriRn5hn/wxDxmNir6vUWWv+6lzMXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFLBtUCGsN9iVIj6dpF/g7/hMyTo+Pc3QD6c4m2n4H8KIjXyDuY34G3RaSZrbM30bJqJFO16caJaGlN214XyI/D4gm0tr+MsK0ibUYml6k2qFS/ucCSaZgEPLTYJbK6hkmLJ5VuSGDwIn39LWFW4SGdc9HlvjyGI0DWiZx4TEX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzM1bQs8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzM1bQs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113241F00A3D;
	Fri,  4 Sep 2026 05:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498422;
	bh=dXcqX7ImAmN7gc0OUXvmYsxKlEZjcAvvDzwHBAN70I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzM1bQs8geUVphax/LZj8A0Stm2NuuXmZEReY5skzaqMzE83xNSi1P8VqoslcWHcp
	 Se4okJ+e2CG8iQk93cUO56pUhbH4Wm6ZSD5krk8cJ884yAOz3GkxEdNVF/zpynXknu
	 tKaoLKq8FSXPEgSQsrFR73GXa9fV2tQ8/7vg+//U=
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
Subject: [PATCH 7.2 057/713] mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()
Date: Fri,  4 Sep 2026 06:50:25 +0200
Message-ID: <20260904045805.115466699@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1830,7 +1830,7 @@ static int migrate_pages_batch(struct li
 			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 
 			/*
 			 * The rare folio on the deferred split list should


