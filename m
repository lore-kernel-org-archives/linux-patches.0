Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691E2ED168;
	Thu,  3 Jul 2025 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554495; cv=none; b=IGoXyperGB+zV9rVJF85eqxypF1NtXOR8YVscTUYH+5fuFbcEHDm93bNF9emUTM2oN7HFssQKeszXmlGqdL61Q3iTgwFnUehiwmdNzPq7QxuJ9ctQpmCooZE3K9scHD1r4Po0KZD+GSjif733UwhGCvRAqKfzBBp4WhmkYU7ivg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554495; c=relaxed/simple;
	bh=ArhFnrChxQDwvSlRvD+sJCPhe1tDG5d/vXrhCZ5QJsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVc8JYIMJ6bDJBzhHsJHP9fipkeAxR6YaxcdMsyIAEujbB5/URvSPHlOIYgq82IFFxnbSBXX/JKmol1vx4HWVELtG6W3cOn87ieBXczhYyOP5z5U1oJZiv/ku4I9th05EG/M7nBtKenct3uut0buzwatmJArMxT3fWU0dgJJzR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ei/sLT9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ei/sLT9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A795C4CEE3;
	Thu,  3 Jul 2025 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554494;
	bh=ArhFnrChxQDwvSlRvD+sJCPhe1tDG5d/vXrhCZ5QJsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ei/sLT9eC2t+kBCToyhZfki/SYWlNoiog8+UXGRjU/vSkpq/s9kAp5HMVDT2pWynm
	 GTej5KHYFFPnU5YcWUQ0D8GOiCBYMJkniOYUL4AbYFbqTHNld2h7ePeEXlUXn0uOM6
	 hHINJtRuiiQP4AEqh9hzOwiZtRw9jREhyrX83aWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/218] LoongArch: Set hugetlb mmap base address aligned with pmd size
Date: Thu,  3 Jul 2025 16:42:34 +0200
Message-ID: <20250703144004.457285463@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 3109d5ff484b7bc7b955f166974c6776d91f247b ]

With ltp test case "testcases/bin/hugefork02", there is a dmesg error
report message such as:

 kernel BUG at mm/hugetlb.c:5550!
 Oops - BUG[#1]:
 CPU: 0 UID: 0 PID: 1517 Comm: hugefork02 Not tainted 6.14.0-rc2+ #241
 Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 2/2/2022
 pc 90000000004eaf1c ra 9000000000485538 tp 900000010edbc000 sp 900000010edbf940
 a0 900000010edbfb00 a1 9000000108d20280 a2 00007fffe9474000 a3 00007ffff3474000
 a4 0000000000000000 a5 0000000000000003 a6 00000000003cadd3 a7 0000000000000000
 t0 0000000001ffffff t1 0000000001474000 t2 900000010ecd7900 t3 00007fffe9474000
 t4 00007fffe9474000 t5 0000000000000040 t6 900000010edbfb00 t7 0000000000000001
 t8 0000000000000005 u0 90000000004849d0 s9 900000010edbfa00 s0 9000000108d20280
 s1 00007fffe9474000 s2 0000000002000000 s3 9000000108d20280 s4 9000000002b38b10
 s5 900000010edbfb00 s6 00007ffff3474000 s7 0000000000000406 s8 900000010edbfa08
    ra: 9000000000485538 unmap_vmas+0x130/0x218
   ERA: 90000000004eaf1c __unmap_hugepage_range+0x6f4/0x7d0
  PRMD: 00000004 (PPLV0 +PIE -PWE)
  EUEN: 00000007 (+FPE +SXE +ASXE -BTE)
  ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
 ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
 PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
 Process hugefork02 (pid: 1517, threadinfo=00000000a670eaf4, task=000000007a95fc64)
 Call Trace:
 [<90000000004eaf1c>] __unmap_hugepage_range+0x6f4/0x7d0
 [<9000000000485534>] unmap_vmas+0x12c/0x218
 [<9000000000494068>] exit_mmap+0xe0/0x308
 [<900000000025fdc4>] mmput+0x74/0x180
 [<900000000026a284>] do_exit+0x294/0x898
 [<900000000026aa30>] do_group_exit+0x30/0x98
 [<900000000027bed4>] get_signal+0x83c/0x868
 [<90000000002457b4>] arch_do_signal_or_restart+0x54/0xfa0
 [<90000000015795e8>] irqentry_exit_to_user_mode+0xb8/0x138
 [<90000000002572d0>] tlb_do_page_fault_1+0x114/0x1b4

The problem is that base address allocated from hugetlbfs is not aligned
with pmd size. Here add a checking for hugetlbfs and align base address
with pmd size. After this patch the test case "testcases/bin/hugefork02"
passes to run.

This is similar to the commit 7f24cbc9c4d42db8a3c8484d1 ("mm/mmap: teach
generic_get_unmapped_area{_topdown} to handle hugetlb mappings").

Cc: stable@vger.kernel.org  # 6.13+
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/mmap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/mm/mmap.c b/arch/loongarch/mm/mmap.c
index 914e82ff3f656..1df9e99582cc6 100644
--- a/arch/loongarch/mm/mmap.c
+++ b/arch/loongarch/mm/mmap.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
  */
 #include <linux/export.h>
+#include <linux/hugetlb.h>
 #include <linux/io.h>
 #include <linux/kfence.h>
 #include <linux/memblock.h>
@@ -63,8 +64,11 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 	}
 
 	info.length = len;
-	info.align_mask = do_color_align ? (PAGE_MASK & SHM_ALIGN_MASK) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_color_align ? (PAGE_MASK & SHM_ALIGN_MASK) : 0;
 
 	if (dir == DOWN) {
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-- 
2.39.5



