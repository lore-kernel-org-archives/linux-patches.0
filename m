Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC77502D43;
	Thu, 17 Sep 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666341; cv=none; b=mmiza/OWbv6TA2xri8J+4TjdlYB96Jj8syrLDhpu2tulqC8+lfPw/E2stMu28OuGw4egR3ogWba+NVoKVBDwQbD1aeQIylBmMcKCRKTswub6o1PsWYXtjUx53vicgMGndb4ltKqKK16AUQz8V0Hw6JEWVqlzbYqLCFr/QkkK8lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666341; c=relaxed/simple;
	bh=fYHSH1Cq7BuzdcUkCJfUgfU4/9wyKzA2XV8xvoFkBL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjE/9aEWJodT0eeGKjj9LbSl+G4qVSfKGMppM2f7tTbBeOq74Dvd1lCrghvAvMzy/cbYzpzjTvsl5Ho+kXAt1oKEq7Wz7DfMCFhXnDAuAXbzTcxqspACZCHG6xiEUcPykYne1cICtxJHX3uxDw5viYXWXEpKqJ0H8V8L+dZP2kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJ4K5+iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJ4K5+iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDB41F000FF;
	Thu, 17 Sep 2026 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666339;
	bh=vFkJoEVXv1Tap8bgXCHM0ZJimm1rbfdN7J2c8WncmZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJ4K5+ivlZ5KyTQYIJwgqqrHBgjMEGsFUxxUhQ9+nXXnimKRQL9MBZ7d6bLubckqC
	 2aySfh+HUmDDU5JqCoZMXKXM/hEsvSgV8VP4rbAzUQ66p/PBu+Ic6zDdq/xO84QtjO
	 020WcmNQWIBgGgcVqX3IZCKVrgPZZAmX4KfUkWo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 1004/1250] function_graph: Use the saved entrys size when reprinting it
Date: Thu, 17 Sep 2026 16:13:19 +0100
Message-ID: <20260917151619.254490054@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 0701995aaf8fc2281154db829ca85e231951e51d upstream.

When a graph entry does not fit in the trace_seq, print_graph_entry()
saves it in the iterator's fgraph_data and reprints it on the next read.
The entry has already been consumed from the ring buffer by then, so the
copy is all that is left of it.

The copy is sized with iter->ent_size, which no longer describes the
saved entry but whatever entry the iterator has moved on to. The
argument count is derived from the same field, so a 72 byte entry saved
and then reprinted ahead of a 48 byte return entry loses its arguments.

Record the size next to the failure flag, so that the two are always set
together, and restore it before reprinting.

Cc: stable@vger.kernel.org
Fixes: ff5c9c576e75 ("ftrace: Add support for function argument to graph tracer")
Link: https://patch.msgid.link/20260906034406.1335316-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -44,6 +44,7 @@ struct fgraph_data {
 	};
 	struct ftrace_graph_ret_entry	ret;
 	int				failed;
+	int				ent_size;
 	int				cpu;
 };
 
@@ -1239,6 +1240,7 @@ print_graph_entry(struct ftrace_graph_en
 		if (s->full) {
 			data->failed = 1;
 			data->cpu = cpu;
+			data->ent_size = iter->ent_size;
 		} else
 			data->failed = 0;
 	}
@@ -1422,6 +1424,7 @@ print_graph_function_flags(struct trace_
 	if (data && data->failed) {
 		field = &data->ent.ent;
 		iter->cpu = data->cpu;
+		iter->ent_size = data->ent_size;
 		ret = print_graph_entry(field, s, iter, flags);
 		if (ret == TRACE_TYPE_HANDLED && iter->cpu != cpu) {
 			per_cpu_ptr(data->cpu_data, iter->cpu)->ignore = 1;


