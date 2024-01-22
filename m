Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8638F371;
	Tue, 23 Jan 2024 00:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969473; cv=none; b=A9kX9bz/Op1AEjzrLdtkqFDm1OnmKVfmjNjnIv00sSnBuXvaHok4NVXOf6AHGoEgoTeeMqvKF2PPXh2DCYexh4ijpxIDKJYIah97b9c9JAexkAbJDSLazCjenLTqh2a2jb0XD/iZIUIJn4RSjHkLhjmGPD7m6ovT+YFA1c2Tw/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969473; c=relaxed/simple;
	bh=x05L4RuGDybPpjmIAHDnE8r0vXLhz7Bjfp5Y7jkM568=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poRanTCWVU0OcDQpMv2LLx3wQkPwx23fy/ahNgg3JOR7KgWYK/ZCnai1KFYMyzHGaLFJNTnOalExsKDCJuTk98bP6h1J9XNald3/6LK/y8VsgLTassjjVHhmQ9KQF5PIOlavmmdVS3blWaNreYNQ2b+PzY3LPAwSZHn58vAgbnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD5swdtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD5swdtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC45C43399;
	Tue, 23 Jan 2024 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969473;
	bh=x05L4RuGDybPpjmIAHDnE8r0vXLhz7Bjfp5Y7jkM568=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XD5swdtTd9LknUBhMA8IFi+SdTrDop8qJTZs7t6rNOeNutVvTxjGfluZdnNrkv/7f
	 l3a46vmKSxtG/KLaFz/HjIlIqHnjgE9cazrovU5pFY6bOjhkNyjpI1cnL7khfoCn99
	 9+Dn5HUZAh9PDUDqcMcrdaYfWtozkEg4udApUWVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 244/641] drm/i915/display: Move releasing gem object away from fb tracking
Date: Mon, 22 Jan 2024 15:52:28 -0800
Message-ID: <20240122235825.560925905@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 501069dad5214fafe1b8ba38fa26a5d07df784c3 ]

As a preparation for Xe we want to remove all i915_gem_object details away
from frontbuffer tacking code. Due to this move releasing gem object
reference to i915_gem_object_set_frontbuffer.

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231012072158.4115795-2-jouni.hogander@intel.com
Stable-dep-of: 560ea72c76eb ("drm/i915/dp_mst: Fix race between connector registration and setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_frontbuffer.c       | 2 --
 drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.c b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
index ec46716b2f49..2ea37c0414a9 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.c
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
@@ -265,8 +265,6 @@ static void frontbuffer_release(struct kref *ref)
 	spin_unlock(&intel_bo_to_i915(obj)->display.fb_tracking.lock);
 
 	i915_active_fini(&front->write);
-
-	i915_gem_object_put(obj);
 	kfree_rcu(front, rcu);
 }
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h b/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h
index e5e870b6f186..9fbf14867a2a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_frontbuffer.h
@@ -89,6 +89,7 @@ i915_gem_object_set_frontbuffer(struct drm_i915_gem_object *obj,
 
 	if (!front) {
 		RCU_INIT_POINTER(obj->frontbuffer, NULL);
+		drm_gem_object_put(intel_bo_to_drm_bo(obj));
 	} else if (rcu_access_pointer(obj->frontbuffer)) {
 		cur = rcu_dereference_protected(obj->frontbuffer, true);
 		kref_get(&cur->ref);
-- 
2.43.0



