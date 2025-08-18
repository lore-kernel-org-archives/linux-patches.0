Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F1333EB0D;
	Mon, 18 Aug 2025 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526399; cv=none; b=s1ONRf9nnXvOWh/wDbrTWk6IA9pjkMN1Q0q31fUHIiR0LFnnu/6ebqLioepAHUMhdjqwmqKriEHJM6F2n68J4iKbKER13u19PQms8OmqEw+6T/AP0MRwoUx68oclG8S/awBtigYYrfbhVek7oOM2F2tbs3FZV7y2QKl9Vho0g3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526399; c=relaxed/simple;
	bh=PlYqzt+IX4CrnScvEnN4gp6KJhhJrcxuiHYBSe83d4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT62obzJz+SxdNYYlwAuegzOHwZu/IVR6QcV+GATSlz6+1W5M4jXQpThYM0OaLKzm8cCta6N/wCQ+/mZeapZwDWtEiqX6CDND0OeG6B9HJhzmspVKVBdVkMkhJOnRVRPmC14E2u6sEmacAdieeUi40EHmKeIrWuJ7fQXTpEnlcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+7yubD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+7yubD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F6CC4CEF1;
	Mon, 18 Aug 2025 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526399;
	bh=PlYqzt+IX4CrnScvEnN4gp6KJhhJrcxuiHYBSe83d4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+7yubD6sUC6UNaQ3h54Q1F06hLYLRgZsLRBf5tPj0afpgLgjR42CV9jmnCAQkjok
	 BixH+dJyMW6ozN/KoMPlwwjYc6XZOk9Nkt5Ebi9KhH+kV46bTWRv04RmBm7Sc9p+Wi
	 dle4aV/P2ExcE873Z8pb2cmS40zOmNe7hwoVXbPo=
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
Subject: [PATCH 6.16 544/570] mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()
Date: Mon, 18 Aug 2025 14:48:51 +0200
Message-ID: <20250818124526.830577239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -413,9 +412,7 @@ bool ptdump_check_wx(void)
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	get_online_mems();
 	ptdump_walk(m, m->private);
-	put_online_mems();
 
 	return 0;
 }
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -247,11 +247,9 @@ static int ptdump_show(struct seq_file *
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
@@ -175,6 +175,7 @@ void ptdump_walk_pgd(struct ptdump_state
 {
 	const struct ptdump_range *range = st->range;
 
+	get_online_mems();
 	mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
@@ -182,6 +183,7 @@ void ptdump_walk_pgd(struct ptdump_state
 		range++;
 	}
 	mmap_write_unlock(mm);
+	put_online_mems();
 
 	/* Flush out the last page */
 	st->note_page_flush(st);


