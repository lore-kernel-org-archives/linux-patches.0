Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA60142E86;
	Wed,  5 Feb 2025 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763704; cv=none; b=SD89OAA6jDjwK4FZCysbjFxzGgccdh/+AGc2cYif5brDah8KMUJBoBrYSF+d5Z+oSyzRATCw7avcuN4FHmdG5W/ztVfL11k0A5j2CNrmoSvvAJFNdeEScZ705/wm/7soHACfnQv1rTmsrnS+5a3yvV8HElWZ7kP44k33wcPMUFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763704; c=relaxed/simple;
	bh=aWkSnKtcWeqcJWR/stZ2ifqknDLsce1LpFP42lQxy1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0b3szIQar2uIPwk6hFsR9zkuxgZPojut/DovVn9nYyd25EERg98m/mzFwFL9KwPY6Gk4Q39hrh2AdpeXCWhXXnH2sEbmhxnvUxouxewXapiaQDEp+n3bCZME0u0oTnRb30TvpxvOWdmlRp6hvRvX4fPelVbYFypze66hL/w3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDCHVCR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDCHVCR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6C6C4CED1;
	Wed,  5 Feb 2025 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763704;
	bh=aWkSnKtcWeqcJWR/stZ2ifqknDLsce1LpFP42lQxy1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDCHVCR/BPn4saW7LLJurN3m78XzxSKD8UvF4NWXxzethiMhJTo0+VNJ0/pgeW3o1
	 67VKfCD0+XaFkXHBCv/a10NyewH5nj+77R2Oq5LIY+7Fe9GCZe6a1HXaQ3HxdTMJxR
	 faXGmlGKYSzXFJJHPDX7XAw037eiDrrA2u1+PqQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/590] drm/connector: Allow clearing HDMI infoframes
Date: Wed,  5 Feb 2025 14:36:44 +0100
Message-ID: <20250205134457.132214620@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Foreman <derek.foreman@collabora.com>

[ Upstream commit d34357743b360c99903b5a59daab08f55b2f41a1 ]

Our infoframe setting code currently lacks the ability to clear
infoframes. For some of the infoframes, we only need to replace them,
so if an error occurred when generating a new infoframe we would leave
a stale frame instead of clearing the frame.

However, the Dynamic Range and Mastering (DRM) infoframe should only
be present when displaying HDR content (ie: the HDR_OUTPUT_METADATA blob
is set). If we can't clear infoframes, the stale DRM infoframe will
remain and we can never set the display back to SDR mode.

With this change, we clear infoframes when they can not, or should not,
be generated. This fixes switching to an SDR mode from an HDR one.

Fixes: f378b77227bc ("drm/connector: hdmi: Add Infoframes generation")
Signed-off-by: Derek Foreman <derek.foreman@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241202181939.724011-1-derek.foreman@collabora.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_hdmi_state_helper.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_hdmi_state_helper.c b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
index feb7a3a759811..936a8f95d80f7 100644
--- a/drivers/gpu/drm/display/drm_hdmi_state_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
@@ -347,6 +347,8 @@ static int hdmi_generate_avi_infoframe(const struct drm_connector *connector,
 		is_limited_range ? HDMI_QUANTIZATION_RANGE_LIMITED : HDMI_QUANTIZATION_RANGE_FULL;
 	int ret;
 
+	infoframe->set = false;
+
 	ret = drm_hdmi_avi_infoframe_from_display_mode(frame, connector, mode);
 	if (ret)
 		return ret;
@@ -376,6 +378,8 @@ static int hdmi_generate_spd_infoframe(const struct drm_connector *connector,
 		&infoframe->data.spd;
 	int ret;
 
+	infoframe->set = false;
+
 	ret = hdmi_spd_infoframe_init(frame,
 				      connector->hdmi.vendor,
 				      connector->hdmi.product);
@@ -398,6 +402,8 @@ static int hdmi_generate_hdr_infoframe(const struct drm_connector *connector,
 		&infoframe->data.drm;
 	int ret;
 
+	infoframe->set = false;
+
 	if (connector->max_bpc < 10)
 		return 0;
 
@@ -425,6 +431,8 @@ static int hdmi_generate_hdmi_vendor_infoframe(const struct drm_connector *conne
 		&infoframe->data.vendor.hdmi;
 	int ret;
 
+	infoframe->set = false;
+
 	if (!info->has_hdmi_infoframe)
 		return 0;
 
-- 
2.39.5



