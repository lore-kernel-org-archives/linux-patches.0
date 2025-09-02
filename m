Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF12D6623;
	Tue,  2 Sep 2025 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819360; cv=none; b=G/3dKUGoFHXLKqZJ/dzjmHZqvkNK+bRueZfH73qz+EuNa61Dz48vtnEd7MVYPNB8oR5invj4aa9BMkz328gGefutdHLKxYL3KxCstIJHAAKXZQGVAruWbCxnHpHgl6JZe8u2oV7p7P2tnt+R81uSXEML4lHOPRCQiI3mIcWN+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819360; c=relaxed/simple;
	bh=XAZhpHl7qIOewz9UAtbo8wiK0aLI6eTBHiNuv/D6VN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5nJDWtLFbbhc6c2/P2xlnbtF2ZZc7fLFITpXw6Pkjk+cDescgct/I3DbuiVciT/UYPNvVmApMLbEzKMlYUbo0dXJ8e+ap7XvHtwUlPvWEVK8a4yZkFpbEDOAruC8qsa5OoJ2Rn9QPmoz7xebdRRhy1Z6RsUx1ekZMiGxQRoC4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoijkyNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoijkyNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C9BC4CEED;
	Tue,  2 Sep 2025 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819359;
	bh=XAZhpHl7qIOewz9UAtbo8wiK0aLI6eTBHiNuv/D6VN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoijkyNw7qSlKyiiwXpjFuOOG6o0UGo1uHpkVkqDTTdABzOP4dmwVUsOGoDLrLgBW
	 Wa32iPL+M0lCV/OoBm6IvdL3ybNXYAVf68+jGiXqaPWKQIWs9u3FpbqtNXuzVK1116
	 RbFIcTVLGlirZ1eyE+DY42T368Oc/xRmP1SUIfu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.16 012/142] fgraph: Copy args in intermediate storage with entry
Date: Tue,  2 Sep 2025 15:18:34 +0200
Message-ID: <20250902131948.625572784@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit e3d01979e4bff5c87eb4054a22e7568bb679b1fe ]

The output of the function graph tracer has two ways to display its
entries. One way for leaf functions with no events recorded within them,
and the other is for functions with events recorded inside it. As function
graph has an entry and exit event, to simplify the output of leaf
functions it combines the two, where as non leaf functions are separate:

 2)               |              invoke_rcu_core() {
 2)               |                raise_softirq() {
 2)   0.391 us    |                  __raise_softirq_irqoff();
 2)   1.191 us    |                }
 2)   2.086 us    |              }

The __raise_softirq_irqoff() function above is really two events that were
merged into one. Otherwise it would have looked like:

 2)               |              invoke_rcu_core() {
 2)               |                raise_softirq() {
 2)               |                  __raise_softirq_irqoff() {
 2)   0.391 us    |                  }
 2)   1.191 us    |                }
 2)   2.086 us    |              }

In order to do this merge, the reading of the trace output file needs to
look at the next event before printing. But since the pointer to the event
is on the ring buffer, it needs to save the entry event before it looks at
the next event as the next event goes out of focus as soon as a new event
is read from the ring buffer. After it reads the next event, it will print
the entry event with either the '{' (non leaf) or ';' and timestamps (leaf).

The iterator used to read the trace file has storage for this event. The
problem happens when the function graph tracer has arguments attached to
the entry event as the entry now has a variable length "args" field. This
field only gets set when funcargs option is used. But the args are not
recorded in this temp data and garbage could be printed. The entry field
is copied via:

  data->ent = *curr;

Where "curr" is the entry field. But this method only saves the non
variable length fields from the structure.

Add a helper structure to the iterator data that adds the max args size to
the data storage in the iterator. Then simply copy the entire entry into
this storage (with size protection).

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/20250820195522.51d4a268@gandalf.local.home
Reported-by: Sasha Levin <sashal@kernel.org>
Tested-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/all/aJaxRVKverIjF4a6@lappy/
Fixes: ff5c9c576e75 ("ftrace: Add support for function argument to graph tracer")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_functions_graph.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 14d74a7491b8c..97fb32aaebeb9 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -27,14 +27,21 @@ struct fgraph_cpu_data {
 	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
 };
 
+struct fgraph_ent_args {
+	struct ftrace_graph_ent_entry	ent;
+	/* Force the sizeof of args[] to have FTRACE_REGS_MAX_ARGS entries */
+	unsigned long			args[FTRACE_REGS_MAX_ARGS];
+};
+
 struct fgraph_data {
 	struct fgraph_cpu_data __percpu *cpu_data;
 
 	/* Place to preserve last processed entry. */
 	union {
-		struct ftrace_graph_ent_entry	ent;
+		struct fgraph_ent_args		ent;
+		/* TODO allow retaddr to have args */
 		struct fgraph_retaddr_ent_entry	rent;
-	} ent;
+	};
 	struct ftrace_graph_ret_entry	ret;
 	int				failed;
 	int				cpu;
@@ -627,10 +634,13 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * Save current and next entries for later reference
 			 * if the output fails.
 			 */
-			if (unlikely(curr->ent.type == TRACE_GRAPH_RETADDR_ENT))
-				data->ent.rent = *(struct fgraph_retaddr_ent_entry *)curr;
-			else
-				data->ent.ent = *curr;
+			if (unlikely(curr->ent.type == TRACE_GRAPH_RETADDR_ENT)) {
+				data->rent = *(struct fgraph_retaddr_ent_entry *)curr;
+			} else {
+				int size = min((int)sizeof(data->ent), (int)iter->ent_size);
+
+				memcpy(&data->ent, curr, size);
+			}
 			/*
 			 * If the next event is not a return type, then
 			 * we only care about what type it is. Otherwise we can
-- 
2.50.1



