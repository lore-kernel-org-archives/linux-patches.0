Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9998230D0F;
	Mon, 10 Mar 2025 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627526; cv=none; b=g80wXwOs0+IhMEmd7BjSRRNYjM7ic3C7cFtulS3nps6/2wFtzbpcDsAvXcsMuvSTxdBmSe8ScABMGR8MqE+Cp3m8eY0A/edAw9E9edfHzCcPKde6XaxQneq4KQYzoQx/5WpFI9Pj0E7FlNapsuao8u1SppXcxPZNQmibUR0Vy8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627526; c=relaxed/simple;
	bh=z3V+ljAKnoNFG8at5xRP1ID78SSFUCDbMPRyy7/do9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFL1d008gJwyTseGi4hQz6HqNBN0yMCugkojFWurRUNmEqN2RvxZnpvA7kW1Yh1h4S+OJPBHhT5h4iSBolJi7EG02EiKIQBx1trNUDMoukyuQlNUs6ObEO935jtREw5sU771sJOFzYboJVlahtVE32Hivfq+ziOk8L1CbGePoGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZI67jCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZI67jCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B62C4CEE5;
	Mon, 10 Mar 2025 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627526;
	bh=z3V+ljAKnoNFG8at5xRP1ID78SSFUCDbMPRyy7/do9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZI67jCGchV/hzPfif239fvSe93pDIc5bwjxGHjL6xJ+pjRijVCbrkzB+U6B3OsHW
	 IoMMxnK471/UnveyUa8j5WQ1Yap1HWyW2kFpdQJhKJTtyksZgM3jveWDZ3TvupyvlV
	 9JYvU5frKDXaBEvMXSuo2qBxfo6EDpmVV16OFwdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/269] drm/nouveau: Run DRM default client setup
Date: Mon, 10 Mar 2025 18:05:13 +0100
Message-ID: <20250310170504.099598592@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit ef350898ae22db832ada972476fa2999f8ea978c ]

Call drm_client_setup() to run the kernel's default client setup
for DRM. Set fbdev_probe in struct drm_driver, so that the client
setup can start the common fbdev client.

The nouveau driver specifies a preferred color mode depending on
the available video memory, with a default of 32. Adapt this for
the new client interface.

v5:
- select DRM_CLIENT_SELECTION
v2:
- style changes

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924071734.98201-69-tzimmermann@suse.de
Stable-dep-of: 6b481ab0e685 ("drm/nouveau: select FW caching")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/Kconfig       |  1 +
 drivers/gpu/drm/nouveau/nouveau_drm.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index ceef470c9fbfc..ce840300578d8 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -4,6 +4,7 @@ config DRM_NOUVEAU
 	depends on DRM && PCI && MMU
 	select IOMMU_API
 	select FW_LOADER
+	select DRM_CLIENT_SELECTION
 	select DRM_DISPLAY_DP_HELPER
 	select DRM_DISPLAY_HDMI_HELPER
 	select DRM_DISPLAY_HELPER
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 34985771b2a28..6e5adab034713 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -31,6 +31,7 @@
 #include <linux/dynamic_debug.h>
 
 #include <drm/drm_aperture.h>
+#include <drm/drm_client_setup.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_fbdev_ttm.h>
 #include <drm/drm_gem_ttm_helper.h>
@@ -836,6 +837,7 @@ static int nouveau_drm_probe(struct pci_dev *pdev,
 {
 	struct nvkm_device *device;
 	struct nouveau_drm *drm;
+	const struct drm_format_info *format;
 	int ret;
 
 	if (vga_switcheroo_client_probe_defer(pdev))
@@ -873,9 +875,11 @@ static int nouveau_drm_probe(struct pci_dev *pdev,
 		goto fail_pci;
 
 	if (drm->client.device.info.ram_size <= 32 * 1024 * 1024)
-		drm_fbdev_ttm_setup(drm->dev, 8);
+		format = drm_format_info(DRM_FORMAT_C8);
 	else
-		drm_fbdev_ttm_setup(drm->dev, 32);
+		format = NULL;
+
+	drm_client_setup(drm->dev, format);
 
 	quirk_broken_nv_runpm(pdev);
 	return 0;
@@ -1318,6 +1322,8 @@ driver_stub = {
 	.dumb_create = nouveau_display_dumb_create,
 	.dumb_map_offset = drm_gem_ttm_dumb_map_offset,
 
+	DRM_FBDEV_TTM_DRIVER_OPS,
+
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
 #ifdef GIT_REVISION
-- 
2.39.5



