Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F153223710;
	Thu, 17 Apr 2025 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913533; cv=none; b=G8hbv/R7UXZ9W6bi/JhwrdyO95FcCeRdrNZ/yVP0s16B4T51TsKJbzBNwioawXTHsUKAJoTx9iqlPtZCSFmGJbdTWcxPQedQU5kISbpg3Tqe7Jwm971PB2jfdcKA7MyKjIpD+g0F+7YySxzSRn/8FM5vjT6PUeGmPwd0GgjjRfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913533; c=relaxed/simple;
	bh=ty6cm4sLquDd5bC4ObbOJBwpmOAgLd5DLE8DaaGWVgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpsKMWz8erk3snAYbuHcPyK28wukMRAvP2LQ+S6cpa9sO1ZfmKTfArDuUYS8zoxmwipUtD58zAM/gyVBF6X5k8wvmiJ81bgAmkvooeUCtEnNLwngFArWOFWScY+3eW6NDaPZHCY96kPJ0inQNCxpi28Z2XBLFlQJeTgUPOTaeIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+s1LDbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+s1LDbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68797C4CEE4;
	Thu, 17 Apr 2025 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913532;
	bh=ty6cm4sLquDd5bC4ObbOJBwpmOAgLd5DLE8DaaGWVgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+s1LDbtpuN8KxPs3NhgmZOiQ8TsrHFITNTfWMKj7EMvR7fPzu6IfU+oAvquDhjYp
	 bTVQEhGquwRW7uhny2uzxnTyMo1MoU2X3q6lXHpovj2gXgTcEw7NSmEISPHzcgEMIr
	 ZVTbGOgihBk5FyoEGyxEb/k4cbXMdzaPMkKvW1Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.14 371/449] tracing: fprobe events: Fix possible UAF on modules
Date: Thu, 17 Apr 2025 19:50:59 +0200
Message-ID: <20250417175133.188496845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -919,9 +919,15 @@ static void __find_tracepoint_module_cb(
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
 
@@ -933,7 +939,11 @@ static void __find_tracepoint_cb(struct
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
@@ -962,7 +972,10 @@ static void reenable_trace_fprobe(struct
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
@@ -1169,11 +1182,6 @@ static int trace_fprobe_create_internal(
 	if (is_tracepoint) {
 		ctx->flags |= TPARG_FL_TPOINT;
 		tpoint = find_tracepoint(symbol, &tp_mod);
-		/* lock module until register this tprobe. */
-		if (tp_mod && !try_module_get(tp_mod)) {
-			tpoint = NULL;
-			tp_mod = NULL;
-		}
 		if (tpoint) {
 			ctx->funcname = kallsyms_lookup(
 				(unsigned long)tpoint->probestub,


