Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F2847010D;
	Tue, 21 Jul 2026 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664556; cv=none; b=qRzf815qhwMKd/naLM+lxOdCxNUeZqBSevQ3cdcjlu71twSe+I1HvH8iwfDIo1Hgd+klS6AHd+9en4sHViCfHVY0dfDCIqCo1us4ilaYPSIVOoeDYuDsTWjVgffUeiY5yKSnCOaYP0i4suB09GUNcchRUpgdUdYwXv6+pbNWd00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664556; c=relaxed/simple;
	bh=wREO/Llptqtdz+Y3/r54GgrkNJJKgHfjSQbNaSySP24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSih0gYLKi5I0EAS1a1mGfgZLOheaHkKJQVrou7tHtDPbi6F315BygvOt5ZnibkQvq7uwHkUjvJ8vriE3Tw3FlgKMcSWT1MymjOz3WNhaopHTPMFymFOIoaUCNVuXxg86eNPpgnBcKQTQjH8wMswtdqCpNAys9CDGYUDV6+BCvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lds7N6TL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lds7N6TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66AC1F000E9;
	Tue, 21 Jul 2026 20:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664554;
	bh=b/4IVLG/KO5h165U3hbktuM2cdoH8lk2nfnhxMZspDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lds7N6TLA6wCCVLySItPtsCT/y+/D9AhOoLAZ8lEa731sSfsvQFn4ov2GvsPlegwk
	 Ls4XXH+bh3aHj7AeqhPPOnHyu2Kt5VwQtm675XciA4T2ZrLVxfhQfje2XeUutgOchb
	 L4bZwSVp5nUniQonSx5pC1hwVUYnX9GJKaxHvHWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 1242/1276] mm/damon/core: always put unsuccessfully committed target pids
Date: Tue, 21 Jul 2026 17:28:05 +0200
Message-ID: <20260721152513.887506855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 6a66c557a2ab2609575bafd15e093669c05f9711 upstream.

damon_commit_target() puts and gets the destination and the source target
pids.  It puts the destination target pid because it will be overwritten
by the source target pid.  It gets the source pid because the caller is
supposed to eventually put the pids.  In more detail, the caller will call
damon_destroy_ctx() after damon_commit_ctx() to destroy the entire source
context.  And in this case, [f]vaddr operation set's cleanup_target()
callback will put the pids.

The commit operation is made at the context level.  The operation can fail
in multiple places including in the middle and after the targets commit
operations.  For any such failures, immediately the error is returned to
the damon_commit_ctx() caller.  If some or all of the source target pids
were committed to the destination during the unsuccessful context commit
attempt, those pids should be put twice.

The source context will do the put operations using the above explained
routine.  However, let's suppose the destination context was not
originally using [f]vaddr operation set and the commit failed before the
ops of the source context is committed.  The destination does not have the
cleanup_target() ops callback, so it cannot put the pids via the
damon_destroy_ctx().

As a result, the pids are leaked.  The issue in the real world would be
not very common.  The commit feature is for changing parameters of running
DAMON context while inheriting internal status like the monitoring
results.  The monitoring results of a physical address range ain't have
things that are beneficial to be inherited to a virtual address ranges
monitoring.  So the problem-causing DAMON control would be not very common
in the real world.  That said, it is a supported feature.  And
damon_commit_target() failure due to memory allocation is relatively
realistic [1] if there are a huge number of target regions.

Fix by putting the pids in the commit operation in case of the failures.

The issue was discovered [2] by Sashiko.

Link: https://lore.kernel.org/20260605013849.83750-1-sj@kernel.org
Link: https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com [1]
Link: https://lore.kernel.org/20260320020056.835-1-sj@kernel.org [2]
Fixes: 83dc7bbaecae ("mm/damon/sysfs: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -938,10 +938,36 @@ static int damon_commit_target(
 	return 0;
 }
 
+/*
+ * damon_revert_target_commits() - revert unsuccessful target commits.
+ * @dst:	Commit destination context
+ * @failed:	Commit failed destination target
+ * @src:	Commit source context
+ *
+ * Revert target states that changed by damon_commit_target(), and cannot be
+ * cleaned up by the destination context's ops.cleanup_target().
+ */
+static void damon_revert_target_commits(struct damon_ctx *dst,
+		struct damon_target *failed, struct damon_ctx *src)
+{
+	struct damon_target *target;
+
+	if (!damon_target_has_pid(src))
+		return;
+	if (damon_target_has_pid(dst))
+		return;
+	damon_for_each_target(target, dst) {
+		if (target == failed)
+			return;
+		put_pid(target->pid);
+	}
+}
+
 static int damon_commit_targets(
 		struct damon_ctx *dst, struct damon_ctx *src)
 {
 	struct damon_target *dst_target, *next, *src_target, *new_target;
+	struct damon_target *failed;
 	int i = 0, j = 0, err;
 
 	damon_for_each_target_safe(dst_target, next, dst) {
@@ -950,8 +976,10 @@ static int damon_commit_targets(
 			err = damon_commit_target(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src));
-			if (err)
-				return err;
+			if (err) {
+				failed = dst_target;
+				goto out;
+			}
 		} else {
 			if (damon_target_has_pid(dst))
 				put_pid(dst_target->pid);
@@ -959,21 +987,28 @@ static int damon_commit_targets(
 		}
 	}
 
+	failed = NULL;
 	damon_for_each_target_safe(src_target, next, src) {
 		if (j++ < i)
 			continue;
 		new_target = damon_new_target();
-		if (!new_target)
-			return -ENOMEM;
+		if (!new_target) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src));
 		if (err) {
 			damon_destroy_target(new_target);
-			return err;
+			goto out;
 		}
 		damon_add_target(dst, new_target);
 	}
 	return 0;
+
+out:
+	damon_revert_target_commits(dst, failed, src);
+	return err;
 }
 
 /**
@@ -1007,8 +1042,10 @@ int damon_commit_ctx(struct damon_ctx *d
 	 *    committing require putting pids).
 	 */
 	err = damon_set_attrs(dst, &src->attrs);
-	if (err)
+	if (err) {
+		damon_revert_target_commits(dst, NULL, src);
 		return err;
+	}
 	dst->ops = src->ops;
 
 	return 0;


