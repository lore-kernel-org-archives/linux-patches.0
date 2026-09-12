Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469F1DE4EF;
	Sat, 12 Sep 2026 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222107; cv=none; b=eTD4j6Hw2crOtdSIpe8teR6fzrQgj5ZDxAWkUnBCQVB9ASFytkCtYeBbtlYv9EySZKIFymkNKzibUdMch+gvlfUXEiISUVZgN5XokCukWxTAqHxka5Znnt69y8qR+zON6ZenNWZMvUDcuFr/D/IkGFHKRntlXae6XtmMDlTRVXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222107; c=relaxed/simple;
	bh=plizMQCxl94oA0vU8VfswiXtOX+GL3xGMyARfSEiGJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEiXiupaa3Y0rdGgmly22+LPsdAnW6ZHY1Hi40fmuzHh7yE5g1Ilea6tifYxGR510w4qRwzeWkWe+FkRl6EHUJd/4CAzgfQkJkE+abj/CFjDLqdfwT9WpeBwqwt9BezG4gn58mFHjjG7N2ZV5n6zDotH9rkuLoaIjaFix5UzvyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyN7ceLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyN7ceLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D994B1F000FF;
	Sat, 12 Sep 2026 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222106;
	bh=uuLPaSz9KmElidUgQpMuRa5B2NAQQx6XgWbrfN5hYfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyN7ceLSlZgzCQvtDVibkqJXQrDZwk0YBwYPSsp0aikRpQ+sGuGW9zeuuBUtAvSX3
	 ABNuu9R+h+48Fyf/Wwn1WsgljHrtKI7rQ2orhiwTjovSqbTH4g41qJirg1wf+VR+2G
	 GJVOvjTDxedG/5XtxGyfnWt0gJQy2kOpY/AedxYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Melissa Wen <mwen@igalia.com>
Subject: [PATCH 6.6 0520/1424] drm: Fix drm_crtc_commit leak if signaled when PAGE_FLIP_EVENT is used
Date: Sat, 12 Sep 2026 08:49:12 +0200
Message-ID: <20260912065618.937169462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 4d4be202165e832d74849b4a68e289a2a377039c upstream.

Commit 1c6ceeee6ebb ("drm/atomic: Fix memleak on ERESTARTSYS during
non-blocking commits") fixed a very similar issue when the event was
allocated by drm_atomic_helper_setup_commit() itself.

However, if the event is allocated in prepare_signaling(), it will also be
set to NULL in complete_signaling(), which prevents drm_crtc_commit from
being put in __drm_atomic_helper_crtc_destroy_state().

Dropping the reference when the event is set to NULL at
complete_signaling() fixes the leak.

The leak can be reproduced by sending a signal to the thread using
DRM_MODE_PAGE_FLIP_EVENT and using a sw_sync fence to cause the atomic
ioctl to block at drm_atomic_helper_wait_for_fences(). It happened both
with amdgpu and vkms.

Fixes: 24835e442f28 ("drm: reference count event->completion")
Cc: stable@vger.kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260727-drm_crtc_atomic_commit_leak-v1-1-23d9948a9d7c@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1304,6 +1304,8 @@ static void complete_signaling(struct dr
 		 * to prevent a double free in drm_atomic_state_clear.
 		 */
 		if (event && (event->base.fence || event->base.file_priv)) {
+			if (crtc_state->commit && crtc_state->commit->abort_completion)
+				drm_crtc_commit_put(crtc_state->commit);
 			drm_event_cancel_free(dev, &event->base);
 			crtc_state->event = NULL;
 		}


