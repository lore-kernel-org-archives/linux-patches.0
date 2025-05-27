Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2D27FD63;
	Tue, 27 May 2025 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368397; cv=none; b=gioKS9uLRai68rIsOB3rW72OGhqYzDJwVQO4f22wwpWZ6ZK7Jsv6qDVQA3N19q44sM3+rgv65aFNXYqHJt+fqAxkyazRQwierUW8wxgLKjW3PZKhz/QY2O91srbY8IAA0H6TbY3f7TqGJ6mSbzLcFudTHmw4ufMqJhwIE0YY2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368397; c=relaxed/simple;
	bh=GHbTdrQu4gRjh6ejPyqluQ3OdKn9MB4AHZjTpWdFvzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9x9LevVJyQrBFCG3eXal9bGckcjLzKa7R9QC8M74LuulnJaI0bIiBu3DewOm696pyrJIhxWNImTMCQY32Awb4teM+U7b3FN4LzMIPvmciaf5XDuOTLQIh6thYpb+Fi1kL753kmxr8yvwyioWXTpWZO6EVz8DQiihsgp0fh+Cro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mbA/JyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mbA/JyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C909CC4CEE9;
	Tue, 27 May 2025 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368397;
	bh=GHbTdrQu4gRjh6ejPyqluQ3OdKn9MB4AHZjTpWdFvzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mbA/JyPXhpklT7Xb2fWs0AdC+NLXf3aBSaatJGF3dF8Pgs2dUhHaXmxOtUQVyoOx
	 7z6sfbbJUQAbqP9uYXp6m6lbmHhR7gOROra8Z6XDA1yk9MHkKo631pJ+j/950cjvYz
	 VojRdk44wEOYC+3siUFfotX+UHYaWxIARDCYSAHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 693/783] driver core: Split devres APIs to device/devres.h
Date: Tue, 27 May 2025 18:28:10 +0200
Message-ID: <20250527162541.350632420@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a21cad9312767d26b5257ce0662699bb202cdda1 ]

device.h is a huge header which is hard to follow and easy to miss
something. Improve that by splitting devres APIs to device/devres.h.

In particular this helps to speedup the build of the code that includes
device.h solely for a devres APIs.

While at it, cast the error pointers to __iomem using IOMEM_ERR_PTR()
and fix sparse warnings.

Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 7dd7f39fce00 ("ASoC: SOF: Intel: hda: Fix UAF when reloading module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h        | 119 +-------------------------------
 include/linux/device/devres.h | 124 ++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+), 118 deletions(-)
 create mode 100644 include/linux/device/devres.h

diff --git a/include/linux/device.h b/include/linux/device.h
index 80a5b32689866..78ca7fd0e625a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -26,9 +26,9 @@
 #include <linux/atomic.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
-#include <linux/overflow.h>
 #include <linux/device/bus.h>
 #include <linux/device/class.h>
+#include <linux/device/devres.h>
 #include <linux/device/driver.h>
 #include <linux/cleanup.h>
 #include <asm/device.h>
@@ -281,123 +281,6 @@ int __must_check device_create_bin_file(struct device *dev,
 void device_remove_bin_file(struct device *dev,
 			    const struct bin_attribute *attr);
 
-/* device resource management */
-typedef void (*dr_release_t)(struct device *dev, void *res);
-typedef int (*dr_match_t)(struct device *dev, void *res, void *match_data);
-
-void *__devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp,
-			  int nid, const char *name) __malloc;
-#define devres_alloc(release, size, gfp) \
-	__devres_alloc_node(release, size, gfp, NUMA_NO_NODE, #release)
-#define devres_alloc_node(release, size, gfp, nid) \
-	__devres_alloc_node(release, size, gfp, nid, #release)
-
-void devres_for_each_res(struct device *dev, dr_release_t release,
-			 dr_match_t match, void *match_data,
-			 void (*fn)(struct device *, void *, void *),
-			 void *data);
-void devres_free(void *res);
-void devres_add(struct device *dev, void *res);
-void *devres_find(struct device *dev, dr_release_t release,
-		  dr_match_t match, void *match_data);
-void *devres_get(struct device *dev, void *new_res,
-		 dr_match_t match, void *match_data);
-void *devres_remove(struct device *dev, dr_release_t release,
-		    dr_match_t match, void *match_data);
-int devres_destroy(struct device *dev, dr_release_t release,
-		   dr_match_t match, void *match_data);
-int devres_release(struct device *dev, dr_release_t release,
-		   dr_match_t match, void *match_data);
-
-/* devres group */
-void * __must_check devres_open_group(struct device *dev, void *id, gfp_t gfp);
-void devres_close_group(struct device *dev, void *id);
-void devres_remove_group(struct device *dev, void *id);
-int devres_release_group(struct device *dev, void *id);
-
-/* managed devm_k.alloc/kfree for device drivers */
-void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp) __alloc_size(2);
-void *devm_krealloc(struct device *dev, void *ptr, size_t size,
-		    gfp_t gfp) __must_check __realloc_size(3);
-__printf(3, 0) char *devm_kvasprintf(struct device *dev, gfp_t gfp,
-				     const char *fmt, va_list ap) __malloc;
-__printf(3, 4) char *devm_kasprintf(struct device *dev, gfp_t gfp,
-				    const char *fmt, ...) __malloc;
-static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
-{
-	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
-}
-static inline void *devm_kmalloc_array(struct device *dev,
-				       size_t n, size_t size, gfp_t flags)
-{
-	size_t bytes;
-
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
-		return NULL;
-
-	return devm_kmalloc(dev, bytes, flags);
-}
-static inline void *devm_kcalloc(struct device *dev,
-				 size_t n, size_t size, gfp_t flags)
-{
-	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
-}
-static inline __realloc_size(3, 4) void * __must_check
-devm_krealloc_array(struct device *dev, void *p, size_t new_n, size_t new_size, gfp_t flags)
-{
-	size_t bytes;
-
-	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
-		return NULL;
-
-	return devm_krealloc(dev, p, bytes, flags);
-}
-
-void devm_kfree(struct device *dev, const void *p);
-char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp) __malloc;
-const char *devm_kstrdup_const(struct device *dev, const char *s, gfp_t gfp);
-void *devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp)
-	__realloc_size(3);
-
-unsigned long devm_get_free_pages(struct device *dev,
-				  gfp_t gfp_mask, unsigned int order);
-void devm_free_pages(struct device *dev, unsigned long addr);
-
-#ifdef CONFIG_HAS_IOMEM
-void __iomem *devm_ioremap_resource(struct device *dev,
-				    const struct resource *res);
-void __iomem *devm_ioremap_resource_wc(struct device *dev,
-				       const struct resource *res);
-
-void __iomem *devm_of_iomap(struct device *dev,
-			    struct device_node *node, int index,
-			    resource_size_t *size);
-#else
-
-static inline
-void __iomem *devm_ioremap_resource(struct device *dev,
-				    const struct resource *res)
-{
-	return ERR_PTR(-EINVAL);
-}
-
-static inline
-void __iomem *devm_ioremap_resource_wc(struct device *dev,
-				       const struct resource *res)
-{
-	return ERR_PTR(-EINVAL);
-}
-
-static inline
-void __iomem *devm_of_iomap(struct device *dev,
-			    struct device_node *node, int index,
-			    resource_size_t *size)
-{
-	return ERR_PTR(-EINVAL);
-}
-
-#endif
-
 /* allows to add/remove a custom action to devres stack */
 int devm_remove_action_nowarn(struct device *dev, void (*action)(void *), void *data);
 
diff --git a/include/linux/device/devres.h b/include/linux/device/devres.h
new file mode 100644
index 0000000000000..6b0b265058bcc
--- /dev/null
+++ b/include/linux/device/devres.h
@@ -0,0 +1,124 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _DEVICE_DEVRES_H_
+#define _DEVICE_DEVRES_H_
+
+#include <linux/err.h>
+#include <linux/gfp_types.h>
+#include <linux/numa.h>
+#include <linux/overflow.h>
+#include <linux/stdarg.h>
+#include <linux/types.h>
+
+struct device;
+struct device_node;
+struct resource;
+
+/* device resource management */
+typedef void (*dr_release_t)(struct device *dev, void *res);
+typedef int (*dr_match_t)(struct device *dev, void *res, void *match_data);
+
+void * __malloc
+__devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp, int nid, const char *name);
+#define devres_alloc(release, size, gfp) \
+	__devres_alloc_node(release, size, gfp, NUMA_NO_NODE, #release)
+#define devres_alloc_node(release, size, gfp, nid) \
+	__devres_alloc_node(release, size, gfp, nid, #release)
+
+void devres_for_each_res(struct device *dev, dr_release_t release,
+			 dr_match_t match, void *match_data,
+			 void (*fn)(struct device *, void *, void *),
+			 void *data);
+void devres_free(void *res);
+void devres_add(struct device *dev, void *res);
+void *devres_find(struct device *dev, dr_release_t release, dr_match_t match, void *match_data);
+void *devres_get(struct device *dev, void *new_res, dr_match_t match, void *match_data);
+void *devres_remove(struct device *dev, dr_release_t release, dr_match_t match, void *match_data);
+int devres_destroy(struct device *dev, dr_release_t release, dr_match_t match, void *match_data);
+int devres_release(struct device *dev, dr_release_t release, dr_match_t match, void *match_data);
+
+/* devres group */
+void * __must_check devres_open_group(struct device *dev, void *id, gfp_t gfp);
+void devres_close_group(struct device *dev, void *id);
+void devres_remove_group(struct device *dev, void *id);
+int devres_release_group(struct device *dev, void *id);
+
+/* managed devm_k.alloc/kfree for device drivers */
+void * __alloc_size(2)
+devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
+void * __must_check __realloc_size(3)
+devm_krealloc(struct device *dev, void *ptr, size_t size, gfp_t gfp);
+static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
+}
+static inline void *devm_kmalloc_array(struct device *dev, size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+
+	return devm_kmalloc(dev, bytes, flags);
+}
+static inline void *devm_kcalloc(struct device *dev, size_t n, size_t size, gfp_t flags)
+{
+	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
+}
+static inline __realloc_size(3, 4) void * __must_check
+devm_krealloc_array(struct device *dev, void *p, size_t new_n, size_t new_size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
+		return NULL;
+
+	return devm_krealloc(dev, p, bytes, flags);
+}
+
+void devm_kfree(struct device *dev, const void *p);
+
+void * __realloc_size(3)
+devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp);
+
+char * __malloc
+devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
+const char *devm_kstrdup_const(struct device *dev, const char *s, gfp_t gfp);
+char * __printf(3, 0) __malloc
+devm_kvasprintf(struct device *dev, gfp_t gfp, const char *fmt, va_list ap);
+char * __printf(3, 4) __malloc
+devm_kasprintf(struct device *dev, gfp_t gfp, const char *fmt, ...);
+
+unsigned long devm_get_free_pages(struct device *dev, gfp_t gfp_mask, unsigned int order);
+void devm_free_pages(struct device *dev, unsigned long addr);
+
+#ifdef CONFIG_HAS_IOMEM
+
+void __iomem *devm_ioremap_resource(struct device *dev, const struct resource *res);
+void __iomem *devm_ioremap_resource_wc(struct device *dev, const struct resource *res);
+
+void __iomem *devm_of_iomap(struct device *dev, struct device_node *node, int index,
+			    resource_size_t *size);
+#else
+
+static inline
+void __iomem *devm_ioremap_resource(struct device *dev, const struct resource *res)
+{
+	return IOMEM_ERR_PTR(-EINVAL);
+}
+
+static inline
+void __iomem *devm_ioremap_resource_wc(struct device *dev, const struct resource *res)
+{
+	return IOMEM_ERR_PTR(-EINVAL);
+}
+
+static inline
+void __iomem *devm_of_iomap(struct device *dev, struct device_node *node, int index,
+			    resource_size_t *size)
+{
+	return IOMEM_ERR_PTR(-EINVAL);
+}
+
+#endif
+
+#endif /* _DEVICE_DEVRES_H_ */
-- 
2.39.5



