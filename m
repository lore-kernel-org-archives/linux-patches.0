Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B57B264F81;
	Sat, 25 Oct 2025 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409600; cv=none; b=mQjc+YD1z6ETS1BVXRe2JeOjp/4jKNRouugvTjptJ9MMBwb5ipbIMMSVAd3xIGL0NobzYUiaWFfkl9flblOvjUaHApFt/YTAL2Q0FojhsC/qguYd5jXvWHxy0+hc9RphPGo2MBaYGtPcpD50H6V+5AAvy1qT5sqKktgdnTrutN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409600; c=relaxed/simple;
	bh=kfDcDMw7eTIsx4lkXWJSt5Nhdmtf4AE030oWpxBM3nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWn2L4T8rEBn2y6R1giGGrdnuIycfqlgA5jh5zmha7to3iGAB0QyuXTV9b1RG2c5vLA65ECICsSKPxxqqwaS9awJ57jEYnp8a+BIqXtjzHq21GfQEuU+qfQg160N1QZysdyorbC1yW8e13jP5379peJ2WG09SeB/XiUqEHUSd5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPNXYUS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPNXYUS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFDDC4CEFF;
	Sat, 25 Oct 2025 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409600;
	bh=kfDcDMw7eTIsx4lkXWJSt5Nhdmtf4AE030oWpxBM3nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPNXYUS4lZGgj9WFgGJDsouli5QzwxrpUBXJcoD/nuP5Yd/3fkt4a87pgFzfzKFLZ
	 dzYfDHGEV+MsDl75Tv8YylGbJB6I2RZPJDAIphM+Fz2AbCG5DB0/m5tmM0HoGYiSMI
	 ChWlWNQzl/r6hGoxzu0MnmKjjiRyKbuUxY0KPc/wg8D/Hjsk7bHaO2jun5qnpuBMbD
	 1MA5VHnUcTgiNrXLoO26TRiNuAJZ1bE5/DNztYFFoeDyWy7thH3wt2eO4+An74YTQH
	 OCD3Lglg/WVy5hVoNYQG1NKd3Eboq4oxHYgeSczJvgZuDJE/wfJMq/KVQTrRqbS3Z4
	 TZAPZPzL1b4GQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	mhiramat@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] ftrace: Fix softlockup in ftrace_module_enable
Date: Sat, 25 Oct 2025 12:00:16 -0400
Message-ID: <20251025160905.3857885-385-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 4099b98203d6b33d990586542fa5beee408032a3 ]

A soft lockup was observed when loading amdgpu module.
If a module has a lot of tracable functions, multiple calls
to kallsyms_lookup can spend too much time in RCU critical
section and with disabled preemption, causing kernel panic.
This is the same issue that was fixed in
commit d0b24b4e91fc ("ftrace: Prevent RCU stall on PREEMPT_VOLUNTARY
kernels") and commit 42ea22e754ba ("ftrace: Add cond_resched() to
ftrace_graph_set_hash()").

Fix it the same way by adding cond_resched() in ftrace_module_enable.

Link: https://lore.kernel.org/aMQD9_lxYmphT-up@vova-pc
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change inserts `cond_resched()` inside the inner iteration over
  every ftrace record (`kernel/trace/ftrace.c:7538`). That loop holds
  the ftrace mutex and, for each record, invokes heavy helpers like
  `test_for_valid_rec()` which in turn calls `kallsyms_lookup()`
  (`kernel/trace/ftrace.c:4289`). On huge modules (e.g. amdgpu) this can
  run for tens of milliseconds with preemption disabled, triggering the
  documented soft lockup/panic during module load.
- `ftrace_module_enable()` runs only in process context via
  `prepare_coming_module()` (`kernel/module/main.c:3279`), so adding a
  voluntary reschedule point is safe; the same pattern already exists in
  other long-running ftrace loops (see commits d0b24b4e91fc and
  42ea22e754ba), so this brings consistency without changing control
  flow or semantics.
- No data structures or interfaces change, and the code still executes
  under the same locking (`ftrace_lock`, `text_mutex` when the arch
  overrides `ftrace_arch_code_modify_prepare()`), so the risk of
  regression is minimal: the new call simply yields CPU if needed while
  keeping the locks held, preventing watchdog-induced crashes but
  otherwise behaving identically.

Given it fixes a real, user-visible soft lockup with a contained and
well-understood tweak, this is an excellent candidate for stable
backporting.

 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a69067367c296..42bd2ba68a821 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7535,6 +7535,8 @@ void ftrace_module_enable(struct module *mod)
 		if (!within_module(rec->ip, mod))
 			break;
 
+		cond_resched();
+
 		/* Weak functions should still be ignored */
 		if (!test_for_valid_rec(rec)) {
 			/* Clear all other flags. Should not be enabled anyway */
-- 
2.51.0

