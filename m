Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4686453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC27C340EC;
	Tue, 22 Mar 2022 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985479;
	bh=ZvOSrd3ZmpmUC3b9SxlsCcPdesA004qet5FVbPnbosk=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=IuUJKBgQSK/bDVYL2hGQn9my63DEkCF/dugsqgLIpL//0vhd5oIqmEPvBIEhYNO+a
	 wBUvUPT/JEJSdEVdyX1ZNYP0R5GEahHBjN+el7UEvFu1MXBvTqV++AJ/GJuiS1fCf8
	 bq+oSvrWNayjGZ35fuztoUg8gsDNJQOaf+wiEdIM=
Date: Tue, 22 Mar 2022 14:44:38 -0700
To: tony.luck@intel.com,tglx@linutronix.de,naoya.horiguchi@nec.com,mingo@redhat.com,linmiaohe@huawei.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@suse.de,luofei@unicloud.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 121/227] mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler
Message-Id: <20220322214439.8DC27C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: luofei <luofei@unicloud.com>
Subject: mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler

When the hwpoison page meets the filter conditions, it should not be
regarded as successful memory_failure() processing for mce handler, but
should return a distinct value, otherwise mce handler regards the error
page has been identified and isolated, which may lead to calling
set_mce_nospec() to change page attribute, etc.

Here memory_failure() return -EOPNOTSUPP to indicate that the error event
is filtered, mce handler should not take any action for this situation and
hwpoison injector should treat as correct.

Link: https://lkml.kernel.org/r/20220223082135.2769649-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/core.c |    8 +++++---
 drivers/base/memory.c          |    2 ++
 mm/hwpoison-inject.c           |    3 ++-
 mm/madvise.c                   |    2 ++
 mm/memory-failure.c            |    9 +++++++--
 5 files changed, 18 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -1304,10 +1304,12 @@ static void kill_me_maybe(struct callbac
 
 	/*
 	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
-	 * to the current process with the proper error info, so no need to
-	 * send SIGBUS here again.
+	 * to the current process with the proper error info,
+	 * -EOPNOTSUPP means hwpoison_filter() filtered the error event,
+	 *
+	 * In both cases, no further processing is required.
 	 */
-	if (ret == -EHWPOISON)
+	if (ret == -EHWPOISON || ret == -EOPNOTSUPP)
 		return;
 
 	pr_err("Memory error not recovered");
--- a/drivers/base/memory.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/drivers/base/memory.c
@@ -555,6 +555,8 @@ static ssize_t hard_offline_page_store(s
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
 	ret = memory_failure(pfn, 0);
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
 	return ret ? ret : count;
 }
 
--- a/mm/hwpoison-inject.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/hwpoison-inject.c
@@ -48,7 +48,8 @@ static int hwpoison_inject(void *data, u
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	return memory_failure(pfn, 0);
+	err = memory_failure(pfn, 0);
+	return (err == -EOPNOTSUPP) ? 0 : err;
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
--- a/mm/madvise.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/madvise.c
@@ -1067,6 +1067,8 @@ static int madvise_inject_error(int beha
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
 			ret = memory_failure(pfn, MF_COUNT_INCREASED);
+			if (ret == -EOPNOTSUPP)
+				ret = 0;
 		}
 
 		if (ret)
--- a/mm/memory-failure.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/memory-failure.c
@@ -1515,7 +1515,7 @@ static int memory_failure_hugetlb(unsign
 				if (TestClearPageHWPoison(head))
 					num_poisoned_pages_dec();
 				unlock_page(head);
-				return 0;
+				return -EOPNOTSUPP;
 			}
 			unlock_page(head);
 			res = MF_FAILED;
@@ -1602,7 +1602,7 @@ static int memory_failure_dev_pagemap(un
 		goto out;
 
 	if (hwpoison_filter(page)) {
-		rc = 0;
+		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
 
@@ -1671,6 +1671,10 @@ static DEFINE_MUTEX(mf_mutex);
  *
  * Must run in process context (e.g. a work queue) with interrupts
  * enabled and no spinlocks hold.
+ *
+ * Return: 0 for successfully handled the memory error,
+ *         -EOPNOTSUPP for memory_filter() filtered the error event,
+ *         < 0(except -EOPNOTSUPP) on failure.
  */
 int memory_failure(unsigned long pfn, int flags)
 {
@@ -1836,6 +1840,7 @@ try_again:
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
+		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
_
