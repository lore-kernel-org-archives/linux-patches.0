Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03522413258;
	Tue, 31 Mar 2026 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975565; cv=none; b=gBAHQBCZjfebK1VnRH72P1hUBvCJ2GCEoktmWSikOzKZkvjmSYCg9+aJYXfB/0/Sko+2eLg6K/8kAJ26ZbU+S1kJOMFiWuYbqAZDPFVXhlLRjhuanS85lKGDX+HxpDNJy92n3+TgrYpXcP0CpXum2vUubxLUIA5bbNG9lOhshYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975565; c=relaxed/simple;
	bh=rtVFecSvs0kjaSQ91aaU9xmmqdCFXKGADyttldemOY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUMKjp8fBUqA0h/b08uJIexFTzVy+8XoudTm9SlZAuSNHXsNqRLytm3KXlDyEmZwPCioiMQzjUTEEezeuyv+mhh5gRRjK3UXkyTlzxizUXTDB1ZMys/tzroGK6nvLQfVAAlZ2Uk8yHI+6YdXOxQqiVW4xurmfPUzdRwVnTny6YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG3fUU8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG3fUU8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841EAC19423;
	Tue, 31 Mar 2026 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975564;
	bh=rtVFecSvs0kjaSQ91aaU9xmmqdCFXKGADyttldemOY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG3fUU8Pt38NAaOtf1XOwEkcaV5Ui+38RDcbCgbX61+K/OCdwLghnkkou+96asR/N
	 79Bo77FDhQwqnfiLrvrXQ8st3XfUD+Nn5FLtCPyyGW7HYlsqAY77z5oCMnryf3ZE4K
	 KS7MAk0LHhix2PBUNIIHIZNiVllscYeb9JJ/cKgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 310/342] mm/damon/core: avoid use of half-online-committed context
Date: Tue, 31 Mar 2026 18:22:23 +0200
Message-ID: <20260331161810.330097263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 26f775a054c3cda86ad465a64141894a90a9e145 upstream.

One major usage of damon_call() is online DAMON parameters update.  It is
done by calling damon_commit_ctx() inside the damon_call() callback
function.  damon_commit_ctx() can fail for two reasons: 1) invalid
parameters and 2) internal memory allocation failures.  In case of
failures, the damon_ctx that attempted to be updated (commit destination)
can be partially updated (or, corrupted from a perspective), and therefore
shouldn't be used anymore.  The function only ensures the damon_ctx object
can safely deallocated using damon_destroy_ctx().

The API callers are, however, calling damon_commit_ctx() only after
asserting the parameters are valid, to avoid damon_commit_ctx() fails due
to invalid input parameters.  But it can still theoretically fail if the
internal memory allocation fails.  In the case, DAMON may run with the
partially updated damon_ctx.  This can result in unexpected behaviors
including even NULL pointer dereference in case of damos_commit_dests()
failure [1].  Such allocation failure is arguably too small to fail, so
the real world impact would be rare.  But, given the bad consequence, this
needs to be fixed.

Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
the damon_commit_ctx() failure on the damon_ctx object.  For this,
introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
when it is failed.  kdamond_call() checks if the field is set after each
damon_call_control->fn() is executed.  If it is set, ignore remaining
callback requests and return.  All kdamond_call() callers including
kdamond_fn() also check the maybe_corrupted field right after
kdamond_call() invocations.  If the field is set, break the kdamond_fn()
main loop so that DAMON sill doesn't use the context that might be
corrupted.

[sj@kernel.org: let kdamond_call() with cancel regardless of maybe_corrupted]
  Link: https://lkml.kernel.org/r/20260320031553.2479-1-sj@kernel.org
  Link: https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org
Link: https://lkml.kernel.org/r/20260319145218.86197-1-sj@kernel.org
Link: https://lore.kernel.org/20260319043309.97966-1-sj@kernel.org [1]
Fixes: 3301f1861d34 ("mm/damon/sysfs: handle commit command using damon_call()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    7 +++++++
 mm/damon/core.c       |    9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -806,7 +806,14 @@ struct damon_ctx {
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
 
+	/*
+	 * indicate if this may be corrupted.  Currentonly this is set only for
+	 * damon_commit_ctx() failure.
+	 */
+	bool maybe_corrupted;
+
 /* public: */
+	/* Working thread of the given DAMON context */
 	struct task_struct *kdamond;
 	struct mutex kdamond_lock;
 
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1241,6 +1241,7 @@ int damon_commit_ctx(struct damon_ctx *d
 {
 	int err;
 
+	dst->maybe_corrupted = true;
 	if (!is_power_of_2(src->min_region_sz))
 		return -EINVAL;
 
@@ -1266,6 +1267,7 @@ int damon_commit_ctx(struct damon_ctx *d
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
+	dst->maybe_corrupted = false;
 	return 0;
 }
 
@@ -2610,10 +2612,11 @@ static void kdamond_call(struct damon_ct
 			complete(&control->completion);
 		} else if (control->canceled && control->dealloc_on_cancel) {
 			kfree(control);
-			continue;
 		} else {
 			list_add(&control->list, &repeat_controls);
 		}
+		if (!cancel && ctx->maybe_corrupted)
+			break;
 	}
 	control = list_first_entry_or_null(&repeat_controls,
 			struct damon_call_control, list);
@@ -2646,6 +2649,8 @@ static int kdamond_wait_activation(struc
 		kdamond_usleep(min_wait_time);
 
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			return -EINVAL;
 		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;
@@ -2731,6 +2736,8 @@ static int kdamond_fn(void *data)
 		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			break;
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else


