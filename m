Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3641A4F8;
	Fri,  4 Sep 2026 05:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500311; cv=none; b=JFcFs7hx7sy7PGlGQ3QdjfNUm5xVSmQ52joVbva6DtErYQO+eUwpaG5m7ELaknLGqEzLFtgAmnkcHYWyXQtF5VsmL+EeZZw04RTH8rvkUh+q+5DbCuANJQPVTiNKAV1/lgzxFFxnKLX47HhXfF5GtaCuezStzYyvyJrEj0kAA4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500311; c=relaxed/simple;
	bh=BiJwtHnEYuF6JtU2x9mhW4kF1qHhmRxXJVWS1BA+A4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ss9RIv7L4kvb/ssiVYCeOwCyNaEzTYWm1e23FurzBKYSFSYG1IbKac8K7Cq4QtMRSbohW91L6HlkMKsiWr5odHhs07/TDsXdP7dkKUQ3gCDL/RvYVVmF9dmEGobUlm6xCSGZ/g/pNWSyHjRKrlsb2NRsG95+xvFvo4fvnwZRLgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he8JAMwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he8JAMwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9FA1F00A3E;
	Fri,  4 Sep 2026 05:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500309;
	bh=XtHR67B5QM1n7gHYTq/qDIe14yUIhBxagdJX09yduzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=he8JAMwQtyJCdS7AsVrQRk8RI00kN0JQjP55b6wybjVoE1rQpINJDRtQYRpZViO+q
	 prrl+cRt3r3fbM3G5b/nxjy4+S3qft3KanPi4rjBg9CiqY4lJUc1hH605Rzp84EVsG
	 AbMjGj3Lg4ua81PFlIbZPpz7OA+KJn44KhQUa2OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/552] drm/amd/display: Refactor amdgpu_dm_connector_detect (v2)
Date: Fri,  4 Sep 2026 06:52:49 +0200
Message-ID: <20260904045748.104513309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 8223a605744bb471f31018eac9075a539415b16f ]

Prepare for polling analog connectors.
Document the function better.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 35 ++++++++++---------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fd5a6c6532a1e..d70b94c688c3a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7327,29 +7327,32 @@ create_stream_for_sink(struct drm_connector *connector,
 	return stream;
 }
 
+/**
+ * amdgpu_dm_connector_detect() - Detect whether a DRM connector is connected to a display
+ *
+ * A connector is considered connected when it has a sink that is not NULL.
+ * For connectors that support HPD (hotplug detection), the connection is
+ * handled in the HPD interrupt.
+ *
+ * Notes:
+ * 1. This interface is NOT called in context of HPD irq.
+ * 2. This interface *is called* in context of user-mode ioctl. Which
+ *    makes it a bad place for *any* MST-related activity.
+ */
 static enum drm_connector_status
 amdgpu_dm_connector_detect(struct drm_connector *connector, bool force)
 {
-	bool connected;
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
 
-	/*
-	 * Notes:
-	 * 1. This interface is NOT called in context of HPD irq.
-	 * 2. This interface *is called* in context of user-mode ioctl. Which
-	 * makes it a bad place for *any* MST-related activity.
-	 */
-
-	if (aconnector->base.force == DRM_FORCE_UNSPECIFIED &&
-	    !aconnector->fake_enable)
-		connected = (aconnector->dc_sink != NULL);
-	else
-		connected = (aconnector->base.force == DRM_FORCE_ON ||
-				aconnector->base.force == DRM_FORCE_ON_DIGITAL);
-
 	update_subconnector_property(aconnector);
 
-	return (connected ? connector_status_connected :
+	if (aconnector->base.force == DRM_FORCE_ON ||
+		aconnector->base.force == DRM_FORCE_ON_DIGITAL)
+		return connector_status_connected;
+	else if (aconnector->base.force == DRM_FORCE_OFF)
+		return connector_status_disconnected;
+
+	return (aconnector->dc_sink ? connector_status_connected :
 			connector_status_disconnected);
 }
 
-- 
2.53.0



