Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEA23019A3;
	Tue, 26 Aug 2025 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215042; cv=none; b=U/57v32MMlB4fZ66HnZcqa3hvapZEwIa6v5CiUFuEPAuAdhPmCwyWY9mJhRFkmWBAVctiZgvVVl/1mY8DoVW8UwfqNANtYao9magfoQX3Ye6IcE5pOFjzNlxQDHJwBXcirSPrzOtU7GIGNb/+Yh3UVdE2Qt50gpKvbrolPyDtHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215042; c=relaxed/simple;
	bh=+jyoG6wStOd9X+l2F10eB6Wx0TBSFwAnOcena8YFeuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSeElRAsv48GkxqMtdNXPoh/NR9nHHHFrA6eo49J5LxJX7tdMWkgP15h2j5TDS1So2NEqKMeum78QoWIhkg+Ef1V+sl+PL4RCuy7TcE0+w45qEyslYWZYWc0ZXgK8VnWhmWkyddRcwCIDLH9n9gDuDAjkHraR54CMWJlI/JrQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+YdfRzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+YdfRzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB61C4CEF1;
	Tue, 26 Aug 2025 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215042;
	bh=+jyoG6wStOd9X+l2F10eB6Wx0TBSFwAnOcena8YFeuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+YdfRztQCLK9uMOPqxDaBnCdRXbCSR3a2O5dGuEe7eitnVsYoxPzd9dgX2pOh8ZN
	 L/dHojm8FUwzm/Ceo6GCL6QWRoSQ/iAe6reoOurcyxANkvexrZyL8SPIqr7YDhfVNk
	 Z3TDXB0Li0Bz4oelVGFSeHC5scSE3S4kqbAUXcwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 366/482] mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()
Date: Tue, 26 Aug 2025 13:10:19 +0200
Message-ID: <20250826110939.876525500@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 59305202c67fea50378dcad0cc199dbc13a0e99a ]

Memory hot remove unmaps and tears down various kernel page table regions
as required.  The ptdump code can race with concurrent modifications of
the kernel page tables.  When leaf entries are modified concurrently, the
dump code may log stale or inconsistent information for a VA range, but
this is otherwise not harmful.

But when intermediate levels of kernel page table are freed, the dump code
will continue to use memory that has been freed and potentially
reallocated for another purpose.  In such cases, the ptdump code may
dereference bogus addresses, leading to a number of potential problems.

To avoid the above mentioned race condition, platforms such as arm64,
riscv and s390 take memory hotplug lock, while dumping kernel page table
via the sysfs interface /sys/kernel/debug/kernel_page_tables.

Similar race condition exists while checking for pages that might have
been marked W+X via /sys/kernel/debug/kernel_page_tables/check_wx_pages
which in turn calls ptdump_check_wx().  Instead of solving this race
condition again, let's just move the memory hotplug lock inside generic
ptdump_check_wx() which will benefit both the scenarios.

Drop get_online_mems() and put_online_mems() combination from all existing
platform ptdump code paths.

Link: https://lkml.kernel.org/r/20250620052427.2092093-1-anshuman.khandual@arm.com
Fixes: bbd6ec605c0f ("arm64/mm: Enable memory hot remove")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	[s390]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/ptdump_debugfs.c |    3 ---
 arch/s390/mm/dump_pagetables.c |    2 --
 mm/ptdump.c                    |    2 ++
 3 files changed, 2 insertions(+), 5 deletions(-)

--- a/arch/arm64/mm/ptdump_debugfs.c
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/debugfs.h>
-#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 
 #include <asm/ptdump.h>
@@ -9,9 +8,7 @@ static int ptdump_show(struct seq_file *
 {
 	struct ptdump_info *info = m->private;
 
-	get_online_mems();
 	ptdump_walk(m, info);
-	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptdump);
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -249,11 +249,9 @@ static int ptdump_show(struct seq_file *
 		.marker = address_markers,
 	};
 
-	get_online_mems();
 	mutex_lock(&cpa_mutex);
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 	mutex_unlock(&cpa_mutex);
-	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptdump);
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -152,6 +152,7 @@ void ptdump_walk_pgd(struct ptdump_state
 {
 	const struct ptdump_range *range = st->range;
 
+	get_online_mems();
 	mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
@@ -159,6 +160,7 @@ void ptdump_walk_pgd(struct ptdump_state
 		range++;
 	}
 	mmap_write_unlock(mm);
+	put_online_mems();
 
 	/* Flush out the last page */
 	st->note_page(st, 0, -1, 0);


