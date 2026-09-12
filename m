Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA9A3C1F46;
	Sat, 12 Sep 2026 09:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203947; cv=none; b=Jwd2Wi5xL+xxIub189UiJeiZkqr2PUQT1zNAyc4yv1xDP6tm3Ea87yKwWmFcLeWkegATLfed1AqIguRuKFoYWFKXT2LamdhJ+7jrNp78AMA7dZzAaB0q580dsMpGGBuZlGCe/eJB9zdediHm+/IkyeVU1w8lQD/18zG0/R7Q3Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203947; c=relaxed/simple;
	bh=BO2GTUU48lY5pgNWy5sI8n/agkB+fZ7QJLZdyqil7Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mukiFLJVkeFZzmp3Bq1JYjs1wEVgkFwCaGW/90eI61K/wqWOaT3hOpf6s6zYvktFS6dCOrFux89MKWMaPonnIKFoP7WWp6vZd3zKNmK5GTWUdtjrLGGLa9hMqmDpazQ0SWW41/6ASnCc1ZhQrcl/GnHk+kdEcWBDLzBDTpd/5hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBB+r4fT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBB+r4fT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C16B1F000FF;
	Sat, 12 Sep 2026 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203946;
	bh=Y87NnuE7wj8dIxuS4K6YxKyiliPRe/UKUczqzEC/PrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBB+r4fTFhab09J1RFZRsMugzMZdoXQ45h/ArH/MG+wCbUylQAw5NSWjWFU04YzA8
	 HM77rAUZ+jgCQVtjj5mMhlzTGAbL60cmmVIIYPYZHqYtF9dp/cAfyoGFBf/RaCQ1ZJ
	 Q/7qu89W/Vb25PpN8F+7wmxFSb1Y6f/QJ97G6Yu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1469/1815] sched_ext/scx_flatcg: Fix cvtime true-up on slice expiry
Date: Sat, 12 Sep 2026 08:53:39 +0200
Message-ID: <20260912065723.492982923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 9b4243d30469e7733730e786792d1560442e229e ]

fcg_dispatch() true-ups the current cgroup's cvtime when its slice
expires or its DSQ runs empty while the slice is still active:

	__sync_fetch_and_add(&cgc->cvtime_delta,
			     (cpuc->cur_at + cgrp_slice_ns - now) *
			     FCG_HWEIGHT_ONE / (cgc->hweight ?: 1));

The true-up should be actual minus charged: on CNS_EXPIRE, the overrun
(now - cur_at - cgrp_slice_ns) should be added; on CNS_EMPTY, the
unused portion of the slice should be subtracted. The expression above
has the sign inverted, and in the CNS_EXPIRE case now is already past
cur_at + cgrp_slice_ns, so the u64 subtraction wraps. The
multiplication preserves the two's complement encoding but the
unsigned division by hweight destroys it, adding roughly 2^64/hweight
per expiry instead of a small correction.

Under saturation the hweight budget clamp in cgrp_cap_budget() masks
most of the garbage, so the weight distribution barely moves, but the
accounting is broken all the same. Compute the delta as a signed value
and use fetch_and_add()/fetch_and_sub() so that the dividends stay
positive, as BPF division is unsigned.

Instrumented the true-up and ran a saturated three-leaf cgroup tree on
a 4-CPU VM: without the fix, each expiry added ~5e15 (2^64/hweight
territory) to cvtime_delta; with it, the corrections are back to
slice scale, with the overrun added and the unused portion subtracted.

Fixes: a4103eacc2ab ("sched_ext: Add a cgroup scheduler which uses flattened hierarchy")
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.bpf.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index 0fd214cc61dae..ddcf6bc03b11c 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -769,10 +769,18 @@ void BPF_STRUCT_OPS(fcg_dispatch, s32 cpu, struct task_struct *prev)
 		 * cgroup to execute but the latter needs to be done in a loop
 		 * and we can't keep the lock held. Oh well...
 		 */
+		s64 delta = now - cpuc->cur_at - cgrp_slice_ns;
+
 		bpf_spin_lock(&cgv_tree_lock);
-		__sync_fetch_and_add(&cgc->cvtime_delta,
-				     (cpuc->cur_at + cgrp_slice_ns - now) *
-				     FCG_HWEIGHT_ONE / (cgc->hweight ?: 1));
+		/* keep the dividends positive, BPF division is unsigned */
+		if (delta >= 0)
+			__sync_fetch_and_add(&cgc->cvtime_delta,
+					     (u64)delta * FCG_HWEIGHT_ONE /
+					     (cgc->hweight ?: 1));
+		else
+			__sync_fetch_and_sub(&cgc->cvtime_delta,
+					     (u64)-delta * FCG_HWEIGHT_ONE /
+					     (cgc->hweight ?: 1));
 		bpf_spin_unlock(&cgv_tree_lock);
 	} else {
 		stat_inc(FCG_STAT_CNS_GONE);
-- 
2.53.0



