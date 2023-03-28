Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A4B8BEB
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5572CC433D2;
	Tue, 28 Mar 2023 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016213;
	bh=+3IOEgtbXr+cxot6lBfvpe0EV/vUYpbIZpuV21F7yQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJSfJF/ad/o9KQCUevZcMcRa4XW/KXIiyrG+jDiEvU+TZ+PXfPb3owhRg13uXB6h6
	 HraDtDQulhYilRKwdUegKNfUP9rynATiGXpTYSvdO6Vue81KcNjx22yxbIZ2Hp7tfu
	 wCYEAdTMaxBHX2lR4Ff5kAm/GomVN0QX6+IXfTAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 107/146] efi: sysfb_efi: Fix DMI quirks not working for simpledrm
Date: Tue, 28 Mar 2023 16:43:16 +0200
Message-Id: <20230328142607.137325505@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 3615c78673c332b69aaacefbcde5937c5c706686 upstream.

Commit 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup
for all arches") moved the sysfb_apply_efi_quirks() call in sysfb_init()
from before the [sysfb_]parse_mode() call to after it.
But sysfb_apply_efi_quirks() modifies the global screen_info struct which
[sysfb_]parse_mode() parses, so doing it later is too late.

This has broken all DMI based quirks for correcting wrong firmware efifb
settings when simpledrm is used.

To fix this move the sysfb_apply_efi_quirks() call back to its old place
and split the new setup of the efifb_fwnode (which requires
the platform_device) into its own function and call that at
the place of the moved sysfb_apply_efi_quirks(pd) calls.

Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Cc: stable@vger.kernel.org
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/sysfb_efi.c  |    5 ++++-
 drivers/firmware/sysfb.c          |    4 +++-
 drivers/firmware/sysfb_simplefb.c |    2 +-
 include/linux/sysfb.h             |    9 +++++++--
 4 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -343,7 +343,7 @@ static const struct fwnode_operations ef
 #ifdef CONFIG_EFI
 static struct fwnode_handle efifb_fwnode;
 
-__init void sysfb_apply_efi_quirks(struct platform_device *pd)
+__init void sysfb_apply_efi_quirks(void)
 {
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
 	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
@@ -357,7 +357,10 @@ __init void sysfb_apply_efi_quirks(struc
 		screen_info.lfb_height = temp;
 		screen_info.lfb_linelength = 4 * screen_info.lfb_width;
 	}
+}
 
+__init void sysfb_set_efifb_fwnode(struct platform_device *pd)
+{
 	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI && IS_ENABLED(CONFIG_PCI)) {
 		fwnode_init(&efifb_fwnode, &efifb_fwnode_ops);
 		pd->dev.fwnode = &efifb_fwnode;
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -81,6 +81,8 @@ static __init int sysfb_init(void)
 	if (disabled)
 		goto unlock_mutex;
 
+	sysfb_apply_efi_quirks();
+
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
@@ -103,7 +105,7 @@ static __init int sysfb_init(void)
 		goto unlock_mutex;
 	}
 
-	sysfb_apply_efi_quirks(pd);
+	sysfb_set_efifb_fwnode(pd);
 
 	ret = platform_device_add_data(pd, si, sizeof(*si));
 	if (ret)
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -110,7 +110,7 @@ __init struct platform_device *sysfb_cre
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	sysfb_apply_efi_quirks(pd);
+	sysfb_set_efifb_fwnode(pd);
 
 	ret = platform_device_add_resources(pd, &res, 1);
 	if (ret)
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -70,11 +70,16 @@ static inline void sysfb_disable(void)
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
-void sysfb_apply_efi_quirks(struct platform_device *pd);
+void sysfb_apply_efi_quirks(void);
+void sysfb_set_efifb_fwnode(struct platform_device *pd);
 
 #else /* CONFIG_EFI */
 
-static inline void sysfb_apply_efi_quirks(struct platform_device *pd)
+static inline void sysfb_apply_efi_quirks(void)
+{
+}
+
+static inline void sysfb_set_efifb_fwnode(struct platform_device *pd)
 {
 }
 


