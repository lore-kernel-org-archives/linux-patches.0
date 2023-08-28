Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2536E11C9A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA8AC433C8;
	Mon, 28 Aug 2023 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218610;
	bh=gekEyGH+pCFtntiKroD2gdYpqQshKVc3dU24d74Vlf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZop2brSFprBggfh+n0jyUUYK8MDEywRUS5xUe5myk22HAvMyKNExSCC3jjgnQNYt
	 zXLW82HNmKtp6YYmm/SxE0t0Gs4xbU6feMo8xCp/w/ej7nz/QR1/XiZTHwrAOIeH2M
	 hSo936EUsTjMhBogg0ws/3qbUaRmnLZv9kjQbS54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/122] drm/gma500: Use drm_aperture_remove_conflicting_pci_framebuffers
Date: Mon, 28 Aug 2023 12:12:01 +0200
Message-ID: <20230828101156.686202522@linuxfoundation.org>
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

[ Upstream commit 80e993988b97fe794f3ec2be6db05fe30f9353c3 ]

This one nukes all framebuffers, which is a bit much. In reality
gma500 is igpu and never shipped with anything discrete, so there should
not be any difference.

v2: Unfortunately the framebuffer sits outside of the pci bars for
gma500, and so only using the pci helpers won't be enough. Otoh if we
only use non-pci helper, then we don't get the vga handling, and
subsequent refactoring to untangle these special cases won't work.

It's not pretty, but the simplest fix (since gma500 really is the only
quirky pci driver like this we have) is to just have both calls.

v4:
- fix Daniel's S-o-b address

v5:
- add back an S-o-b tag with Daniel's Intel address

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230406132109.32050-2-tzimmermann@suse.de
Stable-dep-of: 5ae3716cfdcd ("video/aperture: Only remove sysfb on the default vga pci device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/psb_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index cd9c73f5a64ab..000e6704e3c75 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -424,12 +424,17 @@ static int psb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/*
 	 * We cannot yet easily find the framebuffer's location in memory. So
-	 * remove all framebuffers here.
+	 * remove all framebuffers here. Note that we still want the pci special
+	 * handling to kick out vgacon.
 	 *
 	 * TODO: Refactor psb_driver_load() to map vdc_reg earlier. Then we
 	 *       might be able to read the framebuffer range from the device.
 	 */
-	ret = drm_aperture_remove_framebuffers(true, &driver);
+	ret = drm_aperture_remove_framebuffers(false, &driver);
+	if (ret)
+		return ret;
+
+	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &driver);
 	if (ret)
 		return ret;
 
-- 
2.40.1



