Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29AA1E47BA;
	Wed, 19 Feb 2025 08:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954250; cv=none; b=kkCroNKQMYUtnjQnDw0X70n4Q2UNUcx/JH1qRD6NF5JD4Za+otnPkgF20TNZM76BLgcoFuPvqoyr0HcmitizsUKSsmOewVsmad9IfYrauewVdKdBqxY2otC5VqpNM2TK7Vv4b42GZKkCiz1B/ebVUL7T5c3+P4taGEs1bXpzAAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954250; c=relaxed/simple;
	bh=QTdK4mxUbIt8HXDPEvtAZDh+nYUuk/SmddJLSWROOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrjwYBMo+khWOuCJ1QxLHj4MXJzU30perxbMVb57sap46ZH2Y/6Mw8TkbmHHywN6uwWSF4BcWgHkR7+utK3m9USdoXQcy/m1ICR2GaHCTh18frb2RR1CBhlwZVEAsuvsi6aSdEWtmWYgoOc1/METkSSsm7IvguPxlptfXxbeZpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7CWg+Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7CWg+Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3D4C4CED1;
	Wed, 19 Feb 2025 08:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954250;
	bh=QTdK4mxUbIt8HXDPEvtAZDh+nYUuk/SmddJLSWROOXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7CWg+MbIGDwQEobzaFDpVlJk4aEUcmwJ2dq8l9AZhmQTGbJzPAzPaaSbSiF7P85c
	 IB3Y3+s7RKoUKne1+fVfBNb+jvX86F24KzTjLNVLDCkJiEb4S8gPHBN9JIFbHkQHxq
	 /i2IrNT2SXOY74w7SbCSiaqhjQBAaD96pv7KoE0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksym Planeta <maksym@exostellar.io>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 102/274] Grab mm lock before grabbing pt lock
Date: Wed, 19 Feb 2025 09:25:56 +0100
Message-ID: <20250219082613.611331340@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maksym Planeta <maksym@exostellar.io>

[ Upstream commit 6d002348789bc16e9203e9818b7a3688787e3b29 ]

Function xen_pin_page calls xen_pte_lock, which in turn grab page
table lock (ptlock). When locking, xen_pte_lock expect mm->page_table_lock
to be held before grabbing ptlock, but this does not happen when pinning
is caused by xen_mm_pin_all.

This commit addresses lockdep warning below, which shows up when
suspending a Xen VM.

[ 3680.658422] Freezing user space processes
[ 3680.660156] Freezing user space processes completed (elapsed 0.001 seconds)
[ 3680.660182] OOM killer disabled.
[ 3680.660192] Freezing remaining freezable tasks
[ 3680.661485] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[ 3680.685254]
[ 3680.685265] ==================================
[ 3680.685269] WARNING: Nested lock was not taken
[ 3680.685274] 6.12.0+ #16 Tainted: G        W
[ 3680.685279] ----------------------------------
[ 3680.685283] migration/0/19 is trying to lock:
[ 3680.685288] ffff88800bac33c0 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: xen_pin_page+0x175/0x1d0
[ 3680.685303]
[ 3680.685303] but this task is not holding:
[ 3680.685308] init_mm.page_table_lock
[ 3680.685311]
[ 3680.685311] stack backtrace:
[ 3680.685316] CPU: 0 UID: 0 PID: 19 Comm: migration/0 Tainted: G        W          6.12.0+ #16
[ 3680.685324] Tainted: [W]=WARN
[ 3680.685328] Stopper: multi_cpu_stop+0x0/0x120 <- __stop_cpus.constprop.0+0x8c/0xd0
[ 3680.685339] Call Trace:
[ 3680.685344]  <TASK>
[ 3680.685347]  dump_stack_lvl+0x77/0xb0
[ 3680.685356]  __lock_acquire+0x917/0x2310
[ 3680.685364]  lock_acquire+0xce/0x2c0
[ 3680.685369]  ? xen_pin_page+0x175/0x1d0
[ 3680.685373]  _raw_spin_lock_nest_lock+0x2f/0x70
[ 3680.685381]  ? xen_pin_page+0x175/0x1d0
[ 3680.685386]  xen_pin_page+0x175/0x1d0
[ 3680.685390]  ? __pfx_xen_pin_page+0x10/0x10
[ 3680.685394]  __xen_pgd_walk+0x233/0x2c0
[ 3680.685401]  ? stop_one_cpu+0x91/0x100
[ 3680.685405]  __xen_pgd_pin+0x5d/0x250
[ 3680.685410]  xen_mm_pin_all+0x70/0xa0
[ 3680.685415]  xen_pv_pre_suspend+0xf/0x280
[ 3680.685420]  xen_suspend+0x57/0x1a0
[ 3680.685428]  multi_cpu_stop+0x6b/0x120
[ 3680.685432]  ? update_cpumasks_hier+0x7c/0xa60
[ 3680.685439]  ? __pfx_multi_cpu_stop+0x10/0x10
[ 3680.685443]  cpu_stopper_thread+0x8c/0x140
[ 3680.685448]  ? smpboot_thread_fn+0x20/0x1f0
[ 3680.685454]  ? __pfx_smpboot_thread_fn+0x10/0x10
[ 3680.685458]  smpboot_thread_fn+0xed/0x1f0
[ 3680.685462]  kthread+0xde/0x110
[ 3680.685467]  ? __pfx_kthread+0x10/0x10
[ 3680.685471]  ret_from_fork+0x2f/0x50
[ 3680.685478]  ? __pfx_kthread+0x10/0x10
[ 3680.685482]  ret_from_fork_asm+0x1a/0x30
[ 3680.685489]  </TASK>
[ 3680.685491]
[ 3680.685491] other info that might help us debug this:
[ 3680.685497] 1 lock held by migration/0/19:
[ 3680.685500]  #0: ffffffff8284df38 (pgd_lock){+.+.}-{3:3}, at: xen_mm_pin_all+0x14/0xa0
[ 3680.685512]
[ 3680.685512] stack backtrace:
[ 3680.685518] CPU: 0 UID: 0 PID: 19 Comm: migration/0 Tainted: G        W          6.12.0+ #16
[ 3680.685528] Tainted: [W]=WARN
[ 3680.685531] Stopper: multi_cpu_stop+0x0/0x120 <- __stop_cpus.constprop.0+0x8c/0xd0
[ 3680.685538] Call Trace:
[ 3680.685541]  <TASK>
[ 3680.685544]  dump_stack_lvl+0x77/0xb0
[ 3680.685549]  __lock_acquire+0x93c/0x2310
[ 3680.685554]  lock_acquire+0xce/0x2c0
[ 3680.685558]  ? xen_pin_page+0x175/0x1d0
[ 3680.685562]  _raw_spin_lock_nest_lock+0x2f/0x70
[ 3680.685568]  ? xen_pin_page+0x175/0x1d0
[ 3680.685572]  xen_pin_page+0x175/0x1d0
[ 3680.685578]  ? __pfx_xen_pin_page+0x10/0x10
[ 3680.685582]  __xen_pgd_walk+0x233/0x2c0
[ 3680.685588]  ? stop_one_cpu+0x91/0x100
[ 3680.685592]  __xen_pgd_pin+0x5d/0x250
[ 3680.685596]  xen_mm_pin_all+0x70/0xa0
[ 3680.685600]  xen_pv_pre_suspend+0xf/0x280
[ 3680.685607]  xen_suspend+0x57/0x1a0
[ 3680.685611]  multi_cpu_stop+0x6b/0x120
[ 3680.685615]  ? update_cpumasks_hier+0x7c/0xa60
[ 3680.685620]  ? __pfx_multi_cpu_stop+0x10/0x10
[ 3680.685625]  cpu_stopper_thread+0x8c/0x140
[ 3680.685629]  ? smpboot_thread_fn+0x20/0x1f0
[ 3680.685634]  ? __pfx_smpboot_thread_fn+0x10/0x10
[ 3680.685638]  smpboot_thread_fn+0xed/0x1f0
[ 3680.685642]  kthread+0xde/0x110
[ 3680.685645]  ? __pfx_kthread+0x10/0x10
[ 3680.685649]  ret_from_fork+0x2f/0x50
[ 3680.685654]  ? __pfx_kthread+0x10/0x10
[ 3680.685657]  ret_from_fork_asm+0x1a/0x30
[ 3680.685662]  </TASK>
[ 3680.685267] xen:grant_table: Grant tables using version 1 layout
[ 3680.685921] OOM killer enabled.
[ 3680.685934] Restarting tasks ... done.

Signed-off-by: Maksym Planeta <maksym@exostellar.io>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241204103516.3309112-1-maksym@exostellar.io>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/mmu_pv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index ffdf0d299c5d7..d078de2c952b3 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -826,6 +826,7 @@ void xen_mm_pin_all(void)
 {
 	struct page *page;
 
+	spin_lock(&init_mm.page_table_lock);
 	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
@@ -836,6 +837,7 @@ void xen_mm_pin_all(void)
 	}
 
 	spin_unlock(&pgd_lock);
+	spin_unlock(&init_mm.page_table_lock);
 }
 
 static void __init xen_mark_pinned(struct mm_struct *mm, struct page *page,
@@ -935,6 +937,7 @@ void xen_mm_unpin_all(void)
 {
 	struct page *page;
 
+	spin_lock(&init_mm.page_table_lock);
 	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
@@ -946,6 +949,7 @@ void xen_mm_unpin_all(void)
 	}
 
 	spin_unlock(&pgd_lock);
+	spin_unlock(&init_mm.page_table_lock);
 }
 
 static void xen_enter_mmap(struct mm_struct *mm)
-- 
2.39.5



