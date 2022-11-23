Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF781C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41CCC433C1;
	Wed, 23 Nov 2022 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197172;
	bh=XK2XB+PkT/c4qjKTVfCpPyHMtYbpNOFZ0JljGvGJa10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fC4ATNlSgxuuXLg0d7uKa0wFpbAhM9hQWlq9kEzUqYPAp2pyuhthhmHnV9s4luoRa
	 rT13o+lB3t3y1iVv0m/o2+X4qbImLR4EhW7Zrjx6k/hseWqH2jHV7glJOt6NfcvAft
	 jY37XegryGb49SXfGPBaDzTm4sHQWgEvoUKBq9yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 219/314] drm/amd/display: dont enable DRM CRTC degamma property for DCE
Date: Wed, 23 Nov 2022 09:51:04 +0100
Message-Id: <20221123084635.469897310@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Melissa Wen <mwen@igalia.com>

commit 0e444a4de6b38c4593a07e4cfb5bf54c40cc79b6 upstream.

DM maps DRM CRTC degamma to DPP (pre-blending) degamma block, but DCE doesn't
support programmable degamma curve anywhere. Currently, a custom degamma is
accepted by DM but just ignored by DCE driver and degamma correction isn't
actually applied. There is no way to map custom degamma in DCE, therefore, DRM
CRTC degamma property shouldn't be enabled for DCE drivers.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -412,7 +412,7 @@ int amdgpu_dm_crtc_init(struct amdgpu_di
 {
 	struct amdgpu_crtc *acrtc = NULL;
 	struct drm_plane *cursor_plane;
-
+	bool is_dcn;
 	int res = -ENOMEM;
 
 	cursor_plane = kzalloc(sizeof(*cursor_plane), GFP_KERNEL);
@@ -450,8 +450,14 @@ int amdgpu_dm_crtc_init(struct amdgpu_di
 	acrtc->otg_inst = -1;
 
 	dm->adev->mode_info.crtcs[crtc_index] = acrtc;
-	drm_crtc_enable_color_mgmt(&acrtc->base, MAX_COLOR_LUT_ENTRIES,
+
+	/* Don't enable DRM CRTC degamma property for DCE since it doesn't
+	 * support programmable degamma anywhere.
+	 */
+	is_dcn = dm->adev->dm.dc->caps.color.dpp.dcn_arch;
+	drm_crtc_enable_color_mgmt(&acrtc->base, is_dcn ? MAX_COLOR_LUT_ENTRIES : 0,
 				   true, MAX_COLOR_LUT_ENTRIES);
+
 	drm_mode_crtc_set_gamma_size(&acrtc->base, MAX_COLOR_LEGACY_LUT_ENTRIES);
 
 	return 0;


