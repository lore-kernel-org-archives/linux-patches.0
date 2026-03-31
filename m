Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186A130F523;
	Tue, 31 Mar 2026 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977002; cv=none; b=aZsw6Tjdjkui9I1aD4BUl5nWOfcnWUsxuYDfJGL9hJGR9Ykl2R41XbVSee4CtOuNsFie8b6hwRsQIhjJEEa30AthK76dD/bWkyns5+Sxh8gU90rjA2wBh3IsuCwjNbQrmNaQp82IrUeb5ZGuOWJCntZZWPPHQ0a0nSyxJGOcOsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977002; c=relaxed/simple;
	bh=KMm/VXkD0QUPTJGA9a+jNjEcENb+Vi6HO8hSBF57r8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5xXknIqlNR92kfaUqRUIot9JJXs8YEW9ydZ+333kG1IPQZ8WYOPRfFQZTACKhF6plEiqYC1JKEPmK4B/R5KpJHfwDGGALVotRHNHENC9g1lXJ0538nEjtm8/EFdxyBfnQl1s8ddb6N3Lu/i/esXEHGuFLbWrnpNNC4Nyf9Za/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auLLQTdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auLLQTdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CB3C19424;
	Tue, 31 Mar 2026 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774977001;
	bh=KMm/VXkD0QUPTJGA9a+jNjEcENb+Vi6HO8hSBF57r8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auLLQTdAmPJF+/vgFIrIvp4MNnB7TDZa4sJQRInQMem7bgmSoFeaLRnTaSEJamenF
	 P88urDrw5WgGUsPeVys0kDbMo5pv/Hr4vLSgFn76qopOO7jitxPKytLFJ0ThRY+2K9
	 QhuK+0et3Bju3Mdl4Esk+9QFlBu+Dtpe8mLiz3jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 278/309] mm/damon/core: avoid use of half-online-committed context
Date: Tue, 31 Mar 2026 18:23:01 +0200
Message-ID: <20260331161803.795241676@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |    8 ++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -786,6 +786,12 @@ struct damon_ctx {
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
 
+	/*
+	 * indicate if this may be corrupted.  Currentonly this is set only for
+	 * damon_commit_ctx() failure.
+	 */
+	bool maybe_corrupted;
+
 /* public: */
 	struct task_struct *kdamond;
 	struct mutex kdamond_lock;
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1236,6 +1236,7 @@ int damon_commit_ctx(struct damon_ctx *d
 {
 	int err;
 
+	dst->maybe_corrupted = true;
 	if (!is_power_of_2(src->min_sz_region))
 		return -EINVAL;
 
@@ -1261,6 +1262,7 @@ int damon_commit_ctx(struct damon_ctx *d
 	dst->addr_unit = src->addr_unit;
 	dst->min_sz_region = src->min_sz_region;
 
+	dst->maybe_corrupted = false;
 	return 0;
 }
 
@@ -2562,6 +2564,8 @@ static void kdamond_call(struct damon_ct
 		} else {
 			list_add(&control->list, &repeat_controls);
 		}
+		if (!cancel && ctx->maybe_corrupted)
+			break;
 	}
 	control = list_first_entry_or_null(&repeat_controls,
 			struct damon_call_control, list);
@@ -2594,6 +2598,8 @@ static int kdamond_wait_activation(struc
 		kdamond_usleep(min_wait_time);
 
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			return -EINVAL;
 		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;
@@ -2679,6 +2685,8 @@ static int kdamond_fn(void *data)
 		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			break;
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else


