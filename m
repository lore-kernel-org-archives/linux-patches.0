Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBFE78C92;
	Wed,  7 Aug 2024 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043285; cv=none; b=IjWjgPRP1nZSNkbB9kHRG5XE/iUhXIJJyZ0QYi93+iOSzfNzHqczezNWcOAWz9m1Q2CDrIx9J9TYnhWzFfqdByUDY/BvWJPwbFNg0gEG8yddyCTxv9vq2Tzjg7W7qDY5sVxOqV3aSvJDyhy6lMP/8l6XYau3bhDeJJAVHi2yjyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043285; c=relaxed/simple;
	bh=DFdYc8tLm8XsPfeBDQwWzd1HixQPfPvr1prccoG+6/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx0GHkMfBAfwVZvntmVtffvkhoDTO3teySPYvWc3I5dign4ZK8iQcLrF18B6srvFx/miw0Spz1OxTlG+qKKYwg3MbJbTgm7mgSonAY9egvafew3VxzK9d0kTRVBOMmD1EkQOLiEguBa6ITu6jl+4u2Mv70VHwCHSuB6fDKduH98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnZiN1K2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnZiN1K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7AAC4AF0D;
	Wed,  7 Aug 2024 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043285;
	bh=DFdYc8tLm8XsPfeBDQwWzd1HixQPfPvr1prccoG+6/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnZiN1K2/34mL5Btf79tLUt2Stktbuv21RKCZN03IB9NhA1PWSvDxBtGyjJMPAsMu
	 /lQHX+SCoNDANPyKYAWugEcf6rfCS+GokYTzDWrRD0SpiufreHhfycP4J9PhTbKOH7
	 uHucRTx4qMnyNtIaoKpA4Rei3tRySRTtkmksxsyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/121] firmware/sysfb: Update screen_info for relocated EFI framebuffers
Date: Wed,  7 Aug 2024 16:59:27 +0200
Message-ID: <20240807150020.483198360@linuxfoundation.org>
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

[ Upstream commit 78aa89d1dfba1e3cf4a2e053afa3b4c4ec622371 ]

On ARM PCI systems, the PCI hierarchy might be reconfigured during
boot and the firmware framebuffer might move as a result of that.
The values in screen_info will then be invalid.

Work around this problem by tracking the framebuffer's initial
location before it get relocated; then fix the screen_info state
between reloaction and creating the firmware framebuffer's device.

This functionality has been lifted from efifb. See the commit message
of commit 55d728a40d36 ("efi/fb: Avoid reconfiguration of BAR that
covers the framebuffer") for more information.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240212090736.11464-8-tzimmermann@suse.de
Stable-dep-of: c2bc958b2b03 ("fbdev: vesafb: Detect VGA compatibility from screen info's VESA attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/sysfb.c        |  2 +
 drivers/video/screen_info_pci.c | 88 +++++++++++++++++++++++++++++++++
 include/linux/screen_info.h     | 16 ++++++
 3 files changed, 106 insertions(+)

diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 3c197db42c9d9..defd7a36cb08a 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -77,6 +77,8 @@ static __init int sysfb_init(void)
 	bool compatible;
 	int ret = 0;
 
+	screen_info_apply_fixups();
+
 	mutex_lock(&disable_lock);
 	if (disabled)
 		goto unlock_mutex;
diff --git a/drivers/video/screen_info_pci.c b/drivers/video/screen_info_pci.c
index d8985a54ce717..6c58335171410 100644
--- a/drivers/video/screen_info_pci.c
+++ b/drivers/video/screen_info_pci.c
@@ -1,7 +1,95 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/pci.h>
+#include <linux/printk.h>
 #include <linux/screen_info.h>
+#include <linux/string.h>
+
+static struct pci_dev *screen_info_lfb_pdev;
+static size_t screen_info_lfb_bar;
+static resource_size_t screen_info_lfb_offset;
+static struct resource screen_info_lfb_res = DEFINE_RES_MEM(0, 0);
+
+static bool __screen_info_relocation_is_valid(const struct screen_info *si, struct resource *pr)
+{
+	u64 size = __screen_info_lfb_size(si, screen_info_video_type(si));
+
+	if (screen_info_lfb_offset > resource_size(pr))
+		return false;
+	if (size > resource_size(pr))
+		return false;
+	if (resource_size(pr) - size < screen_info_lfb_offset)
+		return false;
+
+	return true;
+}
+
+void screen_info_apply_fixups(void)
+{
+	struct screen_info *si = &screen_info;
+
+	if (screen_info_lfb_pdev) {
+		struct resource *pr = &screen_info_lfb_pdev->resource[screen_info_lfb_bar];
+
+		if (pr->start != screen_info_lfb_res.start) {
+			if (__screen_info_relocation_is_valid(si, pr)) {
+				/*
+				 * Only update base if we have an actual
+				 * relocation to a valid I/O range.
+				 */
+				__screen_info_set_lfb_base(si, pr->start + screen_info_lfb_offset);
+				pr_info("Relocating firmware framebuffer to offset %pa[d] within %pr\n",
+					&screen_info_lfb_offset, pr);
+			} else {
+				pr_warn("Invalid relocating, disabling firmware framebuffer\n");
+			}
+		}
+	}
+}
+
+static void screen_info_fixup_lfb(struct pci_dev *pdev)
+{
+	unsigned int type;
+	struct resource res[SCREEN_INFO_MAX_RESOURCES];
+	size_t i, numres;
+	int ret;
+	const struct screen_info *si = &screen_info;
+
+	if (screen_info_lfb_pdev)
+		return; // already found
+
+	type = screen_info_video_type(si);
+	if (type != VIDEO_TYPE_EFI)
+		return; // only applies to EFI
+
+	ret = screen_info_resources(si, res, ARRAY_SIZE(res));
+	if (ret < 0)
+		return;
+	numres = ret;
+
+	for (i = 0; i < numres; ++i) {
+		struct resource *r = &res[i];
+		const struct resource *pr;
+
+		if (!(r->flags & IORESOURCE_MEM))
+			continue;
+		pr = pci_find_resource(pdev, r);
+		if (!pr)
+			continue;
+
+		/*
+		 * We've found a PCI device with the framebuffer
+		 * resource. Store away the parameters to track
+		 * relocation of the framebuffer aperture.
+		 */
+		screen_info_lfb_pdev = pdev;
+		screen_info_lfb_bar = pr - pdev->resource;
+		screen_info_lfb_offset = r->start - pr->start;
+		memcpy(&screen_info_lfb_res, r, sizeof(screen_info_lfb_res));
+	}
+}
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY, 16,
+			       screen_info_fixup_lfb);
 
 static struct pci_dev *__screen_info_pci_dev(struct resource *res)
 {
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 0eae08e3c6f90..75303c126285a 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -4,6 +4,8 @@
 
 #include <uapi/linux/screen_info.h>
 
+#include <linux/bits.h>
+
 /**
  * SCREEN_INFO_MAX_RESOURCES - maximum number of resources per screen_info
  */
@@ -27,6 +29,17 @@ static inline u64 __screen_info_lfb_base(const struct screen_info *si)
 	return lfb_base;
 }
 
+static inline void __screen_info_set_lfb_base(struct screen_info *si, u64 lfb_base)
+{
+	si->lfb_base = lfb_base & GENMASK_ULL(31, 0);
+	si->ext_lfb_base = (lfb_base & GENMASK_ULL(63, 32)) >> 32;
+
+	if (si->ext_lfb_base)
+		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
+	else
+		si->capabilities &= ~VIDEO_CAPABILITY_64BIT_BASE;
+}
+
 static inline u64 __screen_info_lfb_size(const struct screen_info *si, unsigned int type)
 {
 	u64 lfb_size = si->lfb_size;
@@ -106,8 +119,11 @@ static inline unsigned int screen_info_video_type(const struct screen_info *si)
 ssize_t screen_info_resources(const struct screen_info *si, struct resource *r, size_t num);
 
 #if defined(CONFIG_PCI)
+void screen_info_apply_fixups(void);
 struct pci_dev *screen_info_pci_dev(const struct screen_info *si);
 #else
+static inline void screen_info_apply_fixups(void)
+{ }
 static inline struct pci_dev *screen_info_pci_dev(const struct screen_info *si)
 {
 	return NULL;
-- 
2.43.0



