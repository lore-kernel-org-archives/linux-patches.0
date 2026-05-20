Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168FD40DFC6;
	Wed, 20 May 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302700; cv=none; b=thUXv/31aykHE3K4whxMUAHbVeP4293QRhQUbkM9XLbeaw4yi2KRQH3Ry9gnBcgmX16oRd+vtbzhPqeZ5VlMFdIXix6cmZHxGnE/LJTIzK9KMGQZ205bfP2WOf9aVDg5uk7zzHc2r41sB2hEvTJ4wQpkCTtGCSWu3fBb2kUic/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302700; c=relaxed/simple;
	bh=qAwOzoC7d727F4GAoOJPZ4LdKxjTnwGQIpCVnxMWmJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2a/NMNOyyh710wOeEFpFwMZ8PBz8EQO9vPeWURu3elXvEtaj9x+m1PFD7/wq+EQA2cNfzNolF7iEMnFLiW6dGo6GPc56cqEWSn6B+bgEmyLjGJR1Dfmtugn66gRnpSIkxqPsTAlzNWSHwObUMCFHpUxCs+waWgZr5pKKto/s3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1oXgvqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1oXgvqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6E91F00893;
	Wed, 20 May 2026 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302698;
	bh=Zr/Mp/Z41i//7+gBMrTkpIsE3k15n2uTdJ3/0TdJO4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1oXgvqcL2UmQCozj1NRctbYSKXnZx2ok5em9Fk+WUedughLEtzS1g8/u5LRCy230
	 BGap61rkHO3fdaQKL/lzISqBOZooWBYO+WWFnzfgnf03hMWNYPSAv3TjYHYf5Od2B3
	 u2onxxJ9mKy3sK0axVlKmhEG5WoPRHzUgafAl3eg=
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
Subject: [PATCH 6.6 366/508] tracing: branch: Fix inverted check on stat tracer registration
Date: Wed, 20 May 2026 18:23:09 +0200
Message-ID: <20260520162106.558640444@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e47fdb4c92fbc..30f72e0ecb5d4 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -379,10 +379,10 @@ __init static int init_annotated_branch_stats(void)
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
@@ -444,10 +444,10 @@ __init static int all_annotated_branch_stats(void)
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



