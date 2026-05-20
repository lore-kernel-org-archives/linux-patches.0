Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1706F3D6CB5;
	Wed, 20 May 2026 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297095; cv=none; b=KCjUJVHfmeRd6lY9xtJI6KljX5vkUC9gAu2NyVex9fhJ0eAvn1IXgcHfAKebZ5GTUW/9gB37rAkDIm+EtLY/GFXWU8kz9PcNh+GjBYWhIHq+Wpr13lsmNZ5r7tYe74QNQ1ScycM7gzLC3Sr9j3hUuyeLPPrv2++IM/eR4Fowa0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297095; c=relaxed/simple;
	bh=N9nUzjo4ycSrOdS9sBhi2214K8YWYgZRy/M3WaCQHbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MI22mMd9StoO/hY8QdVSA43ICRUKkPWT1MSU+rgJLzaKkOzJS8mrVOBvvkCHHu8+viLviQd/TYewOy8iNUDAOm6oW/ogTTNCB6/dpZMl+rMsU84DFT4HQgeUufSkrr4xPtJNzT2hC7ecsKNWrMAwHUEjTVBM3LMJ0+35IUP4lTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0Fz730Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0Fz730Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384B61F000E9;
	Wed, 20 May 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297093;
	bh=EAcJekvNM0f//r+tZk0fn24z2TA7PKsbQaTeOfQ/uF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0Fz730Qy2BHu6Hvpyx9o0EeIsMOMoF7ec9VmGNXclEtsHaNO5sGvi6oL1T2nV6zj
	 QZqoCGVQrZRMYzDG5Yz6tVbYyebCUQGSqx1Njd7HRKEgawIiBaAsR7JJ0hq0tJ3X+k
	 hW36yEp5R85SvrAbS+e4CM+rb6Jiege+mDRcwPoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1007/1146] drm/amd/display: Use EDID from VBIOS embedded panel info
Date: Wed, 20 May 2026 18:20:57 +0200
Message-ID: <20260520162211.022879304@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 019155e2bd3e2cec425553195e9f9bc76bb0f848 ]

When an embedded panel has no DDC, read the EDID from
the VBIOS embedded panel info and use that.

Fixes: 7c7f5b15be65 ("drm/amd/display: Refactor edid read.")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 399b9abc353c62f6e37d38325edbdb6c2c00411c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index a09761f9882d1..5b0245eb5fdb2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -993,6 +993,45 @@ dm_helpers_read_acpi_edid(struct amdgpu_dm_connector *aconnector)
 	return drm_edid_read_custom(connector, dm_helpers_probe_acpi_edid, connector);
 }
 
+static const struct drm_edid *
+dm_helpers_read_vbios_hardcoded_edid(struct dc_link *link, struct amdgpu_dm_connector *aconnector)
+{
+	struct dc_bios *bios = link->ctx->dc_bios;
+	struct embedded_panel_info info;
+	const struct drm_edid *edid;
+	enum bp_result r;
+
+	if (!dc_is_embedded_signal(link->connector_signal) ||
+	    !bios->funcs->get_embedded_panel_info)
+		return NULL;
+
+	memset(&info, 0, sizeof(info));
+	r = bios->funcs->get_embedded_panel_info(bios, &info);
+
+	if (r != BP_RESULT_OK) {
+		dm_error("Error when reading embedded panel info: %u\n", r);
+		return NULL;
+	}
+
+	if (!info.fake_edid || !info.fake_edid_size) {
+		dm_error("Embedded panel info doesn't contain an EDID\n");
+		return NULL;
+	}
+
+	edid = drm_edid_alloc(info.fake_edid, info.fake_edid_size);
+
+	if (!drm_edid_valid(edid)) {
+		dm_error("EDID from embedded panel info is invalid\n");
+		drm_edid_free(edid);
+		return NULL;
+	}
+
+	aconnector->base.display_info.width_mm = info.panel_width_mm;
+	aconnector->base.display_info.height_mm = info.panel_height_mm;
+
+	return edid;
+}
+
 void populate_hdmi_info_from_connector(struct drm_hdmi_info *hdmi, struct dc_edid_caps *edid_caps)
 {
 	edid_caps->scdc_present = hdmi->scdc.supported;
@@ -1013,6 +1052,9 @@ enum dc_edid_status dm_helpers_read_local_edid(
 
 	if (link->aux_mode)
 		ddc = &aconnector->dm_dp_aux.aux.ddc;
+	else if (link->ddc_hw_inst == GPIO_DDC_LINE_UNKNOWN &&
+		 dc_is_embedded_signal(link->connector_signal))
+		ddc = NULL;
 	else
 		ddc = &aconnector->i2c->base;
 
@@ -1023,6 +1065,8 @@ enum dc_edid_status dm_helpers_read_local_edid(
 		drm_edid = dm_helpers_read_acpi_edid(aconnector);
 		if (drm_edid)
 			drm_info(connector->dev, "Using ACPI provided EDID for %s\n", connector->name);
+		else if (!ddc)
+			drm_edid = dm_helpers_read_vbios_hardcoded_edid(link, aconnector);
 		else
 			drm_edid = drm_edid_read_ddc(connector, ddc);
 		drm_edid_connector_update(connector, drm_edid);
-- 
2.53.0



