Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D4F1448EF;
	Tue, 23 Apr 2024 21:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908666; cv=none; b=Imjt7ZVyXIGMmEPkFRpLhowJkDPzmRN6iP6XKeZdu1C9HiKBDAAmkZOCZFnGHgO8LdhTuMDRpHhrp6TsMj3iHSj4q8HFAz2688RJ8LLZz/vjJ55BDxfcw/Yocc5qZS2BNLd2YCVQ6TEknMltda0ToDXQumiEZYFZUvzNe2a7TW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908666; c=relaxed/simple;
	bh=4W6FyvICcLJ+EEZf5qHyokIo9IPdgqIKpjjnH0WEwOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ncp+diA/GUHE4yCqTxYjZG7lZYZ7i2MgTU0ZMSF2jbjL8j/HcDe94eInjneABs9bpuOO31QLo1Sm599g7sDQLS3fyK0RC6S1gxGevK1Gywej4taLgLrKJFklb9XM4u9ydFqvzDJFlJMgAft1hKhnWKkub/quZ56zhU8C9d3xW3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nG8OXB2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nG8OXB2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75364C3277B;
	Tue, 23 Apr 2024 21:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908666;
	bh=4W6FyvICcLJ+EEZf5qHyokIo9IPdgqIKpjjnH0WEwOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nG8OXB2v2e/GunOXoZ58fQEwmvVQ6wk8bhIjZ25IMgPX2dCkquutKMhrXjRqoecWm
	 kMsqaK1go73GJ+WpjCO/prAJ7RFWBqW3cBMqbqbK4oRNIyvrCAJrXZt5wnPtHp84d5
	 r5nEQqmU+AMCzjb+zZG2cpSAqQT727QiAuL4TsiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Salvador <osalvador@suse.de>,
	Tony Luck <tony.luck@intel.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 137/158] mm,swapops: update check in is_pfn_swap_entry for hwpoison entries
Date: Tue, 23 Apr 2024 14:39:34 -0700
Message-ID: <20240423213900.151202897@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Salvador <osalvador@suse.de>

commit 07a57a338adb6ec9e766d6a6790f76527f45ceb5 upstream.

Tony reported that the Machine check recovery was broken in v6.9-rc1, as
he was hitting a VM_BUG_ON when injecting uncorrectable memory errors to
DRAM.

After some more digging and debugging on his side, he realized that this
went back to v6.1, with the introduction of 'commit 0d206b5d2e0d
("mm/swap: add swp_offset_pfn() to fetch PFN from swap entry")'.  That
commit, among other things, introduced swp_offset_pfn(), replacing
hwpoison_entry_to_pfn() in its favour.

The patch also introduced a VM_BUG_ON() check for is_pfn_swap_entry(), but
is_pfn_swap_entry() never got updated to cover hwpoison entries, which
means that we would hit the VM_BUG_ON whenever we would call
swp_offset_pfn() for such entries on environments with CONFIG_DEBUG_VM
set.  Fix this by updating the check to cover hwpoison entries as well,
and update the comment while we are it.

Link: https://lkml.kernel.org/r/20240407130537.16977-1-osalvador@suse.de
Fixes: 0d206b5d2e0d ("mm/swap: add swp_offset_pfn() to fetch PFN from swap entry")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Tony Luck <tony.luck@intel.com>
Closes: https://lore.kernel.org/all/Zg8kLSl2yAlA3o5D@agluck-desk3/
Tested-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>	[6.1.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swapops.h |   65 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -390,6 +390,35 @@ static inline bool is_migration_entry_di
 }
 #endif	/* CONFIG_MIGRATION */
 
+#ifdef CONFIG_MEMORY_FAILURE
+
+/*
+ * Support for hardware poisoned pages
+ */
+static inline swp_entry_t make_hwpoison_entry(struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
+}
+
+static inline int is_hwpoison_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_HWPOISON;
+}
+
+#else
+
+static inline swp_entry_t make_hwpoison_entry(struct page *page)
+{
+	return swp_entry(0, 0);
+}
+
+static inline int is_hwpoison_entry(swp_entry_t swp)
+{
+	return 0;
+}
+#endif
+
 typedef unsigned long pte_marker;
 
 #define  PTE_MARKER_UFFD_WP			BIT(0)
@@ -470,8 +499,9 @@ static inline struct page *pfn_swap_entr
 
 /*
  * A pfn swap entry is a special type of swap entry that always has a pfn stored
- * in the swap offset. They are used to represent unaddressable device memory
- * and to restrict access to a page undergoing migration.
+ * in the swap offset. They can either be used to represent unaddressable device
+ * memory, to restrict access to a page undergoing migration or to represent a
+ * pfn which has been hwpoisoned and unmapped.
  */
 static inline bool is_pfn_swap_entry(swp_entry_t entry)
 {
@@ -479,7 +509,7 @@ static inline bool is_pfn_swap_entry(swp
 	BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
 
 	return is_migration_entry(entry) || is_device_private_entry(entry) ||
-	       is_device_exclusive_entry(entry);
+	       is_device_exclusive_entry(entry) || is_hwpoison_entry(entry);
 }
 
 struct page_vma_mapped_walk;
@@ -548,35 +578,6 @@ static inline int is_pmd_migration_entry
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
-#ifdef CONFIG_MEMORY_FAILURE
-
-/*
- * Support for hardware poisoned pages
- */
-static inline swp_entry_t make_hwpoison_entry(struct page *page)
-{
-	BUG_ON(!PageLocked(page));
-	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
-}
-
-static inline int is_hwpoison_entry(swp_entry_t entry)
-{
-	return swp_type(entry) == SWP_HWPOISON;
-}
-
-#else
-
-static inline swp_entry_t make_hwpoison_entry(struct page *page)
-{
-	return swp_entry(0, 0);
-}
-
-static inline int is_hwpoison_entry(swp_entry_t swp)
-{
-	return 0;
-}
-#endif
-
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;


