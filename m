Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF37A152532;
	Thu, 17 Apr 2025 18:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913530; cv=none; b=SZQYM6aIyo3ah/74Xi21gbxDzlZQKXSQ/oCy/O43YkeQYRX7j1C/Hv+cXVKW75WWYe7bCfZxybo7c6mIHB4qc62l0tGWAEOA5uCC93u+n/ToLpzao9Ndlkvyo7XG7IdT3z4XnvzVAHs7dphWceLf3t02+LMwFrIzeNJBhz8l73E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913530; c=relaxed/simple;
	bh=EyM2JGFhEBxr/UAXTzav0+W/1rHwVODkOooq4sey4lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NucYiLHxqdQexj5XLnTw4waLBtbmGaFNmVJYUob9r8Y/bjnWku/z+/dtOfAdB3OLCbRVPF6FFuFd3lyHL6Nqb0TBAiHx1zs6K5J9nqlsDve/R4egOMbcPjYYZruQtVqcDIQyKEdCgif7rG5DllRvcva1/UkE/J4qbmPlI+oarAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yT8RUlbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT8RUlbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDFFC4CEE4;
	Thu, 17 Apr 2025 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913529;
	bh=EyM2JGFhEBxr/UAXTzav0+W/1rHwVODkOooq4sey4lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yT8RUlbksW9awYKLm1mZsLsi7HrncGQdvbc5oHKrbOmmoSkKg8DPr4DW/JOa/UZV0
	 0yFag2tf8Gqp/3mdRMxhQhFyt3S+vP++rEf1zj+/MUR9Fl8o8cU136fTElZ2khdNIa
	 0NngjYbGn3DerevREIrAZifl9d+3bHe7nkMwxvgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.14 370/449] tracing: fprobe: Fix to lock module while registering fprobe
Date: Thu, 17 Apr 2025 19:50:58 +0200
Message-ID: <20250417175133.148899867@linuxfoundation.org>
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

commit d24fa977eec53399a9a49a2e1dc592430ea0a607 upstream.

Since register_fprobe() does not get the module reference count while
registering fgraph filter, if the target functions (symbols) are in
modules, those modules can be unloaded when registering fprobe to
fgraph.

To avoid this issue, get the reference counter of module for each
symbol, and put it after register the fprobe.

Link: https://lore.kernel.org/all/174330568792.459674.16874380163991113156.stgit@devnote2/

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250325130628.3a9e234c@gandalf.local.home/
Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   67 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 19 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -544,6 +544,7 @@ struct filter_match_data {
 	size_t index;
 	size_t size;
 	unsigned long *addrs;
+	struct module **mods;
 };
 
 static int filter_match_callback(void *data, const char *name, unsigned long addr)
@@ -557,30 +558,47 @@ static int filter_match_callback(void *d
 	if (!ftrace_location(addr))
 		return 0;
 
-	if (match->addrs)
-		match->addrs[match->index] = addr;
+	if (match->addrs) {
+		struct module *mod = __module_text_address(addr);
+
+		if (mod && !try_module_get(mod))
+			return 0;
 
+		match->mods[match->index] = mod;
+		match->addrs[match->index] = addr;
+	}
 	match->index++;
 	return match->index == match->size;
 }
 
 /*
  * Make IP list from the filter/no-filter glob patterns.
- * Return the number of matched symbols, or -ENOENT.
+ * Return the number of matched symbols, or errno.
+ * If @addrs == NULL, this just counts the number of matched symbols. If @addrs
+ * is passed with an array, we need to pass the an @mods array of the same size
+ * to increment the module refcount for each symbol.
+ * This means we also need to call `module_put` for each element of @mods after
+ * using the @addrs.
  */
-static int ip_list_from_filter(const char *filter, const char *notfilter,
-			       unsigned long *addrs, size_t size)
+static int get_ips_from_filter(const char *filter, const char *notfilter,
+			       unsigned long *addrs, struct module **mods,
+			       size_t size)
 {
 	struct filter_match_data match = { .filter = filter, .notfilter = notfilter,
-		.index = 0, .size = size, .addrs = addrs};
+		.index = 0, .size = size, .addrs = addrs, .mods = mods};
 	int ret;
 
+	if (addrs && !mods)
+		return -EINVAL;
+
 	ret = kallsyms_on_each_symbol(filter_match_callback, &match);
 	if (ret < 0)
 		return ret;
-	ret = module_kallsyms_on_each_symbol(NULL, filter_match_callback, &match);
-	if (ret < 0)
-		return ret;
+	if (IS_ENABLED(CONFIG_MODULES)) {
+		ret = module_kallsyms_on_each_symbol(NULL, filter_match_callback, &match);
+		if (ret < 0)
+			return ret;
+	}
 
 	return match.index ?: -ENOENT;
 }
@@ -642,24 +660,35 @@ static int fprobe_init(struct fprobe *fp
  */
 int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter)
 {
-	unsigned long *addrs;
-	int ret;
+	unsigned long *addrs __free(kfree) = NULL;
+	struct module **mods __free(kfree) = NULL;
+	int ret, num;
 
 	if (!fp || !filter)
 		return -EINVAL;
 
-	ret = ip_list_from_filter(filter, notfilter, NULL, FPROBE_IPS_MAX);
-	if (ret < 0)
-		return ret;
+	num = get_ips_from_filter(filter, notfilter, NULL, NULL, FPROBE_IPS_MAX);
+	if (num < 0)
+		return num;
 
-	addrs = kcalloc(ret, sizeof(unsigned long), GFP_KERNEL);
+	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs)
 		return -ENOMEM;
-	ret = ip_list_from_filter(filter, notfilter, addrs, ret);
-	if (ret > 0)
-		ret = register_fprobe_ips(fp, addrs, ret);
 
-	kfree(addrs);
+	mods = kcalloc(num, sizeof(*mods), GFP_KERNEL);
+	if (!mods)
+		return -ENOMEM;
+
+	ret = get_ips_from_filter(filter, notfilter, addrs, mods, num);
+	if (ret < 0)
+		return ret;
+
+	ret = register_fprobe_ips(fp, addrs, ret);
+
+	for (int i = 0; i < num; i++) {
+		if (mods[i])
+			module_put(mods[i]);
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_fprobe);


