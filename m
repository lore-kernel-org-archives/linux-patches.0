Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A84F96CB;
	Thu, 17 Sep 2026 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666220; cv=none; b=A4HfyzpU2ddP72Kd3aKsa0080ndpyApnEx2hUe63wGOGuqvD2WPqLJt8mVdtyMOUpLSbYL8gPPndKM43V5m3vyfHpDqpRO5GnClZRzwiF0E0Z8J90ow4/LvjJ6rnQf8Biy2OlQf+u6L/8UA51G/hMrjuezsP6iLl2f3iNzt5tGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666220; c=relaxed/simple;
	bh=BS64pgMvombB+WwN7d11jsdj0NyL1cCx+M45yElQnUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIZgxF5fY0/wnhI9XsytvAJujFcu14fax+R0ZRxjinQ0id+KDdv1h4pv2M5pjRXI5bEaIN3CiHo0KCqKyAutNMekjLoWyTJfAdTT8TVbCnDB1txGXZzddtbkdvGN5anKJBCZZsDMJNeJ+7K3vq3vKCLEzsLhLB/ZiXjIQ8KPPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2sSWMP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2sSWMP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8991F000FF;
	Thu, 17 Sep 2026 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666218;
	bh=V4tVZfw55v+mZ1fMauv8dv4AnndlbCD94hHLXELRTR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2sSWMP3AbmjkJR/JpBvPqAegEuWjY75+cdXZtFvERLbwbnPzISfs89btEySIo6S7
	 bBUjtwvImfSQM2B7U/NJz3ysutU/wOVD+PPLMtFSAyE+gF/VkkRZD3vR61uwjnzqBm
	 xvRhn9I+hQkCPVZMRnqG8nJWlGVpPI+rzHtFNQkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Steffen Dirkwinkel <lists@steffen.cc>,
	Pedro Falcato <pfalcato@suse.de>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Atish Patra <atishp@meta.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH 6.18 0964/1250] x86/alternatives: Exclude text poking against change_page_attr()
Date: Thu, 17 Sep 2026 16:12:39 +0100
Message-ID: <20260917151618.144847237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Pedro Falcato <pfalcato@suse.de>

commit 1587d3394e254639cc36516256031334095e6ef3 upstream.

>From time to time, the following BUG can be observed
in the x86 alternatives patching code [0]:

  > kernel BUG at arch/x86/kernel/alternative.c:2576!
  > Oops: invalid opcode: 0000 [#1] SMP NOPTI
  > CPU: 0 UID: 0 PID: 355 Comm: (udev-worker) Not tainted 7.1.3-1-default #1 PREEMPT(full) openSUSE Tumbleweed  8c1795b03ec64f997e57a8ad38b1161e3b98da64
  > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 02/02/2022
  > RIP: 0010:__text_poke+0x2aa/0x450
  > Call Trace:
  >  <TASK>
  >  smp_text_poke_batch_finish+0x2a7/0x320
  >  __static_call_transform+0xb7/0x220
  >  arch_static_call_transform+0x5b/0xb0
  >  __static_call_init+0xe9/0x270
  >  static_call_module_notify+0x11f/0x150
  >  notifier_call_chain+0x61/0xe0
  >  blocking_notifier_call_chain_robust+0x63/0xc0
  >  load_module+0x1c92/0x20c0
  >  init_module_from_file+0xd8/0x140
  >  idempotent_init_module+0x100/0x2f0
  >  __x64_sys_finit_module+0x71/0xe0
  >  do_syscall_64+0xe1/0x610
  >  entry_SYSCALL_64_after_hwframe+0x76/0x7e

which matches the following BUG_ON() in alternative.c:

	/*
	 * If something went wrong, crash and burn since recovery paths are not
	 * implemented.
	 */
	BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));

This can happen if vmalloc_to_page() fails, for any reason. Such can happen
if text poking races with CPA, which can possibly result in the collapsing
of page tables (or breaking of PMD hugepages). It is not a problem for most
users of vmalloc_to_page() (they solely own the vmalloc'd range) but, when
CONFIG_ARCH_HAS_EXECMEM_ROX=y, various modules own a single execmem vmalloc
range, and can call set_memory_*() in parallel on it. This can happen to
race against __text_poke and cause havoc in vmalloc_to_page().

Fix it by excluding against CPA using the init_mm mmap read lock.

[ dhansen: Fix up SoB ordering. The actual code flow here was:
	   Pedro=>Lorenzo=>Mike=>Me which is reflected in the SoB chain
	   now. I *believe* Mike simply picked up Lorenzo's update to
	   Pedro's post from the Link ]

Fixes: 64f6a4e10c05 ("x86: re-enable EXECMEM_ROX support")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Steffen Dirkwinkel <lists@steffen.cc>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Co-developed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Atish Patra <atishp@meta.com>
Tested-by: Nikunj A Dadhania <nikunj@amd.com>
Cc: stable@vger.kernel.org
Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1271202 [0]
Link: https://lore.kernel.org/linux-mm/555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc/
Link: https://patch.msgid.link/20260813-cpa-fixes-v2-3-39b4ff90f91d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -6,6 +6,9 @@
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 #include <linux/execmem.h>
+#include <linux/cleanup.h>
+#include <linux/kgdb.h>
+#include <linux/mmap_lock.h>
 
 #include <asm/text-patching.h>
 #include <asm/insn.h>
@@ -2502,6 +2505,38 @@ static void text_poke_memset(void *dst,
 
 typedef void text_poke_f(void *dst, const void *src, size_t len);
 
+static void __poke_vmalloc_pages(struct page **pages, void *addr,
+				 bool cross_page_boundary)
+{
+	pages[0] = vmalloc_to_page(addr);
+	if (cross_page_boundary)
+		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
+}
+
+static void poke_vmalloc_pages(struct page **pages, void *addr,
+			       bool cross_page_boundary)
+{
+	if (in_dbg_master()) {
+		/*
+		 * If called from kgdb cannot sleep, but all other CPUs stopped
+		 * anyway so safe to proceed without locks
+		 */
+		__poke_vmalloc_pages(pages, addr, cross_page_boundary);
+	} else {
+		/*
+		 * execmem ROX ranges are shared between modules and can be
+		 * collapsed to huge PMD entries, and this collapse can happen
+		 * concurrently with a racing set_memory_rox().
+		 *
+		 * Prevent vmalloc_to_page() from racing by acquiring an
+		 * init_mm read lock which pairs with the init_mm write lock in
+		 * cpa_collapse_large_pages().
+		 */
+		guard(mmap_read_lock)(&init_mm);
+		__poke_vmalloc_pages(pages, addr, cross_page_boundary);
+	}
+}
+
 static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t len)
 {
 	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
@@ -2519,9 +2554,7 @@ static void *__text_poke(text_poke_f fun
 	BUG_ON(!after_bootmem);
 
 	if (!core_kernel_text((unsigned long)addr)) {
-		pages[0] = vmalloc_to_page(addr);
-		if (cross_page_boundary)
-			pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
+		poke_vmalloc_pages(pages, addr, cross_page_boundary);
 	} else {
 		pages[0] = virt_to_page(addr);
 		WARN_ON(!PageReserved(pages[0]));


