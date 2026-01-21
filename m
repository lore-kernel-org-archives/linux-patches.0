Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C63C1987;
	Wed, 21 Jan 2026 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020495; cv=none; b=Ab3C3Jue81u9Vhrln4ya9Z2Ncwe8Fwbb2/Y+JqRWuhCsMbr33b6Lt201ouPgXRJvS8CLU7DpXbEO5eRM+EkvDNCpqx9e20+sE201AQxdcXTmOxVmT+BRn8b40ZTIm3K9pe9NMIhRyhnUgofkvBsudXEdKSgYkiYdbCIAwrF9KXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020495; c=relaxed/simple;
	bh=8zBnjBz2UNFV6HEeuqnaDqCJSj6nOK9HhIWxrtLVg5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUe/bVdOI5YtKFjP9z6B2U1A1Qy+pnmR6M51wUqbP7B7gYRYI9pw+LNEl1KOCzuz0nH4bEeTJUm4tKhVJd6fjxfSDD6/yjCah/qUkqBaKZvr6DTVfDAkKl+0ztMrctlrJSntScEJUjlwxDW1/vOqQZxXWERFheQuLA6Fu61XYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7WJ4Y/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7WJ4Y/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F65CC4CEF1;
	Wed, 21 Jan 2026 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020494;
	bh=8zBnjBz2UNFV6HEeuqnaDqCJSj6nOK9HhIWxrtLVg5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7WJ4Y/XNFuTzGGxOJB2ig6LqNLodCZLYqLz6nmXYDw8SQPJWTqXaZgck1ur28R7U
	 hK3Uj33vSxdCiAxblhPcxLeIbjsQW82+BrMA3zidlRJdFPJkurQ87QDOThdbinBvD0
	 dBaWeZvLLXdgKqOKj/czbCF1QcsONd4EAXVpk45I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	JaeJoon Jung <rgbi3307@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 142/198] mm/damon/core: remove call_control in inactive contexts
Date: Wed, 21 Jan 2026 19:16:10 +0100
Message-ID: <20260121181423.663508848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit f9132fbc2e83baf2c45a77043672a63a675c9394 upstream.

If damon_call() is executed against a DAMON context that is not running,
the function returns error while keeping the damon_call_control object
linked to the context's call_controls list.  Let's suppose the object is
deallocated after the damon_call(), and yet another damon_call() is
executed against the same context.  The function tries to add the new
damon_call_control object to the call_controls list, which still has the
pointer to the previous damon_call_control object, which is deallocated.
As a result, use-after-free happens.

This can actually be triggered using the DAMON sysfs interface.  It is not
easily exploitable since it requires the sysfs write permission and making
a definitely weird file writes, though.  Please refer to the report for
more details about the issue reproduction steps.

Fix the issue by making two changes.  Firstly, move the final
kdamond_call() for cancelling all existing damon_call() requests from
terminating DAMON context to be done before the ctx->kdamond reset.  This
makes any code that sees NULL ctx->kdamond can safely assume the context
may not access damon_call() requests anymore.  Secondly, let damon_call()
to cleanup the damon_call_control objects that were added to the
already-terminated DAMON context, before returning the error.

Link: https://lkml.kernel.org/r/20251231012315.75835-1-sj@kernel.org
Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1426,6 +1426,35 @@ bool damon_is_running(struct damon_ctx *
 	return running;
 }
 
+/*
+ * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
+ *				      an inactive context.
+ * @ctx:	The inactive DAMON context.
+ * @control:	Control variable of the call request.
+ *
+ * This function is called in a case that @control is added to @ctx but @ctx is
+ * not running (inactive).  See if @ctx handled @control or not, and cleanup
+ * @control if it was not handled.
+ *
+ * Returns 0 if @control was handled by @ctx, negative error code otherwise.
+ */
+static int damon_call_handle_inactive_ctx(
+		struct damon_ctx *ctx, struct damon_call_control *control)
+{
+	struct damon_call_control *c;
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_for_each_entry(c, &ctx->call_controls, list) {
+		if (c == control) {
+			list_del(&control->list);
+			mutex_unlock(&ctx->call_controls_lock);
+			return -EINVAL;
+		}
+	}
+	mutex_unlock(&ctx->call_controls_lock);
+	return 0;
+}
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1456,7 +1485,7 @@ int damon_call(struct damon_ctx *ctx, st
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
-		return -EINVAL;
+		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);
@@ -2704,13 +2733,13 @@ done:
 	if (ctx->ops.cleanup)
 		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
+	kdamond_call(ctx, true);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
 	mutex_lock(&damon_lock);


