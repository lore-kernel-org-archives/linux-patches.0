Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9CE2737EE;
	Fri,  9 Jan 2026 12:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961749; cv=none; b=IqcBp88yINBXw72trur7Byu1fQtYzc801fIxMXI9j3bSVC5CpLDZV1ioT7rcOlWfbSa9knyOyXdx4/F33qwkLy/asH2oH9r8PfU289f1Hj/VSvJq8h27Gug0ERes0pFYdgs9MKJZQ2nwN4b7z25nUDmmYuaCkkUCf6YCj7t7O+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961749; c=relaxed/simple;
	bh=tjJK0X0mj5GRf3FEoo1L3OAhIPLUeEzKhASeHnjS9Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO5FIPGxGfUi1VrAa+VMW6u4jleCR/A2CpVDkvpPFA1rlvOxGApDKVKJ+Za/HFThfE8NrG/riOd/H4oJBAPGfa2LZ3O4LPS3SCOxHVOAjO+lSexIR1CoXwWRtdQ/bc05cOlegf10cpurHBM9vuQ0AFiOYoY0uhVptNfvQZNvlqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxUvf8d1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxUvf8d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E041CC19421;
	Fri,  9 Jan 2026 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961748;
	bh=tjJK0X0mj5GRf3FEoo1L3OAhIPLUeEzKhASeHnjS9Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxUvf8d12s6wX7TahHmmAZwj4mAGb79aPYQ52sGVd/lKk7LEaO706fTJdkeyWYzCD
	 q1p56rE+CBb++RGhItXnclU719trjFikPpbvSDt1I6IM54di7eKpgTHKkPpSQ0eTIj
	 Pxm54ySl8yrZSg8x0CM5SCabaSWZfARSnyctBcB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/634] bpf: Fix invalid prog->stats access when update_effective_progs fails
Date: Fri,  9 Jan 2026 12:36:40 +0100
Message-ID: <20260109112122.034965268@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b7de1cbda5dc5..37260c48fad49 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -596,11 +596,13 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
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
index c15d243bfe382..b559d99e5959a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2141,6 +2141,9 @@ void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog)
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



