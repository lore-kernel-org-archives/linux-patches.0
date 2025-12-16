Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BFC342513;
	Tue, 16 Dec 2025 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884463; cv=none; b=jEEecNY+S80f2FgF/jBK/ULsPTrDAdwuhZL9I0TSeCAQ7oOi3Otx7JGHZtRsWgm5yOmq4mfk3+h2YIOkZtu/0GSh84IZXH7SZgM132AFQKgTjQKPb9c6W78g/IwtkdP25cZ0yZJzNKpKSleiU+RwS1BYL8XXdcgRbX4zhI2B+Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884463; c=relaxed/simple;
	bh=DR8RChKvj5S1zu31xHlgqK/SncfdVBk8sNmGoi7ecLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFIuYwREvGAQ3m6IU1GL5fTrT+/CcZLFHzpggjUSfNZpjnNrQuwXfX1o3cja7mfJ4csCEpchE9PUU1wGygQR09wEhErSRj7agxHZyICzDy3RiB/yFg6z5hPCnbTYWIwZTWy2VhhVVoXBnQ6c70hpX52lTMZ9HKIdMr8V6jLQFyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0G18Oza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0G18Oza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EE8C4CEF1;
	Tue, 16 Dec 2025 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884463;
	bh=DR8RChKvj5S1zu31xHlgqK/SncfdVBk8sNmGoi7ecLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0G18OzaVtxnOViETFQ5m0jMul2r7nhdQgBLqoINTzxX7Fmo0pHDF+nu1TItyXcS+
	 HWNCNH+WBiDiAniF/Dc/7fRA6pYv+xbReox38cmp6+dLa7CCScurMU4vwTqLn+98NQ
	 81sjy+sZEimW5rouzrTmEAX/JXKxCrDr9ttDprJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/354] bpf: Fix invalid prog->stats access when update_effective_progs fails
Date: Tue, 16 Dec 2025 12:12:21 +0100
Message-ID: <20251216111327.217715648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 7dc211c1159d991db609bdf4b0fb9033c04adcbc ]

Syzkaller triggers an invalid memory access issue following fault
injection in update_effective_progs. The issue can be described as
follows:

__cgroup_bpf_detach
  update_effective_progs
    compute_effective_progs
      bpf_prog_array_alloc <-- fault inject
  purge_effective_progs
    /* change to dummy_bpf_prog */
    array->items[index] = &dummy_bpf_prog.prog

---softirq start---
__do_softirq
  ...
    __cgroup_bpf_run_filter_skb
      __bpf_prog_run_save_cb
        bpf_prog_run
          stats = this_cpu_ptr(prog->stats)
          /* invalid memory access */
          flags = u64_stats_update_begin_irqsave(&stats->syncp)
---softirq end---

  static_branch_dec(&cgroup_bpf_enabled_key[atype])

The reason is that fault injection caused update_effective_progs to fail
and then changed the original prog into dummy_bpf_prog.prog in
purge_effective_progs. Then a softirq came, and accessing the members of
dummy_bpf_prog.prog in the softirq triggers invalid mem access.

To fix it, skip updating stats when stats is NULL.

Fixes: 492ecee892c2 ("bpf: enable program stats")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20251115102343.2200727-1-pulehui@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 12 +++++++-----
 kernel/bpf/syscall.c   |  3 +++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9b6908291de7c..a91f2babf4253 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -692,11 +692,13 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
 
 		duration = sched_clock() - start;
-		stats = this_cpu_ptr(prog->stats);
-		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		u64_stats_inc(&stats->cnt);
-		u64_stats_add(&stats->nsecs, duration);
-		u64_stats_update_end_irqrestore(&stats->syncp, flags);
+		if (likely(prog->stats)) {
+			stats = this_cpu_ptr(prog->stats);
+			flags = u64_stats_update_begin_irqsave(&stats->syncp);
+			u64_stats_inc(&stats->cnt);
+			u64_stats_add(&stats->nsecs, duration);
+			u64_stats_update_end_irqrestore(&stats->syncp, flags);
+		}
 	} else {
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
 	}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ba4543e771a6e..04c8755c0b951 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2281,6 +2281,9 @@ void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog)
 	struct bpf_prog_stats *stats;
 	unsigned int flags;
 
+	if (unlikely(!prog->stats))
+		return;
+
 	stats = this_cpu_ptr(prog->stats);
 	flags = u64_stats_update_begin_irqsave(&stats->syncp);
 	u64_stats_inc(&stats->misses);
-- 
2.51.0



