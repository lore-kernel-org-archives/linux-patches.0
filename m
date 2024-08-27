Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7062A1BC9E3;
	Tue, 27 Aug 2024 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771372; cv=none; b=mieRHFM0+QSGfuyuRRmaE1hd/GGTjsggFan/TGn7EU7kRNrCVO3SRoxDFkgAcRvfAZw5ovAxC9eLdHGC/zEspK/FUxBQvVJqkZX14+ftiNo4Nf5b5YwlP9GThvCfV7uhj+SakYr8aXYXTvIv4tw/zHJC/T5N9+ZEeFzBdzcWX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771372; c=relaxed/simple;
	bh=OCkMetbm6vVHqtsIK62w/aDUv0g0LeCo2K6O7mMTiL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3R9HpcMTXDCsUpMnmUVVhPnxG8m9lA7+dsoCeh2fl7dUN3Gl6aMOyD7lYpqaUcp2u1y73UjOcoexn/vDevPMSdvaeBj8fr2BJI/GdVDfZImlb8qYcSeXGW+GeG4RPMTjlG8otLGAKvuaMXpR/IpHO8qYjQwEh315Q61j22p3AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGYiNozr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGYiNozr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D570AC4AF18;
	Tue, 27 Aug 2024 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771372;
	bh=OCkMetbm6vVHqtsIK62w/aDUv0g0LeCo2K6O7mMTiL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGYiNozrq99OsDw2/PmtssCmHt6g1hoTd2+UKeMlZ8DPTkTDMWzGAurxS+4vct1kp
	 0l1BpxZFzSR4bai+1Lxuq/9Y6c3h2Uw9mK1oNubQvp+Jz7SZElSmyeLSkUf+jMU9e6
	 OIK08wYQPrD0XbssW8LhCwSfUX4vbwnSBhDWt5B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 137/273] drm/amd/display: Dont register panel_power_savings on OLED panels
Date: Tue, 27 Aug 2024 16:37:41 +0200
Message-ID: <20240827143838.618120726@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 76cb763e6ea62e838ccc8f7a1ea4246d690fccc9 upstream.

OLED panels don't support the ABM, they shouldn't offer the
panel_power_savings attribute to the user. Check whether aux BL
control support was enabled to decide whether to offer it.

Reported-by: Gergo Koteles <soyer@irl.hu>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3359
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Gergo Koteles <soyer@irl.hu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   29 ++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6562,12 +6562,34 @@ static const struct attribute_group amdg
 	.attrs = amdgpu_attrs
 };
 
+static bool
+amdgpu_dm_should_create_sysfs(struct amdgpu_dm_connector *amdgpu_dm_connector)
+{
+	if (amdgpu_dm_abm_level >= 0)
+		return false;
+
+	if (amdgpu_dm_connector->base.connector_type != DRM_MODE_CONNECTOR_eDP)
+		return false;
+
+	/* check for OLED panels */
+	if (amdgpu_dm_connector->bl_idx >= 0) {
+		struct drm_device *drm = amdgpu_dm_connector->base.dev;
+		struct amdgpu_display_manager *dm = &drm_to_adev(drm)->dm;
+		struct amdgpu_dm_backlight_caps *caps;
+
+		caps = &dm->backlight_caps[amdgpu_dm_connector->bl_idx];
+		if (caps->aux_support)
+			return false;
+	}
+
+	return true;
+}
+
 static void amdgpu_dm_connector_unregister(struct drm_connector *connector)
 {
 	struct amdgpu_dm_connector *amdgpu_dm_connector = to_amdgpu_dm_connector(connector);
 
-	if (connector->connector_type == DRM_MODE_CONNECTOR_eDP &&
-	    amdgpu_dm_abm_level < 0)
+	if (amdgpu_dm_should_create_sysfs(amdgpu_dm_connector))
 		sysfs_remove_group(&connector->kdev->kobj, &amdgpu_group);
 
 	drm_dp_aux_unregister(&amdgpu_dm_connector->dm_dp_aux.aux);
@@ -6674,8 +6696,7 @@ amdgpu_dm_connector_late_register(struct
 		to_amdgpu_dm_connector(connector);
 	int r;
 
-	if (connector->connector_type == DRM_MODE_CONNECTOR_eDP &&
-	    amdgpu_dm_abm_level < 0) {
+	if (amdgpu_dm_should_create_sysfs(amdgpu_dm_connector)) {
 		r = sysfs_create_group(&connector->kdev->kobj,
 				       &amdgpu_group);
 		if (r)


