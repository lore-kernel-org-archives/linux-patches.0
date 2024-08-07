Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA7523CE;
	Wed,  7 Aug 2024 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042907; cv=none; b=DgugNpqcwd5W9zNbAwyWZMhu4jyihxWYKAxGp/r5yNVdgnSWq7VWh1bdZnQE8/PFZgvNJLBSBWGaFRrfdHuFwk2il5BGCLTL0r7Ta6Bx19ee8dTyG7YSEmZ21LD04ib8N293FTbTEA7EDdqIw4gHC/h2Abym1ZlXliCwgqjMras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042907; c=relaxed/simple;
	bh=o1V+Bn9vaIrgFQPudjbIvxGZL0mE69OvzlU+cbqc5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FimRN4OWLANSVgZfuwXDRsdl8ec9mAmbkdxOZHZd2TmlQK+fFMCG8xFKaWOL6R6OzcxePWEHKUTPiMYsuMzE3GxMqR+fSSC8LkLarncCwsSCjYGF+yeo1hryUajfvs2htl1YF+5jeNZepgFFFwlYT4ZeP4yO/JjNtu6CGjKGBJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIbsdirW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIbsdirW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D67C32781;
	Wed,  7 Aug 2024 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042907;
	bh=o1V+Bn9vaIrgFQPudjbIvxGZL0mE69OvzlU+cbqc5/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIbsdirWvV0Wlz1OYvlEPWbc4NQDXJ7+hy7shPC+xDqd0h2HXYbHLGv2MM+XP/hDI
	 7BzTTNFYe2qMJ8YnmTyWvPEtoLMz61I3ptjXX5rmIVr8y/vTJ/UA1vIaA1UALliM7u
	 rMffexfpPkOMlrTZbU7B5dSP/skajtm/joPMgE6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lance Yang <ioworker0@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 002/123] mm: fix khugepaged activation policy
Date: Wed,  7 Aug 2024 16:58:41 +0200
Message-ID: <20240807150020.868570577@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 00f58104202c472e487f0866fbd38832523fd4f9 ]

Since the introduction of mTHP, the docuementation has stated that
khugepaged would be enabled when any mTHP size is enabled, and disabled
when all mTHP sizes are disabled.  There are 2 problems with this; 1.
this is not what was implemented by the code and 2.  this is not the
desirable behavior.

Desirable behavior is for khugepaged to be enabled when any PMD-sized THP
is enabled, anon or file.  (Note that file THP is still controlled by the
top-level control so we must always consider that, as well as the PMD-size
mTHP control for anon).  khugepaged only supports collapsing to PMD-sized
THP so there is no value in enabling it when PMD-sized THP is disabled.
So let's change the code and documentation to reflect this policy.

Further, per-size enabled control modification events were not previously
forwarded to khugepaged to give it an opportunity to start or stop.
Consequently the following was resulting in khugepaged eroneously not
being activated:

  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  echo always > /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled

[ryan.roberts@arm.com: v3]
  Link: https://lkml.kernel.org/r/20240705102849.2479686-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240705102849.2479686-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240704091051.2411934-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Closes: https://lore.kernel.org/linux-mm/7a0bbe69-1e3d-4263-b206-da007791a5c4@redhat.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/mm/transhuge.rst | 11 ++++----
 include/linux/huge_mm.h                    | 12 --------
 mm/huge_memory.c                           |  7 +++++
 mm/khugepaged.c                            | 33 +++++++++++++++++-----
 4 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index d414d3f5592a8..1f901de208bca 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -202,12 +202,11 @@ PMD-mappable transparent hugepage::
 
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
-khugepaged will be automatically started when one or more hugepage
-sizes are enabled (either by directly setting "always" or "madvise",
-or by setting "inherit" while the top-level enabled is set to "always"
-or "madvise"), and it'll be automatically shutdown when the last
-hugepage size is disabled (either by directly setting "never", or by
-setting "inherit" while the top-level enabled is set to "never").
+khugepaged will be automatically started when PMD-sized THP is enabled
+(either of the per-size anon control or the top-level control are set
+to "always" or "madvise"), and it'll be automatically shutdown when
+PMD-sized THP is disabled (when both the per-size anon control and the
+top-level control are "never")
 
 Khugepaged controls
 -------------------
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71945cf4c7a8d..d73c7d89d27b9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -132,18 +132,6 @@ static inline bool hugepage_global_always(void)
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
-static inline bool hugepage_flags_enabled(void)
-{
-	/*
-	 * We cover both the anon and the file-backed case here; we must return
-	 * true if globally enabled, even when all anon sizes are set to never.
-	 * So we don't need to look at huge_anon_orders_inherit.
-	 */
-	return hugepage_global_enabled() ||
-	       READ_ONCE(huge_anon_orders_always) ||
-	       READ_ONCE(huge_anon_orders_madvise);
-}
-
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 374a0d54b08df..e234954cf5067 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -517,6 +517,13 @@ static ssize_t thpsize_enabled_store(struct kobject *kobj,
 	} else
 		ret = -EINVAL;
 
+	if (ret > 0) {
+		int err;
+
+		err = start_stop_khugepaged();
+		if (err)
+			ret = err;
+	}
 	return ret;
 }
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 774a97e6e2da3..92ecd59fffd41 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -416,6 +416,26 @@ static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 	       test_bit(MMF_DISABLE_THP, &mm->flags);
 }
 
+static bool hugepage_pmd_enabled(void)
+{
+	/*
+	 * We cover both the anon and the file-backed case here; file-backed
+	 * hugepages, when configured in, are determined by the global control.
+	 * Anon pmd-sized hugepages are determined by the pmd-size control.
+	 */
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+	    hugepage_global_enabled())
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 void __khugepaged_enter(struct mm_struct *mm)
 {
 	struct khugepaged_mm_slot *mm_slot;
@@ -452,7 +472,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
-	    hugepage_flags_enabled()) {
+	    hugepage_pmd_enabled()) {
 		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
 					    PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
@@ -2465,8 +2485,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) &&
-		hugepage_flags_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2539,7 +2558,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_flags_enabled())
+	if (hugepage_pmd_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2570,7 +2589,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_flags_enabled()) {
+	if (!hugepage_pmd_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2620,7 +2639,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_flags_enabled()) {
+	if (hugepage_pmd_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2646,7 +2665,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_flags_enabled() && khugepaged_thread)
+	if (hugepage_pmd_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.43.0



