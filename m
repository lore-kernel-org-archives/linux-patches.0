Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207D93F7ABB;
	Wed, 20 May 2026 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297174; cv=none; b=kW2h6/OYq/28jSvAeO0ixiKYwGPf5yC9WyV2TWAedpfdccG2NuKb/h98uGXqxaBHf/hZXmvQ2A1OIwxJXj0tOTMl9dpZR4QSJR57e/CMtP2zzbj/T+6r/LJGG2lGpxjfaBUr7JQeWN6GihbpfROfGsNPzyRNMCmGgGFufqqNwIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297174; c=relaxed/simple;
	bh=xGPIeFi9VR1jt28jVF6mh0me6g0L6IAMcn8iZY1BjM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJ9MqI5wZ8gFKOXycWRPW7FOLJWxyW0d8rqq4JpH25NO9U2tUiFpBs2PwkZefzxlC1qoFLfVNy06EFk9GoBzDwVUhfeoInwGg08oI7AaBfQNNNrs6+GTADZrt6uir+Ju6BkH85IwbH+yQkdb1NebQmi3ExaZiQNPHZvFQlQWfIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjVXT2Z1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjVXT2Z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5889E1F000E9;
	Wed, 20 May 2026 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297172;
	bh=uT5wMTCDA+xPSDJcEyj8k3m6s0Yt79U587ci3stT4Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjVXT2Z1wrep7OIsa82DLKPuLo1V+bdQf4LNqfA/yyt1BGfGWHJUFASw52k/j6jUb
	 EetLxfMJfIkmbURkFeuFdQqRGl7FePmNbMSbRUHVmCKhzIs5rdF0AjtAMXrxGIy018
	 5993h2YZ17eEOu7tbG9QErsjI9lQOYw4fQSF9X4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jatin Kataria <jkataria@netflix.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Brost <matthew.brost@intel.com>,
	dri-devel@lists.freedesktop.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Boqun Feng <boqun@kernel.org>
Subject: [PATCH 7.0 1077/1146] drm/ttm: Fix ttm_bo_swapout() infinite LRU walk on swapout failure
Date: Wed, 20 May 2026 18:22:07 +0200
Message-ID: <20260520162212.608402858@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit b2ed01e7ad3de80333e9b962a44024b094bc0b2b upstream.

When ttm_tt_swapout() fails, the current code calls
ttm_resource_add_bulk_move() followed by ttm_resource_move_to_lru_tail()
to restore the resource's bulk_move membership.

However, ttm_resource_move_to_lru_tail() places the resource at the tail
of the LRU list which, relative to the walk cursor's hitch node (placed
immediately after the resource when it was yielded), puts the resource
*in front of the* the hitch. The next list_for_each_entry_continue() from
the hitch finds the same resource again, causing an infinite loop.

Fix by deferring del_bulk_move to the success path only.

On the success path, TTM_TT_FLAG_SWAPPED has just been set by
ttm_tt_swapout() but the resource is still tracked in the bulk_move range,
so ttm_resource_del_bulk_move()'s !ttm_resource_unevictable() guard would
incorrectly skip the removal. Introduce
ttm_resource_del_bulk_move_unevictable() which bypasses that guard.

Reported-by: Jatin Kataria <jkataria@netflix.com>
Fixes: fc5d96670eb2 ("drm/ttm: Move swapped objects off the manager's LRU list")
Cc: Christian König <christian.koenig@amd.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <stable@vger.kernel.org> # v6.13+
Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Boqun Feng <boqun@kernel.org>
Link: https://patch.msgid.link/20260428094442.16985-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c       |   16 ++++++----------
 drivers/gpu/drm/ttm/ttm_resource.c |   13 +++++++++++++
 include/drm/ttm/ttm_resource.h     |    2 ++
 3 files changed, 21 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1178,17 +1178,13 @@ ttm_bo_swapout_cb(struct ttm_lru_walk *w
 		bdev->funcs->swap_notify(bo);
 
 	if (ttm_tt_is_populated(tt)) {
-		spin_lock(&bdev->lru_lock);
-		ttm_resource_del_bulk_move(bo->resource, bo);
-		spin_unlock(&bdev->lru_lock);
-
 		ret = ttm_tt_swapout(bdev, tt, swapout_walk->gfp_flags);
-
-		spin_lock(&bdev->lru_lock);
-		if (ret)
-			ttm_resource_add_bulk_move(bo->resource, bo);
-		ttm_resource_move_to_lru_tail(bo->resource);
-		spin_unlock(&bdev->lru_lock);
+		if (!ret) {
+			spin_lock(&bdev->lru_lock);
+			ttm_resource_del_bulk_move_unevictable(bo->resource, bo);
+			ttm_resource_move_to_lru_tail(bo->resource);
+			spin_unlock(&bdev->lru_lock);
+		}
 	}
 
 out:
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -292,6 +292,19 @@ void ttm_resource_del_bulk_move(struct t
 		ttm_lru_bulk_move_del(bo->bulk_move, res);
 }
 
+/*
+ * Remove a resource from its bulk_move, bypassing the unevictable check.
+ * Use only when the resource is known to still be tracked in the range despite
+ * the BO having just become unevictable; asserts that this is the case.
+ */
+void ttm_resource_del_bulk_move_unevictable(struct ttm_resource *res,
+					    struct ttm_buffer_object *bo)
+{
+	WARN_ON_ONCE(!ttm_resource_unevictable(res, bo));
+	if (bo->bulk_move)
+		ttm_lru_bulk_move_del(bo->bulk_move, res);
+}
+
 /* Move a resource to the LRU or bulk tail */
 void ttm_resource_move_to_lru_tail(struct ttm_resource *res)
 {
--- a/include/drm/ttm/ttm_resource.h
+++ b/include/drm/ttm/ttm_resource.h
@@ -448,6 +448,8 @@ void ttm_resource_add_bulk_move(struct t
 				struct ttm_buffer_object *bo);
 void ttm_resource_del_bulk_move(struct ttm_resource *res,
 				struct ttm_buffer_object *bo);
+void ttm_resource_del_bulk_move_unevictable(struct ttm_resource *res,
+					    struct ttm_buffer_object *bo);
 void ttm_resource_move_to_lru_tail(struct ttm_resource *res);
 
 void ttm_resource_init(struct ttm_buffer_object *bo,


