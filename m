Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E754A2F0C74;
	Fri,  7 Aug 2026 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115169; cv=none; b=T1K+2zom68Q9afUyhRyGw5gADKZftSPL2SWb9JxmPH3/XbiJTycEetDSpPQPysoLLf23YW/5QCpOttM18q7lndpQ2gqUdwDjtSS9phDlr8sFqzJsMuL6AGR0pvNUuj4tfN6VlXJMvBfFOnIpcsJGKB4tu+cJtKB0xyzm+n8d0kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115169; c=relaxed/simple;
	bh=CvsaiMj8G0uv1/s3fTtiO7AoaM7CgIs8640kqoQiqaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWiYuxlLvv5iUOOO5lZowzHUtOi8BECMSi95+bfBFsbCzWJpbX54jb7bVZ/btoE/3gCbwsoVy7Q/QNjse/j4Ri2AdqQvdo1CMVEPzeD/AP0Vcp5UqrwQ3E342LSfy5hhLOTUsHG1qbYdl4+aDg7BxGDwWQI2XXbZgYTMelQwV0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8Fl/DoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8Fl/DoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A6A1F000E9;
	Fri,  7 Aug 2026 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115163;
	bh=1J7Mdi+KaifXRnVvxuY3IrBo7Xn5EEdHKFT0nQopIXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8Fl/DoPg/wO/gExq8v71PjJpzpKVF0aQA+hEzi///O1iMkqNxkvT+Wt9hRQEU54T
	 90aw7bze1a9HoXuMDyngyxTrQodKDA7Myo2n9yuwanvhKkXt0x8m6Zdv8PXrSjX8iE
	 lVoPLscESRfAO7ljCFIRFlBsXNq15HZ685H/cbRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/396] riscv: mm: Fix out-of-bounds page-table walk during memory hot-remove
Date: Fri,  7 Aug 2026 16:35:03 +0200
Message-ID: <20260807143427.394318386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a0188cc133696627857d16054e43f9ebc7efc821 ]

remove_pud_mapping() and remove_p4d_mapping() obtain a child table base
with pud_offset(p4dp, 0) and p4d_offset(pgd, 0), then add the index for
addr.

RISC-V folds page-table levels at runtime. When a level is folded, its
offset helper returns the parent entry itself, but the index can still be
nonzero. Adding it walks past the parent table. Sv48 folds P4D, while Sv39
folds both P4D and PUD, so memory hot-remove can descend into unrelated
memory and pass an invalid page to __free_pages(). This can trigger:

  kernel BUG at include/linux/mm.h:1810!
  VM_BUG_ON_PAGE(page_ref_count(page) == 0)
  arch_remove_memory+0x1e/0x5c
  try_remove_memory+0x15e/0x200
  remove_memory+0x24/0x3c

Only add the index when the corresponding page-table level is enabled,
matching p4d_offset() and pud_offset().

Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260729012132.24882-1-kmehltretter@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index ee40ca01ac663..557bf160b503a 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1738,7 +1738,7 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 
 	for (; addr < end; addr = next) {
 		next = pud_addr_end(addr, end);
-		pudp = pud_base + pud_index(addr);
+		pudp = pgtable_l4_enabled ? pud_base + pud_index(addr) : pud_base;
 		pud = pudp_get(pudp);
 		if (!pud_present(pud))
 			continue;
@@ -1769,7 +1769,7 @@ static void __meminit remove_p4d_mapping(p4d_t *p4d_base, unsigned long addr, un
 
 	for (; addr < end; addr = next) {
 		next = p4d_addr_end(addr, end);
-		p4dp = p4d_base + p4d_index(addr);
+		p4dp = pgtable_l5_enabled ? p4d_base + p4d_index(addr) : p4d_base;
 		p4d = p4dp_get(p4dp);
 		if (!p4d_present(p4d))
 			continue;
-- 
2.53.0



