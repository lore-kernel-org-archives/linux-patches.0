Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6661833C518;
	Wed, 21 Jan 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019456; cv=none; b=PAb3DqoRroifSSzckzwBwJcLpAKSd++Ih1wPmLHS1/Bm01i04cvSYapdo64c7H2CviyZ3GjU1EB+1Pp0ja5LIcobCy1o2q2YGLGAYmQsTWV1q//AvG5z/4wmHYdngyvdnm/bE7eGOKuREkkkLdT4pUfjzIk6NcAgNdNNp2hgwyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019456; c=relaxed/simple;
	bh=xSDmehKzPbBAdBGqPwURNVcJiBweGS0udPhnhmBRtB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjEoZK9kf81ArT0nr0wwC/lUrrnxKlxt+1/YrvcqXZLyJJV7+xPrs8Xm8JFZBDypdsv9tsDt33i2a434Sza7dfwuT91MPHd/op+AkbeTBvWpMY48hYrle+UnKLED/HsJcAHdgfw9Kk6jjZYvEDusD+VFvNw8m6bX4+c9/1NmJdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+u0AQ+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+u0AQ+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B03C4CEF1;
	Wed, 21 Jan 2026 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019456;
	bh=xSDmehKzPbBAdBGqPwURNVcJiBweGS0udPhnhmBRtB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+u0AQ+cWfWHuP289m1+FfnkF4Ql+hIHI4LkEQctNwmyUVV6PNmZHSDsl0J6sjVfk
	 x494sIuGfW5RWng53gQnmwJqbiUNq2Mi7N1EnSzXKLcz//INWis9ZELQJ/ipLsLnhD
	 OGtM/0GMlv7Bu8DvQCAgdfV/orvDwSHoFzqs2aa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/139] drm/vmwgfx: Merge vmw_bo_release and vmw_bo_free functions
Date: Wed, 21 Jan 2026 19:14:20 +0100
Message-ID: <20260121181411.901442923@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 37a0cff4551c14aca4cfa6ef3f2f0e0f61d66825 ]

Some of the warnings need to be reordered between these two functions
in order to be correct. This has happened multiple times.
Merging them solves this problem once and for all.

Fixes: d6667f0ddf46 ("drm/vmwgfx: Fix handling of dumb buffers")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20260107152059.3048329-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index e8e49f13cfa2c..86834005de713 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -32,9 +32,15 @@
 
 #include <drm/ttm/ttm_placement.h>
 
-static void vmw_bo_release(struct vmw_bo *vbo)
+/**
+ * vmw_bo_free - vmw_bo destructor
+ *
+ * @bo: Pointer to the embedded struct ttm_buffer_object
+ */
+static void vmw_bo_free(struct ttm_buffer_object *bo)
 {
 	struct vmw_resource *res;
+	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
 
 	WARN_ON(vbo->tbo.base.funcs &&
 		kref_read(&vbo->tbo.base.refcount) != 0);
@@ -63,20 +69,8 @@ static void vmw_bo_release(struct vmw_bo *vbo)
 		}
 		vmw_surface_unreference(&vbo->dumb_surface);
 	}
-	drm_gem_object_release(&vbo->tbo.base);
-}
-
-/**
- * vmw_bo_free - vmw_bo destructor
- *
- * @bo: Pointer to the embedded struct ttm_buffer_object
- */
-static void vmw_bo_free(struct ttm_buffer_object *bo)
-{
-	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
-
 	WARN_ON(!RB_EMPTY_ROOT(&vbo->res_tree));
-	vmw_bo_release(vbo);
+	drm_gem_object_release(&vbo->tbo.base);
 	WARN_ON(vbo->dirty);
 	kfree(vbo);
 }
-- 
2.51.0



