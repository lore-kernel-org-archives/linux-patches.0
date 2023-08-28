Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF611C94
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D194BC433C8;
	Mon, 28 Aug 2023 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218607;
	bh=mwknJkyoH5UO24OF0N2LW4xoJd3pjAzpMHHxPzl5kic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDW63G9cEQFKSJBYoPg4Vvq5MnD61ONk8MRWLjRvQIeVrrv5/mK2ozW3sUDfD7iuT
	 oK72yryC5nzDohDGbd5/vVBnh2v1vs+4f4M19HAVPBT0TNjzATc1IR3oDiLdxKTQsn
	 fiyPOFhCPylMA50MTKppUKYop2aMy591Hz66vb2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-fbdev@vger.kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/122] fbdev/radeon: use pci aperture helpers
Date: Mon, 28 Aug 2023 12:12:00 +0200
Message-ID: <20230828101156.656023754@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 9b539c4d1b921bc9c8c578d4d50f0a7e7874d384 ]

It's not exactly the same since the open coded version doesn't set
primary correctly. But that's a bugfix, so shouldn't hurt really.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-fbdev@vger.kernel.org
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230111154112.90575-7-daniel.vetter@ffwll.ch
Stable-dep-of: 5ae3716cfdcd ("video/aperture: Only remove sysfb on the default vga pci device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/aty/radeon_base.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/aty/radeon_base.c b/drivers/video/fbdev/aty/radeon_base.c
index 8b28c9bddd974..50c384ce28837 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2238,14 +2238,6 @@ static const struct bin_attribute edid2_attr = {
 	.read	= radeon_show_edid2,
 };
 
-static int radeon_kick_out_firmware_fb(struct pci_dev *pdev)
-{
-	resource_size_t base = pci_resource_start(pdev, 0);
-	resource_size_t size = pci_resource_len(pdev, 0);
-
-	return aperture_remove_conflicting_devices(base, size, false, KBUILD_MODNAME);
-}
-
 static int radeonfb_pci_register(struct pci_dev *pdev,
 				 const struct pci_device_id *ent)
 {
@@ -2296,7 +2288,7 @@ static int radeonfb_pci_register(struct pci_dev *pdev,
 	rinfo->fb_base_phys = pci_resource_start (pdev, 0);
 	rinfo->mmio_base_phys = pci_resource_start (pdev, 2);
 
-	ret = radeon_kick_out_firmware_fb(pdev);
+	ret = aperture_remove_conflicting_pci_devices(pdev, KBUILD_MODNAME);
 	if (ret)
 		goto err_release_fb;
 
-- 
2.40.1



