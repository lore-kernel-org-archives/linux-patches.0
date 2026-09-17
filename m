Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF3B4FD26C;
	Thu, 17 Sep 2026 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666079; cv=none; b=DUJYGEkPjU7YvtfJKbkXRskPKbTqCIhyYDIh1KttFpsxawUO0Ta7C/ScKoczkcNL5+fVY63YntxdMh1E8/Y43+DaC4pMQrwc0B9LmkWwm09SdBEv4h4kuhPPL2cSHDYkLeX9VhgJQC6t8W1xPv75s+C5k+xBNt9fCaQdXRPJGHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666079; c=relaxed/simple;
	bh=OPEabJBYRhRF9oZ5K7j6ZesQ96IZcTbXPnRBBaVxXU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/GzWvz3QgKHJ2PLSCI+6KDrtDrtGLvdaKbjNTrj7cT6Gi/7td7zb6Ld+o6pZcHGE/0mOIk36KlTrUtKnvWU7HYSWItYtH4EgAR8PzyUaMKRkjUn6/VxHSIC2NpORhWqDohB3y85HFGvNrPFX07jdgYqKL2QZLtaD2HnA+Dw+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK34XPL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK34XPL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59151F000FF;
	Thu, 17 Sep 2026 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666078;
	bh=lRMnXjdLknREPzluqRXYWccxchCORQFR8WJ5ej9RLJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mK34XPL91ZT83ik0GGHo9sBbith123rsPy1Dk0TKAEyG044hFjtkFuWn9GPG0buCW
	 HomsdE4BICir9vJc1Bbpos8iqABihzP4nLb18Te1lVvt6ZbHEOfSZou3uNpBZzdQ8a
	 TcCW4raA1XF0f8WboyIHsmP6yRRVsKPh8jb7MBmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0917/1250] perf/x86/intel: Correct pt_regs->flags update for PEBS path
Date: Thu, 17 Sep 2026 16:11:52 +0100
Message-ID: <20260917151616.856946482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 88aa1223bfffb1a0a98c639e9e1f71058f0d9178 ]

pt_regs->flags holds the saved CPU FLAGS register. In the PEBS path,
it was incorrectly set to PERF_EFLAGS_EXACT instead of being populated
from the PEBS flags snapshot.

Update pt_regs->flags from PEBS GPR flags if GPRs group is present.

Fixes: c22497f5838c ("perf/x86/intel: Support adaptive PEBS v4")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260908075102.540715-1-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index a116be23c28cf..cab7c4d2e99bd 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2083,7 +2083,7 @@ static inline void __setup_pebs_basic_group(struct perf_event *event,
 {
 	/* The ip in basic is EventingIP */
 	set_linear_ip(regs, ip);
-	regs->flags = PERF_EFLAGS_EXACT;
+	regs->flags |= PERF_EFLAGS_EXACT;
 	setup_pebs_time(event, data, tsc);
 
 	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT)
@@ -2095,9 +2095,17 @@ static inline void __setup_pebs_gpr_group(struct perf_event *event,
 					  struct pebs_gprs *gprs,
 					  u64 sample_type)
 {
+	/*
+	 * Update flags with PEBS data. PERF_EFLAGS_EXACT must be set
+	 * in previous basic group handling.
+	 */
+	regs->flags = gprs->flags | PERF_EFLAGS_EXACT;
+
 	if (event->attr.precise_ip < 2) {
 		set_linear_ip(regs, gprs->ip);
 		regs->flags &= ~PERF_EFLAGS_EXACT;
+	} else if (regs->flags & X86_VM_MASK) {
+		regs->flags ^= (PERF_EFLAGS_VM | X86_VM_MASK);
 	}
 
 	if (sample_type & (PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_REGS_USER))
-- 
2.53.0



