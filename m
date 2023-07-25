Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FC1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98F4C433C7;
	Tue, 25 Jul 2023 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284749;
	bh=IiINVVFp3FcZlpj5GWmJ9MH+vbqklIbUM8ZJn3S5EWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIV1hhh4lbERP1ifVAoNUma8f4tdWOarzYZf2czWNMT/ncIA8X7lTMfiO7W71FBI9
	 ZtJfOCfHQkiCMNrxiDgMwYQTayWYAkeEu4RiPh5eP2w+WOpkLssVfB66G3mSrG6Rn/
	 NY4JsKCz/p9ST8mPxOElLS4euWLKQSh0bYMbdWe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shanzhulig <shanzhulig@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	stable@kernel.org,
	Daniel Vetter <daniel.vetter@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 439/509] drm/atomic: Fix potential use-after-free in nonblocking commits
Date: Tue, 25 Jul 2023 12:46:18 +0200
Message-ID: <20230725104613.833889001@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4e076c73e4f6e90816b30fcd4a0d7ab365087255 upstream.

This requires a bit of background.  Properly done a modeset driver's
unload/remove sequence should be

	drm_dev_unplug();
	drm_atomic_helper_shutdown();
	drm_dev_put();

The trouble is that the drm_dev_unplugged() checks are by design racy,
they do not synchronize against all outstanding ioctl.  This is because
those ioctl could block forever (both for modeset and for driver
specific ioctls), leading to deadlocks in hotunplug.  Instead the code
sections that touch the hardware need to be annotated with
drm_dev_enter/exit, to avoid accessing hardware resources after the
unload/remove has finished.

To avoid use-after-free issues all the involved userspace visible
objects are supposed to hold a reference on the underlying drm_device,
like drm_file does.

The issue now is that we missed one, the atomic modeset ioctl can be run
in a nonblocking fashion, and in that case it cannot rely on the implied
drm_device reference provided by the ioctl calling context.  This can
result in a use-after-free if an nonblocking atomic commit is carefully
raced against a driver unload.

Fix this by unconditionally grabbing a drm_device reference for any
drm_atomic_state structures.  Strictly speaking this isn't required for
blocking commits and TEST_ONLY calls, but it's the simpler approach.

Thanks to shanzhulig for the initial idea of grabbing an unconditional
reference, I just added comments, a condensed commit message and fixed a
minor potential issue in where exactly we drop the final reference.

Reported-by: shanzhulig <shanzhulig@gmail.com>
Suggested-by: shanzhulig <shanzhulig@gmail.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -98,6 +98,12 @@ drm_atomic_state_init(struct drm_device
 	if (!state->planes)
 		goto fail;
 
+	/*
+	 * Because drm_atomic_state can be committed asynchronously we need our
+	 * own reference and cannot rely on the on implied by drm_file in the
+	 * ioctl call.
+	 */
+	drm_dev_get(dev);
 	state->dev = dev;
 
 	DRM_DEBUG_ATOMIC("Allocated atomic state %p\n", state);
@@ -257,7 +263,8 @@ EXPORT_SYMBOL(drm_atomic_state_clear);
 void __drm_atomic_state_free(struct kref *ref)
 {
 	struct drm_atomic_state *state = container_of(ref, typeof(*state), ref);
-	struct drm_mode_config *config = &state->dev->mode_config;
+	struct drm_device *dev = state->dev;
+	struct drm_mode_config *config = &dev->mode_config;
 
 	drm_atomic_state_clear(state);
 
@@ -269,6 +276,8 @@ void __drm_atomic_state_free(struct kref
 		drm_atomic_state_default_release(state);
 		kfree(state);
 	}
+
+	drm_dev_put(dev);
 }
 EXPORT_SYMBOL(__drm_atomic_state_free);
 


