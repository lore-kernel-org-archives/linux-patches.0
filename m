Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DC252905;
	Wed,  5 Mar 2025 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198493; cv=none; b=sszqViJeOyVF1yBuRFzEHdrC0BPE4J8l+9P8cHtVC5aBlWgJnQT/mVkbBj+Ow46xjmx99KmO1Q2hBTTUIVWk3RJggfwAak7P3Gzo4zH6LFwFNbxsLKiqF9RhlgHTD4abkJSIEipatH+v2A2DaB2x0H3ZpsSniMI4fjTzF//GBsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198493; c=relaxed/simple;
	bh=iy5HdzvCCDkLD/K+kyJNjVnLJIPcjeqr+P0xW1FhTJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcN2xZKO3aNxWhZMydrllUfBqXUMITivYSr+giPJzz+7moobsuC7Eljv7eF5blDSn6vKX/uaJ/xdC5YLSPpPcXWXmjgksJU5DLZuhC+9q7tFI/pJLcFCb3RYBZfzIxHRtO5BUbzbn37fmOmA1hxxTADmIwKS+dqXTiISHSBjyjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2567Sxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2567Sxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA9C4CED1;
	Wed,  5 Mar 2025 18:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198492;
	bh=iy5HdzvCCDkLD/K+kyJNjVnLJIPcjeqr+P0xW1FhTJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2567SxptZpwyOHPD/AeDkDdDaOs4x+f4XoqdlcKEfTnPNHuDPzjnrn1UVoSgNKpU
	 NaMttrznxJ6Cp7Het296A5WbqozfdgZbhUh6SQ0ct47RC9TR7g5SjlVkBgInbqztC6
	 KTFxBPQFiAHOG3rOkTUE0UDy7lKfeoFQQGKInJek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 046/157] drm/amd/display: restore edid reading from a given i2c adapter
Date: Wed,  5 Mar 2025 18:48:02 +0100
Message-ID: <20250305174507.157203479@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 12f3b92d1cfa5526715fff93a6d6fe29300d5e2a ]

When switching to drm_edid, we slightly changed how to get edid by
removing the possibility of getting them from dc_link when in aux
transaction mode. As MST doesn't initialize the connector with
`drm_connector_init_with_ddc()`, restore the original behavior to avoid
functional changes.

v2:
- Fix build warning of unchecked dereference (kernel test bot)

CC: Alex Hung <alex.hung@amd.com>
CC: Mario Limonciello <mario.limonciello@amd.com>
CC: Roman Li <Roman.Li@amd.com>
CC: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Fixes: 48edb2a4256e ("drm/amd/display: switch amdgpu_dm_connector to use struct drm_edid")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 81262b1656feb3813e3d917ab78824df6831e69e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f7c0d7625ff12..35b9e026fe0d5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7180,8 +7180,14 @@ static void amdgpu_dm_connector_funcs_force(struct drm_connector *connector)
 	struct dc_link *dc_link = aconnector->dc_link;
 	struct dc_sink *dc_em_sink = aconnector->dc_em_sink;
 	const struct drm_edid *drm_edid;
+	struct i2c_adapter *ddc;
 
-	drm_edid = drm_edid_read(connector);
+	if (dc_link && dc_link->aux_mode)
+		ddc = &aconnector->dm_dp_aux.aux.ddc;
+	else
+		ddc = &aconnector->i2c->base;
+
+	drm_edid = drm_edid_read_ddc(connector, ddc);
 	drm_edid_connector_update(connector, drm_edid);
 	if (!drm_edid) {
 		DRM_ERROR("No EDID found on connector: %s.\n", connector->name);
@@ -7226,14 +7232,21 @@ static int get_modes(struct drm_connector *connector)
 static void create_eml_sink(struct amdgpu_dm_connector *aconnector)
 {
 	struct drm_connector *connector = &aconnector->base;
+	struct dc_link *dc_link = aconnector->dc_link;
 	struct dc_sink_init_data init_params = {
 			.link = aconnector->dc_link,
 			.sink_signal = SIGNAL_TYPE_VIRTUAL
 	};
 	const struct drm_edid *drm_edid;
 	const struct edid *edid;
+	struct i2c_adapter *ddc;
+
+	if (dc_link && dc_link->aux_mode)
+		ddc = &aconnector->dm_dp_aux.aux.ddc;
+	else
+		ddc = &aconnector->i2c->base;
 
-	drm_edid = drm_edid_read(connector);
+	drm_edid = drm_edid_read_ddc(connector, ddc);
 	drm_edid_connector_update(connector, drm_edid);
 	if (!drm_edid) {
 		DRM_ERROR("No EDID found on connector: %s.\n", connector->name);
-- 
2.39.5



