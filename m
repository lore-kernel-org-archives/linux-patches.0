Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB661AF0BB;
	Tue, 27 May 2025 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367089; cv=none; b=GyybvjrNzdesASOvrl13N0xSJhQ2GgYlz4/xHgyC19CHwCqq6Q/PQa/1eYZMV+jCST1V4N8g2Fnl2zktl9tv3VfAQLMl2bduAfbJHtXYnPWzBnYokGeRFy9BJWA6OhlqfGzVW901EtBSuErNLpSZdFUDxrmBL8CE9DLi1xNNguU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367089; c=relaxed/simple;
	bh=z5KRmcBHe68+fLxwydnf/kG3bFcYW+NBR3WI2ZogTO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S6grruP+BfVIJWb+it2/82flqPG5RpSvr+7nYSbicKLoeecROc/Ralxfoht4tU7KOTmCEuEitEHEe/82XRAzOJLD7ScNeAEuDhotiL5ZcgAsB5D5Bf0UdfFB49jjqr4TPiut7vasB/H4mlXtbHU7PBXF4m+xaR4kMB7O9VS2QUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XB9rGtxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB9rGtxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7203C4CEE9;
	Tue, 27 May 2025 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367089;
	bh=z5KRmcBHe68+fLxwydnf/kG3bFcYW+NBR3WI2ZogTO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XB9rGtxhGugrtnahdNCC68x2YVhvuPT7l+Krsp1Bof3j0jTP8FMrXgEsnndEPchlV
	 hp5vxOPOrXScxxGn6ZGh1xetOy1MFd8eOsTctjt5Bi6S2XHJFe+XvK4tTuvs4QDOI+
	 fP3lhR59hhyhvKLV/+Msw+habzFS7C8lncWHLLyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Anusha Srivatsa <asrivats@redhat.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 274/783] drm/gem: Test for imported GEM buffers with helper
Date: Tue, 27 May 2025 18:21:11 +0200
Message-ID: <20250527162524.243759500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit b57aa47d39e94dc47403a745e2024664e544078c ]

Add drm_gem_is_imported() that tests if a GEM object's buffer has
been imported. Update the GEM code accordingly.

GEM code usually tests for imports if import_attach has been set
in struct drm_gem_object. But attaching a dma-buf on import requires
a DMA-capable importer device, which is not the case for many serial
busses like USB or I2C. The new helper tests if a GEM object's dma-buf
has been created from the GEM object.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Anusha Srivatsa <asrivats@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226172457.217725-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem.c |  4 ++--
 include/drm/drm_gem.h     | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index ee811764c3df4..c6240bab3fa55 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -348,7 +348,7 @@ int drm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
 		return -ENOENT;
 
 	/* Don't allow imported objects to be mapped */
-	if (obj->import_attach) {
+	if (drm_gem_is_imported(obj)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1178,7 +1178,7 @@ void drm_gem_print_info(struct drm_printer *p, unsigned int indent,
 			  drm_vma_node_start(&obj->vma_node));
 	drm_printf_indent(p, indent, "size=%zu\n", obj->size);
 	drm_printf_indent(p, indent, "imported=%s\n",
-			  str_yes_no(obj->import_attach));
+			  str_yes_no(drm_gem_is_imported(obj)));
 
 	if (obj->funcs->print_info)
 		obj->funcs->print_info(p, indent, obj);
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index fdae947682cd0..2bf893eabb4b2 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -35,6 +35,7 @@
  */
 
 #include <linux/kref.h>
+#include <linux/dma-buf.h>
 #include <linux/dma-resv.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -575,6 +576,19 @@ static inline bool drm_gem_object_is_shared_for_memory_stats(struct drm_gem_obje
 	return (obj->handle_count > 1) || obj->dma_buf;
 }
 
+/**
+ * drm_gem_is_imported() - Tests if GEM object's buffer has been imported
+ * @obj: the GEM object
+ *
+ * Returns:
+ * True if the GEM object's buffer has been imported, false otherwise
+ */
+static inline bool drm_gem_is_imported(const struct drm_gem_object *obj)
+{
+	/* The dma-buf's priv field points to the original GEM object. */
+	return obj->dma_buf && (obj->dma_buf->priv != obj);
+}
+
 #ifdef CONFIG_LOCKDEP
 /**
  * drm_gem_gpuva_set_lock() - Set the lock protecting accesses to the gpuva list.
-- 
2.39.5



