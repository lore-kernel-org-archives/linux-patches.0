Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5654EFFA9;
	Thu, 17 Sep 2026 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660809; cv=none; b=EAoattCj5yicOvDNFj7Tw99/BkSfcmnV0/+ctGxP1BF0x/ViTWMaUDgyHses1vdxlpIi/wl5PXMmtiG5jzuTqVKfaQwP0XWHKzrbQmMPBexNZ0O1F604mXFwGHDnC+8MGGgqC2A3WsTtBffYHay0CSRaeAqSNMIxfQc5JSioQJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660809; c=relaxed/simple;
	bh=Y6Pi7kByVCzenIFI7FOEUvVOKcjMMn1XCraodaYAGNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO1LBWYnAo0yYN1jawcJVO8kWH5OgYHJKzz6KcKn3ZTeFnGXSyorybcFBfq2/Kg5o/YZ38nqCqzLtPoBIhhZrf4t8YoEzbNWiFaCwKAJmnwxKiAhnGxwYGovZrvXmoeBA7428HFa8N+7dtEDaMfL6Xiz900gu4j63KQ7/ZnuvC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n12Rfj18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n12Rfj18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFAC1F000FF;
	Thu, 17 Sep 2026 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660808;
	bh=ug2Z9NCANCmP5hFQyF9PpM36eWIEGlEkb86FeiU9B5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n12Rfj18lCa+Wl/IGcAxoWIcVxHsZJSXxur+YTgLEe8DLYBvmNqC6ryXY6jS1pcLQ
	 gUquleC6eKtxO7rWZ8nRl9Ax2LE0ZuMKkDR+Xeb9Yuuuk/x1mKjDrqZOkz6Aip7CAK
	 CMOZVPB3pdLTi9vxGUccHRMX41hb3gm681PHmbK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Atish Patra <atishp@meta.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 716/733] x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF
Date: Thu, 17 Sep 2026 16:17:04 +0100
Message-ID: <20260917151410.764031297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

[ Upstream commit d5d8b8662e6e5a565b47a0388640e88402f23274 ]

A previous commit protected against races between ptdump and CPA collapse,
however one still exists between attribute changes and collapse as reported
by Denis V. Lunev (linked).

When an attribute change arises, a lockless page table walker obtains a PTE
entry, which is later written to via set_pte_atomic():

  ...
  -> change_page_attr_set_clr()
  -> __change_page_attr_set_clr()
  -> __change_page_attr()
	-> _lookup_address_cpa()
	-> lookup_address_in_pgd_attr()
	-> [ lockless page table walker ]
  -> set_pte_atomic()

There is nothing preventing a concurrent CPA collapse which can free the
PTE that was retrieved here, resulting in a use-after-free.

With the mmap write lock taken on init_mm over CPA collapse, resolve this
race by acquiring an mmap read lock on init_mm over
__change_page_attr_set_clr().

This locks across the whole operation over which the walk and the PTE
entry write occurs, solving the race.

It is safe to do this here, as no spinlocks are held upon entry to
__change_page_attr_set_clr().

However, the lock must not be held over an allocation, as allocation can
trigger reclaim and shrinkers may call into CPA recursively, making
deadlocks possible (init_mm -> ... -> fs_reclaim -> init_mm).

A page table is allocated when a huge page needs to be split:

  -> change_page_attr_set_clr()
  -> __change_page_attr_set_clr()
  -> __change_page_attr()
  -> split_large_page()
  [ pagetable_alloc() ]
  -> __split_large_page()

Avoid deadlocks by dropping the mmap lock across pagetable_alloc() in
split_large_page() and track whether this is needed by adding a new
'init_mm_read_locked' flag to struct cpa_data.

This is safe as __split_large_page() (called with locks re-established)
revalidates that the page table entry is the same as it was prior to the
locks being dropped and __change_page_attr() repeats the entire page table
walk whenever a split occurs, so concurrent split and collapse are
accounted for.

Concurrent ptdump is also safe as the lock is only dropped over page table
allocation during which time the page table has not yet been modified.

The CPA_COLLAPSE flag is only set by set_memory_rox(), which exclusively
operates upon vmalloc ranges, and on x86 only within the module mapping
space.

This is important, because some callers directly invoke
__change_page_attr_set_clr(), bypassing this lock. However, none of these
operate within the module mapping space.

  * cpa_process_alias() - a recursive helper called by
    __change_page_attr_set_clr().
  * __set_memory_enc_pgtable() - operates on the direct mapping and (via
    __vmbus_establish_gpadl()) the vmalloc mapping space.
  * __set_pages_[n]p() - called by set_direct_map_[invalid, default,
    valid]_noflush(), __kernel_map_pages() - operates on the direct map.
  * kernel_[un]map_pages_in_pgd() - operates on EFI ranges.

This work is based upon Denis V. Lunev's excellent analysis of the bug
with gratitude.

[ dhansen: move to imperative voice in changelog ]

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Atish Patra <atishp@meta.com>
Tested-by: Nikunj A Dadhania <nikunj@amd.com>
Link: https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org/
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260813-cpa-fixes-v2-2-39b4ff90f91d@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -50,7 +50,8 @@ struct cpa_data {
 	unsigned int	flags;
 	unsigned int	force_split		: 1,
 			force_static_prot	: 1,
-			force_flush_all		: 1;
+			force_flush_all		: 1,
+			init_mm_read_locked	: 1;
 	struct page	**pages;
 };
 
@@ -1254,7 +1255,11 @@ static int split_large_page(struct cpa_d
 	struct ptdesc *ptdesc;
 
 	spin_unlock(&cpa_lock);
+	if (cpa->init_mm_read_locked)
+		mmap_read_unlock(&init_mm);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (cpa->init_mm_read_locked)
+		mmap_read_lock(&init_mm);
 	spin_lock(&cpa_lock);
 	if (!ptdesc)
 		return -ENOMEM;
@@ -2123,7 +2128,11 @@ static int change_page_attr_set_clr(unsi
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	ret = __change_page_attr_set_clr(&cpa, 1);
+	/* Avoid race with concurrent CPA collapse. */
+	cpa.init_mm_read_locked = true;
+	scoped_guard(mmap_read_lock, &init_mm)
+		ret = __change_page_attr_set_clr(&cpa, 1);
+	cpa.init_mm_read_locked = false;
 
 	/*
 	 * Check whether we really changed something:


