Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A10B18E778;
	Mon, 28 Oct 2024 06:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097784; cv=none; b=dFNFyen0C/FwuSIT8QJnMWVaBdim6d87vCyj3gCsVhqw3S/KMlMc9g47wiY6yfrMfxC+cYzXB6b2YYUzFJ0d15R7qmrWi2hPYveYdv9xINg0voJADNcsa8bjdqHbnGji1FUI4j+ac2P4WBMEvdJ5YKaCu7+G5id7lFpaBKghsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097784; c=relaxed/simple;
	bh=g1P1hnOvFz0Uz7ulPqsLAkzChOCKVgbFh0VphGcICoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSNmeYFNu0iVBEemfBXmKr011pxnr5VV4Cs+qx8XNSdf1h6JbhZRAPJn9wU8WStHiQe9Mu0IiHEfSja2oGtahh1hBDdsV36WuEWVzHAGf+77uk6vrG9i6N5Vkh9sB1IXP8zqtoi3FRmQg6+hN8giiw08JJjaI4d5TFO74OCL0FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/wU22q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/wU22q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994A7C4CEC3;
	Mon, 28 Oct 2024 06:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097783;
	bh=g1P1hnOvFz0Uz7ulPqsLAkzChOCKVgbFh0VphGcICoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/wU22q2wnaU/j4vjzFBE9RJoajkCR4mPWJ3hu7c0MijYMee1rfc1KG9R49bGFPs1
	 ASpPfIjaiVHlTMCOI1CEFW0IpDvqpBb+DomwFKpD0AX3i6hSu4HY+1OL1cI340lK2g
	 pMSzk3G55MKcZfFDJtdn3MRNzcREsBRVSDvV4qbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/208] tracing/probes: cleanup: Set trace_probe::nr_args at trace_probe_init
Date: Mon, 28 Oct 2024 07:24:48 +0100
Message-ID: <20241028062309.318962661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 035ba76014c096316fa809a46ce0a1b9af1cde0d ]

Instead of incrementing the trace_probe::nr_args, init it at
trace_probe_init(). Without this change, there is no way to get the number
of trace_probe arguments while parsing it.
This is a cleanup, so the behavior is not changed.

Link: https://lore.kernel.org/all/170952363585.229804.13060759900346411951.stgit@devnote2/

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 373b9338c972 ("uprobe: avoid out-of-bounds memory access of fetching args")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_eprobe.c |  2 +-
 kernel/trace/trace_fprobe.c |  2 +-
 kernel/trace/trace_kprobe.c |  2 +-
 kernel/trace/trace_probe.c  | 10 ++++++----
 kernel/trace/trace_probe.h  |  2 +-
 kernel/trace/trace_uprobe.c |  2 +-
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 72714cbf475c7..42b76f02e57a9 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -220,7 +220,7 @@ static struct trace_eprobe *alloc_event_probe(const char *group,
 	if (!ep->event_system)
 		goto error;
 
-	ret = trace_probe_init(&ep->tp, this_event, group, false);
+	ret = trace_probe_init(&ep->tp, this_event, group, false, nargs);
 	if (ret < 0)
 		goto error;
 
diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index 3ccef4d822358..5109650b0d82d 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -389,7 +389,7 @@ static struct trace_fprobe *alloc_trace_fprobe(const char *group,
 	tf->tpoint = tpoint;
 	tf->fp.nr_maxactive = maxactive;
 
-	ret = trace_probe_init(&tf->tp, event, group, false);
+	ret = trace_probe_init(&tf->tp, event, group, false, nargs);
 	if (ret < 0)
 		goto error;
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 52f8b537dd0a0..d1a7c876e4198 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -290,7 +290,7 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
 	INIT_HLIST_NODE(&tk->rp.kp.hlist);
 	INIT_LIST_HEAD(&tk->rp.kp.list);
 
-	ret = trace_probe_init(&tk->tp, event, group, false);
+	ret = trace_probe_init(&tk->tp, event, group, false, nargs);
 	if (ret < 0)
 		goto error;
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index ae162ba36a480..5d6c6c105f3cd 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1383,9 +1383,6 @@ int traceprobe_parse_probe_arg(struct trace_probe *tp, int i, const char *arg,
 	struct probe_arg *parg = &tp->args[i];
 	const char *body;
 
-	/* Increment count for freeing args in error case */
-	tp->nr_args++;
-
 	body = strchr(arg, '=');
 	if (body) {
 		if (body - arg > MAX_ARG_NAME_LEN) {
@@ -1770,7 +1767,7 @@ void trace_probe_cleanup(struct trace_probe *tp)
 }
 
 int trace_probe_init(struct trace_probe *tp, const char *event,
-		     const char *group, bool alloc_filter)
+		     const char *group, bool alloc_filter, int nargs)
 {
 	struct trace_event_call *call;
 	size_t size = sizeof(struct trace_probe_event);
@@ -1806,6 +1803,11 @@ int trace_probe_init(struct trace_probe *tp, const char *event,
 		goto error;
 	}
 
+	tp->nr_args = nargs;
+	/* Make sure pointers in args[] are NULL */
+	if (nargs)
+		memset(tp->args, 0, sizeof(tp->args[0]) * nargs);
+
 	return 0;
 
 error:
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index c1877d0182691..ed8d1052f8a78 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -338,7 +338,7 @@ static inline bool trace_probe_has_single_file(struct trace_probe *tp)
 }
 
 int trace_probe_init(struct trace_probe *tp, const char *event,
-		     const char *group, bool alloc_filter);
+		     const char *group, bool alloc_filter, int nargs);
 void trace_probe_cleanup(struct trace_probe *tp);
 int trace_probe_append(struct trace_probe *tp, struct trace_probe *to);
 void trace_probe_unlink(struct trace_probe *tp);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 99c051de412af..49d9af6d446e9 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -337,7 +337,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (!tu)
 		return ERR_PTR(-ENOMEM);
 
-	ret = trace_probe_init(&tu->tp, event, group, true);
+	ret = trace_probe_init(&tu->tp, event, group, true, nargs);
 	if (ret < 0)
 		goto error;
 
-- 
2.43.0



