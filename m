Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207142;
	b=ahudXhWeDizzj1C+3dbu8nRC2p0i3UxhQ5l/QApkxvNOgPJRv0Pf2mAMAPjICbK3gwt5
	 M/AXZU8zfvDen1/9GXUH0gfhQ/zYmVfOU+d2Sp8kUkAMdGl731zJmWZqmOa6TSJg2PwLv
	 Ff4ZpWLxVrljLO9Sivk2oNVC2CGtl4lr0XEktEQ06lm0d0PIZg8q9pX8B3M6oPl8vBB42
	 n1Ryy2H3HlTHBft9cJUgzXL8L4V1mp0fBs7SPoFIfUvwWWIbajNhPnf4hdVgibmuqUifP
	 6Mo36efqZIwZ+V/Hmaemg6LNpYmiFOvy0HkZytYdyddFRlwEot2gcsjR8b1S2RiHKqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HWdeiB4A61x54cft6ITHnfrXCRj3VfQKPV/kVn/0irE=;
	b=r6Ob3HzmDL/avcXFSRoD+AaZ/IHaC4u3avQbYGXLZHgCAFHiaRDLD7pNrMit18QDBN2e
	 sayhhB6NpXycA5is4seO3J81TxO2TXGuwny/MDnVPl5YxCST1k9rDecUg0zNJPjGIuk5E
	 QXYZzIlwN/HbOljpPkzT8iQrQVOlXNTzTleEk096QRfD9ohGjUlMtQ/xvwqsopblFuGI6
	 Cb38pwgnnz8n3ju5T3O1VntKRl+YatT7eUaefMYYUxV/NeDnQKKT5nc2+vip3wW/itxlO
	 nJRYsaJcIsK2oysYra3YVdljAaxyKD/T7zWtt1aJNwWrwdknc6CTPKAp8HHCNi7rasg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3wrJlW3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69122606A31C;
	Wed, 28 Oct 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3wrJlW3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845911F01825;
	Wed, 28 Oct 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207142;
	bh=HWdeiB4A61x54cft6ITHnfrXCRj3VfQKPV/kVn/0irE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3wrJlW39U+2KIDO3Z8mAcIWSpEwydFfGML08IyAnibiUCQZ7a7K5Pi/XW9HNzF5n
	 MklnrOabWYUl7EVLZh7HFpl/u1I9261W6cK3OcFSVGPsbp5D4n2mtVLZE/gAVTDN/r
	 OTv/HIHEGgc/WEH7PIYW1L+Gpl9fe4GYAJggfOu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"JongHyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 07/38] tracing: Reject incomplete event filter expressions
Date: Wed, 28 Oct 2026 17:59:54 +0100
Message-ID: <20261028165940.588429970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 1fdc4164e488916402badddbb1f51e9380dabb91 upstream.

A non-empty expression normally finishes in predicate_parse()'s inner
loop, which resolves the pending logical operators before jumping to
finalization. If the input ends after an operator, possibly followed by
unary '!' tokens, the outer loop instead falls through with unresolved
operator state.

For example, "common_pid == 1 || common_pid == 2 &&" leaves
prog[0].target equal to -1. The second pass then reads prog[-1] before
the forward-jump check can reject it. Depending on adjacent slab
contents, it can also copy an out-of-bounds word into a branch target
that passes the forward-only check. A self-targeted perf tracepoint
counting event can reach this path through PERF_EVENT_IOC_SET_FILTER.

Reject the outer-loop fallthrough when a predicate has already been
parsed. This ensures that non-empty expressions only reach finalization
after the inner loop has resolved their operators. Keep the existing
no-filter error for input that has no predicates. Add a regression test
for trailing logical operators and unary negations.

Fixes: 80765597bc587 ("tracing: Rewrite filter logic to be simpler and faster")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261023174620.91969-1-kylebot@openai.com
Assisted-by: Codex:gpt-6-astra
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: JongHyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_filter.c                                      |    6 ++
 tools/testing/selftests/ftrace/test.d/filter/event-filter-incomplete.tc |   24 ++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/filter/event-filter-incomplete.tc

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -595,6 +595,12 @@ predicate_parse(const char *str, int nr_
 			top--;					/* #12 */
 		}
 	}
+	/* Only the inner loop can complete a non-empty expression. */
+	if (N) {
+		ret = -EINVAL;
+		parse_error(pe, FILT_ERR_INVALID_FILTER, ptr - str);
+		goto out_free;
+	}
  out:
 	if (top != op_stack) {
 		/* Too many '(' */
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/filter/event-filter-incomplete.tc
@@ -0,0 +1,24 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: event filter - reject incomplete logical expressions
+# requires: events/sched/sched_switch/filter
+# flags: instance
+
+filter=events/sched/sched_switch/filter
+
+for base in \
+    'common_pid == 1' \
+    'common_pid == 1 || common_pid == 2' \
+    'common_pid == 1 && common_pid == 2' \
+    '!(common_pid == 1 || common_pid == 2)'
+do
+    printf '%s' "$base" > "$filter"
+    for tail in '&&' '||' '&& !' '|| !' '&& !! ' '|| !! '; do
+        if printf '%s' "$base $tail" > "$filter" 2>/dev/null; then
+            echo "Accepted incomplete filter: $base $tail"
+            exit_fail
+        fi
+    done
+done
+
+echo 0 > "$filter"


