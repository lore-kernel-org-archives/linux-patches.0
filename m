Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5A42580D7;
	Thu, 28 May 2026 20:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999587; cv=none; b=s9j58fT5RrEeTU/nt6lcm2ZPxGIPf5dAhdcqekSY5BbNAhOKkSr8g8vF5pmfyliiKXNiToX3lj0RHc/tHS/mGKEGqhIl1CTgAn7WJITx6nMWX7VLnyftkXTSlhAt5n3+CP8pe1ICOBwn9GHnn7/1swaNYHdME9RMrLxB15dPc8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999587; c=relaxed/simple;
	bh=61W0ZDQ71nTCSd3rpeRzcLrv1Xo0pvnpENYUyx+nBfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZgSxG7AIirjScrsFpWPdq9RV6kGX9LY0SmrTL2UoGzRWih4bpOC2QGyivroadFRYpFdBBiQITfV91Da3qCWGU+827z0ZeqmgpPlPrzScb0GeVlu8FkvQb6MVKeYyP/JVT9a4F95iuTcI7iYhJDI+XfRZSuDxeUx66eOYTzUq7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL2RAFkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL2RAFkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C531F000E9;
	Thu, 28 May 2026 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999585;
	bh=PnKVXu+bnSRPpug/wMwLt5zvkZQzhXIRytqsO1SGVy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL2RAFkRfYZQ/vjM9gs2U0t9g6M+9DIw2tlFtOzFT1RxJwO79EF3XMzrG8CsZcRss
	 Wej/c+rwfUsW6h32yoqOMTWce8AM3pUjbKwksUn9AZs1VR2jXRil5KAfpOT05epZKe
	 A8m79hfQcRRm619UcIyFzxqsRzPQ2pXAxEUJmMgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/377] tracing: fprobe: use ftrace if CONFIG_DYNAMIC_FTRACE_WITH_ARGS
Date: Thu, 28 May 2026 21:45:10 +0200
Message-ID: <20260528194640.449942481@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit cd06078a38aaedfebbf8fa0c009da0f99f4473fb ]

For now, we will use ftrace for the fprobe if fp->exit_handler not exists
and CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled.

However, CONFIG_DYNAMIC_FTRACE_WITH_REGS is not supported by some arch,
such as arm. What we need in the fprobe is the function arguments, so we
can use ftrace for fprobe if CONFIG_DYNAMIC_FTRACE_WITH_ARGS is enabled.

Therefore, use ftrace if CONFIG_DYNAMIC_FTRACE_WITH_REGS or
CONFIG_DYNAMIC_FTRACE_WITH_ARGS enabled.

Link: https://lore.kernel.org/all/20251103063434.47388-1-dongml2@chinatelecom.cn/

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 0ac0058a74ac ("tracing/fprobe: Check the same type fprobe on table as the unregistered one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -45,6 +45,7 @@
 static struct hlist_head fprobe_table[FPROBE_TABLE_SIZE];
 static struct rhltable fprobe_ip_table;
 static DEFINE_MUTEX(fprobe_mutex);
+static struct fgraph_ops fprobe_graph_ops;
 
 static u32 fprobe_node_hashfn(const void *data, u32 len, u32 seed)
 {
@@ -259,7 +260,7 @@ static inline int __fprobe_kprobe_handle
 	return ret;
 }
 
-#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+#if defined(CONFIG_DYNAMIC_FTRACE_WITH_ARGS) || defined(CONFIG_DYNAMIC_FTRACE_WITH_REGS)
 /* ftrace_ops callback, this processes fprobes which have only entry_handler. */
 static void fprobe_ftrace_entry(unsigned long ip, unsigned long parent_ip,
 	struct ftrace_ops *ops, struct ftrace_regs *fregs)
@@ -300,7 +301,7 @@ NOKPROBE_SYMBOL(fprobe_ftrace_entry);
 
 static struct ftrace_ops fprobe_ftrace_ops = {
 	.func	= fprobe_ftrace_entry,
-	.flags	= FTRACE_OPS_FL_SAVE_REGS,
+	.flags	= FTRACE_OPS_FL_SAVE_ARGS,
 };
 static int fprobe_ftrace_active;
 
@@ -341,6 +342,15 @@ static bool fprobe_is_ftrace(struct fpro
 {
 	return !fp->exit_handler;
 }
+
+#ifdef CONFIG_MODULES
+static void fprobe_set_ips(unsigned long *ips, unsigned int cnt, int remove,
+			   int reset)
+{
+	ftrace_set_filter_ips(&fprobe_graph_ops.ops, ips, cnt, remove, reset);
+	ftrace_set_filter_ips(&fprobe_ftrace_ops, ips, cnt, remove, reset);
+}
+#endif
 #else
 static int fprobe_ftrace_add_ips(unsigned long *addrs, int num)
 {
@@ -355,7 +365,15 @@ static bool fprobe_is_ftrace(struct fpro
 {
 	return false;
 }
+
+#ifdef CONFIG_MODULES
+static void fprobe_set_ips(unsigned long *ips, unsigned int cnt, int remove,
+			   int reset)
+{
+	ftrace_set_filter_ips(&fprobe_graph_ops.ops, ips, cnt, remove, reset);
+}
 #endif
+#endif /* !CONFIG_DYNAMIC_FTRACE_WITH_ARGS && !CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
 /* fgraph_ops callback, this processes fprobes which have exit_handler. */
 static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops *gops,
@@ -601,14 +619,8 @@ static int fprobe_module_callback(struct
 	} while (node == ERR_PTR(-EAGAIN));
 	rhashtable_walk_exit(&iter);
 
-	if (alist.index > 0) {
-		ftrace_set_filter_ips(&fprobe_graph_ops.ops,
-				      alist.addrs, alist.index, 1, 0);
-#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
-		ftrace_set_filter_ips(&fprobe_ftrace_ops,
-				      alist.addrs, alist.index, 1, 0);
-#endif
-	}
+	if (alist.index > 0)
+		fprobe_set_ips(alist.addrs, alist.index, 1, 0);
 	mutex_unlock(&fprobe_mutex);
 
 	kfree(alist.addrs);


