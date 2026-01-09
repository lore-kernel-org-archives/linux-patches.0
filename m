Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30F035A955;
	Fri,  9 Jan 2026 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961746; cv=none; b=tjHMBoMEoqMwV9CxB3lTZF+r/yDz0fodhy7H4yCMua9Up1OXaY22f3L1IIDpUlSru5GwvL+9BxIMvHzUQ1BhaRgMrz2E401Y7sgGUf3fgP+EFdlM6LA12mo4szQTpnX2JQZEyyJuPP6VrYbxbVlHrEvsGzgEKBb1Yl9zz/tFh30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961746; c=relaxed/simple;
	bh=PmODZQ8hT90rFmR58rkIKeAduM3t9lGxwcI8jzo4NOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ef49MR/pfA0EJ8d6Oqt7LElMNjWXCa0Yl42uAkS6NJ6F3Gs8JvmfDag1wXdPk5wMNWNFrM0cYDiCmiAg6OT9LDZib3R6iV+itfGyTtroC87KaOcTA+d8YvVZx4G8G/8M2uxvlSfgrD1RmNmOGOB+tnM4c8+4V9iNBd7E2kS2qbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBsHzzdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBsHzzdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12445C4CEF1;
	Fri,  9 Jan 2026 12:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961745;
	bh=PmODZQ8hT90rFmR58rkIKeAduM3t9lGxwcI8jzo4NOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBsHzzdSOuf4B+057j4MlNyA2MM46qopRknHW57QWMsGJclI3qciUp6T1XL77VgMC
	 uKV6EBjUKLwQNQ7aOrO+8+pSdxJoRom2YBYFDpG/8DNNxx5b0VCpd48Hg1i4zEwQ29
	 u1R6C1F7q+Y6A/xugZxiXp+cvq9491BZg7V1Rc3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Fernandez <josef@netflix.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/634] bpf: Improve program stats run-time calculation
Date: Fri,  9 Jan 2026 12:36:39 +0100
Message-ID: <20260109112121.997234913@linuxfoundation.org>
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

From: Jose Fernandez <josef@netflix.com>

[ Upstream commit ce09cbdd988887662546a1175bcfdfc6c8fdd150 ]

This patch improves the run-time calculation for program stats by
capturing the duration as soon as possible after the program returns.

Previously, the duration included u64_stats_t operations. While the
instrumentation overhead is part of the total time spent when stats are
enabled, distinguishing between the program's native execution time and
the time spent due to instrumentation is crucial for accurate
performance analysis.

By making this change, the patch facilitates more precise optimization
of BPF programs, enabling users to understand their performance in
environments without stats enabled.

I used a virtualized environment to measure the run-time over one minute
for a basic raw_tracepoint/sys_enter program, which just increments a
local counter. Although the virtualization introduced some performance
degradation that could affect the results, I observed approximately a
16% decrease in average run-time reported by stats with this change
(310 -> 260 nsec).

Signed-off-by: Jose Fernandez <josef@netflix.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240402034010.25060-1-josef@netflix.com
Stable-dep-of: 7dc211c1159d ("bpf: Fix invalid prog->stats access when update_effective_progs fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h  | 6 ++++--
 kernel/bpf/trampoline.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 502cab01e9e97..b7de1cbda5dc5 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -590,14 +590,16 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 	cant_migrate();
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {
 		struct bpf_prog_stats *stats;
-		u64 start = sched_clock();
+		u64 duration, start = sched_clock();
 		unsigned long flags;
 
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
+
+		duration = sched_clock() - start;
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
 		u64_stats_inc(&stats->cnt);
-		u64_stats_add(&stats->nsecs, sched_clock() - start);
+		u64_stats_add(&stats->nsecs, duration);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	} else {
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 748ac86169941..4c7c6129db90e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -901,12 +901,13 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 	     * Hence check that 'start' is valid.
 	     */
 	    start > NO_START_TIME) {
+		u64 duration = sched_clock() - start;
 		unsigned long flags;
 
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
 		u64_stats_inc(&stats->cnt);
-		u64_stats_add(&stats->nsecs, sched_clock() - start);
+		u64_stats_add(&stats->nsecs, duration);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	}
 }
-- 
2.51.0



