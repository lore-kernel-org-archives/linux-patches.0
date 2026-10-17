Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC4018787A;
	Sat, 17 Oct 2026 15:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252627; cv=none; b=Pt3Z2KPZAp0Jmn/3zaC3wdvx84KJZbHP1tXeTy1aLOiPB68oOCW1CfsSlu2M+k9vLwFSKOcAeDmLvOmZ+yTOBlrftXAxZxdDLnhj1geGLF2yKuFm4lm3FIhW0rR31Kgez/p61fdzhSFNgSJS7PFDTVDULb1FJkbHaAhenYKdg2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252627; c=relaxed/simple;
	bh=IMVO5lZu8Q4O9cK6Z0wUgelRDNt82kMZOcAtsa5+lDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMjHtL9dhqaA03P8MeAP5fRlGPx+gOYJfkSJfkzYY7XMhM7Zq4ft583obwSdd2tf3RPBEheF842UllL6Ulrkw9aSumA7zR59js5MFVWaBOAACF7ewInOf4l2XCXFXyG67lUqaFkOd386TGchEaGVypNxDRpaaxlY9TfH59/70S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yie2Y2Vw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yie2Y2Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E661F000C4;
	Sat, 17 Oct 2026 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252626;
	bh=OS6JM6aoQKzmGJI1/FikYZXbE9aIx6fwiAe9+qHgWZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yie2Y2VwSHYHTqbhyOqY4LOsr+nSeoAG8oz4Z7F3AV0cPJv2m7rnTOlHYD1jHzyV0
	 YA1Q1yV0/v2JggCVwXkEeQCnG99QUgqn4La73QGDpDqGyTH5lf1CYT8eLMcW8tZLUQ
	 teB7Lo+srFX0/zsbshVQmScC3EWkrQTeOaN+DuQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 42/52] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
Date: Sat, 17 Oct 2026 17:54:43 +0200
Message-ID: <20261017155106.194159839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

[ Upstream commit 33c3f6c2b48cd84b441dba1ee3e62290e53930f4 ]

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

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bb4dd13984d39..656a314ad2159 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -785,6 +785,7 @@ struct damon_ctx {
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
+	bool walk_control_obsolete;
 	struct mutex walk_control_lock;
 
 	/*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index c77d17cb7a68b..4e6e3d7d0a5c0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1568,6 +1568,10 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
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
@@ -1575,19 +1579,16 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
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
@@ -2725,6 +2726,9 @@ static int kdamond_fn(void *data)
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = false;
+	mutex_unlock(&ctx->walk_control_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -2838,6 +2842,9 @@ static int kdamond_fn(void *data)
 	ctx->call_controls_obsolete = true;
 	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = true;
+	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
-- 
2.53.0



