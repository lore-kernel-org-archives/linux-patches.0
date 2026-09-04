Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D815834A3A5;
	Fri,  4 Sep 2026 05:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501021; cv=none; b=K4y4USsWXvtwDX9PXg177NZ5D+iyiXTK3fKrpus1OYbm05mqtAuCTlPRMUUPioqRVmpTWMOyTMIH80zF5Vqod3RExDlr5a9ALk2FG78p8jZNdVhfEo3YgwsxsSX06AaFaSW2889r8fpY3YcY0KiiTq6OSgVue0xNej0mKVy4UDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501021; c=relaxed/simple;
	bh=OlF2Nsv6QtXkHCkyBz4Djlrek2BPTHKC8M4zndcecyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwPDIqtPvT3dCl+CYgta/lwY5QK22TK2B0s23SfVe27FZuiUsHGkYFw63FA1xPqUlymxbbHuPxFUpd1AvOT5CvKq/doObwOOyCuLEiKMw1m8UImEtoYfXoM2Yam4CNbFHcuqRboDSHnr07q6KJ4TcG9v/n+6gSHXq3kiyc13fJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xktWUOGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xktWUOGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470D31F00A3E;
	Fri,  4 Sep 2026 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501019;
	bh=ypu/R6uV9RIUCV1Ehua/nvovBJN3qbpzzTsswUPknsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xktWUOGmueZLWPkvywK3L/c2cLIvSle613f/mht8/CpZ/scVKudtly1KUTO3mqzCO
	 zaZM1Zohli821Sip6LFFzVB7pEUO2wQB27XwS17vJJMasOcVPwxnvBJ7Gp7Yydl7Rm
	 qIDeP59ZYfEbPCERNiOv6WxMmXD3kh+N/DmSruf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	"Zhang, Qiang1" <qiang1.zhang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 255/552] kasan: fix cache shrink race with CPU hotplug
Date: Fri,  4 Sep 2026 06:56:52 +0200
Message-ID: <20260904045755.499785818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

commit 8790303cbaac52a11dfed4aab261f8ea60682525 upstream.

kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
all online CPUs.  Each callback moves objects belonging to the cache from
cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
from task context.

kmem_cache_destroy() invokes the quarantine removal path while holding
cpus_read_lock(), but kmem_cache_shrink() does not.  The latter can
therefore race with CPU offlining as follows:

  kmem_cache_shrink()             CPU hotplug
  -------------------             -----------
  on_each_cpu()
    CPU1 moves objects to
    CPU1's shrink_qlist
  on_each_cpu() returns
                                  CPU1 goes offline
                                  kasan_cpu_offline()
                                    drains cpu_quarantine
                                    leaves shrink_qlist untouched
  for_each_online_cpu()
    skips CPU1

The objects left on CPU1's shrink_qlist are not returned to the slab
allocator.  This may prevent kmem_cache_shrink() from releasing slabs that
would otherwise become empty.  If CPU1 remains offline, a later
kmem_cache_destroy() also skips the list and can report that the cache
still contains objects.

An intermittent occurrence was observed with a virtio-9p filesystem.  The
mount and umount commands both returned 0, but the kernel logged the
following during the userspace-triggered teardown:

  [  2994.380134][  T111] BUG 9p-fcall-cache-1 (Tainted: G    B              ): Objects remaining on __kmem_cache_shutdown()
  [  2994.381140][  T111] Object 0xff11000004361118 @offset=4376
  [  2994.381607][  T111] Allocated in p9_fcall_init+0x201/0x400 age=19564 cpu=1 pid=104
  [  2994.382591][  T111]  p9_fcall_init+0x201/0x400
  [  2994.382810][  T111]  p9_tag_alloc+0x12f/0x700
  [  2994.382982][  T111]  p9_client_prepare_req+0x102/0x3e0
  [  2994.383165][  T111]  p9_client_rpc+0x1ab/0xa50
  [  2994.383334][  T111]  p9_client_getattr_dotl+0xb0/0x1a0
  [  2994.383515][  T111]  v9fs_vfs_getattr_dotl+0x115/0x360
  [  2994.383719][  T111]  vfs_getattr_nosec+0x22c/0x3a0
  [  2994.383910][  T111]  vfs_statx+0xd7/0x170
  [  2994.384062][  T111]  vfs_fstatat+0x45/0x80
  [  2994.384215][  T111]  __do_sys_newfstatat+0x84/0xe0
  [  2994.384386][  T111]  do_syscall_64+0x115/0x6a0
  [  2994.384566][  T111]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [  2994.399720][  T111] WARNING: mm/slub.c:1244 at __kmem_cache_shutdown+0x363/0x500, CPU#0: busybox/111
  [  2994.405655][  T111] Call Trace:
  [  2994.406325][  T111]  kmem_cache_destroy+0x73/0x1b0
  [  2994.406630][  T111]  p9_client_destroy+0x271/0x3c0
  [  2994.407210][  T111]  v9fs_session_close+0x3c/0x260
  [  2994.407409][  T111]  v9fs_kill_super+0x48/0x90
  [  2994.407584][  T111]  deactivate_locked_super+0xa3/0x160
  [  2994.407778][  T111]  cleanup_mnt+0x1dd/0x3e0

Thus, a successful umount left objects in the 9p fcall cache and prevented
the cache from being destroyed cleanly.

Per-CPU shrink_qlist storage exists for every possible CPU, and each list
is protected by its own raw spinlock.  Iterate over possible CPUs so that
a list populated before its CPU went offline is drained as well.

for_each_possible_cpu() can do more work than for_each_online_cpu(), but
this change only affects CONFIG_KASAN_GENERIC kernels.  The extra work is
limited to cache shrink and cache destruction paths and does not affect
the normal allocation/free fast path.  It adds one raw-spinlock-protected
scan of each possible CPU's shrink list.  These lists are normally empty;
a non-empty list is traversed to remove objects belonging to the cache
being shrunk or destroyed.

Link: https://lore.kernel.org/20260808031459.3032812-1-sh_def@163.com
Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: "Zhang, Qiang1" <qiang1.zhang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/quarantine.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -355,7 +355,12 @@ void kasan_quarantine_remove_cache(struc
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
-	for_each_online_cpu(cpu) {
+	/*
+	 * A CPU can go offline after on_each_cpu() returns, leaving cache
+	 * objects on that CPU's shrink list. Scan all possible CPUs to
+	 * drain those lists.
+	 */
+	for_each_possible_cpu(cpu) {
 		sq = per_cpu_ptr(&shrink_qlist, cpu);
 		raw_spin_lock_irqsave(&sq->lock, flags);
 		qlist_move_cache(&sq->qlist, &to_free, cache);


