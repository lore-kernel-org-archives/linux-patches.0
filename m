Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B42D25C717;
	Tue, 25 Mar 2025 12:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906314; cv=none; b=iGuxJoxpHcpYCQXleDVCQJSh8siVGivlut150esMh3cP5dpRIerEkXC7g+bRggd/LPh+7iEw/JYTcY1HBfMyn8Yy2My0wS5H/TOIk92D378dmCJvUZYw+N/T0XX7g1gk1ln8g8VMbLbA+IXQ+/VAeKG0KHYLkHo75RcBcW+OBkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906314; c=relaxed/simple;
	bh=S3t4Hr/ZWWQezniPLldv4O8HgdmKMxvzLUp+MUsNtcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRbVOwOiyOyo4hbexxLdzQiS7+YMeYDp/kvAmE4FvN51XGKaE4zJTX7aX5QTGOvPr3Oc09c3HTYwltcqwLQXigGq86jr7uDd5uxpvCWJSmTIZFEeVrknnHbM8s90mBMprBeD5d3YW8/J7wuDSncLDmnjvb1jm+R/Owqrn2nXwTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXSEOk6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXSEOk6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103C9C4CEE4;
	Tue, 25 Mar 2025 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906314;
	bh=S3t4Hr/ZWWQezniPLldv4O8HgdmKMxvzLUp+MUsNtcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXSEOk6J7u0FfXDfq4VaES5JPgdZGQZUwqq5l/L2Z4y4FoI1UeCintP5S0wo0Gcvm
	 syjs7669Iu+kaQ8j0NYyPNQaUBgPcKvsCvoJ+zXkEN4/RwV4UtS20uP0FJsMAwHuoE
	 41Cf6FxzelIbAVZjBc5K6xJhIx1zN9oFUbdaZNx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 051/116] tracing: tprobe-events: Fix leakage of module refcount
Date: Tue, 25 Mar 2025 08:22:18 -0400
Message-ID: <20250325122150.511958085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ac91052f0ae5be9e46211ba92cc31c0e3b0a933a upstream.

When enabling the tracepoint at loading module, the target module
refcount is incremented by find_tracepoint_in_module(). But it is
unnecessary because the module is not unloaded while processing
module loading callbacks.
Moreover, the refcount is not decremented in that function.
To be clear the module refcount handling, move the try_module_get()
callsite to trace_fprobe_create_internal(), where it is actually
required.

Link: https://lore.kernel.org/all/174182761071.83274.18334217580449925882.stgit@devnote2/

Fixes: 57a7e6de9e30 ("tracing/fprobe: Support raw tracepoints on future loaded modules")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -889,13 +889,8 @@ static void __find_tracepoint_module_cb(
 
 	if (!data->tpoint && !strcmp(data->tp_name, tp->name)) {
 		data->tpoint = tp;
-		if (!data->mod) {
+		if (!data->mod)
 			data->mod = mod;
-			if (!try_module_get(data->mod)) {
-				data->tpoint = NULL;
-				data->mod = NULL;
-			}
-		}
 	}
 }
 
@@ -907,13 +902,7 @@ static void __find_tracepoint_cb(struct
 		data->tpoint = tp;
 }
 
-/*
- * Find a tracepoint from kernel and module. If the tracepoint is in a module,
- * this increments the module refcount to prevent unloading until the
- * trace_fprobe is registered to the list. After registering the trace_fprobe
- * on the trace_fprobe list, the module refcount is decremented because
- * tracepoint_probe_module_cb will handle it.
- */
+/* Find a tracepoint from kernel and module. */
 static struct tracepoint *find_tracepoint(const char *tp_name,
 					  struct module **tp_mod)
 {
@@ -942,6 +931,7 @@ static void reenable_trace_fprobe(struct
 	}
 }
 
+/* Find a tracepoint from specified module. */
 static struct tracepoint *find_tracepoint_in_module(struct module *mod,
 						    const char *tp_name)
 {
@@ -1177,6 +1167,11 @@ static int __trace_fprobe_create(int arg
 	if (is_tracepoint) {
 		ctx.flags |= TPARG_FL_TPOINT;
 		tpoint = find_tracepoint(symbol, &tp_mod);
+		/* lock module until register this tprobe. */
+		if (tp_mod && !try_module_get(tp_mod)) {
+			tpoint = NULL;
+			tp_mod = NULL;
+		}
 		if (tpoint) {
 			ctx.funcname = kallsyms_lookup(
 				(unsigned long)tpoint->probestub,


