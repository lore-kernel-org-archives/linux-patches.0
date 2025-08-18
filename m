Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890941DC997;
	Mon, 18 Aug 2025 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524503; cv=none; b=GPhaWJ06rdqaaLjR0NxlwlxmVHv+SI31X4E1YzTVmeIkGNR1zIeo3qQy+uYtUOyX/qYQ8EnepK28chiR0/YKNyGd73voV4An1AVWcCQmv0b8TnEx4tkda69QkBeY6zSkbWq2j2NzPEE9+W+thJY3rLGQF7LfNxXM6GbYiJBjutg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524503; c=relaxed/simple;
	bh=s0+3h5vupvTfojArTr1oKC9Ck7mRWikjAWMC3mY3A1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcSyijekJr4tlJt2zT6UIhMYvCGazNF4N6wS3RVTzdN4W8IBDn+dFPnDpNDzEDNOXdR8FWvuZJyGcXjjXWhgo0+onCOwGhv1aLvkVHKyUOWJHg/a2+st2Cob27AZH9S+HLP0/nCeUQoYP+1wjV9TNwBhZIzaIL1wXg14FeeEUOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcIlBtkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcIlBtkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D081DC116C6;
	Mon, 18 Aug 2025 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524503;
	bh=s0+3h5vupvTfojArTr1oKC9Ck7mRWikjAWMC3mY3A1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcIlBtknM8DOVZOFnCzi0ZcX8gbHjnjQCzX0+x2t+F6pldjMzvHuDe+7GDKV1tonH
	 oS/zgJXlRJLDolpww6HqHGKFp01UDp/1TB90J0J5yyY1TFjgS44MmqZgSIzZR4Kb6M
	 NuYSNPH5/EvGKrc14T7aQTcnoNZOgMYPlWMr7WOs=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 492/515] mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()
Date: Mon, 18 Aug 2025 14:47:58 +0200
Message-ID: <20250818124517.379068002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 59305202c67fea50378dcad0cc199dbc13a0e99a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/ptdump_debugfs.c |    3 ---
 arch/riscv/mm/ptdump.c         |    3 ---
 arch/s390/mm/dump_pagetables.c |    2 --
 mm/ptdump.c                    |    2 ++
 4 files changed, 2 insertions(+), 8 deletions(-)

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
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -6,7 +6,6 @@
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
-#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 #include <linux/ptdump.h>
 
@@ -371,9 +370,7 @@ bool ptdump_check_wx(void)
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	get_online_mems();
 	ptdump_walk(m, m->private);
-	put_online_mems();
 
 	return 0;
 }
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -205,11 +205,9 @@ static int ptdump_show(struct seq_file *
 		.marker = markers,
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
@@ -153,6 +153,7 @@ void ptdump_walk_pgd(struct ptdump_state
 {
 	const struct ptdump_range *range = st->range;
 
+	get_online_mems();
 	mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
@@ -160,6 +161,7 @@ void ptdump_walk_pgd(struct ptdump_state
 		range++;
 	}
 	mmap_write_unlock(mm);
+	put_online_mems();
 
 	/* Flush out the last page */
 	st->note_page(st, 0, -1, 0);


