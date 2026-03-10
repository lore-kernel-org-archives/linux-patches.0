Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01EE387583;
	Tue, 10 Mar 2026 11:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141223; cv=none; b=Ayq2jEtiHmcVuxsONKmWFZV96vtymumiUDanU6bdqt29IGk6TL4/9IYh1SJ6J2IpOsY3UfFzFjZRTvL06D5U5rspLLnhhqz03WwYETZ64nfR2/RM2i2JaUyGKulrY+IX5sxOlPVspMSl2O4/M9d7HNAQ4xqDzu4SFkP6ADaXqz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141223; c=relaxed/simple;
	bh=vyHdMcG9VyGrk5evzWM8H2tnqtTS/qoE5WYMnzt799Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgDzrCV4RPgp1ZehtgqN+CbWXltdE96uwwJtXYVoejBTCV3iQRP7KAh8LyQq4TBaL01B35b/v4fg4rqifYOYxgoonrqKfeWFH50J8jvwmmwC+FLGTZFksHS264y2X9torGptUnV3MDjgXuK+KxT14K5kXOh78SuOurFbgoa09k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQ4jPZLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQ4jPZLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDC5C2BCB2;
	Tue, 10 Mar 2026 11:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141223;
	bh=vyHdMcG9VyGrk5evzWM8H2tnqtTS/qoE5WYMnzt799Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ4jPZLgyOvX4UC2vjE2WJselobnBhyBpw4jInuVGQ0BPYmCK68KWZrsv0aCB0Lo8
	 ONV1TMQi9qSjh9/ek87egm/0qJkhbvbQmlf/NwlQVsrzAEQ76qZcniR+KUPfrv5uCr
	 /aqjLZxMrH79b2VTqoFQa3BWmrCrq8XLpnIM9yp3zBQVF/itXd/SvXy5cHGFy0BTsK
	 eoawQCP0VFCt5siLFgcgYGV9pr6QMPd50gY30bL/lwmgY6Gado6zXyBvPC3hfZw4s7
	 yDtwF6eX+rhIENt6ZWe4tMoeCtTOuUFzbK2498A/6HZHmm+tWpCxlqHkXr5qKRKUgn
	 fLyMgXhPV+0MQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Lis <tomasz.lis@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 225/311] drm/xe/queue: Call fini on exec queue creation fail
Date: Tue, 10 Mar 2026 07:04:32 -0400
Message-ID: <a17371b1cb31109a780b2a6754e7b28967fe4e45.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tomasz Lis <tomasz.lis@intel.com>

[ Upstream commit 99f9b5343cae80eb0dfe050baf6c86d722b3ba2e ]

Every call to queue init should have a corresponding fini call.
Skipping this would mean skipping removal of the queue from GuC list
(which is part of guc_id allocation). A damaged queue stored in
exec_queue_lookup list would lead to invalid memory reference,
sooner or later.

Call fini to free guc_id. This must be done before any internal
LRCs are freed.

Since the finalization with this extra call became very similar to
__xe_exec_queue_fini(), reuse that. To make this reuse possible,
alter xe_lrc_put() so it can survive NULL parameters, like other
similar functions.

v2: Reuse _xe_exec_queue_fini(). Make xe_lrc_put() aware of NULLs.

Fixes: 3c1fa4aa60b1 ("drm/xe: Move queue init before LRC creation")
Signed-off-by: Tomasz Lis <tomasz.lis@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com> (v1)
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patch.msgid.link/20260226212701.2937065-2-tomasz.lis@intel.com
(cherry picked from commit 393e5fea6f7d7054abc2c3d97a4cfe8306cd6079)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 23 +++++++++++------------
 drivers/gpu/drm/xe/xe_lrc.h        |  3 ++-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 779d7e7e2d2ec..1e774fa1fa190 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -185,6 +185,16 @@ static struct xe_exec_queue *__xe_exec_queue_alloc(struct xe_device *xe,
 	return q;
 }
 
+static void __xe_exec_queue_fini(struct xe_exec_queue *q)
+{
+	int i;
+
+	q->ops->fini(q);
+
+	for (i = 0; i < q->width; ++i)
+		xe_lrc_put(q->lrc[i]);
+}
+
 static int __xe_exec_queue_init(struct xe_exec_queue *q, u32 exec_queue_flags)
 {
 	int i, err;
@@ -239,21 +249,10 @@ static int __xe_exec_queue_init(struct xe_exec_queue *q, u32 exec_queue_flags)
 	return 0;
 
 err_lrc:
-	for (i = i - 1; i >= 0; --i)
-		xe_lrc_put(q->lrc[i]);
+	__xe_exec_queue_fini(q);
 	return err;
 }
 
-static void __xe_exec_queue_fini(struct xe_exec_queue *q)
-{
-	int i;
-
-	q->ops->fini(q);
-
-	for (i = 0; i < q->width; ++i)
-		xe_lrc_put(q->lrc[i]);
-}
-
 struct xe_exec_queue *xe_exec_queue_create(struct xe_device *xe, struct xe_vm *vm,
 					   u32 logical_mask, u16 width,
 					   struct xe_hw_engine *hwe, u32 flags,
diff --git a/drivers/gpu/drm/xe/xe_lrc.h b/drivers/gpu/drm/xe/xe_lrc.h
index 2fb628da5c433..96ae31df3359f 100644
--- a/drivers/gpu/drm/xe/xe_lrc.h
+++ b/drivers/gpu/drm/xe/xe_lrc.h
@@ -73,7 +73,8 @@ static inline struct xe_lrc *xe_lrc_get(struct xe_lrc *lrc)
  */
 static inline void xe_lrc_put(struct xe_lrc *lrc)
 {
-	kref_put(&lrc->refcount, xe_lrc_destroy);
+	if (lrc)
+		kref_put(&lrc->refcount, xe_lrc_destroy);
 }
 
 /**
-- 
2.51.0

