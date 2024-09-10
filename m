Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308D18B462;
	Tue, 10 Sep 2024 09:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961876; cv=none; b=j1zsPtuoR/NQ9WndHU+vSAzf+qtO2B+oC9ZCWGywsDPvtXFL4cRA8XAof3WLg3h5jdKS94Z/ZMyScHZ01CLyVoFL2IqVO+p4vBOjNjunVprKtslgxdGAkJfN5kdrPAzXaqy2vAi+zuMTT3qwG27NGkPJdcL0X9N5cnd6mhEyNJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961876; c=relaxed/simple;
	bh=tlNNzTzI/5c2lLikZvBMCJ1sdtKE0NF20BjhNAgWhAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoSpvlFT9xGmG6KQO4YPKjpA3e4i9UTaFDHvokvucGQuNsqrdfvJDS5tKP9nL6kWstdKWDucArE052HGvqEEi7zBbpZS/WTviAxw4Ro75NgyU9btfb7dO1Zy+8Xh/IDoosJB2p03pB+PDhcZNV/wMeCXcK1mlctn/O2Vel9YLPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrHoHHGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrHoHHGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A8FC4CEC6;
	Tue, 10 Sep 2024 09:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961875;
	bh=tlNNzTzI/5c2lLikZvBMCJ1sdtKE0NF20BjhNAgWhAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrHoHHGh5j/HFRbI95BYBQGdhNUK1qCIcyNoCakkZlQgrJ6ncKmzsXx/KCPPfo2fO
	 iK0jJjtbfX+6ZzFKVPwbrQpWiLpWEh92MAcPQYy8trAvsSSTJFCgvqgUJyE7m0HCYJ
	 LfMpkeUECU0sHNTSu3Ur7oQNVApr0zSAMjGrwQ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 218/375] tracing/kprobes: Add symbol counting check when module loads
Date: Tue, 10 Sep 2024 11:30:15 +0200
Message-ID: <20240910092629.861905554@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 9d8616034f161222a4ac166c1b42b6d79961c005 ]

Currently, kprobe event checks whether the target symbol name is unique
or not, so that it does not put a probe on an unexpected place. But this
skips the check if the target is on a module because the module may not
be loaded.

To fix this issue, this patch checks the number of probe target symbols
in a target module when the module is loaded. If the probe is not on the
unique name symbols in the module, it will be rejected at that point.

Note that the symbol which has a unique name in the target module,
it will be accepted even if there are same-name symbols in the
kernel or other modules,

Link: https://lore.kernel.org/all/172016348553.99543.2834679315611882137.stgit@devnote2/

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 125 +++++++++++++++++++++++-------------
 1 file changed, 81 insertions(+), 44 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 16383247bdbf..0d88922f8763 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -678,6 +678,21 @@ static int register_trace_kprobe(struct trace_kprobe *tk)
 }
 
 #ifdef CONFIG_MODULES
+static int validate_module_probe_symbol(const char *modname, const char *symbol);
+
+static int register_module_trace_kprobe(struct module *mod, struct trace_kprobe *tk)
+{
+	const char *p;
+	int ret = 0;
+
+	p = strchr(trace_kprobe_symbol(tk), ':');
+	if (p)
+		ret = validate_module_probe_symbol(module_name(mod), p + 1);
+	if (!ret)
+		ret = __register_trace_kprobe(tk);
+	return ret;
+}
+
 /* Module notifier call back, checking event on the module */
 static int trace_kprobe_module_callback(struct notifier_block *nb,
 				       unsigned long val, void *data)
@@ -696,7 +711,7 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
 		if (trace_kprobe_within_module(tk, mod)) {
 			/* Don't need to check busy - this should have gone. */
 			__unregister_trace_kprobe(tk);
-			ret = __register_trace_kprobe(tk);
+			ret = register_module_trace_kprobe(mod, tk);
 			if (ret)
 				pr_warn("Failed to re-register probe %s on %s: %d\n",
 					trace_probe_name(&tk->tp),
@@ -747,17 +762,68 @@ static int count_mod_symbols(void *data, const char *name, unsigned long unused)
 	return 0;
 }
 
-static unsigned int number_of_same_symbols(char *func_name)
+static unsigned int number_of_same_symbols(const char *mod, const char *func_name)
 {
 	struct sym_count_ctx ctx = { .count = 0, .name = func_name };
 
-	kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
+	if (!mod)
+		kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
 
-	module_kallsyms_on_each_symbol(NULL, count_mod_symbols, &ctx);
+	module_kallsyms_on_each_symbol(mod, count_mod_symbols, &ctx);
 
 	return ctx.count;
 }
 
+static int validate_module_probe_symbol(const char *modname, const char *symbol)
+{
+	unsigned int count = number_of_same_symbols(modname, symbol);
+
+	if (count > 1) {
+		/*
+		 * Users should use ADDR to remove the ambiguity of
+		 * using KSYM only.
+		 */
+		return -EADDRNOTAVAIL;
+	} else if (count == 0) {
+		/*
+		 * We can return ENOENT earlier than when register the
+		 * kprobe.
+		 */
+		return -ENOENT;
+	}
+	return 0;
+}
+
+static int validate_probe_symbol(char *symbol)
+{
+	struct module *mod = NULL;
+	char *modname = NULL, *p;
+	int ret = 0;
+
+	p = strchr(symbol, ':');
+	if (p) {
+		modname = symbol;
+		symbol = p + 1;
+		*p = '\0';
+		/* Return 0 (defer) if the module does not exist yet. */
+		rcu_read_lock_sched();
+		mod = find_module(modname);
+		if (mod && !try_module_get(mod))
+			mod = NULL;
+		rcu_read_unlock_sched();
+		if (!mod)
+			goto out;
+	}
+
+	ret = validate_module_probe_symbol(modname, symbol);
+out:
+	if (p)
+		*p = ':';
+	if (mod)
+		module_put(mod);
+	return ret;
+}
+
 static int trace_kprobe_entry_handler(struct kretprobe_instance *ri,
 				      struct pt_regs *regs);
 
@@ -881,6 +947,14 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 			trace_probe_log_err(0, BAD_PROBE_ADDR);
 			goto parse_error;
 		}
+		ret = validate_probe_symbol(symbol);
+		if (ret) {
+			if (ret == -EADDRNOTAVAIL)
+				trace_probe_log_err(0, NON_UNIQ_SYMBOL);
+			else
+				trace_probe_log_err(0, BAD_PROBE_ADDR);
+			goto parse_error;
+		}
 		if (is_return)
 			ctx.flags |= TPARG_FL_RETURN;
 		ret = kprobe_on_func_entry(NULL, symbol, offset);
@@ -893,31 +967,6 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 		}
 	}
 
-	if (symbol && !strchr(symbol, ':')) {
-		unsigned int count;
-
-		count = number_of_same_symbols(symbol);
-		if (count > 1) {
-			/*
-			 * Users should use ADDR to remove the ambiguity of
-			 * using KSYM only.
-			 */
-			trace_probe_log_err(0, NON_UNIQ_SYMBOL);
-			ret = -EADDRNOTAVAIL;
-
-			goto error;
-		} else if (count == 0) {
-			/*
-			 * We can return ENOENT earlier than when register the
-			 * kprobe.
-			 */
-			trace_probe_log_err(0, BAD_PROBE_ADDR);
-			ret = -ENOENT;
-
-			goto error;
-		}
-	}
-
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, gbuf,
@@ -1835,21 +1884,9 @@ create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
 	char *event;
 
 	if (func) {
-		unsigned int count;
-
-		count = number_of_same_symbols(func);
-		if (count > 1)
-			/*
-			 * Users should use addr to remove the ambiguity of
-			 * using func only.
-			 */
-			return ERR_PTR(-EADDRNOTAVAIL);
-		else if (count == 0)
-			/*
-			 * We can return ENOENT earlier than when register the
-			 * kprobe.
-			 */
-			return ERR_PTR(-ENOENT);
+		ret = validate_probe_symbol(func);
+		if (ret)
+			return ERR_PTR(ret);
 	}
 
 	/*
-- 
2.43.0



