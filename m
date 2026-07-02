Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9256A1FA859;
	Thu,  2 Jul 2026 17:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011673; cv=none; b=uhwldAOz3QN7h4pzR6ADeLsOHPxMcE5SIbTK+hzTcRwMd4IRoChRtb7Srz20M5jAqgvC9KcLurIiExC2RtF5w/FptLegsurOgW4Hze0hTIwXSsqbW95kwg+KLfvVDH6fU86hWuSOWmjvwLisFQ2dg8+oJnBKZu2RSYj/JrrphZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011673; c=relaxed/simple;
	bh=fXNi37Eo1X39Ae9CvcMnXe7rvsPVIG/Fk6VI9s++19Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjGsdr5CS0m+y/4dQoYSOfU1ldV/1wTACxqVM6EP7v4bkwGt+81SS6IXeSWFuxTpw+qxC2jJAU5u7ayFSPfPT1k7s56iCUKp7W8Gm1Fcj4auO5rmjPPROK6Dn6P0OkRmNuQE7aIn04N/MR7h9Z33iN+f/vy1/pXomE/sSMkMwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UJE1pEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UJE1pEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0466F1F00A3A;
	Thu,  2 Jul 2026 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011672;
	bh=k73HxcFZMWiHFNVj7jviBTUx1U4uODxZhNVHwavlOXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UJE1pEVIyVN1VYKT13JQJQ0adQv+F6lZYvi33tfu22BJKWmtOzRVh5I81aiXPc7N
	 +3vKdp1DvnJAIqf0NgTbfxNWsUkjHfdasUR/f9erGcIit6baUS2evy0eko7Kmiteot
	 8sk/sDdEQQNpFnZnxjv6VfinXxjfLFrG8NDjOYLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 7.1 087/120] sched/mmcid: Fix OOB clear_bit when CID is MM_CID_UNSET in fixup path
Date: Thu,  2 Jul 2026 18:21:23 +0200
Message-ID: <20260702155114.760632648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit de3ab9bd3133899efb92e4cd05ba4203e58fc0a3 upstream.

In mm_cid_fixup_cpus_to_tasks(), when rq->curr has the target mm and
mm_cid.active is set, the CID is checked with cid_in_transit() before
setting the transition bit.  In per-CPU mode a newly forked or exec'd
task can be running with mm_cid.cid == MM_CID_UNSET because CIDs are
assigned lazily on schedule-in.  With cid_in_transit() the guard passes
for MM_CID_UNSET (no transit bit), converts it to MM_CID_UNSET |
MM_CID_TRANSIT and stores it back; later mm_cid_schedout() feeds this
to clear_bit() with MM_CID_UNSET as the bit number, triggering an
out-of-bounds write.

Symptoms: this is genuine memory corruption, but a bounded out-of-bounds
write, not an arbitrary one.  MM_CID_UNSET is the fixed sentinel BIT(31),
so once the bad value reaches mm_cid_schedout() the cid_from_transit_cid()
strip leaves MM_CID_UNSET, which fails the "cid < max_cids" convergence
test and falls into mm_drop_cid() -> clear_bit(MM_CID_UNSET,
mm_cidmask(mm)).  The cid bitmap is embedded in the mm_struct slab object
(after cpu_bitmap and mm_cpus_allowed) and is only num_possible_cpus()
bits wide, so clearing bit 31 is a deterministic OOB bit-clear at a
fixed offset of 2^31 / 8 == 256 MiB past the bitmap base.  The address is
not attacker-influenced (fixed sentinel -> fixed offset) and the op only
clears a single bit; what sits 256 MiB further along the direct map is
whatever kernel object happens to live there, so this corrupts one bit of
unpredictable kernel memory -- it is not an arbitrary-address or
arbitrary-value write.

It triggers only in per-CPU CID mode, when a CPU is running an active
task of the target mm whose cid is still MM_CID_UNSET -- the
fork()/execve() window before that task's next schedule-in assigns it a
real CID -- and a per-CPU -> per-task fixup walks over it (the mode
fallback driven by a thread exit, sched_mm_cid_exit(), or by the deferred
max_cids recompute in mm_cid_work_fn()).

In practice syzkaller surfaced it as a KASAN use-after-free reported in
__schedule -> mm_cid_switch_to, where the offending clear_bit() is inlined
via mm_cid_schedout() -> mm_drop_cid().

Guard the transition-bit assignment against MM_CID_UNSET, in addition to
the existing cid_in_transit() check, so the bit is only set on a genuine
task-owned CID.  A CPU-owned (MM_CID_ONCPU) CID of a running active task
is handled by the cid_on_cpu(pcp->cid) branch above and never reaches
this path, so excluding MM_CID_UNSET (and the already-transitioning case)
is sufficient.

Fixes: fbd0e71dc370 ("sched/mmcid: Provide CID ownership mode fixup functions")
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: Claude:claude-opus-4-8 syzkaller
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616203818.1516263-1-riel@surriel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10880,8 +10880,19 @@ static void mm_cid_fixup_cpus_to_tasks(s
 		} else if (rq->curr->mm == mm && rq->curr->mm_cid.active) {
 			unsigned int cid = rq->curr->mm_cid.cid;
 
-			/* Ensure it has the transition bit set */
-			if (!cid_in_transit(cid)) {
+			/*
+			 * Set the transition bit only on a genuine task-owned
+			 * CID. A running active task can legitimately have
+			 * MM_CID_UNSET here: in per-CPU mode CIDs are assigned
+			 * lazily on schedule-in, so the fork()/execve() window
+			 * leaves the task active with no owned CID. Setting the
+			 * transition bit on MM_CID_UNSET would later feed
+			 * clear_bit() an out-of-bounds bit number via
+			 * mm_cid_schedout(), so exclude it. A CPU-owned
+			 * (MM_CID_ONCPU) CID is handled by the cid_on_cpu()
+			 * branch above and never reaches here.
+			 */
+			if (cid != MM_CID_UNSET && !cid_in_transit(cid)) {
 				cid = cid_to_transit_cid(cid);
 				rq->curr->mm_cid.cid = cid;
 				pcp->cid = cid;


