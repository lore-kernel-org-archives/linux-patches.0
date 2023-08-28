Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD6A11C93
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8E7C433C7;
	Mon, 28 Aug 2023 10:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218604;
	bh=hiKwYpczDxwqi8bNwU8u9fgLtGHIjMwArskL5ZT09OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNZfBJFWBFzcTou1nbDGIeqaE8hLKZyM1RUI0otV5+TsN0J7sqRLMq7Z+nTMnYvx7
	 apeKuZLBNDxEIg6hK1n11V0ndjb+OJv0HnIJw6VyEgmmQPNRAUeZK9aGb5jF0SS07e
	 Vn8E/L5BLphGPXsTnmL0iVuP9Jq5wgcMp8TWibRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/122] drm/ast: Use drm_aperture_remove_conflicting_pci_framebuffers
Date: Mon, 28 Aug 2023 12:11:59 +0200
Message-ID: <20230828101156.626841490@linuxfoundation.org>
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

[ Upstream commit c1ebead36099deb85384f6fb262fe619a04cee73 ]

It's just open coded and matches.

Note that Thomas said that his version apparently failed for some
reason, but hey maybe we should try again.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Tested-by: Thomas Zimmmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230111154112.90575-1-daniel.vetter@ffwll.ch
Stable-dep-of: 5ae3716cfdcd ("video/aperture: Only remove sysfb on the default vga pci device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_drv.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index b9392f31e6291..800471f2a2037 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -89,27 +89,13 @@ static const struct pci_device_id ast_pciidlist[] = {
 
 MODULE_DEVICE_TABLE(pci, ast_pciidlist);
 
-static int ast_remove_conflicting_framebuffers(struct pci_dev *pdev)
-{
-	bool primary = false;
-	resource_size_t base, size;
-
-	base = pci_resource_start(pdev, 0);
-	size = pci_resource_len(pdev, 0);
-#ifdef CONFIG_X86
-	primary = pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
-#endif
-
-	return drm_aperture_remove_conflicting_framebuffers(base, size, primary, &ast_driver);
-}
-
 static int ast_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ast_private *ast;
 	struct drm_device *dev;
 	int ret;
 
-	ret = ast_remove_conflicting_framebuffers(pdev);
+	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &ast_driver);
 	if (ret)
 		return ret;
 
-- 
2.40.1



