Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034614;
	b=AsZKfCriU1OokjtWB41yliunp7H+ORzypCvrvJFg7SNf4SVMEXkcidAxmcwNy4Nmd2eb
	 OEvBa+eQlGM2C7vz8pZBwMfgA2kBRB2VhHEleVbCkXCjMQKgcEkjdn7+UTL8cQsU37zxL
	 qkBHcd8+1WG2jZn9IOopPeQyyHdl+eOjB3VRCZ1PShGmG3YIROTJQfu8ZsAUt5f3kyW4d
	 ivNA3ydswuJj3wE0tmvd2/GIvxII2FaSdsvfLzJF3rgueXdLVHmqT7krL22dPl1fLWcUi
	 qxzLp+PnNjxE/jotenGcX/vxPeGrXJVq5tHpqk8GLBuW9S/qCBsFIQ4g8JDQS1X+aSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZWeQipm1RZmxbLiPSD170sehVut24zGWkxd/XEAzjyY=;
	b=0yawTBnVXTRitKDUT5perSnGfLv1KJHeYTVW3kKjtt3+XhNXyAtbvn/rPs/PGwHlnAli
	 Lp4yvFwxl9PUX4AhYjrM/Fm8kitkVE15nLRDLIaD7F1Wl9R/gBfJrgRo9SX/bFHdVfwRx
	 Xhv+5cxg/VFeHvPx5wQER0p7+4nx2Uz7kycV9sLOEYSWxiis0/zTaT9du+DbhttTYtUoP
	 /RpbeGJQblsdCTayJ1eseL+7xJR4MYkWspRihafmGepBCH5c7/WCCqCjDAVPLmjAbpOQQ
	 mkBbyCJ3tdFfLUtYtMTGLky39DY651LRacMD+SrgTpmeAl0p1oS+M/ERy75YOIoE2Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2yob5R3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B865A60A2628;
	Wed, 18 Nov 2026 20:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2yob5R3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166621F000C5;
	Wed, 18 Nov 2026 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034614;
	bh=ZWeQipm1RZmxbLiPSD170sehVut24zGWkxd/XEAzjyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2yob5R3aGqnRhwr/Os1w8JEEm8uS8zNMCDe3hmaD0hPR4z1KtSY4Spi+lxq6o2TB
	 9u4gTpHcHvS0KIVLXpuCsX/5ZtJRReTC7psaP9ejl9+Gd5nbl8ZQwGeYeujIFeCwkK
	 /fPlahCbmmGCtP64iQmd/19QrTS5BmBl7KkWdwFo=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0429/3318] memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done
Date: Wed, 18 Nov 2026 15:17:31 +0100
Message-ID: <20261118150329.485382808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 6b0d1083364fc8e7cc2f7d1f93ee3ee78f4d52f7 ]

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

[ sashal: Replaced the missing mm_flags_test() helper with test_bit() on oom_mm->flags, and kept the older memcg_memory_event() call as context since allow_spinning doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 18b5b8cd7ed20..5ff036cd70bad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2716,6 +2716,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
+	    test_bit(MMF_OOM_SKIP, &current->signal->oom_mm->flags))
+		goto nomem;
+
 	memcg_memory_event(mem_over_limit, MEMCG_MAX);
 	raised_max_event = true;
 
-- 
2.53.0



