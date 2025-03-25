Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B702571AE;
	Tue, 25 Mar 2025 12:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906022; cv=none; b=tVg+fEtfmEosBvNSDxOT2qE1ouzRhxcDMdvsJuqmwd4Qf4RHhQjV9lOYUzm4q9YB/woTehhxtpRMX0wPOPTBXk4xBWE38rnik+LIZtggzcQDGoMkHGp6zPOR47Pbc/W+scPLAZ9k2uWMQzs4luz+DNbrexCOqp8IUtKHtYW7inQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906022; c=relaxed/simple;
	bh=0gBmFSO1jYwDbKGh2he7uCd0cb51yWs+kUtYggTTS7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt3ekaU1GOsErBRjljSC8nYaF/ofHpD0Nzv0L4g300MchNctadAV2+TExDYGKRVbyvOpnWmxp8dVrIdu3PIkYEBkO+pUQkfyJdbgj38hhOS0czc0qhZY+DNMt8ujW/cpu0sB+WhWirgTykDY/2A25WxGheyvQKps/+zb1lPsjBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljcT9KWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljcT9KWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30497C4CEE4;
	Tue, 25 Mar 2025 12:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906022;
	bh=0gBmFSO1jYwDbKGh2he7uCd0cb51yWs+kUtYggTTS7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljcT9KWKpdeWdUxRK3+BTZc1E5u2i8Q0A5sWsPk7wMGc6kpkV1z7TFIjI6BSoH95F
	 CwY4GvGnx/w5nswzRYgo6jRa+kqL8f42dtF8+0pbIvcmZA+vF9rXcimXF6idQd5lkk
	 akQ45YtBupRe1Oqu1vmxHzELWGUqlEBOQ6qIcMTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.13 053/119] tracing: tprobe-events: Fix leakage of module refcount
Date: Tue, 25 Mar 2025 08:21:51 -0400
Message-ID: <20250325122150.408471091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


