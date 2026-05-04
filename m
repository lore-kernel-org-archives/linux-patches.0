Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0F33DE458;
	Mon,  4 May 2026 14:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903773; cv=none; b=TbK/ngKMf3tU5ehwebw4TS9ACfLR65JfK1ZI6XSJkl5B6XOritPRIIhnUJHiWc99IERCmAT6fVU/ws/Yh2z/dUrHZScJitrb72mX8HoCcHPjPxgHAo7hbkaxjHkaTxuXemiftJHP5v7VS5BwrI0MjPYKwQrUHlK1Vvmsj/P5kPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903773; c=relaxed/simple;
	bh=vcjF7Zn8S4hdgI9HftRqc9LdKLPksjgUT/EctSd4eIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scjwihni6smpkiRUMQ/G0kAWovYHVme4CIwfOL+nVFaQv8KSk+pwbe9jFpVy/KWWBKM/BaoA2xUbbv0gmsMxdml7STs+CukM7OMuLB2RWioPQNPLfQZDwL8z4oehyo6K5pQkNZAdjRHmkyX8bbpbzkaruid+jzE35KCpnvihs9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYelivcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYelivcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1DEC2BCB8;
	Mon,  4 May 2026 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903773;
	bh=vcjF7Zn8S4hdgI9HftRqc9LdKLPksjgUT/EctSd4eIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYelivcVEo9AqyjTMHRvZXI6sPuhejsOFADxv58ubXpXDxWKfGp07jri5AbRBkHsT
	 D15eA9ZsAHohYQZAj4F4Vf6+iQSBqLa2tQBEp+CuxZoCFQ4zJBZSHSBj64vU4Ohijb
	 W39b0PaqXHtb5haAACdYbidkGicrHNCtyXCYB2Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 024/275] mm: migrate: requeue destination folio on deferred split queue
Date: Mon,  4 May 2026 15:49:24 +0200
Message-ID: <20260504135143.837208988@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Usama Arif <usama.arif@linux.dev>

commit a2e0c0668a3486f96b86c50e02872c8e94fd4f9c upstream.

During folio migration, __folio_migrate_mapping() removes the source folio
from the deferred split queue, but the destination folio is never
re-queued.  This causes underutilized THPs to escape the shrinker after
NUMA migration, since they silently drop off the deferred split list.

Fix this by recording whether the source folio was on the deferred split
queue and its partially mapped state before move_to_new_folio() unqueues
it, and re-queuing the destination folio after a successful migration if
it was.

By the time migrate_folio_move() runs, partially mapped folios without a
pin have already been split by migrate_pages_batch().  So only two cases
remain on the deferred list at this point:
  1. Partially mapped folios with a pin (split failed).
  2. Fully mapped but potentially underused folios.  The recorded
     partially_mapped state is forwarded to deferred_split_folio() so that
     the destination folio is correctly re-queued in both cases.

Because THPs are removed from the deferred_list, THP shinker cannot
split the underutilized THPs in time.  As a result, users will show
less free memory than before.

Link: https://lkml.kernel.org/r/20260312104723.1351321-1-usama.arif@linux.dev
Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1349,6 +1349,8 @@ static int migrate_folio_move(free_folio
 	int rc;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
+	bool src_deferred_split = false;
+	bool src_partially_mapped = false;
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
@@ -1362,6 +1364,12 @@ static int migrate_folio_move(free_folio
 		goto out_unlock_both;
 	}
 
+	if (folio_order(src) > 1 &&
+	    !data_race(list_empty(&src->_deferred_list))) {
+		src_deferred_split = true;
+		src_partially_mapped = folio_test_partially_mapped(src);
+	}
+
 	rc = move_to_new_folio(dst, src, mode);
 	if (rc)
 		goto out;
@@ -1382,6 +1390,15 @@ static int migrate_folio_move(free_folio
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
+	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);


