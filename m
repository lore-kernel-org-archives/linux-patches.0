Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6C8256C80;
	Thu, 17 Apr 2025 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916135; cv=none; b=Qgw/gAHSnE+tEVWt579jxpPB34lljrStBKK+7bTEC2e6uoM9K6BVd38Y+HObhbPJTD+L5maBExm+9DsWuBXSoPqlXnYJwdfTiC+lhKaZ4LeK7gdX7PWnAlX/jBmKe24H5m7CUtStUPfxRgjV28jMFaiz8w0sfaEWPRzlI/n67Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916135; c=relaxed/simple;
	bh=U9AftH/FfblJgHwmfnDT8f2pK2Cb3nZXYMB7dvznl9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDCLYFImgiB+T+29os2+bNiU0JE8SKTdaYTq46kRptV0lELAcOYAanGgqZRZFlos3i9PbYfligndTwBuFcA57xrcHP4vAH1HXsNMJo8ICrPZCAYzUPi7HZMXli/J9mEh7CUCt9c4FpWEQt15MEQ/oBPChLU/WKN2PyrH5TswUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi5AnYce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi5AnYce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3286C4CEE4;
	Thu, 17 Apr 2025 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916135;
	bh=U9AftH/FfblJgHwmfnDT8f2pK2Cb3nZXYMB7dvznl9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi5AnYcesgmONX4AVSZH6ODwYah4ENDY0wBY9gpnGnmg6N5XKTEXX9LypqgtCAd4D
	 vCmQJarRwde/FsQg7KhY0p5AEElZSvVrY+l3hqHLVr7xFNLeu+GngL/c2L5FUcLceT
	 WRd6bLqigykVYb4gZ0dIiwgWAYPHmktWB0HfphDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 315/393] tracing: fprobe events: Fix possible UAF on modules
Date: Thu, 17 Apr 2025 19:52:04 +0200
Message-ID: <20250417175120.276195339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

commit dd941507a9486252d6fcf11814387666792020f3 upstream.

Commit ac91052f0ae5 ("tracing: tprobe-events: Fix leakage of module
refcount") moved try_module_get() from __find_tracepoint_module_cb()
to find_tracepoint() caller, but that introduced a possible UAF
because the module can be unloaded before try_module_get(). In this
case, the module object should be freed too. Thus, try_module_get()
does not only fail but may access to the freed object.

To avoid that, try_module_get() in __find_tracepoint_module_cb()
again.

Link: https://lore.kernel.org/all/174342990779.781946.9138388479067729366.stgit@devnote2/

Fixes: ac91052f0ae5 ("tracing: tprobe-events: Fix leakage of module refcount")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -888,9 +888,15 @@ static void __find_tracepoint_module_cb(
 	struct __find_tracepoint_cb_data *data = priv;
 
 	if (!data->tpoint && !strcmp(data->tp_name, tp->name)) {
-		data->tpoint = tp;
-		if (!data->mod)
+		/* If module is not specified, try getting module refcount. */
+		if (!data->mod && mod) {
+			/* If failed to get refcount, ignore this tracepoint. */
+			if (!try_module_get(mod))
+				return;
+
 			data->mod = mod;
+		}
+		data->tpoint = tp;
 	}
 }
 
@@ -902,7 +908,11 @@ static void __find_tracepoint_cb(struct
 		data->tpoint = tp;
 }
 
-/* Find a tracepoint from kernel and module. */
+/*
+ * Find a tracepoint from kernel and module. If the tracepoint is on the module,
+ * the module's refcount is incremented and returned as *@tp_mod. Thus, if it is
+ * not NULL, caller must call module_put(*tp_mod) after used the tracepoint.
+ */
 static struct tracepoint *find_tracepoint(const char *tp_name,
 					  struct module **tp_mod)
 {
@@ -931,7 +941,10 @@ static void reenable_trace_fprobe(struct
 	}
 }
 
-/* Find a tracepoint from specified module. */
+/*
+ * Find a tracepoint from specified module. In this case, this does not get the
+ * module's refcount. The caller must ensure the module is not freed.
+ */
 static struct tracepoint *find_tracepoint_in_module(struct module *mod,
 						    const char *tp_name)
 {
@@ -1167,11 +1180,6 @@ static int __trace_fprobe_create(int arg
 	if (is_tracepoint) {
 		ctx.flags |= TPARG_FL_TPOINT;
 		tpoint = find_tracepoint(symbol, &tp_mod);
-		/* lock module until register this tprobe. */
-		if (tp_mod && !try_module_get(tp_mod)) {
-			tpoint = NULL;
-			tp_mod = NULL;
-		}
 		if (tpoint) {
 			ctx.funcname = kallsyms_lookup(
 				(unsigned long)tpoint->probestub,


