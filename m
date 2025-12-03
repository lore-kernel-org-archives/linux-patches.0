Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD6135F8B7;
	Wed,  3 Dec 2025 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779255; cv=none; b=F1Jf5/NNYO1AdBGQ3zHxvQE6OfBx+c8wclRKlptl/IvsRUR66oahpSKrHRsWMdI4y+tbucfx71bQNeYpDAQxyn/egVJ05jllkMBM5SO4bmfox3Mw7Kw4Th5nFOIiIAVR9KTDOM8DL+ARneRqIcs3G1Iv4MVXBIFhj3HCUGuvHDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779255; c=relaxed/simple;
	bh=xQd3WVw048hjnTArT5q98UJEFDq/lClqo5Q05LrTs9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWz7g3A4CtJS9SmWNL5PH3lZdDxW+mqy2VKXUu4krHnw2F+OJTy6A72eO9FlmU5bH3AjJYId/J/QHvPSV4M31OaI3dB1dnVrZfCbkLN9wC4E69Qgc5kYGJz4C9Cfuyb3Upwd5rsL+Uh03Pcxq1B+ERXSRWWoEf1xHicr0HTD+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mx1aORZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mx1aORZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32F1C4CEF5;
	Wed,  3 Dec 2025 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779255;
	bh=xQd3WVw048hjnTArT5q98UJEFDq/lClqo5Q05LrTs9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mx1aORZwQlPexhjergaQT5drB01CxVHTwWkuXNFC1V0L1t0CB4pR5TB31enkONAt/
	 JDevV+h/B+i0IJjDBFm8AjbTzl6nBTh0y90YPix+u7hyhLWyhs6E5V3I0hWYy6j21f
	 zpjFGeyqmWCYjcxBLXHqdagfP/VuZsPat3Mz8dV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/568] drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)
Date: Wed,  3 Dec 2025 16:22:57 +0100
Message-ID: <20251203152447.140938676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cfb262911bfc7..9ec5706d26219 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1165,29 +1165,60 @@ static void amdgpu_connector_dvi_force(struct drm_connector *connector)
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



