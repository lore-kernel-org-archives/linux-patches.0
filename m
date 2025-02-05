Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4C1519AA;
	Wed,  5 Feb 2025 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764210; cv=none; b=XH3gomwIn5vkpchgZUP9fv0pFa+s6u9nFUPzjrpFL19GXOBvXOyOsfAf886Z+q525RTksNVV9LcVbSV1+IEgv21v3ZT4D7TT6znznABsxgLFuDIIgGtyR+/b9BpWzEd/1Y2hVsVoATQy5MetGT+PsqT8TuAvdb1KVsXpIhQjpug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764210; c=relaxed/simple;
	bh=NCieyCbgnnyl00XLHYqkmE43fuMQ42EU/oM9PDURWNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIH1dKQhelViVECaMkROvtnHO0wg/X9cf9PXshUCd+bcN0id+wHF+3md7C39jrwLtAov5THRbcQYEfJhR7lP5kqBHVWhHyvoL9gb77hHd91Y8WPS4akaFdJgPp7TO+cjvQgkB5ucrJqJYgj9XqsVL4aoRKONVgXJLDcP78+kods=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mJIRBey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mJIRBey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF35C4CED1;
	Wed,  5 Feb 2025 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764210;
	bh=NCieyCbgnnyl00XLHYqkmE43fuMQ42EU/oM9PDURWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mJIRBeym7HoRQILcfI+sq3zGg99UJFfcJ69pyEUhrmSOnnKwDKCE9VvgK7psmOGI
	 xTbDTnWsQB9GWTeTlDljERGO5BHz3E//3rpWfsUfLyJaVgWByi2FU1vk6tTjmuNkYJ
	 PFYCNDGde2tGkiM4ke0wloPHvrgYkpSzUxcK0k6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 057/623] drm/connector: Allow clearing HDMI infoframes
Date: Wed,  5 Feb 2025 14:36:39 +0100
Message-ID: <20250205134458.409584734@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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



