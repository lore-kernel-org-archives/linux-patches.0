Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C67246AA94;
	Tue, 21 Jul 2026 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648279; cv=none; b=n+hLx2drlf5L6lXWOJ/UnjGuMCIJGquv+K0vQW+pf3FkSBJkPHZpVO5kT0kHpK7gD/KgpDin+yUrZjnR4m11h/0dyOSUksNZMDzTmrKcVcsIMpOOjKbvOAvyE4+L7KN0d0yOV+MrP/14c0qA5h1IdVNCapp5WLEq/m8TtZDU9R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648279; c=relaxed/simple;
	bh=88C5BGdqTCZxsvfKr60844lBkbSEYcmD+RgPMnoYd98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7R6dAQG+UybvE6hR4zt1tDhpXpgYnKjoAiZXa0HJTl42iUN+jB0h4aqIoBLYnpI1fX8DWaewUSyhH6kE6Otbndft/LlLYPMHz62HtvanE/ZkRiUrNK6PLPHHlybh+28yNNdT+0zsGqL5hgO/ET5y38+31m419lHp9BBdFBvyK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0fqekmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0fqekmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB261F000E9;
	Tue, 21 Jul 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648278;
	bh=u4lFQRjC7t67zBqWQTtk9T/2wS5uboUbmIej7XKrcuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0fqekmuMk+8fRK6Gp0cqKr/Oli39qh6rH4HWsYB38OVhAFsbb7UMrDWx01VBrYF9
	 1lBD8j3wCySonnGKvfFQkzQKdlyJ9L05va5cROiyU27B6hX2LkM8CHwVv5OkP4xmVK
	 a9e8P7xd7644Ir8FEC+VrESv7NNKBdyp4lUVpYPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0140/2077] drm/gpuvm: take refcount on DRM device
Date: Tue, 21 Jul 2026 16:56:53 +0200
Message-ID: <20260721152555.990413791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit c2d72717e0a9dd01c6a1bac61a1462a8e04bd179 ]

Currently GPUVM relies on the owner implicitly holding a refcount to the
drm device, and it does not implicitly take a refcount on the drm
device. This design is error-prone, so take a refcount on the device.

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 546ca4d35dcc ("drm/gpuvm: convert WARN() to drm_WARN() variants")
Link: https://patch.msgid.link/20260416-gpuvm-drm-dev-get-v1-1-f3bc06571e73@google.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpuvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gpuvm.c b/drivers/gpu/drm/drm_gpuvm.c
index f56719e9f4350a..83020b6cf9ba15 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -25,6 +25,7 @@
  *
  */
 
+#include <drm/drm_drv.h>
 #include <drm/drm_gpuvm.h>
 #include <drm/drm_print.h>
 
@@ -1117,6 +1118,7 @@ drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,
 	gpuvm->drm = drm;
 	gpuvm->r_obj = r_obj;
 
+	drm_dev_get(drm);
 	drm_gem_object_get(r_obj);
 
 	drm_gpuvm_warn_check_overflow(gpuvm, start_offset, range);
@@ -1160,13 +1162,15 @@ static void
 drm_gpuvm_free(struct kref *kref)
 {
 	struct drm_gpuvm *gpuvm = container_of(kref, struct drm_gpuvm, kref);
+	struct drm_device *drm = gpuvm->drm;
 
 	drm_gpuvm_fini(gpuvm);
 
-	if (drm_WARN_ON(gpuvm->drm, !gpuvm->ops->vm_free))
+	if (drm_WARN_ON(drm, !gpuvm->ops->vm_free))
 		return;
 
 	gpuvm->ops->vm_free(gpuvm);
+	drm_dev_put(drm);
 }
 
 /**
-- 
2.53.0



