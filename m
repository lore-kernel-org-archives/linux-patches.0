Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB0E344DAC;
	Thu, 28 May 2026 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998328; cv=none; b=SuAPPfLdkWlRaM2iyVaIujVRBKBu+7x/tWMCLtC5zBWq2TD/IRQqex52QM8CIPkKE+vfowUf2ca4OpJTbYsTjcqggoggS29hADQvvSXR6YYbPw47VIAJMjx/u/0II3rpu6vM2omNFlTsNFZQJxySHkHTaq6Cfm+/nAGg8ciKCes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998328; c=relaxed/simple;
	bh=CNqupDFpDpQSy84+KNpf6U8zwMbG6ko/c0+rGMOthhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXzOjBMJu671YNmvnJfN8p0to8ggE/mi/6iqmpGfGrt2uK8YG/aAUu5SPItN0zzUl1+MsrKmL0AwAe4BkW7QMcfAH4DQVRD8iXMa2J9woA0UDsziAdcnl0IzxvdW6KXcMnyrsyBvvSp63upVHpaO/DZtNZEiTxf3HUQhn6JJ2ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcxbI8Xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcxbI8Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD531F000E9;
	Thu, 28 May 2026 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998327;
	bh=HwL1ELeiniv8eitXsLSw/EtRVUCLQzMqDmvjZ6xBPtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcxbI8Xl5lKhz6QQap/mvo60oNny69TmeQoJGOblI/y7QMWiKK1HSeoneCBLuoMw1
	 r6ijnl5w5Q6HyFr28JRLuuieKIJjz42pFkh+3iWFnBuZusIEEqst+cf6Deot2pFMNA
	 AMSQ0IFe9i/OD4YEi5w2s6zfsGFz9CbNgxTU1yxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Sebastian=20=C3=96sterlund?= <sebastian.osterlund@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.0 134/461] drm/xe/multi_queue: Fix secondary queue error case
Date: Thu, 28 May 2026 21:44:23 +0200
Message-ID: <20260528194650.869761753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

commit 00907da2126ed785451b2a2f0fef282246dad104 upstream.

If xe_lrc_create() fails, the secondary queue added to the
multi-queue group list is not removed before freeing the
queue. Fix error path handling for secondary queues by
removing it from the multi-queue group list at the right
place.

Reported-by: Sebastian Österlund <sebastian.osterlund@intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7979
Fixes: d716a5088c88 ("drm/xe/multi_queue: Handle tearing down of a multi queue")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260518191639.320890-2-niranjana.vishwanathapura@intel.com
(cherry picked from commit d2d23c12789cf69eddc35b8d38cd8eaabd0168f1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1623,6 +1623,14 @@ static void guc_exec_queue_fini(struct x
 	struct xe_guc_exec_queue *ge = q->guc;
 	struct xe_guc *guc = exec_queue_to_guc(q);
 
+	if (xe_exec_queue_is_multi_queue_secondary(q)) {
+		struct xe_exec_queue_group *group = q->multi_queue.group;
+
+		mutex_lock(&group->list_lock);
+		list_del(&q->multi_queue.link);
+		mutex_unlock(&group->list_lock);
+	}
+
 	release_guc_id(guc, q);
 	xe_sched_entity_fini(&ge->entity);
 	xe_sched_fini(&ge->sched);
@@ -1644,14 +1652,6 @@ static void __guc_exec_queue_destroy_asy
 	guard(xe_pm_runtime)(guc_to_xe(guc));
 	trace_xe_exec_queue_destroy(q);
 
-	if (xe_exec_queue_is_multi_queue_secondary(q)) {
-		struct xe_exec_queue_group *group = q->multi_queue.group;
-
-		mutex_lock(&group->list_lock);
-		list_del(&q->multi_queue.link);
-		mutex_unlock(&group->list_lock);
-	}
-
 	/* Confirm no work left behind accessing device structures */
 	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
 


