Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BA2E2F0E;
	Mon,  4 May 2026 13:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903048; cv=none; b=Ak5bwRw0+daayRaKC3eopNS5aKGonyeOH4FfQya6XB+Q9tXG3xzWyu82X+Cv0jEiMzPJhyemCafUhuS2I++rcN3FazFRvtPaL55zx+1lQmWyn1Qofvwg9oAQpy3VNGswaZ20g/6kvjBfGNcUzSKc1rnnzEuOLk8CpXP1QWL+/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903048; c=relaxed/simple;
	bh=A3S5H2ssC7CBXTPO362D0XQmXeBX3WylB4TpNdCzvAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFfAwbk8sVLKnaeodo6F6n9YBk8GKs3CZTGuXDlpiBuR6Y8acsu1aR7pPea1B7ng2cszDaaJ4vjePMwKZ1zs+uU79rUuJjdSmeP2x+0ROhxzP6lZU9WyadNdl5N+C1s3CP+9+UvxohA1SRXIX/53rYRXYeYomeRUx+Ls82acV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sik/TCx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sik/TCx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3A1C2BCB8;
	Mon,  4 May 2026 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903048;
	bh=A3S5H2ssC7CBXTPO362D0XQmXeBX3WylB4TpNdCzvAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sik/TCx/1zbF5LidKewiDCsuFM9QE1ghri3K6AcpZHpab0tioPtddRQx2TAeg4M1G
	 RQEQ3Eiz4phzyQ9q2Lu2DVbTXMyKrxhjgosFPUJ/v9uD4D7BjTVP1OsN1cqv2MKLGh
	 8Mjcjo/3ovdfUVZUZGloH3VhKVY9xktdlifOU+Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 083/307] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
Date: Mon,  4 May 2026 15:49:28 +0200
Message-ID: <20260504135145.935248212@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 33c3f6c2b48cd84b441dba1ee3e62290e53930f4 upstream.

When kdamond_fn() main loop is finished, the function cancels remaining
damos_walk() request and unset the damon_ctx->kdamond so that API callers
and API functions themselves can show the context is terminated.
damos_walk() adds the caller's request to the queue first.  After that, it
shows if the kdamond of the damon_ctx is still running (damon_ctx->kdamond
is set).  Only if the kdamond is running, damos_walk() starts waiting for
the kdamond's handling of the newly added request.

The damos_walk() requests registration and damon_ctx->kdamond unset are
protected by different mutexes, though.  Hence, damos_walk() could race
with damon_ctx->kdamond unset, and result in deadlocks.

For example, let's suppose kdamond successfully finished the damow_walk()
request cancelling.  Right after that, damos_walk() is called for the
context.  It registers the new request, and shows the context is still
running, because damon_ctx->kdamond unset is not yet done.  Hence the
damos_walk() caller starts waiting for the handling of the request.
However, the kdamond is already on the termination steps, so it never
handles the new request.  As a result, the damos_walk() caller thread
infinitely waits.

Fix this by introducing another damon_ctx field, namely
walk_control_obsolete.  It is protected by the
damon_ctx->walk_control_lock, which protects damos_walk() request
registration.  Initialize (unset) it in kdamond_fn() before letting
damon_start() returns and set it just before the cancelling of the
remaining damos_walk() request is executed.  damos_walk() reads the
obsolete field under the lock and avoids adding a new request.

After this change, only requests that are guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no longer needed.  Remove it together.

The issue is found by sashiko [1].


Link: https://lore.kernel.org/20260327233319.3528-3-sj@kernel.org
Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    1 +
 mm/damon/core.c       |   21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -809,6 +809,7 @@ struct damon_ctx {
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
+	bool walk_control_obsolete;
 	struct mutex walk_control_lock;
 
 	/*
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1528,6 +1528,10 @@ int damon_call(struct damon_ctx *ctx, st
  * passed at least one &damos->apply_interval_us, kdamond marks the request as
  * completed so that damos_walk() can wakeup and return.
  *
+ * Note that this function should be called only after damon_start() with the
+ * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
+ * wait.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
@@ -1535,19 +1539,16 @@ int damos_walk(struct damon_ctx *ctx, st
 	init_completion(&control->completion);
 	control->canceled = false;
 	mutex_lock(&ctx->walk_control_lock);
+	if (ctx->walk_control_obsolete) {
+		mutex_unlock(&ctx->walk_control_lock);
+		return -ECANCELED;
+	}
 	if (ctx->walk_control) {
 		mutex_unlock(&ctx->walk_control_lock);
 		return -EBUSY;
 	}
 	ctx->walk_control = control;
 	mutex_unlock(&ctx->walk_control_lock);
-	if (!damon_is_running(ctx)) {
-		mutex_lock(&ctx->walk_control_lock);
-		if (ctx->walk_control == control)
-			ctx->walk_control = NULL;
-		mutex_unlock(&ctx->walk_control_lock);
-		return -EINVAL;
-	}
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;
@@ -2731,6 +2732,9 @@ static int kdamond_fn(void *data)
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = false;
+	mutex_unlock(&ctx->walk_control_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -2839,6 +2843,9 @@ done:
 	ctx->call_controls_obsolete = true;
 	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = true;
+	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);


