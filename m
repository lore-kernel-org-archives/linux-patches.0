Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE30B1C3C08;
	Fri,  9 Jan 2026 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959350; cv=none; b=madsLmq0+qCBVXNAkwN9U5Uw3gBUkowFfj8t5hZbRdBvPUW9wvekeJZaEoPnj+/1r0rrsFpbFP3AD7vkifwDUugMZx6hJ+zKXoVmamHT6TzCeRfsho6EBoNVCZYDULni3ne8KX+Fq+B1joNjdFm6uS8T7+Oqn0ESUOAGRJpTOTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959350; c=relaxed/simple;
	bh=pF/pCw74npP+omGrOIystvaTr22X0Yhyp74dhgCoTA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcCD3rYVcfc5P9xnJ3mhldDZog8vzxBwTlLNCCscNWaWMcGEyT2XKlCjzvH0D3B9Os2eUh2lHfQ4SmvOO7WCVbfsOONGStKM5EAkaTGzLMGajc+vTftOYfTz/uhIEOqsGdYCrJr9YIsDCqPMFb/7+l9Po5N/4EmfQtP80ZHOrdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KINr29h1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KINr29h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AEEC4CEF1;
	Fri,  9 Jan 2026 11:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959350;
	bh=pF/pCw74npP+omGrOIystvaTr22X0Yhyp74dhgCoTA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KINr29h1j2gEZLtdicGWzpWYSuYKB0DCJvnzkRTZQI6u7lBTpeFEHb1A9fz023ZQA
	 xRlr5g4AYTS+k8W+5nSdB86P+qC5KgJlPupRtQ0Pbl+oroBLNw9rLRjAE6oVklSsOw
	 XbczYjjBcyCFwUJKufN/j6fK9b3mE7It4IkHl0CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/737] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
Date: Fri,  9 Jan 2026 12:32:40 +0100
Message-ID: <20260109112134.794092322@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 3e9a18e1c3e931abecf501cbb23d28d69f85bb56 ]

ftrace_hash_ipmodify_enable() checks IPMODIFY and DIRECT ftrace_ops on
the same kernel function. When needed, ftrace_hash_ipmodify_enable()
calls ops->ops_func() to prepare the direct ftrace (BPF trampoline) to
share the same function as the IPMODIFY ftrace (livepatch).

ftrace_hash_ipmodify_enable() is called in register_ftrace_direct() path,
but not called in modify_ftrace_direct() path. As a result, the following
operations will break livepatch:

1. Load livepatch to a kernel function;
2. Attach fentry program to the kernel function;
3. Attach fexit program to the kernel function.

After 3, the kernel function being used will not be the livepatched
version, but the original version.

Fix this by adding __ftrace_hash_update_ipmodify() to
__modify_ftrace_direct() and adjust some logic around the call.

Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20251027175023.1521602-3-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 44e31eebb7aaa..8f2d44e741510 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1937,7 +1937,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
  */
 static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 					 struct ftrace_hash *old_hash,
-					 struct ftrace_hash *new_hash)
+					 struct ftrace_hash *new_hash,
+					 bool update_target)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec, *end = NULL;
@@ -1972,10 +1973,13 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 		if (rec->flags & FTRACE_FL_DISABLED)
 			continue;
 
-		/* We need to update only differences of filter_hash */
+		/*
+		 * Unless we are updating the target of a direct function,
+		 * we only need to update differences of filter_hash
+		 */
 		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
 		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
-		if (in_old == in_new)
+		if (!update_target && (in_old == in_new))
 			continue;
 
 		if (in_new) {
@@ -1986,7 +1990,16 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 				if (is_ipmodify)
 					goto rollback;
 
-				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);
+				/*
+				 * If this is called by __modify_ftrace_direct()
+				 * then it is only changing where the direct
+				 * pointer is jumping to, and the record already
+				 * points to a direct trampoline. If it isn't,
+				 * then it is a bug to update ipmodify on a direct
+				 * caller.
+				 */
+				FTRACE_WARN_ON(!update_target &&
+					       (rec->flags & FTRACE_FL_DIRECT));
 
 				/*
 				 * Another ops with IPMODIFY is already
@@ -2043,7 +2056,7 @@ static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
 	if (ftrace_hash_empty(hash))
 		hash = NULL;
 
-	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
+	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash, false);
 }
 
 /* Disabling always succeeds */
@@ -2054,7 +2067,7 @@ static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
 	if (ftrace_hash_empty(hash))
 		hash = NULL;
 
-	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
+	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH, false);
 }
 
 static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
@@ -2068,7 +2081,7 @@ static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
 	if (ftrace_hash_empty(new_hash))
 		new_hash = NULL;
 
-	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
+	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash, false);
 }
 
 static void print_ip_ins(const char *fmt, const unsigned char *p)
@@ -5531,7 +5544,7 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_direct);
 static int
 __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 {
-	struct ftrace_hash *hash;
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	struct ftrace_func_entry *entry, *iter;
 	static struct ftrace_ops tmp_ops = {
 		.func		= ftrace_stub,
@@ -5551,13 +5564,21 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	if (err)
 		return err;
 
+	/*
+	 * Call __ftrace_hash_update_ipmodify() here, so that we can call
+	 * ops->ops_func for the ops. This is needed because the above
+	 * register_ftrace_function_nolock() worked on tmp_ops.
+	 */
+	err = __ftrace_hash_update_ipmodify(ops, hash, hash, true);
+	if (err)
+		goto out;
+
 	/*
 	 * Now the ftrace_ops_list_func() is called to do the direct callers.
 	 * We can safely change the direct functions attached to each entry.
 	 */
 	mutex_lock(&ftrace_lock);
 
-	hash = ops->func_hash->filter_hash;
 	size = 1 << hash->size_bits;
 	for (i = 0; i < size; i++) {
 		hlist_for_each_entry(iter, &hash->buckets[i], hlist) {
@@ -5572,6 +5593,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	mutex_unlock(&ftrace_lock);
 
+out:
 	/* Removing the tmp_ops will add the updated direct callers to the functions */
 	unregister_ftrace_function(&tmp_ops);
 
-- 
2.51.0



