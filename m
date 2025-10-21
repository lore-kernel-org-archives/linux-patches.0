Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93921279798;
	Tue, 21 Oct 2025 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077427; cv=none; b=FVcnIWFvpPKjp6HUpD8IhutDMJq/VGAjlrNfsMVxhOES+Wve4L4jyO4VkbaaNDkQQAh1gmX+KmBIre8u7ZdBdwu06yeYCEra/rF1XayoSiyapiULyzxcP8dRMoEWpPRJHSKh5w4lxTq+e+mZdXhyzpacukJA/fHL5syO34bGDKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077427; c=relaxed/simple;
	bh=cpn/a45Dw1tz7fQ7MQIQOybeglSH9Plfewf6nzfvEfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3CL96UAMTtXjadkDyvut0O2eVq7WVMuVzrUS1pCNqB7FOBZzd03UGIHmTY2ydU2qr67iS0tci/VD+BRSLSTd2huXTAV6UhjuGIxYBWPemrS3KHc3JKYmuNOIZ0ytL6VaJllS/RpYId0E92uTJSKJtLtQj6xRGAszilQTVKnKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OU55APoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OU55APoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21755C4CEF1;
	Tue, 21 Oct 2025 20:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077427;
	bh=cpn/a45Dw1tz7fQ7MQIQOybeglSH9Plfewf6nzfvEfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU55APocT1j+1jueEwPPE3b6s74716Q/lTl3bSa4wcK6mtFDGdcCOB8HyzpU3aMTl
	 hwZXwjlq5ncuDypZJwCeciuSa8yKJCU83QvqoWS27zuZ+A1j/+DFLFo7LfOhfdD2r4
	 KyAZLOI4+rdA1JE/kzq86qOo8vcY5jorWWM09K4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 103/159] drm/i915/frontbuffer: Move bo refcounting intel_frontbuffer_{get,release}()
Date: Tue, 21 Oct 2025 21:51:20 +0200
Message-ID: <20251021195045.660427244@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 760039c95c78490c5c66ef584fcd536797ed6a2f ]

Currently xe's intel_frontbuffer implementation forgets to
hold a reference on the bo. This makes the entire thing
extremely fragile as the cleanup order now depends on bo
references held by other things
(namely intel_fb_bo_framebuffer_fini()).

Move the bo refcounting to intel_frontbuffer_{get,release}()
so that both i915 and xe do this the same way.

I first tried to fix this by having xe do the refcounting
from its intel_bo_set_frontbuffer() implementation
(which is what i915 does currently), but turns out xe's
drm_gem_object_free() can sleep and thus drm_gem_object_put()
isn't safe to call while we hold fb_tracking.lock.

Fixes: 10690b8a49bc ("drm/i915/display: Add intel_fb_bo_framebuffer_fini")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251003145734.7634-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit eb4d490729a5fd8dc5a76d334f8d01fec7c14bbe)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_frontbuffer.c       | 10 +++++++++-
 drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h |  2 --
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.c b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
index 43be5377ddc1a..73ed28ac95734 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.c
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
@@ -270,6 +270,8 @@ static void frontbuffer_release(struct kref *ref)
 	spin_unlock(&display->fb_tracking.lock);
 
 	i915_active_fini(&front->write);
+
+	drm_gem_object_put(obj);
 	kfree_rcu(front, rcu);
 }
 
@@ -287,6 +289,8 @@ intel_frontbuffer_get(struct drm_gem_object *obj)
 	if (!front)
 		return NULL;
 
+	drm_gem_object_get(obj);
+
 	front->obj = obj;
 	kref_init(&front->ref);
 	atomic_set(&front->bits, 0);
@@ -299,8 +303,12 @@ intel_frontbuffer_get(struct drm_gem_object *obj)
 	spin_lock(&display->fb_tracking.lock);
 	cur = intel_bo_set_frontbuffer(obj, front);
 	spin_unlock(&display->fb_tracking.lock);
-	if (cur != front)
+
+	if (cur != front) {
+		drm_gem_object_put(obj);
 		kfree(front);
+	}
+
 	return cur;
 }
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h b/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h
index b6dc3d1b9bb13..b682969e3a293 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h
@@ -89,12 +89,10 @@ i915_gem_object_set_frontbuffer(struct drm_i915_gem_object *obj,
 
 	if (!front) {
 		RCU_INIT_POINTER(obj->frontbuffer, NULL);
-		drm_gem_object_put(intel_bo_to_drm_bo(obj));
 	} else if (rcu_access_pointer(obj->frontbuffer)) {
 		cur = rcu_dereference_protected(obj->frontbuffer, true);
 		kref_get(&cur->ref);
 	} else {
-		drm_gem_object_get(intel_bo_to_drm_bo(obj));
 		rcu_assign_pointer(obj->frontbuffer, front);
 	}
 
-- 
2.51.0



