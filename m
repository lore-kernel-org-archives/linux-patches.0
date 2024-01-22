Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE42C14460D;
	Tue, 23 Jan 2024 00:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969546; cv=none; b=hEACOQPDaRmhsFNaGGg4NpVnqE8wigXhCm6Rvj+prrf9A+fJEdCVVHEjnkntIyJs3k4k154tsqu/eoWJTcM+LVd6FYNI0R8SrFYZ5RjUFGFKlJGiwIRlwHsr1g7jYADYyAw724rIZO1xo9lOJ+zOv74IwCI5wZIT339hJcTPfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969546; c=relaxed/simple;
	bh=fmc3LuNla5YlGwUvVBWj+kNccxR2GDKUuMhYROsm9is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gv7+mWfup+A3WhVIbvi2Oudgv7f2+1pX/DB0zMDbNLZmN6PS82AA+65M5BkWRLIJcIM7lr7771sUp5iCLZK4MmD8NwoenraJ7F6Uffh0YjwzTTSEBl3ZqvehfOA0tAenG/fo6Ex0D8FbsRTpcZENFHCxhVdlqf/SeFvkXy6iCNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM+emA91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM+emA91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758E3C43399;
	Tue, 23 Jan 2024 00:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969545;
	bh=fmc3LuNla5YlGwUvVBWj+kNccxR2GDKUuMhYROsm9is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EM+emA91TsRL4cA+WNUhXoQae5dA91aQCzd31qxD3b+iNdrNWEwBBRwIKS9MuRI+s
	 MXLoAYMnyePZJO9s/G4T6EJUc1IbA9AlGAXBMYlatvNHnmuTioQIR1S6ob6hWpielT
	 rN21Dba6BweH5p09e6uQhA1sSiRfQIJUv6Z+sGnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 293/641] drm/amd/display: Check writeback connectors in create_validate_stream_for_sink
Date: Mon, 22 Jan 2024 15:53:17 -0800
Message-ID: <20240122235827.062707974@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit dbf5d3d02987faa0eec3710dd687cd912362d7b5 ]

[WHY & HOW]
This is to check connector type to avoid
unhandled null pointer for writeback connectors.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Fixes: 60e034f28600 ("drm/amd/display: Revert "drm/amd/display: Use drm_connector in create_validate_stream_for_sink"")
Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index beacda24b4ef..a9bd020b165a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6649,6 +6649,9 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 			break;
 		}
 
+		if (aconnector->base.connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+			return stream;
+
 		dc_result = dc_validate_stream(adev->dm.dc, stream);
 		if (dc_result == DC_OK && stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 			dc_result = dm_dp_mst_is_port_support_mode(aconnector, stream);
@@ -9373,7 +9376,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
 	acrtc = to_amdgpu_crtc(crtc);
 	connector = amdgpu_dm_find_first_crtc_matching_connector(state, crtc);
-	if (connector && connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
+	if (connector)
 		aconnector = to_amdgpu_dm_connector(connector);
 
 	/* TODO This hack should go away */
-- 
2.43.0



