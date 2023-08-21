Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CD211707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C04C433C8;
	Mon, 21 Aug 2023 19:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647619;
	bh=j9Tz6x8lkjCX9Kr2o2rDOYuwKuQ9G2uAStU3tn+6Sz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5Am+Vrafn05V1K6MWwBU9xkIltT0KBPW9LbyNOftknjpxjihUo0Al98aqk/DKBzI
	 dnxJeOZpJZS/pig3jM6lM14gBpzFUgL9Z8QUki3QmTAglnbAl2dteBk3IuLTpiUNrg
	 bVYOJvtKoPV0c4KfMXmsD0NhDQnqDwQaXG6Gz3T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Plattner <aplattner@nvidia.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/194] video/aperture: Only remove sysfb on the default vga pci device
Date: Mon, 21 Aug 2023 21:40:58 +0200
Message-ID: <20230821194126.245539327@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 5ae3716cfdcd286268133867f67d0803847acefc ]

Instead of calling aperture_remove_conflicting_devices() to remove the
conflicting devices, just call to aperture_detach_devices() to detach
the device that matches the same PCI BAR / aperture range. Since the
former is just a wrapper of the latter plus a sysfb_disable() call,
and now that's done in this function but only for the primary devices.

This fixes a regression introduced by commit ee7a69aa38d8 ("fbdev:
Disable sysfb device registration when removing conflicting FBs"),
where we remove the sysfb when loading a driver for an unrelated pci
device, resulting in the user losing their efifb console or similar.

Note that in practice this only is a problem with the nvidia blob,
because that's the only gpu driver people might install which does not
come with an fbdev driver of it's own. For everyone else the real gpu
driver will restore a working console.

Also note that in the referenced bug there's confusion that this same
bug also happens on amdgpu. But that was just another amdgpu specific
regression, which just happened to happen at roughly the same time and
with the same user-observable symptoms. That bug is fixed now, see
https://bugzilla.kernel.org/show_bug.cgi?id=216331#c15

Note that we should not have any such issues on non-pci multi-gpu
issues, because I could only find two such cases:
- SoC with some external panel over spi or similar. These panel
  drivers do not use drm_aperture_remove_conflicting_framebuffers(),
  so no problem.
- vga+mga, which is a direct console driver and entirely bypasses all
  this.

For the above reasons the cc: stable is just notionally, this patch
will need a backport and that's up to nvidia if they care enough.

v2:
- Explain a bit better why other multi-gpu that aren't pci shouldn't
  have any issues with making all this fully pci specific.

v3
- polish commit message (Javier)

v4:
- Fix commit message style (i.e., commit 1234 ("..."))
- fix Daniel's S-o-b address

v5:
- add back an S-o-b tag with Daniel's Intel address

Fixes: ee7a69aa38d8 ("fbdev: Disable sysfb device registration when removing conflicting FBs")
Tested-by: Aaron Plattner <aplattner@nvidia.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216303#c28
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org> # v5.19+ (if someone else does the backport)
Link: https://patchwork.freedesktop.org/patch/msgid/20230406132109.32050-8-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/aperture.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index 41e77de1ea82c..5c94abdb1ad6d 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -332,15 +332,16 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
 	primary = pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
 #endif
 
+	if (primary)
+		sysfb_disable();
+
 	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
 		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
 			continue;
 
 		base = pci_resource_start(pdev, bar);
 		size = pci_resource_len(pdev, bar);
-		ret = aperture_remove_conflicting_devices(base, size, primary, name);
-		if (ret)
-			return ret;
+		aperture_detach_devices(base, size);
 	}
 
 	/*
-- 
2.40.1



