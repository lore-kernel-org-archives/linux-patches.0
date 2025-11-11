Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B91308F1D;
	Tue, 11 Nov 2025 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823906; cv=none; b=owyERSmKr+uouUGak3wKkBqfN0ka+PsGEoEJllsk9GBi9LCHoXBWRO5O0z4UT0TpGf1TDcC1U2X7sErul0MvXGclaJjQyVfp52AJhXjRV8c13rUu2poHm0amcf8fDWLcfXrbvQeqkJ2ossUasn8FWCW/yDrxAy9Ug8z4MehLlAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823906; c=relaxed/simple;
	bh=YN3V0aLWeUh19GMjw11WilCo4iXvO9Hk3X2+sQHGNNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IfwhVd+SEVxzCh+Rk6EQCMKINRKG4A7l5fl32npGy1aKqc0GrUB4TA9bPjtiIcaBR5ileo3DwotHrAziMtXbbhY92UScnEGHkC9bOCqdkOUS/CRC+2lMYivhgnoWJCL0SNTZVqdsnL2tUp/vre42W9Mn/3tmsWBN3KNCHnW2CWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7lYQKZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7lYQKZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04EAC19422;
	Tue, 11 Nov 2025 01:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823906;
	bh=YN3V0aLWeUh19GMjw11WilCo4iXvO9Hk3X2+sQHGNNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7lYQKZ1+ZdObQysIkqr+gHsBDze5Z3Wq9vYin3fGOhejnmtRTCDoRjYF4IkfFCJF
	 +SGc77t3Z2T59xN80NaR34H+1zvUrOclEsO5CSzPbKujTKSq3NZQQhQDLctMB7wrBo
	 EuN/NDsw+40vmHqoluNkHPz6R7CmVbZdxi2482MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 395/849] drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)
Date: Tue, 11 Nov 2025 09:39:25 +0900
Message-ID: <20251111004545.985890565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5e375e9c4f5de..a381de8648e54 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1195,29 +1195,60 @@ static void amdgpu_connector_dvi_force(struct drm_connector *connector)
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
 					    const struct drm_display_mode *mode)
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



