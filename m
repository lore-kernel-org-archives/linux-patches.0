Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472C3365A19;
	Tue, 12 May 2026 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609445; cv=none; b=g9Jn9d1UjP1OAQSGP73VBgJdFJbmd524XWufVrXmcLI0xhuRzN7gAkGWnpHqdptg3b5TDX9prWYufdO/pRTbOIlmGs59zHAQD2kgL8/0bgQaGfldpqbxtug1IAmbNWm+zYwZUqYAZ7gpVkBLRJ9VTAyS031OZ40miUb95P1YlgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609445; c=relaxed/simple;
	bh=irruQICVob6U5EVWdLIBSaU6k9mJy6rvFNWbfgJwhz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+HXJSh/v31o55iCfULqdhltBGlEwu/AsxawEgtRDTL7EKdfGuRG6UAIhOyuQkyysuSmxxxjKHaFP42osJ1Ye41YfVpMkxHzNDJ8tuYGRez5E8+ckcuLq3jYBeQpAt/klZA+PTsANbA+gaaIoMr39HUW5T9SMpn4JKszIewnac0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMFJwZ3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMFJwZ3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18AEC2BCB0;
	Tue, 12 May 2026 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609445;
	bh=irruQICVob6U5EVWdLIBSaU6k9mJy6rvFNWbfgJwhz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMFJwZ3oBnlJuALv4jUOLwxQV+/II6ltxFMlDTz675AbGdJ2JbXCXMFBg4V8QJels
	 c/RlIpZ0+enYR3fJtMNpOH347ylCUY95xhGiUrf64akfAZfRHmwHkEDx/MQRDLNH0c
	 NYNiRi67cjyDlaocjokCEZA/p3fw0wfYcOx8M9ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.0 161/307] tracing/fprobe: Remove fprobe from hash in failure path
Date: Tue, 12 May 2026 19:39:16 +0200
Message-ID: <20260512173943.521380133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 845947aca6814f5723ed65e556eb5ee09493f05b upstream.

When register_fprobe_ips() fails, it tries to remove a list of
fprobe_hash_node from fprobe_ip_table, but it missed to remove
fprobe itself from fprobe_table. Moreover, when removing
the fprobe_hash_node which is added to rhltable once, it must
use kfree_rcu() after removing from rhltable.

To fix these issues, this reuses unregister_fprobe() internal
code to rollback the half-way registered fprobe.

Link: https://lore.kernel.org/all/177669366417.132053.17874946321744910456.stgit@mhiramat.tok.corp.google.com/

Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   90 ++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -79,20 +79,27 @@ static const struct rhashtable_params fp
 };
 
 /* Node insertion and deletion requires the fprobe_mutex */
-static int insert_fprobe_node(struct fprobe_hlist_node *node)
+static int insert_fprobe_node(struct fprobe_hlist_node *node, struct fprobe *fp)
 {
+	int ret;
+
 	lockdep_assert_held(&fprobe_mutex);
 
-	return rhltable_insert(&fprobe_ip_table, &node->hlist, fprobe_rht_params);
+	ret = rhltable_insert(&fprobe_ip_table, &node->hlist, fprobe_rht_params);
+	/* Set the fprobe pointer if insertion was successful. */
+	if (!ret)
+		WRITE_ONCE(node->fp, fp);
+	return ret;
 }
 
 /* Return true if there are synonims */
 static bool delete_fprobe_node(struct fprobe_hlist_node *node)
 {
-	lockdep_assert_held(&fprobe_mutex);
 	bool ret;
 
-	/* Avoid double deleting */
+	lockdep_assert_held(&fprobe_mutex);
+
+	/* Avoid double deleting and non-inserted nodes */
 	if (READ_ONCE(node->fp) != NULL) {
 		WRITE_ONCE(node->fp, NULL);
 		rhltable_remove(&fprobe_ip_table, &node->hlist,
@@ -755,7 +762,6 @@ static int fprobe_init(struct fprobe *fp
 	fp->hlist_array = hlist_array;
 	hlist_array->fp = fp;
 	for (i = 0; i < num; i++) {
-		hlist_array->array[i].fp = fp;
 		addr = ftrace_location(addrs[i]);
 		if (!addr) {
 			fprobe_fail_cleanup(fp);
@@ -819,6 +825,8 @@ int register_fprobe(struct fprobe *fp, c
 }
 EXPORT_SYMBOL_GPL(register_fprobe);
 
+static int unregister_fprobe_nolock(struct fprobe *fp);
+
 /**
  * register_fprobe_ips() - Register fprobe to ftrace by address.
  * @fp: A fprobe data structure to be registered.
@@ -845,28 +853,25 @@ int register_fprobe_ips(struct fprobe *f
 	if (ret)
 		return ret;
 
-	hlist_array = fp->hlist_array;
 	if (fprobe_is_ftrace(fp))
 		ret = fprobe_ftrace_add_ips(addrs, num);
 	else
 		ret = fprobe_graph_add_ips(addrs, num);
-
-	if (!ret) {
-		add_fprobe_hash(fp);
-		for (i = 0; i < hlist_array->size; i++) {
-			ret = insert_fprobe_node(&hlist_array->array[i]);
-			if (ret)
-				break;
-		}
-		/* fallback on insert error */
-		if (ret) {
-			for (i--; i >= 0; i--)
-				delete_fprobe_node(&hlist_array->array[i]);
-		}
+	if (ret) {
+		fprobe_fail_cleanup(fp);
+		return ret;
 	}
 
-	if (ret)
-		fprobe_fail_cleanup(fp);
+	hlist_array = fp->hlist_array;
+	ret = add_fprobe_hash(fp);
+	for (i = 0; i < hlist_array->size && !ret; i++)
+		ret = insert_fprobe_node(&hlist_array->array[i], fp);
+
+	if (ret) {
+		unregister_fprobe_nolock(fp);
+		/* In error case, wait for clean up safely. */
+		synchronize_rcu();
+	}
 
 	return ret;
 }
@@ -910,27 +915,12 @@ bool fprobe_is_registered(struct fprobe
 	return true;
 }
 
-/**
- * unregister_fprobe() - Unregister fprobe.
- * @fp: A fprobe data structure to be unregistered.
- *
- * Unregister fprobe (and remove ftrace hooks from the function entries).
- *
- * Return 0 if @fp is unregistered successfully, -errno if not.
- */
-int unregister_fprobe(struct fprobe *fp)
+static int unregister_fprobe_nolock(struct fprobe *fp)
 {
-	struct fprobe_hlist *hlist_array;
+	struct fprobe_hlist *hlist_array = fp->hlist_array;
 	unsigned long *addrs = NULL;
-	int ret = 0, i, count;
+	int i, count;
 
-	mutex_lock(&fprobe_mutex);
-	if (!fp || !fprobe_registered(fp)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	hlist_array = fp->hlist_array;
 	addrs = kcalloc(hlist_array->size, sizeof(unsigned long), GFP_KERNEL);
 	if (!addrs) {
 		ret = -ENOMEM;	/* TODO: Fallback to one-by-one loop */
@@ -952,12 +942,26 @@ int unregister_fprobe(struct fprobe *fp)
 
 	kfree_rcu(hlist_array, rcu);
 	fp->hlist_array = NULL;
+	kfree(addrs);
 
-out:
-	mutex_unlock(&fprobe_mutex);
+	return 0;
+}
 
-	kfree(addrs);
-	return ret;
+/**
+ * unregister_fprobe() - Unregister fprobe.
+ * @fp: A fprobe data structure to be unregistered.
+ *
+ * Unregister fprobe (and remove ftrace hooks from the function entries).
+ *
+ * Return 0 if @fp is unregistered successfully, -errno if not.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	guard(mutex)(&fprobe_mutex);
+	if (!fp || !fprobe_registered(fp))
+		return -EINVAL;
+
+	return unregister_fprobe_nolock(fp);
 }
 EXPORT_SYMBOL_GPL(unregister_fprobe);
 


