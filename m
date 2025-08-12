Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523A82F4A0A;
	Tue, 12 Aug 2025 18:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024173; cv=none; b=EdnrPok+mYqHLlWg8bku76VNU66NRJH31nCQVHbCNaAXr2he5ulE+6ePjN6vJbjtvKuRNyDEAuE+81c3aV+PeCfbVaS21oS+Nekl+Ci5jL/JBBQ3B8pYNPwzoF46STYAxEoReeuV1hHiC3bfN27sveuTGwcQF/X2FNGu15hO2nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024173; c=relaxed/simple;
	bh=7mHppKnj5GUorlaVsAINhYIXmEjFpYJytzazyZCBC9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJtAqYOTw6fo6MSs+pcZWZMvUYQ60x8nd28VyJw6pU4IlDWjBvTDq9NZcdxvnp0yIboy1q1b0tubKkMP5VXBAmxnyMEZun4WBm+g2IY0bqE3J3LVL3rJks+8HSf6OdRMNMXmm1GFa4C0rKlRD56BTKGb/0OryBVjQtxBdIGhML4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpP4oafu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpP4oafu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EEEC4CEF0;
	Tue, 12 Aug 2025 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024173;
	bh=7mHppKnj5GUorlaVsAINhYIXmEjFpYJytzazyZCBC9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpP4oafu9wH/QwqF+zjhic6cc8ZrV2rT9Ak6UXne1B40nthqAI7om22a5gNvJm5LO
	 BeN/moNpEO3mpkzzt9HYa2+5eIvHtzda3UDtIdBx718pNNiaMp+jdp0bitsereci39
	 vF6RIFQcl0IrCoJiZL8du3xWVor3ZuHjaEoRO8qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tomas Glozar <tglozar@redhat.com>,
	Juri Lelli <jlelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	John Kacur <jkacur@redhat.com>,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 295/627] rv: Adjust monitor dependencies
Date: Tue, 12 Aug 2025 19:29:50 +0200
Message-ID: <20250812173430.531864682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 79de661707a4a2dc695fd3e00529a14b4f5ec50d ]

RV monitors relying on the preemptirqs tracepoints are set as dependent
on PREEMPT_TRACER and IRQSOFF_TRACER. In fact, those configurations do
enable the tracepoints but are not the minimal configurations enabling
them, which are TRACE_PREEMPT_TOGGLE and TRACE_IRQFLAGS (not selectable
manually).

Set TRACE_PREEMPT_TOGGLE and TRACE_IRQFLAGS as dependencies for
monitors.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/20250728135022.255578-5-gmonaco@redhat.com
Fixes: fbe6c09b7eb4 ("rv: Add scpd, snep and sncid per-cpu monitors")
Acked-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/rv/monitors/scpd/Kconfig  | 2 +-
 kernel/trace/rv/monitors/sncid/Kconfig | 2 +-
 kernel/trace/rv/monitors/snep/Kconfig  | 2 +-
 kernel/trace/rv/monitors/wip/Kconfig   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/rv/monitors/scpd/Kconfig b/kernel/trace/rv/monitors/scpd/Kconfig
index b9114fbf680f..682d0416188b 100644
--- a/kernel/trace/rv/monitors/scpd/Kconfig
+++ b/kernel/trace/rv/monitors/scpd/Kconfig
@@ -2,7 +2,7 @@
 #
 config RV_MON_SCPD
 	depends on RV
-	depends on PREEMPT_TRACER
+	depends on TRACE_PREEMPT_TOGGLE
 	depends on RV_MON_SCHED
 	default y
 	select DA_MON_EVENTS_IMPLICIT
diff --git a/kernel/trace/rv/monitors/sncid/Kconfig b/kernel/trace/rv/monitors/sncid/Kconfig
index 76bcfef4fd10..3a5639feaaaf 100644
--- a/kernel/trace/rv/monitors/sncid/Kconfig
+++ b/kernel/trace/rv/monitors/sncid/Kconfig
@@ -2,7 +2,7 @@
 #
 config RV_MON_SNCID
 	depends on RV
-	depends on IRQSOFF_TRACER
+	depends on TRACE_IRQFLAGS
 	depends on RV_MON_SCHED
 	default y
 	select DA_MON_EVENTS_IMPLICIT
diff --git a/kernel/trace/rv/monitors/snep/Kconfig b/kernel/trace/rv/monitors/snep/Kconfig
index 77527f971232..7dd54f434ff7 100644
--- a/kernel/trace/rv/monitors/snep/Kconfig
+++ b/kernel/trace/rv/monitors/snep/Kconfig
@@ -2,7 +2,7 @@
 #
 config RV_MON_SNEP
 	depends on RV
-	depends on PREEMPT_TRACER
+	depends on TRACE_PREEMPT_TOGGLE
 	depends on RV_MON_SCHED
 	default y
 	select DA_MON_EVENTS_IMPLICIT
diff --git a/kernel/trace/rv/monitors/wip/Kconfig b/kernel/trace/rv/monitors/wip/Kconfig
index e464b9294865..87a26195792b 100644
--- a/kernel/trace/rv/monitors/wip/Kconfig
+++ b/kernel/trace/rv/monitors/wip/Kconfig
@@ -2,7 +2,7 @@
 #
 config RV_MON_WIP
 	depends on RV
-	depends on PREEMPT_TRACER
+	depends on TRACE_PREEMPT_TOGGLE
 	select DA_MON_EVENTS_IMPLICIT
 	bool "wip monitor"
 	help
-- 
2.39.5



