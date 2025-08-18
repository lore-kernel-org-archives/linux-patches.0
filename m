Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AC932A3DE;
	Mon, 18 Aug 2025 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523706; cv=none; b=TByxktHBX5lM8SfxhcaYCdTyeQovTZyAnJJ9etgrmA67u9sl8W0q/wXXJlTTfRIJwFBP6XmtsnWxqC5QcqW7fFqOXXTpwfRIDU8/kTlhWdP29pAfBOeCkO5CR1cD5yRlC4OBFgSJ7iGrDWJ/iOtwAqOJbE2efUt5ihJW3XnTfX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523706; c=relaxed/simple;
	bh=WFaZ8bmVyn/oKGmImXkEPVWrY2q6KcV+aRXdDDnaAYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4l2Cv6vhYbIBVB60Vb5CZMyJpwXY1tgvGjp5DX63rRxkDb7itDSoIATvIkouRDXp7fSDeb0dFarqKCCp2pSQ/cVsA3Jh9byq6Coy8nKQGl9AwN1elvmkRMYHqy6tNxdb1quOtGlaEctS2Y4zuxDzE2PyGOWKvypT39rK1+2m48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+6J/DKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+6J/DKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AACDC4CEEB;
	Mon, 18 Aug 2025 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523706;
	bh=WFaZ8bmVyn/oKGmImXkEPVWrY2q6KcV+aRXdDDnaAYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+6J/DKOsXKxDVgS2Pwuo4O2IVXJIAHyqhnObiUf+M2nuP/hi24GyxBHY1OWkkCdo
	 mk4ooUr8KslgamX/rvOulhcjl/mQ/D3mP4uba2Na0SqRMX8VGoUstZ8MGDrf2SE4TQ
	 qG+0qZI2Jfvlplx9YH8ed/z85b2qA/WBFGFK9sEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 252/515] drm/fbdev-client: Skip DRM clients if modesetting is absent
Date: Mon, 18 Aug 2025 14:43:58 +0200
Message-ID: <20250818124508.092267880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit cce91f29c088ba902dd2abfc9c3216ba9a2fb2fe ]

Recent generations of Tegra have moved the display components outside of
host1x, leading to a device that has no CRTCs attached and hence doesn't
support any of the modesetting functionality. When this is detected, the
driver clears the DRIVER_MODESET and DRIVER_ATOMIC flags for the device.

Unfortunately, this causes the following errors during boot:

    [      15.418958] ERR KERN drm drm: [drm] *ERROR* Failed to register client: -95
    [      15.425311] WARNING KERN drm drm: [drm] Failed to set up DRM client; error -95

These originate from the fbdev client checking for the presence of the
DRIVER_MODESET flag and returning -EOPNOTSUPP. However, if a driver does
not support DRIVER_MODESET this is entirely expected and the error isn't
helpful.

Prevent this misleading error message by setting up the DRM clients only
if modesetting is enabled.

Changes in v2:
- use DRIVER_MODESET check to avoid registering any clients

Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250613122838.2082334-1-thierry.reding@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_client_setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/clients/drm_client_setup.c b/drivers/gpu/drm/clients/drm_client_setup.c
index e17265039ca8..e460ad354de2 100644
--- a/drivers/gpu/drm/clients/drm_client_setup.c
+++ b/drivers/gpu/drm/clients/drm_client_setup.c
@@ -2,6 +2,7 @@
 
 #include <drm/clients/drm_client_setup.h>
 #include <drm/drm_device.h>
+#include <drm/drm_drv.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_print.h>
 
@@ -31,6 +32,10 @@ MODULE_PARM_DESC(active,
  */
 void drm_client_setup(struct drm_device *dev, const struct drm_format_info *format)
 {
+	if (!drm_core_check_feature(dev, DRIVER_MODESET)) {
+		drm_dbg(dev, "driver does not support mode-setting, skipping DRM clients\n");
+		return;
+	}
 
 #ifdef CONFIG_DRM_FBDEV_EMULATION
 	if (!strcmp(drm_client_default, "fbdev")) {
-- 
2.39.5



