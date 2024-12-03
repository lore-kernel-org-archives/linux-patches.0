Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684091F707A;
	Tue,  3 Dec 2024 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239536; cv=none; b=UWByCu90lAniT+NVf3ulRjtOLkmuo/gnvp1bGIsHcejK5D4XRt1DIxUlpo45readd+o1A6LS5KxNwIIVYeW1mczpBeNHIPpnBJrvxVp8rzKahtfESNixjG3vlsziS6WuBYhgTzRN/dwZZRir4f5RL3pB4cJ2WHELiTG7/gvBlTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239536; c=relaxed/simple;
	bh=z88DFx1+rWQ6VqPIuUu2EiOQBRvSUAnrCiaMMzYSzP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4gycSOaIn6zgNsWNhBrt/OA+c22pdKsXeZihyodYCKAxEUIrpauRhvou7uaOGok8Ue7a4k0+Ko42ri7d5W7DI+ZsLszCKNC/WCF/3KHly01A0pjxoQeIrikwakQL0uZddPBqOYQzhiK11AIDcXbJX3CK+eYAJaAgN6gGIeEK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzUY7ua6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzUY7ua6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BE2C4CED6;
	Tue,  3 Dec 2024 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239536;
	bh=z88DFx1+rWQ6VqPIuUu2EiOQBRvSUAnrCiaMMzYSzP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzUY7ua6rVcB2p+Fa+QUH2rOuTsO9bVt6wkE0vwZ4LcCrO/nrkpVQwX+1u1BbdaVG
	 z692T1InImY4X5Qs/fekE4elrGdgt8+GZa19/UWx+QBfnn0xLxJ4lplGo8g0yfuzA2
	 HK9dgFqvzu5Gd1ivrqsGv4sRQuTLu2I7OBHtv/fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 616/817] drm/radeon: Fix spurious unplug event on radeon HDMI
Date: Tue,  3 Dec 2024 15:43:08 +0100
Message-ID: <20241203144019.979969599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven 'Steve' Kendall <skend@chromium.org>

[ Upstream commit 7037bb04265ef05c6ffad56d884b0df76f57b095 ]

On several HP models (tested on HP 3125 and HP Probook 455 G2),
spurious unplug events are emitted upon login on Chrome OS.
This is likely due to the way Chrome OS restarts graphics
upon login, so it's possible it's an issue on other
distributions but not as common, though I haven't
reproduced the issue elsewhere.
Use logic from an earlier version of the merged change
(see link below) which iterates over connectors and finds
matching encoders, rather than the other way around.
Also fixes an issue with screen mirroring on Chrome OS.
I've deployed this patch on Fedora and did not observe
any regression on these devices.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1569#note_1603002
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3771
Fixes: 20ea34710f7b ("drm/radeon: Add HD-audio component notifier support (v6)")
Signed-off-by: Steven 'Steve' Kendall <skend@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_audio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_audio.c b/drivers/gpu/drm/radeon/radeon_audio.c
index 47aa06a9a9422..5b69cc8011b42 100644
--- a/drivers/gpu/drm/radeon/radeon_audio.c
+++ b/drivers/gpu/drm/radeon/radeon_audio.c
@@ -760,16 +760,20 @@ static int radeon_audio_component_get_eld(struct device *kdev, int port,
 	if (!rdev->audio.enabled || !rdev->mode_info.mode_config_initialized)
 		return 0;
 
-	list_for_each_entry(encoder, &rdev_to_drm(rdev)->mode_config.encoder_list, head) {
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		const struct drm_connector_helper_funcs *connector_funcs =
+				connector->helper_private;
+		encoder = connector_funcs->best_encoder(connector);
+
+		if (!encoder)
+			continue;
+
 		if (!radeon_encoder_is_digital(encoder))
 			continue;
 		radeon_encoder = to_radeon_encoder(encoder);
 		dig = radeon_encoder->enc_priv;
 		if (!dig->pin || dig->pin->id != port)
 			continue;
-		connector = radeon_get_connector_for_encoder(encoder);
-		if (!connector)
-			continue;
 		*enabled = true;
 		ret = drm_eld_size(connector->eld);
 		memcpy(buf, connector->eld, min(max_bytes, ret));
-- 
2.43.0



