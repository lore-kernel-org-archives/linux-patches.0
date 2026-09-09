Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB442550DB2;
	Wed,  9 Sep 2026 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963461; cv=none; b=Mi4pjCMiUB69p5qhU8+YJOuiWt3fPmcgYVBokIy3gan67+D+oa833eb8HBL7/QY3tuhdni0mBcCYDHzvX3jUmHdq6mBQRVUn4IH0o9H9Jc5/QggLeG+ag9XXMHbhcJfQL1SK5JoJffV9ajhUtlxop8NRf3DRBgLobH6D/ZYzkCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963461; c=relaxed/simple;
	bh=xH0GLXR23muTVRQmcX7JmoW4a8TDK+MoFyhtzwOYF5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmjToKaSO5y8gU74++Y8kIoj9uyJP2BBN/DAuhjZM2vibq3JNjmt14Kuindcw9GIFpFCH8HDbVVWOFS34LtoweZfhRbwCxnHC9cyiDNGYR9NUMA+578gvzHVm/5ZYn16opX0xP5mw5A8zTRUhqCcMcPAwHrMLYZBplLakjcCqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK4YM9q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK4YM9q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392FA1F00A3A;
	Wed,  9 Sep 2026 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963459;
	bh=x/pm86xDAYb+9VygfXiicJoDusFFztQgsuA8wRYy0XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qK4YM9q7wRdPOQqZkB11RGDGyT/TG3+/YWUWbyn0UYZAkbsBRbUWSXCaMqd4lgNrF
	 u+TupGOzaUcsizDr/Olf4SZePAkKPGu78/gKMWrEitO4fZcjCFw8lLlLJ3f8mUq9Ch
	 utMWYIiBBDOlmSMoF74NTRuf54gpPH1laiSHxF6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 087/583] memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done
Date: Wed,  9 Sep 2026 15:36:12 +0200
Message-ID: <20260909134241.139049369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit 6b0d1083364fc8e7cc2f7d1f93ee3ee78f4d52f7 upstream.

At Meta, we are seeing instances where an OOM killed job is stuck in the
exit path for several hours.  In one particular case, the job was stuck
for more than 8 hours and I had to manually remove the memory.max limits
to allow the process to exit.

The job was a single process job and had ~55 GiB memory.max and zswap
enabled.  It had almost 0 anon in memory and ~111 GiB in zswap compressed
to ~51 GiB zswap pool (i.e.  almost all of memory.current was zswap).
Nothing was left on the LRUs to reclaim.

On further inspection, I observed ~20k threads of that process stuck with
the following stack:

[<0>] mem_cgroup_out_of_memory+0x4e/0xa0
[<0>] charge_memcg+0x8bf/0x990
[<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
[<0>] __read_swap_cache_async+0x10c/0x260
[<0>] swapin_readahead+0x116/0x3f0
[<0>] do_swap_page+0x13c/0x1ce0
[<0>] handle_mm_fault+0x61d/0x11f0
[<0>] do_user_addr_fault+0x3e7/0x6d0
[<0>] exc_page_fault+0x8f/0x110
[<0>] asm_exc_page_fault+0x22/0x30
[<0>] __get_user_8+0x14/0x20
[<0>] futex_cleanup+0x27/0x1c0
[<0>] futex_exit_release+0x47/0x60
[<0>] do_exit+0x107/0x940
[<0>] do_group_exit+0x81/0xa0
[<0>] get_signal+0x2b1/0x6e0
[<0>] arch_do_signal_or_restart+0x1a/0x1c0
[<0>] exit_to_user_mode_loop+0xa8/0x1c0
[<0>] do_syscall_64+0x152/0x250
[<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

In addition the dmesg was filled with "Out of memory and no killable
processes..." messages.

I have no idea why oom reaper was not able to reap/unmap the process.  My
guess is that since oom reaper tries to acquire mmap_lock in read mode
limited number of times and then gives up, there might be a thread of that
process which had mmap_lock in write mode at that time.

My initial suspicion was the futex_cleanup and kernel page fault causing
infinite fault and charge retries but that was put to rest in previous
discussions happened on similar problem [1].

My current theory is that it is just a simple slow serialization behind
the oom_lock.  Unlike page allocator, memcg charge code takes the oom_lock
without the "try".  Though memcg oom code uses mutex_lock_killable(), note
that in the call stack get_signal() consumes SIGKILL (or
sigdelset(SIGKILL)) before calling do_group_exit().  So this
mutex_lock_killable() is just a mutex_lock() here.  Therefore 10s of
thousands of threads are waiting on oom_lock and one by one they get
-EFAULT from get_user() in the futex cleanup code and bails out.

Discussion from [1] led to commit a75ffa26122b ("memcg, oom: do not bypass
oom killer for dying tasks") which routes dying tasks into the OOM path
precisely so the oom_reaper can reap their mm and free the memory
asynchronously.  But the reaper is best-effort and one-shot: if it cannot
take mmap_lock for read (e.g.  a sibling thread holds it for write) it
sets MMF_OOM_SKIP and never retries, leaving only the glacial
oom_lock-serialized synchronous drain.

Once MMF_OOM_SKIP is set there is no more asynchronous reclaim coming for
the mm, so a dying task charging against it has nothing left to wait for:
it frees its memory only once it finishes exiting.  Running reclaim and
the (no-victim) OOM killer for it is then pointless, and doing it for 10s
of thousands of exiting threads is what serializes them behind oom_lock.
So before reclaim, if current is an OOM victim whose reaper is done, fail
the charge.

Reproduced with 20k threads, each parking a robust futex head on its own
zswapped page, OOM-group-killed while a sibling holds mmap_lock for write
so the reaper gives up and sets MMF_OOM_SKIP.  Tested on next-20260728 and
baseline show ~90 seconds exit time while with the patch the exit time
reduced to ~3 seconds.

Link: https://lore.kernel.org/20260729024612.3369005-1-shakeel.butt@linux.dev
Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2352,6 +2352,19 @@ retry:
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and fail the charge to expedite their exit. They are
+	 * considered fully reclaimed by the oom reaper and they shouldn't
+	 * contribute further charges.
+	 */
+	if (tsk_is_oom_victim(current) &&
+	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
+		goto nomem;
+
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 


