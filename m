Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F44E2E6100;
	Tue, 15 Jul 2025 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586912; cv=none; b=SB7mzPtRdNek4EuL+nCI77nfI86LLclzv7C8x/ThB+MRqkDZD4BE6wxVRI0SBEPXbOsxvZAy1xfiT+War8ak4wjvtlt0XW4qVsqiHOQwQBJQjfX5RAef1JVsZMmRITh7+Ber1oMPNE783TfyXTkajgU9CjV4MXWlLq5oseKWcyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586912; c=relaxed/simple;
	bh=wk5/ktV2JNgcdI0S4Qq3iqXNRxMKujFaQZ/NmLCdz9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLcjnixf456ZKJXxsYgfWqlVh5WXZfM8lDFGeBxDE512XsCccTDiqJ4ggcU6CQ8Rm+9G12fDfSwK4RuyLJ7YONOuZDF6vWjkpB96L2SptefpW6YA7j2vTgY4xkrZfg9Bv3LwuGYTsuWlD46FGOoF1p3f+Yl0xhlkgDLplK52Qi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3/NGXrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3/NGXrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10902C4CEF6;
	Tue, 15 Jul 2025 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586912;
	bh=wk5/ktV2JNgcdI0S4Qq3iqXNRxMKujFaQZ/NmLCdz9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3/NGXrJJ+qcbybFz7AHAzLpkXAMnyXZYl8KSrcwxtj5tJo5s046TzeopZ2RjzU7E
	 FCXkPQZdnNA4U4NTA8YVI2Koj6DamK35MLCGYzfEn13FS5mFcfkwWRGWo7PyE+HJJz
	 9LFohlZq16sGFJ0o/cJZraGBYiLzrlA3csCtcL4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Simona Vetter <simona.vetter@intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>
Subject: [PATCH 6.15 088/192] drm/gem: Fix race in drm_gem_handle_create_tail()
Date: Tue, 15 Jul 2025 15:13:03 +0200
Message-ID: <20250715130818.442423231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simona Vetter <simona.vetter@ffwll.ch>

commit bd46cece51a36ef088f22ef0416ac13b0a46d5b0 upstream.

Object creation is a careful dance where we must guarantee that the
object is fully constructed before it is visible to other threads, and
GEM buffer objects are no difference.

Final publishing happens by calling drm_gem_handle_create(). After
that the only allowed thing to do is call drm_gem_object_put() because
a concurrent call to the GEM_CLOSE ioctl with a correctly guessed id
(which is trivial since we have a linear allocator) can already tear
down the object again.

Luckily most drivers get this right, the very few exceptions I've
pinged the relevant maintainers for. Unfortunately we also need
drm_gem_handle_create() when creating additional handles for an
already existing object (e.g. GETFB ioctl or the various bo import
ioctl), and hence we cannot have a drm_gem_handle_create_and_put() as
the only exported function to stop these issues from happening.

Now unfortunately the implementation of drm_gem_handle_create() isn't
living up to standards: It does correctly finishe object
initialization at the global level, and hence is safe against a
concurrent tear down. But it also sets up the file-private aspects of
the handle, and that part goes wrong: We fully register the object in
the drm_file.object_idr before calling drm_vma_node_allow() or
obj->funcs->open, which opens up races against concurrent removal of
that handle in drm_gem_handle_delete().

Fix this with the usual two-stage approach of first reserving the
handle id, and then only registering the object after we've completed
the file-private setup.

Jacek reported this with a testcase of concurrently calling GEM_CLOSE
on a freshly-created object (which also destroys the object), but it
should be possible to hit this with just additional handles created
through import or GETFB without completed destroying the underlying
object with the concurrent GEM_CLOSE ioctl calls.

Note that the close-side of this race was fixed in f6cd7daecff5 ("drm:
Release driver references to handle before making it available
again"), which means a cool 9 years have passed until someone noticed
that we need to make this symmetry or there's still gaps left :-/
Without the 2-stage close approach we'd still have a race, therefore
that's an integral part of this bugfix.

More importantly, this means we can have NULL pointers behind
allocated id in our drm_file.object_idr. We need to check for that
now:

- drm_gem_handle_delete() checks for ERR_OR_NULL already

- drm_gem.c:object_lookup() also chekcs for NULL

- drm_gem_release() should never be called if there's another thread
  still existing that could call into an IOCTL that creates a new
  handle, so cannot race. For paranoia I added a NULL check to
  drm_gem_object_release_handle() though.

- most drivers (etnaviv, i915, msm) are find because they use
  idr_find(), which maps both ENOENT and NULL to NULL.

- drivers using idr_for_each_entry() should also be fine, because
  idr_get_next does filter out NULL entries and continues the
  iteration.

- The same holds for drm_show_memory_stats().

v2: Use drm_WARN_ON (Thomas)

Reported-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Tested-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: stable@vger.kernel.org
Cc: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: Simona Vetter <simona.vetter@intel.com>
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250707151814.603897-1-simona.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c |   10 +++++++++-
 include/drm/drm_file.h    |    3 +++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -315,6 +315,9 @@ drm_gem_object_release_handle(int id, vo
 	struct drm_file *file_priv = data;
 	struct drm_gem_object *obj = ptr;
 
+	if (drm_WARN_ON(obj->dev, !data))
+		return 0;
+
 	if (obj->funcs->close)
 		obj->funcs->close(obj, file_priv);
 
@@ -435,7 +438,7 @@ drm_gem_handle_create_tail(struct drm_fi
 	idr_preload(GFP_KERNEL);
 	spin_lock(&file_priv->table_lock);
 
-	ret = idr_alloc(&file_priv->object_idr, obj, 1, 0, GFP_NOWAIT);
+	ret = idr_alloc(&file_priv->object_idr, NULL, 1, 0, GFP_NOWAIT);
 
 	spin_unlock(&file_priv->table_lock);
 	idr_preload_end();
@@ -456,6 +459,11 @@ drm_gem_handle_create_tail(struct drm_fi
 			goto err_revoke;
 	}
 
+	/* mirrors drm_gem_handle_delete to avoid races */
+	spin_lock(&file_priv->table_lock);
+	obj = idr_replace(&file_priv->object_idr, obj, handle);
+	WARN_ON(obj != NULL);
+	spin_unlock(&file_priv->table_lock);
 	*handlep = handle;
 	return 0;
 
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -300,6 +300,9 @@ struct drm_file {
 	 *
 	 * Mapping of mm object handles to object pointers. Used by the GEM
 	 * subsystem. Protected by @table_lock.
+	 *
+	 * Note that allocated entries might be NULL as a transient state when
+	 * creating or deleting a handle.
 	 */
 	struct idr object_idr;
 


