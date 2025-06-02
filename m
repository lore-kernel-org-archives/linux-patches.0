Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9832236E0;
	Mon,  2 Jun 2025 14:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873543; cv=none; b=DRrXU44oCHTAWwIHD3nEi8DikY9UcR4IuHZuwjDNeLlNZvdpdv4qXE8BsaTvmQyRPP886atw42YFfLNnnoVRRq+sOMY/nu56Ka/15h7ZWi/NVjGvGKM3Ez5i4q7X14aYh3sizQcXD9quL6nbDVXdHV+n08E3Q9qRsPXTAGjGQLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873543; c=relaxed/simple;
	bh=VaLZT88sn+bbqB/UmsZP3JybiuL6fD6kwRo9bLBk2dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4OF1kYB9qfAjjxiKBJ5A6RFweZqEBefyBo3resOi5BDWYqap5jJkMZKJCeeSGEpUTzLlz/6p5tRUJi5xkyrceQOM9uJ2DyDGFXnmT7kh92cJbB9eFgsUC8kmSIrTwOGA3O/TLEQYkTQVa0nFnRJWyPWtYZYKzHjbHKvp2EjHkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqgSBYT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqgSBYT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D436C4CEEB;
	Mon,  2 Jun 2025 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873543;
	bh=VaLZT88sn+bbqB/UmsZP3JybiuL6fD6kwRo9bLBk2dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqgSBYT8ohMocPqArYLT5DfqJjJK3MqzrK1+I9jn/t8//C8uJW/OutK7CitoKniVQ
	 UMjVA2oL2+iIMLPc9WWxAS7fyq6ZoE5Q7ZrlL6Y1xDbXSrtNNckyw0LzGXcLpmNvWO
	 tsm5ARIMhYwkZ7zZ1ZWpPodS0I2M8K0ti0IdPGl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Anusha Srivatsa <asrivats@redhat.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/444] drm/gem: Test for imported GEM buffers with helper
Date: Mon,  2 Jun 2025 15:43:28 +0200
Message-ID: <20250602134346.753775296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44a948b80ee14..deb93f78ce344 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -322,7 +322,7 @@ int drm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
 		return -ENOENT;
 
 	/* Don't allow imported objects to be mapped */
-	if (obj->import_attach) {
+	if (drm_gem_is_imported(obj)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1155,7 +1155,7 @@ void drm_gem_print_info(struct drm_printer *p, unsigned int indent,
 			  drm_vma_node_start(&obj->vma_node));
 	drm_printf_indent(p, indent, "size=%zu\n", obj->size);
 	drm_printf_indent(p, indent, "imported=%s\n",
-			  str_yes_no(obj->import_attach));
+			  str_yes_no(drm_gem_is_imported(obj)));
 
 	if (obj->funcs->print_info)
 		obj->funcs->print_info(p, indent, obj);
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 7c2ec139c464a..fbfccb96dd17b 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -35,6 +35,7 @@
  */
 
 #include <linux/kref.h>
+#include <linux/dma-buf.h>
 #include <linux/dma-resv.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -557,6 +558,19 @@ static inline bool drm_gem_object_is_shared_for_memory_stats(struct drm_gem_obje
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



