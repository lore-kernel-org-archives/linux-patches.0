Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F32778281;
	Wed,  7 Aug 2024 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043282; cv=none; b=r1aidlh2HV4xl8VC7c2gSA9xZS5sUPet7MSgR9xkwFEN7wAENJXwrIpg3Y9S6We2WZjyxLuX/jTwXLcbbs4PKaQ4CsCM+XRkDDlkfDOuICrwgiuv1jiVO/VD7ZL/ujdQkKpU6/vw2KGwvP4LtyJ1FNjdbZiMvK4bO4eBDkVRoSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043282; c=relaxed/simple;
	bh=h5OdWM/yDLKAnoRjJnXIsb/JrYZaL5D7sps9zz55nj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2uC2xfv3YvO/JNJp0xJsrUkhHant8i0QFhIHtFiOlIUAVMz5Ba5MMFcvxFX+R3sVeUUyYKTpirdRHNYN6SkY79bAekwgdY4YbOVTvFpFLsxuA/UBHy26QIoyM0x1unoMrcj2MDtqtlOS9td7AJAAYOTPQQwlt7Ocm/Wz3K3e3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6O0Xhie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6O0Xhie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF37C4AF0B;
	Wed,  7 Aug 2024 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043282;
	bh=h5OdWM/yDLKAnoRjJnXIsb/JrYZaL5D7sps9zz55nj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6O0XhienWO8KE/GV8j7Fjifrs1B/BRRyJ18UsjStC6YmHEfag6tVUPBeZ2+GS1Bg
	 4RTfxPI+HnKFDYuUY3/+rUwycErouI8W7dXv8nyRnbd/STqkPH0U/HhlDXGjETflCI
	 38XE5zPZdwk5uYL1e9tafbrTgcvgYjQ1DE4czYFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/121] video: Provide screen_info_get_pci_dev() to find screen_infos PCI device
Date: Wed,  7 Aug 2024 16:59:26 +0200
Message-ID: <20240807150020.440212849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 036105e3a776b6fc2fe0d262896a23ff2cc2e6b1 ]

Add screen_info_get_pci_dev() to find the PCI device of an instance
of screen_info. Does nothing on systems without PCI bus.

v3:
	* search PCI device with pci_get_base_class() (Sui)
v2:
	* remove ret from screen_info_pci_dev() (Javier)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240212090736.11464-3-tzimmermann@suse.de
Stable-dep-of: c2bc958b2b03 ("fbdev: vesafb: Detect VGA compatibility from screen info's VESA attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/Makefile          |  1 +
 drivers/video/screen_info_pci.c | 48 +++++++++++++++++++++++++++++++++
 include/linux/screen_info.h     | 10 +++++++
 3 files changed, 59 insertions(+)
 create mode 100644 drivers/video/screen_info_pci.c

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index b929b664d52cd..6bbf87c1b579e 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_VIDEO_NOMODESET)     += nomodeset.o
 obj-$(CONFIG_HDMI)                += hdmi.o
 
 screen_info-y			  := screen_info_generic.o
+screen_info-$(CONFIG_PCI)         += screen_info_pci.o
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_FB_STI)		  += console/
diff --git a/drivers/video/screen_info_pci.c b/drivers/video/screen_info_pci.c
new file mode 100644
index 0000000000000..d8985a54ce717
--- /dev/null
+++ b/drivers/video/screen_info_pci.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/pci.h>
+#include <linux/screen_info.h>
+
+static struct pci_dev *__screen_info_pci_dev(struct resource *res)
+{
+	struct pci_dev *pdev = NULL;
+	const struct resource *r = NULL;
+
+	if (!(res->flags & IORESOURCE_MEM))
+		return NULL;
+
+	while (!r && (pdev = pci_get_base_class(PCI_BASE_CLASS_DISPLAY, pdev))) {
+		r = pci_find_resource(pdev, res);
+	}
+
+	return pdev;
+}
+
+/**
+ * screen_info_pci_dev() - Return PCI parent device that contains screen_info's framebuffer
+ * @si: the screen_info
+ *
+ * Returns:
+ * The screen_info's parent device or NULL on success, or a pointer-encoded
+ * errno value otherwise. The value NULL is not an error. It signals that no
+ * PCI device has been found.
+ */
+struct pci_dev *screen_info_pci_dev(const struct screen_info *si)
+{
+	struct resource res[SCREEN_INFO_MAX_RESOURCES];
+	ssize_t i, numres;
+
+	numres = screen_info_resources(si, res, ARRAY_SIZE(res));
+	if (numres < 0)
+		return ERR_PTR(numres);
+
+	for (i = 0; i < numres; ++i) {
+		struct pci_dev *pdev = __screen_info_pci_dev(&res[i]);
+
+		if (pdev)
+			return pdev;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(screen_info_pci_dev);
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index e7a02c5609d12..0eae08e3c6f90 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -9,6 +9,7 @@
  */
 #define SCREEN_INFO_MAX_RESOURCES	3
 
+struct pci_dev;
 struct resource;
 
 static inline bool __screen_info_has_lfb(unsigned int type)
@@ -104,6 +105,15 @@ static inline unsigned int screen_info_video_type(const struct screen_info *si)
 
 ssize_t screen_info_resources(const struct screen_info *si, struct resource *r, size_t num);
 
+#if defined(CONFIG_PCI)
+struct pci_dev *screen_info_pci_dev(const struct screen_info *si);
+#else
+static inline struct pci_dev *screen_info_pci_dev(const struct screen_info *si)
+{
+	return NULL;
+}
+#endif
+
 extern struct screen_info screen_info;
 
 #endif /* _SCREEN_INFO_H */
-- 
2.43.0



