Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF46D4749FA;
	Fri,  7 Aug 2026 15:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117110; cv=none; b=rEeRA6sY/0pVsseay5ZkwSxS57S329t9CD6FM/wiD06AXArWU4IcY/kVckBdkn+qc/2L5hVA4Oeq4HutBdAMgSvvl21D9Kcdw5ulsOz7aYKae0Qk765oV8oGl2YGKhw1WBdLJnj1kIvI9s8sAYExeEujv+DhrjJu54dEMzT9BFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117110; c=relaxed/simple;
	bh=0S2LONycKn4lWwln4RcE7sUG29L3XHR4TDRHa53o8KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnPFOfG5j7wbhsG3JmEff/GjdxbrbVwLxR/eyhJb/b1JRAS/k5r4VDvZH4wPT/9Uoy/qmAkYPlHo7fM2/6Tc8hXAFXtI7PVoS+1KWCK+p+4IDD+P/lokv9s5BBvMmXISh6CPFxB6tA5gBUcM/YGGAR1m6rc0XJ2Ac8uR5hJU/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvudcxf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvudcxf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EECA1F000E9;
	Fri,  7 Aug 2026 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117108;
	bh=AUSYtyBhHemjfE7CqGp3UlOyhhXoF0XE6ApqudnC13U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvudcxf0n8jvPSS70ZZ9Ku3eD343SSsPEhGhx98MlkNylVh/J4Y5ZGORiZCvSDZ/V
	 n6VdmxT2x8F7s1shy2hclx5nvNnoCqUYmDEDmUcjHcwS5KlMCvqJm/dWw2bZrkSaSG
	 5ubIc7q0L+mo7YnZd27TE5kRaQtNoxq5V3u5Bu40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 166/438] tracing/mmiotrace: Reset dropped_count in mmio_reset_data()
Date: Fri,  7 Aug 2026 16:36:02 +0200
Message-ID: <20260807143431.571421304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit c786d2bdf1f3964deee192ad942dee2a741c1e2c ]

mmio_reset_data() is called during tracer initialization, reset, and
start. While it resets overrun_detected and prev_overruns, it neglects
to reset dropped_count. Consequently, dropped event counts from prior
tracing sessions persist in dropped_count and corrupt overrun reports
in subsequent runs.

Fix this by explicitly calling atomic_set(&dropped_count, 0) in
mmio_reset_data().

Link: https://patch.msgid.link/178524299122.56416.16277704230639425172.stgit@devnote2
Fixes: 173ed24ee2d6 ("mmiotrace: count events lost due to not recording")
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_mmiotrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index b88b8d9923adb..e064ba3f28cb9 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -29,6 +29,7 @@ static void mmio_reset_data(struct trace_array *tr)
 {
 	overrun_detected = false;
 	prev_overruns = 0;
+	atomic_set(&dropped_count, 0);
 
 	tracing_reset_online_cpus(&tr->array_buffer);
 }
-- 
2.53.0



