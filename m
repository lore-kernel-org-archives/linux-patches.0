Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263C32EA463;
	Tue, 22 Jul 2025 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193365; cv=none; b=A6VaUhBAQfmMcOpwJK7sKkjzazz0GjL5UWv++tsCj15TWOBE2L694Ol2RCEtgkMHETR3xCYOZPplQTuanLfVKkHIVBZcSAQzSQDWpTg+/PjlYdoY7i7Y2CmVOYpJzCHiSJ5beU0js7FooZx4Ye8OcAwipgNTihgzCWN8dSqQxAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193365; c=relaxed/simple;
	bh=/zCbMZxtCVG6MvlVGnDEOkik5fAnc8O+kq11N5nXavA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5/aua9plCZVRRZ6dh6s7nOtM8OjeeSz4lv3RZcYFKuCNHIi9MiaX2vehyJTFRfVj3Id0rckMJvInVZkZsUu3XvfNhnNv4+5FBbHXHsWoeAH/hTBWwVQEhQbeaymMU49GF1Xaz+p+C4i4Yq13hvJCMrR54rV7t4RFVbjs4+SZBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBqSe54p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBqSe54p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C33C4CEEB;
	Tue, 22 Jul 2025 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193365;
	bh=/zCbMZxtCVG6MvlVGnDEOkik5fAnc8O+kq11N5nXavA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBqSe54psWqg8XxlfHBiqVsrHC1woj7IX5UfMozTlTJFiMpB4HhvrLnjlk0Sy3vHo
	 V7Q+eiaM2SclpBUm28Ygm3Qo+EhFSo/aylxdxzrqb+xEVR6iuyi4T2oo7NLGU0dS4d
	 8Yk/qxBlj2AkCSJSHfZjFy6y+KLqoz/wQAkTasso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 036/187] drm/amd/display: Disable CRTC degamma LUT for DCN401
Date: Tue, 22 Jul 2025 15:43:26 +0200
Message-ID: <20250722134347.103977459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

commit 97a0f2b5f4d4afcec34376e4428e157ce95efa71 upstream.

In DCN401 pre-blending degamma LUT isn't affecting cursor as in previous
DCN version. As this is not the behavior close to what is expected for
CRTC degamma LUT, disable CRTC degamma LUT property in this HW.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/4176
---

When enabling HDR on KDE, it takes the first CRTC 1D LUT available and
apply a color transformation (Gamma 2.2 -> PQ). AMD driver usually
advertises a CRTC degamma LUT as the first CRTC 1D LUT, but it's
actually applied pre-blending. In previous HW version, it seems to work
fine because the 1D LUT was applied to cursor too, but DCN401 presents a
different behavior and the 1D LUT isn't affecting the hardware cursor.

To address the wrong gamma on cursor with HDR (see the link), I came up
with this patch that disables CRTC degamma LUT in this hw, since it
presents a different behavior than others. With this KDE sees CRTC
regamma LUT as the first post-blending 1D LUT available. This is
actually more consistent with AMD color pipeline. It was tested by the
reporter, since I don't have the HW available for local testing and
debugging.

Melissa
---

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 340231cdceec2c45995d773a358ca3c341f151aa)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -737,7 +737,16 @@ int amdgpu_dm_crtc_init(struct amdgpu_di
 	 * support programmable degamma anywhere.
 	 */
 	is_dcn = dm->adev->dm.dc->caps.color.dpp.dcn_arch;
-	drm_crtc_enable_color_mgmt(&acrtc->base, is_dcn ? MAX_COLOR_LUT_ENTRIES : 0,
+	/* Dont't enable DRM CRTC degamma property for DCN401 since the
+	 * pre-blending degamma LUT doesn't apply to cursor, and therefore
+	 * can't work similar to a post-blending degamma LUT as in other hw
+	 * versions.
+	 * TODO: revisit it once KMS plane color API is merged.
+	 */
+	drm_crtc_enable_color_mgmt(&acrtc->base,
+				   (is_dcn &&
+				    dm->adev->dm.dc->ctx->dce_version != DCN_VERSION_4_01) ?
+				     MAX_COLOR_LUT_ENTRIES : 0,
 				   true, MAX_COLOR_LUT_ENTRIES);
 
 	drm_mode_crtc_set_gamma_size(&acrtc->base, MAX_COLOR_LEGACY_LUT_ENTRIES);


