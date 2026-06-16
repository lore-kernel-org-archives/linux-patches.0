Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CBA44DB61;
	Tue, 16 Jun 2026 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624429; cv=none; b=dBYmjnsfZe2njif9f4BK/mXLvrLGVzzyAysGaVuvDH7yCKJubXUaHG8sfM8M/SKnyxG9/lC/F/o6Nt5o4QkPBdD8bh/9kTawLypId6iuVl248FDrDLrp5E8cn6oSGUrVNOINJ/1pNqdOGXePKBHy84rcL/KzNOm+NyQSehthnm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624429; c=relaxed/simple;
	bh=yLx7GEOXBxeUYawpMq8kenO0cWlxY/hJPNYeyA+1iVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ljcb1e7OKlPJJTeOw3ZVycHHPzANT4OxUpO9H0/A9bJVGEETGnzwiU1skOvZU/L9/4sGA1yZks/et3Q4WZ6IqLVSr6p40rLBfYZRaMf0ACwhrIc8wgGPrx5+CyDu5bLHbGrYmJUuodXWQH1KtVEok4ACArzD3zsTzEpxNo3KCSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlXjgHTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlXjgHTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB56E1F000E9;
	Tue, 16 Jun 2026 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624427;
	bh=+TAc7tW/6OGtYH0czwy+FLs8VBExU63fxJhIk+JC8bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlXjgHTnZ8MX0axDo25OMZgPt0G4Grv2oXB02yM+nYR6RRRbWehMv2S+hhbo8HxQ4
	 CjCwRaldwNeepvv5N/iJAY0vJe2dD7ijhCqMQFxygyY5kevAXPnleuT7tMD31lOYhV
	 G6rm6sP5L8rkPdEJlEd60xeJ0dWPV7PiIokUg/LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"DARKNAVY (@DarkNavyOrg)" <vr@darknavy.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	syzbot+d7c9eed171647e421013@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Airlie <airlied@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Francis <David.Francis@amd.com>,
	Puttimet Thammasaeng <pwn8official@gmail.com>,
	Christian Koenig <Christian.Koenig@amd.com>,
	Zhenghang Xiao <kipreyyy@gmail.com>
Subject: [PATCH 7.0 333/378] drm/gem: Try to fix change_handle ioctl, attempt 4
Date: Tue, 16 Jun 2026 20:29:24 +0530
Message-ID: <20260616145127.755723966@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Simona Vetter <simona.vetter@ffwll.ch>

commit 1a4f03d22fb655e5f192244fb2c87d8066fcfca2 upstream.

[airlied: just added some comments on how to reenable]
On-list because the cat is out of the bag and we're clearly not good
enough to figure this out in private. The story thus far:

5e28b7b94408 ("drm: Set old handle to NULL before prime swap in
change_handle") tried to fix a race condition between the gem_close and
gem_change_handle ioctls, but got a few things wrong:

- There's a confusion with the local variable handle, which is actually
  the new handle, and so the two-stage trick was actually applied to the
  wrong idr slot. 7164d78559b0 ("drm/gem: fix race between
  change_handle and handle_delete") tried to fix that by adding yet
  another code block, but forgot to add the error handling. Which meant
  we now have two paths, both kinda wrong.

- dc366607c41c ("drm: Replace old pointer to new idr") tried to apply
  another fix, but inconsistently, again because of the handle confusion
  - this would be the right fix (kinda, somewhat, it's a mess) if we'd
  do the two-stage approach for the new handle. Except that wasn't the
  intent of the original fix.

We also didn't have an igt merged for the original ioctl, which is a big
no-go. This was attempted to address off-list in the original bugfix,
and amd QA people claimed the bug was fixed now. Very clearly that's not
the case. Here's my attempt to sort this out:

- Rename the local variable to new_handle, the old aliasing with
  args->handle is just too dangerously confusing.

- Merge the gem obj lookup with the two-stage idr_replace so that we
  avoid getting ourselves confused there.

- This means we don't have a surplus temporary reference anymore, only
  an inherited from the idr. A concurrent gem_close on the new_handle
  could steal that. Fix that with the same two-stage approach
  create_tail uses. This is a bit overkill as documented in the comment,
  but I also don't trust my ability to understand this all correctly, so
  go with the established pattern we have from other ioctls instead for
  maximum paranoia.

- Adjust error paths. I've tried to make the error and success paths
  common, because they are identical except for which handle is removed
  and on which we call idr_replace to (re)install the object again. But
  that made things messier to read, so I've left it at the more verbose
  version, which unfortunately hides the symmetry in the entire code
  flow a bit.

- While at it, also replace the 7 space indent with 1 tab.

And finally, because I flat out don't trust my abilities here at all
anymore:

- Disable the ioctl until we have the igt situation and everything else
  sorted out on-list and with full consensus.

v2:

Sashiko noticed that I didn't handle the error path for idr_replace
correctly, it must be checked with IS_ERR_OR_NULL like in
gem_handle_delete. So yeah, definitely should just the existing paths
1:1 because this is endless amounts of tricky.

Also add the Fixes: line for the original ioctl, I forgot that too.

Reported-by: DARKNAVY (@DarkNavyOrg) <vr@darknavy.com>
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Fixes: dc366607c41c ("drm: Replace old pointer to new idr")
Cc: syzbot+d7c9eed171647e421013@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Edward Adam Davis <eadavis@qq.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 5e28b7b94408 ("drm: Set old handle to NULL before prime swap in change_handle")
Cc: David Francis <David.Francis@amd.com>
Cc: Puttimet Thammasaeng <pwn8official@gmail.com>
Cc: Christian Koenig <Christian.Koenig@amd.com>
Fixes: 7164d78559b0 ("drm/gem: fix race between change_handle and handle_delete")
Cc: Zhenghang Xiao <kipreyyy@gmail.com>
Fixes: 5e28b7b94408 ("drm: Set old handle to NULL before prime swap in change_handle")
Reviewed-by: David Francis <David.Francis@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260604194437.1725314-1-simona.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c   |   73 ++++++++++++++++++++------------------------
 drivers/gpu/drm/drm_ioctl.c |    3 +
 2 files changed, 36 insertions(+), 40 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -997,12 +997,25 @@ err:
 	return ret;
 }
 
+/*
+ * This ioctl is disabled for security reasons but also it failed
+ * to follow process in terms of adding testing in igt and verifying
+ * all the corner cases which made fixing security bugs in it even
+ * harder than necessary.
+ *
+ * To re-enable this ioctl
+ * 1. land working IGT tests in igt-gpu-tools that cover
+ *    all corner cases and race conditions.
+ * 2. handle idr_preload
+ * 3. handle == 0
+ * 4. handle == new_handle semantics definition.
+ */
 int drm_gem_change_handle_ioctl(struct drm_device *dev, void *data,
 				struct drm_file *file_priv)
 {
 	struct drm_gem_change_handle *args = data;
-	struct drm_gem_object *obj, *idrobj;
-	int handle, ret;
+	struct drm_gem_object *obj;
+	int new_handle, ret;
 
 	if (!drm_core_check_feature(dev, DRIVER_GEM))
 		return -EOPNOTSUPP;
@@ -1010,52 +1023,36 @@ int drm_gem_change_handle_ioctl(struct d
 	/* idr_alloc() limitation. */
 	if (args->new_handle > INT_MAX)
 		return -EINVAL;
-	handle = args->new_handle;
+	new_handle = args->new_handle;
 
-	obj = drm_gem_object_lookup(file_priv, args->handle);
-	if (!obj)
-		return -ENOENT;
-
-	if (args->handle == handle) {
-		ret = 0;
-		goto out;
-	}
+	if (args->handle == new_handle)
+		return 0;
 
 	mutex_lock(&file_priv->prime.lock);
-
 	spin_lock(&file_priv->table_lock);
-
-       /* When create_tail allocs an obj idr, it needs to first alloc as NULL,
-	* then later replace with the correct object. This is not necessary
-	* here, because the only operations that could race are drm_prime
-	* bookkeeping, and we hold the prime lock.
-	*/
-	ret = idr_alloc(&file_priv->object_idr, obj, handle, handle + 1,
+	ret = idr_alloc(&file_priv->object_idr, NULL, new_handle, new_handle + 1,
 			GFP_NOWAIT);
 
-       if (ret < 0) {
-	       spin_unlock(&file_priv->table_lock);
-	       goto out_unlock;
-       }
-
-       idrobj = idr_replace(&file_priv->object_idr, NULL, handle);
-       if (idrobj != obj) {
-	       idr_replace(&file_priv->object_idr, idrobj, handle);
-	       idr_remove(&file_priv->object_idr, args->new_handle);
-	       spin_unlock(&file_priv->table_lock);
-	       ret = -ENOENT;
-	       goto out_unlock;
-       }
+	if (ret < 0) {
+		spin_unlock(&file_priv->table_lock);
+		goto out_unlock;
+	}
 
-	idr_replace(&file_priv->object_idr, NULL, args->handle);
+	obj = idr_replace(&file_priv->object_idr, NULL, args->handle);
+	if (IS_ERR_OR_NULL(obj)) {
+		idr_remove(&file_priv->object_idr, new_handle);
+		spin_unlock(&file_priv->table_lock);
+		ret = -ENOENT;
+		goto out_unlock;
+	}
 	spin_unlock(&file_priv->table_lock);
 
 	if (obj->dma_buf) {
 		ret = drm_prime_add_buf_handle(&file_priv->prime, obj->dma_buf,
-					       handle);
+					       new_handle);
 		if (ret < 0) {
 			spin_lock(&file_priv->table_lock);
-			idr_remove(&file_priv->object_idr, handle);
+			idr_remove(&file_priv->object_idr, new_handle);
 			idr_replace(&file_priv->object_idr, obj, args->handle);
 			spin_unlock(&file_priv->table_lock);
 			goto out_unlock;
@@ -1068,14 +1065,12 @@ int drm_gem_change_handle_ioctl(struct d
 
 	spin_lock(&file_priv->table_lock);
 	idr_remove(&file_priv->object_idr, args->handle);
-	idrobj = idr_replace(&file_priv->object_idr, obj, handle);
+	obj = idr_replace(&file_priv->object_idr, obj, new_handle);
 	spin_unlock(&file_priv->table_lock);
-	WARN_ON(idrobj != NULL);
+	WARN_ON(obj != NULL);
 
 out_unlock:
 	mutex_unlock(&file_priv->prime.lock);
-out:
-	drm_gem_object_put(obj);
 
 	return ret;
 }
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -660,7 +660,8 @@ static const struct drm_ioctl_desc drm_i
 	DRM_IOCTL_DEF(DRM_IOCTL_GEM_CLOSE, drm_gem_close_ioctl, DRM_RENDER_ALLOW),
 	DRM_IOCTL_DEF(DRM_IOCTL_GEM_FLINK, drm_gem_flink_ioctl, DRM_AUTH),
 	DRM_IOCTL_DEF(DRM_IOCTL_GEM_OPEN, drm_gem_open_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_GEM_CHANGE_HANDLE, drm_gem_change_handle_ioctl, DRM_RENDER_ALLOW),
+	/* see drm_gem.c:drm_gem_change_handle_ioctl for why this is invalid */
+	DRM_IOCTL_DEF(DRM_IOCTL_GEM_CHANGE_HANDLE, drm_invalid_op, DRM_RENDER_ALLOW),
 
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETRESOURCES, drm_mode_getresources, 0),
 


