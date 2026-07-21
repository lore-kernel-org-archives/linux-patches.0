Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F95415F14;
	Tue, 21 Jul 2026 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661577; cv=none; b=FpgUse8lzzhuoOL2R/CdQCxLxipIS7xmu95qNSuPTU8rnMLh2zvyVMe1koTZc0rafyLOtM6J773AoeBXARiW59DFEDHkMdblVULsbavYWhZoesA7iIDndNwrUkYYAHZhg9rC+t+F0kTEjWMscezQ1LnIC8F4ue+Tx5sbM32ln1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661577; c=relaxed/simple;
	bh=OGm6+6jepLgMNb0Jn03d6Q6O0ZpaJzKLXqDrK/X4mq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoD/Chx38f7R9w+6ZjMtK/q7yYkhF/3B7R5xpGOq3zSzDHSL5q1wHGLRjcA5Gg5OkxtaVj+z/GS+TlVoDTKqrVJVVvoy00bq8MMYD7wEzlw5dSMOuH+THMTAHxEHb97IQ0sIgCuQBg2uLmv8gYjZgcTnJSIUGxbkFGPRmFyZpCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsLhCC1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsLhCC1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD81F00A3A;
	Tue, 21 Jul 2026 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661576;
	bh=tqM1XnwM5daVN9v0ldn4n0e4hPGxYLoRFm8mqKFbqgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsLhCC1J2+iD/FOsz4TPzX7PPszHFk9y2czMUN6nH/7hvaZbZDSV+qgeEZ5rkF9bT
	 npapHAti8p/oCjq+dXevtqw3O0+w+90flxmh3OJN26MRsb0r0Ae8JHBqlObU4TEoMj
	 6xBM5zRCt7IbToC/Y+OkgwUDXMq8mmUVNdZJwxFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0092/1276] drm/gpuvm: take refcount on DRM device
Date: Tue, 21 Jul 2026 17:08:55 +0200
Message-ID: <20260721152448.155434584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0321820e9bab77..2515cff3348571 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -25,6 +25,7 @@
  *
  */
 
+#include <drm/drm_drv.h>
 #include <drm/drm_gpuvm.h>
 
 #include <linux/interval_tree_generic.h>
@@ -1019,6 +1020,7 @@ drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,
 	gpuvm->drm = drm;
 	gpuvm->r_obj = r_obj;
 
+	drm_dev_get(drm);
 	drm_gem_object_get(r_obj);
 
 	drm_gpuvm_warn_check_overflow(gpuvm, start_offset, range);
@@ -1060,13 +1062,15 @@ static void
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



