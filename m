Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E15A34A3BF;
	Wed, 20 May 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296686; cv=none; b=CEb4pR/TFvfw7ulJB954dMAgD200MHgzcH4uVLO75kiPNbvtw+mZZsNBitWlt0fRMzE6s+JIxjdpmZRgw4W4G9if/DNUX2tRA2m1CiN2X+maAihMNMBkuvbzZ+EMVHCGOeLTSQ2orunNKr8sIbTKRLnfLjNVoiRYAe1Tr+OIan8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296686; c=relaxed/simple;
	bh=lbPO1nTDg9t9o2bDTBN3aqedNw/kZcSIoOmlfbZay5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQXByjXN8ZoS0jwZ4kQA5xEXAIqpq7nRra6TGy7TK+SWydoEDGpg5UIjGOdeAvUyVGzcDiEEk0dHzJoyZG64wnV9SwEcuEQv1FeGYuKuMF5L7oxSmXCdbb0EyMkwoYFk5eGlEU/mPfpeCmk988NkwDl/Yi4h1u8jckW/l0M8zZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIFocUyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIFocUyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C641F000E9;
	Wed, 20 May 2026 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296685;
	bh=s1xyHrSjB/tk4HCWt0AXIdyFuLweI/jy6tQTlmCDQ6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIFocUyRHUNjPzkHx58FzPtu+4Ew40QXrIWQd7HyqKMGv9GwepH23ehaEDqn5wibZ
	 PD4zQthOvj7kE19SqS2vgwWHqAg8zpUYIGaGRG6EychKbrUiobBghRvfWso9282/ww
	 RdmkZw4BqliGPy6vLMltu0+m6x08dheCyF/ydtMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0893/1146] tracing: branch: Fix inverted check on stat tracer registration
Date: Wed, 20 May 2026 18:19:03 +0200
Message-ID: <20260520162208.446263850@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3b75dd76e64a04771861bb5647951c264919e563 ]

init_annotated_branch_stats() and all_annotated_branch_stats() check the
return value of register_stat_tracer() with "if (!ret)", but
register_stat_tracer() returns 0 on success and a negative errno on
failure. The inverted check causes the warning to be printed on every
successful registration, e.g.:

  Warning: could not register annotated branches stats

while leaving real failures silent. The initcall also returned a
hard-coded 1 instead of the actual error.

Invert the check and propagate ret so that the warning fires on real
errors and the initcall reports the correct status.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: https://patch.msgid.link/20260420-tracing-v1-1-d8f4cd0d6af1@debian.org
Fixes: 002bb86d8d42 ("tracing/ftrace: separate events tracing and stats tracing engine")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_branch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 6809b370e991d..d1564db95a8f5 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -373,10 +373,10 @@ __init static int init_annotated_branch_stats(void)
 	int ret;
 
 	ret = register_stat_tracer(&annotated_branch_stats);
-	if (!ret) {
+	if (ret) {
 		printk(KERN_WARNING "Warning: could not register "
 				    "annotated branches stats\n");
-		return 1;
+		return ret;
 	}
 	return 0;
 }
@@ -438,10 +438,10 @@ __init static int all_annotated_branch_stats(void)
 	int ret;
 
 	ret = register_stat_tracer(&all_branch_stats);
-	if (!ret) {
+	if (ret) {
 		printk(KERN_WARNING "Warning: could not register "
 				    "all branches stats\n");
-		return 1;
+		return ret;
 	}
 	return 0;
 }
-- 
2.53.0



