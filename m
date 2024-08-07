Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B682488;
	Wed,  7 Aug 2024 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043102; cv=none; b=Q+dPH8eHtpJD4x8MOl2POshDKMEhzBVUdDWdcDnx/3JaXklqDwOYcQ7cz2J5LU3n+dm4Rtv7Dc5RI+8lPIfrydYWB8eUb/Q37JCHPzuUHM3faksVzSPeggskzGInRcx2/Knv4S4DCR1Az6/ae+7EEc4DeT97FhK9UKfiio2Aygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043102; c=relaxed/simple;
	bh=BMcSijsLP0jk/TtgzzCKceCpcwID6OdAJ5vQGhvHF1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrtDtJ4mGsgvZorhJIOLy1xA6aJZZNWwg2+2Bfkgj7OwFq7W6vwXZOg+wMHdhI1karpT2N/1p0gl02RldeHs3cWikmkflaHh0xuDvPd0K/x6iqDldPxoIl4LB7+IjZ1gFRYxadpR6IpQhKpZHWnMJQM9+WJGdQU15m4DhTp7D9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ob5smw8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ob5smw8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6C9C4AF0D;
	Wed,  7 Aug 2024 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043102;
	bh=BMcSijsLP0jk/TtgzzCKceCpcwID6OdAJ5vQGhvHF1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ob5smw8JS+OascpWdNUbsIxDR/9rJmKnZCvnKzlbxE8GDb4eESVNaOct8HmeCLQfL
	 7Ocz5PQ8ACsmV2/HGBuTp4MwU1AksnkAtbqh8fSV74/LLMGCxbkrwe0l+xEnaQFfjp
	 nSJ5iJkz2tYC/0ucsJTnMEJoKLk78idJZU4nRmBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>
Subject: [PATCH 6.10 091/123] drm/vmwgfx: Fix a deadlock in dma buf fence polling
Date: Wed,  7 Aug 2024 17:00:10 +0200
Message-ID: <20240807150023.759050099@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit e58337100721f3cc0c7424a18730e4f39844934f upstream.

Introduce a version of the fence ops that on release doesn't remove
the fence from the pending list, and thus doesn't require a lock to
fix poll->fence wait->fence unref deadlocks.

vmwgfx overwrites the wait callback to iterate over the list of all
fences and update their status, to do that it holds a lock to prevent
the list modifcations from other threads. The fence destroy callback
both deletes the fence and removes it from the list of pending
fences, for which it holds a lock.

dma buf polling cb unrefs a fence after it's been signaled: so the poll
calls the wait, which signals the fences, which are being destroyed.
The destruction tries to acquire the lock on the pending fences list
which it can never get because it's held by the wait from which it
was called.

Old bug, but not a lot of userspace apps were using dma-buf polling
interfaces. Fix those, in particular this fixes KDE stalls/deadlock.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 2298e804e96e ("drm/vmwgfx: rework to new fence interface, v2")
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.2+
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722184313.181318-2-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -32,7 +32,6 @@
 #define VMW_FENCE_WRAP (1 << 31)
 
 struct vmw_fence_manager {
-	int num_fence_objects;
 	struct vmw_private *dev_priv;
 	spinlock_t lock;
 	struct list_head fence_list;
@@ -124,13 +123,13 @@ static void vmw_fence_obj_destroy(struct
 {
 	struct vmw_fence_obj *fence =
 		container_of(f, struct vmw_fence_obj, base);
-
 	struct vmw_fence_manager *fman = fman_from_fence(fence);
 
-	spin_lock(&fman->lock);
-	list_del_init(&fence->head);
-	--fman->num_fence_objects;
-	spin_unlock(&fman->lock);
+	if (!list_empty(&fence->head)) {
+		spin_lock(&fman->lock);
+		list_del_init(&fence->head);
+		spin_unlock(&fman->lock);
+	}
 	fence->destroy(fence);
 }
 
@@ -257,7 +256,6 @@ static const struct dma_fence_ops vmw_fe
 	.release = vmw_fence_obj_destroy,
 };
 
-
 /*
  * Execute signal actions on fences recently signaled.
  * This is done from a workqueue so we don't have to execute
@@ -355,7 +353,6 @@ static int vmw_fence_obj_init(struct vmw
 		goto out_unlock;
 	}
 	list_add_tail(&fence->head, &fman->fence_list);
-	++fman->num_fence_objects;
 
 out_unlock:
 	spin_unlock(&fman->lock);
@@ -403,7 +400,7 @@ static bool vmw_fence_goal_new_locked(st
 				      u32 passed_seqno)
 {
 	u32 goal_seqno;
-	struct vmw_fence_obj *fence;
+	struct vmw_fence_obj *fence, *next_fence;
 
 	if (likely(!fman->seqno_valid))
 		return false;
@@ -413,7 +410,7 @@ static bool vmw_fence_goal_new_locked(st
 		return false;
 
 	fman->seqno_valid = false;
-	list_for_each_entry(fence, &fman->fence_list, head) {
+	list_for_each_entry_safe(fence, next_fence, &fman->fence_list, head) {
 		if (!list_empty(&fence->seq_passed_actions)) {
 			fman->seqno_valid = true;
 			vmw_fence_goal_write(fman->dev_priv,


