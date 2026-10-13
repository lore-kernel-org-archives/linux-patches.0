Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605524EB864;
	Tue, 13 Oct 2026 11:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892142; cv=none; b=R9SzIdE4J8NEj3uL4cyOO43Mk0qMakHanzZnnMHt3/Jb8VIJe+K7XwtTu+k4ebZXCK/21hNmohrNgJ2arHHaUxrkMjmM+b/O+SR01LhCHspE/v7HAheNzi7wBmqYZffm8/dvfFnIdAHEYs8eM+JMetrPJBC+k7ztJ1xOHAmMHPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892142; c=relaxed/simple;
	bh=OdRkimAe/e91vhQn/HgrdHoYLiN4UbUjafI+CJJDKvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYRGrXndbePpyQWsOq8iivSrlxS4A/iRi65lZu1QvQDLP26ss+awPtfmVlIfKL6BPgAPXz88Bprh9JT4tztIvhsU9S8bys/7quJNPy1s5F0s5ur2KxLkaw9z3+t6Vj54mOveTsaiP1ziiMSHWdC705EC8wlyVKQRBuw47JEnt20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVDvEIEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVDvEIEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C91B1F000FF;
	Tue, 13 Oct 2026 11:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892141;
	bh=8dolBQ8kpDoUTRHAtBi1Rnqd/KlNUwPLAWbgtoCA7vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVDvEIEBM0baswdODkCCsFUU3YAs8obWVS7whYV6NIAmUQa8uerbX+ExbFRuT5svV
	 r+zpsGPJr4JsDPXr3KapKbcIoVgqM+AJlUYDvN3dhFg3Rri+jFvXMtgtcICo6Qopz+
	 Lf/B0DYGpeicaAJwT5C73MVl/AoLNFIkDECA9Ics=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 072/281] mm: dont schedule deferred kernel page table freeing while booting
Date: Tue, 13 Oct 2026 13:36:28 +0200
Message-ID: <20261013112856.876543592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit 2fb552b0bee70c24c092720028ab4620f5eb2646 upstream.

Booting with a boot-time function tracer and a filter, for example

  ftrace=function ftrace_filter=pud_free_pmd_page

panics on 7.3-rc4 as soon as the tracer starts:

  [   23.531178] Starting tracer 'function'
  [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
  [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
  [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
  [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
  [   25.981629] Call Trace:
  [   26.125727]  <TASK>
  [   26.413912]  ? pagetable_free_kernel+0x20/0x120
  [   26.990283]  queue_work_on+0x97/0xf0
  [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
  [   27.566662]  cpa_flush+0x394/0x620
  [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
  [   29.151729]  set_memory_rox+0xa2/0xf0
  [   29.584018]  create_trampoline+0x431/0x6f0
  ...
  [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!

The boot-time tracer is started from early_trace_init(), which runs
before workqueue_init_early().  Making its trampoline read-only splits a
large page, and CPA collapses it again right away.  The split table has
been a kernel page table since commit 9e4a3ec3411b
("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
collapse frees it through pagetable_free_kernel(), which queues work on
system_percpu_wq - still NULL at that point.  That commit is correct in
itself; it only lets CPA reach pagetable_free_kernel() before the
workqueue that function relies on exists.

Keep putting the table on the list, but don't schedule the work while
the system is still booting.  A core_initcall schedules it once to free
whatever was queued by then.

Link: https://lore.kernel.org/20260925050647.86913-1-mikhail.v.gavrilov@gmail.com
Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/pgtable-generic.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -438,12 +438,30 @@ static void kernel_pgtable_work_func(str
 		__pagetable_free(pt);
 }
 
+static void schedule_kernel_pgtable_free(void)
+{
+	schedule_work(&kernel_pgtable_work.work);
+}
+
 void pagetable_free_kernel(struct ptdesc *pt)
 {
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);
 
-	schedule_work(&kernel_pgtable_work.work);
+	/*
+	 * The workqueue may not exist yet while the system is booting.
+	 * kernel_pgtable_drain_early() schedules the work once it does.
+	 */
+	if (system_state != SYSTEM_BOOTING)
+		schedule_kernel_pgtable_free();
+}
+
+static int __init kernel_pgtable_drain_early(void)
+{
+	/* Free the kernel page tables queued while booting. */
+	schedule_kernel_pgtable_free();
+	return 0;
 }
+core_initcall(kernel_pgtable_drain_early);
 #endif


