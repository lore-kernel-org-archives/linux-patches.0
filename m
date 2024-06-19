Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0012FB31;
	Wed, 19 Jun 2024 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802485; cv=none; b=el58xfJcw9UvNTdNOaXnkB9WHDRYwQ490YvfhBlII1LnV4k+6RgrLelrwuMrE3Nw3vyM3SRAyCxJmemXoKuaw/IwQA3IkaRkR7kM3ZV0O+Z2GqyzEKrdGlP8FlROJht06bOphY2fdCf1f0oivQy2LfC222VSHT1XRHrMJmWcFGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802485; c=relaxed/simple;
	bh=HrbOhwwLFuDo4d64/PpJDDP+fiEJg6dGtUZDEBuWl70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGEgptjv4X7X81dmuV3BfQJet9xpddAi8vajMUTvdNmEJLp0wLx6vJkWOKPFTPPcfd87ChfqZlu3DFrUzciqHOhh0Tmpy0vJwMFZfju7iGEv9Sjn29HPdGXTvUNbBSXIVTSdNhmAucvuTOOUJKxwt6oz5i6TC0WL1ESis7MvI70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pglsfNfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pglsfNfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D16C2BBFC;
	Wed, 19 Jun 2024 13:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802485;
	bh=HrbOhwwLFuDo4d64/PpJDDP+fiEJg6dGtUZDEBuWl70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pglsfNfV9teaVLl33Xmuomv1CB2OfSDYKMMEc7MDoifhRUqGmoOFNyAry99W/MhY6
	 VtbZviXZmfkjo2C9N4M6beyBWNuKec68kl4Z2a5twMUCfaaH5KaIliUn2jLjiwrW2U
	 uu/a9ejjnlpS9E6kj5RcYENgsHBsipPL9G3ZMqj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 212/267] riscv: rewrite __kernel_map_pages() to fix sleeping in invalid context
Date: Wed, 19 Jun 2024 14:56:03 +0200
Message-ID: <20240619125614.463781144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

commit fb1cf0878328fe75d47f0aed0a65b30126fcefc4 upstream.

__kernel_map_pages() is a debug function which clears the valid bit in page
table entry for deallocated pages to detect illegal memory accesses to
freed pages.

This function set/clear the valid bit using __set_memory(). __set_memory()
acquires init_mm's semaphore, and this operation may sleep. This is
problematic, because  __kernel_map_pages() can be called in atomic context,
and thus is illegal to sleep. An example warning that this causes:

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1578
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2, name: kthreadd
preempt_count: 2, expected: 0
CPU: 0 PID: 2 Comm: kthreadd Not tainted 6.9.0-g1d4c6d784ef6 #37
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff800060dc>] dump_backtrace+0x1c/0x24
[<ffffffff8091ef6e>] show_stack+0x2c/0x38
[<ffffffff8092baf8>] dump_stack_lvl+0x5a/0x72
[<ffffffff8092bb24>] dump_stack+0x14/0x1c
[<ffffffff8003b7ac>] __might_resched+0x104/0x10e
[<ffffffff8003b7f4>] __might_sleep+0x3e/0x62
[<ffffffff8093276a>] down_write+0x20/0x72
[<ffffffff8000cf00>] __set_memory+0x82/0x2fa
[<ffffffff8000d324>] __kernel_map_pages+0x5a/0xd4
[<ffffffff80196cca>] __alloc_pages_bulk+0x3b2/0x43a
[<ffffffff8018ee82>] __vmalloc_node_range+0x196/0x6ba
[<ffffffff80011904>] copy_process+0x72c/0x17ec
[<ffffffff80012ab4>] kernel_clone+0x60/0x2fe
[<ffffffff80012f62>] kernel_thread+0x82/0xa0
[<ffffffff8003552c>] kthreadd+0x14a/0x1be
[<ffffffff809357de>] ret_from_fork+0xe/0x1c

Rewrite this function with apply_to_existing_page_range(). It is fine to
not have any locking, because __kernel_map_pages() works with pages being
allocated/deallocated and those pages are not changed by anyone else in the
meantime.

Fixes: 5fde3db5eb02 ("riscv: add ARCH_SUPPORTS_DEBUG_PAGEALLOC support")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/1289ecba9606a19917bc12b6c27da8aa23e1e5ae.1715750938.git.namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/pageattr.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -387,17 +387,33 @@ int set_direct_map_default_noflush(struc
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
+static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
+{
+	int enable = *(int *)data;
+
+	unsigned long val = pte_val(ptep_get(pte));
+
+	if (enable)
+		val |= _PAGE_PRESENT;
+	else
+		val &= ~_PAGE_PRESENT;
+
+	set_pte(pte, __pte(val));
+
+	return 0;
+}
+
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!debug_pagealloc_enabled())
 		return;
 
-	if (enable)
-		__set_memory((unsigned long)page_address(page), numpages,
-			     __pgprot(_PAGE_PRESENT), __pgprot(0));
-	else
-		__set_memory((unsigned long)page_address(page), numpages,
-			     __pgprot(0), __pgprot(_PAGE_PRESENT));
+	unsigned long start = (unsigned long)page_address(page);
+	unsigned long size = PAGE_SIZE * numpages;
+
+	apply_to_existing_page_range(&init_mm, start, size, debug_pagealloc_set_page, &enable);
+
+	flush_tlb_kernel_range(start, start + size);
 }
 #endif
 


