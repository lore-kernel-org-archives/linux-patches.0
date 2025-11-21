Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A02DCF55;
	Fri, 21 Nov 2025 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732676; cv=none; b=lr3vKU0HWjYFCHsi//wVh/pAFDLcOl1C8r4Wtms2Z5pDMxSt+IQ3jQBxQlh7rUcJdwbtdrdQYez0+NNEmPCS0KvEK73Qs0Fj1+O4AYNUc4q8zeILYfJKT+7YuLxIUYz9AT45rfNCoELxSDok32aYKq0DLIZJIILae4JvVo0gSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732676; c=relaxed/simple;
	bh=ypBWEsENghZQFvjxiiFsEaLbWGP7TlB6MyJjBNFd4x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LH5vabX2XAnloUd0qp6Zs8b+kB4IlwTRe9ffNWTdq6gyuYUs53F3agIMxRS85d8PcnVLXDAb1nOusZKQy+IcFupUVGdyvxTyYJU4oW9NVM8ZL+QsTlto5171aXWOyRu8Hg+WuwZZ4je3oa6w7yb1iIjxH/r+JZAaB1yNMVjJE4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvmYNelz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvmYNelz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52233C4CEF1;
	Fri, 21 Nov 2025 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732675;
	bh=ypBWEsENghZQFvjxiiFsEaLbWGP7TlB6MyJjBNFd4x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvmYNelzvfCmmkfSRlk5m7qI28SaOXYHzEPZxcxoO0ztFkuOFvnWv7WMS39hZ1DO3
	 1/5G8Lq2AVQY8uznIwuQ2kvl9UEDhwR+BzWQGmvaXxaahnpouAKG4u/vifq5489adz
	 h1W5edkmhysSgCTqTPOHca2luQ4f3jVXf5g1Z0zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/529] drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)
Date: Fri, 21 Nov 2025 14:07:49 +0100
Message-ID: <20251121130237.067950702@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 585b2f685c56c5095cc22c7202bf74d8e9a73cdd ]

Update the legacy (non-DC) display code to respect the maximum
pixel clock for HDMI and DVI-D. Reject modes that would require
a higher pixel clock than can be supported.

Also update the maximum supported HDMI clock value depending on
the ASIC type.

For reference, see the DC code:
check max_hdmi_pixel_clock in dce*_resource.c

v2:
Fix maximum clocks for DVI-D and DVI/HDMI adapters.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_connectors.c    | 57 ++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index d34037b85cf85..eb20018b61e47 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1205,29 +1205,60 @@ static void amdgpu_connector_dvi_force(struct drm_connector *connector)
 		amdgpu_connector->use_digital = true;
 }
 
+/**
+ * Returns the maximum supported HDMI (TMDS) pixel clock in KHz.
+ */
+static int amdgpu_max_hdmi_pixel_clock(const struct amdgpu_device *adev)
+{
+	if (adev->asic_type >= CHIP_POLARIS10)
+		return 600000;
+	else if (adev->asic_type >= CHIP_TONGA)
+		return 300000;
+	else
+		return 297000;
+}
+
+/**
+ * Validates the given display mode on DVI and HDMI connectors,
+ * including analog signals on DVI-I.
+ */
 static enum drm_mode_status amdgpu_connector_dvi_mode_valid(struct drm_connector *connector,
 					    struct drm_display_mode *mode)
 {
 	struct drm_device *dev = connector->dev;
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	struct amdgpu_connector *amdgpu_connector = to_amdgpu_connector(connector);
+	const int max_hdmi_pixel_clock = amdgpu_max_hdmi_pixel_clock(adev);
+	const int max_dvi_single_link_pixel_clock = 165000;
+	int max_digital_pixel_clock_khz;
 
 	/* XXX check mode bandwidth */
 
-	if (amdgpu_connector->use_digital && (mode->clock > 165000)) {
-		if ((amdgpu_connector->connector_object_id == CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_I) ||
-		    (amdgpu_connector->connector_object_id == CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_D) ||
-		    (amdgpu_connector->connector_object_id == CONNECTOR_OBJECT_ID_HDMI_TYPE_B)) {
-			return MODE_OK;
-		} else if (connector->display_info.is_hdmi) {
-			/* HDMI 1.3+ supports max clock of 340 Mhz */
-			if (mode->clock > 340000)
-				return MODE_CLOCK_HIGH;
-			else
-				return MODE_OK;
-		} else {
-			return MODE_CLOCK_HIGH;
+	if (amdgpu_connector->use_digital) {
+		switch (amdgpu_connector->connector_object_id) {
+		case CONNECTOR_OBJECT_ID_HDMI_TYPE_A:
+			max_digital_pixel_clock_khz = max_hdmi_pixel_clock;
+			break;
+		case CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_I:
+		case CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_D:
+			max_digital_pixel_clock_khz = max_dvi_single_link_pixel_clock;
+			break;
+		case CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_I:
+		case CONNECTOR_OBJECT_ID_DUAL_LINK_DVI_D:
+		case CONNECTOR_OBJECT_ID_HDMI_TYPE_B:
+			max_digital_pixel_clock_khz = max_dvi_single_link_pixel_clock * 2;
+			break;
 		}
+
+		/* When the display EDID claims that it's an HDMI display,
+		 * we use the HDMI encoder mode of the display HW,
+		 * so we should verify against the max HDMI clock here.
+		 */
+		if (connector->display_info.is_hdmi)
+			max_digital_pixel_clock_khz = max_hdmi_pixel_clock;
+
+		if (mode->clock > max_digital_pixel_clock_khz)
+			return MODE_CLOCK_HIGH;
 	}
 
 	/* check against the max pixel clock */
-- 
2.51.0



