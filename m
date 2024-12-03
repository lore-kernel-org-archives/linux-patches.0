Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798FA1E3DCF;
	Tue,  3 Dec 2024 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242258; cv=none; b=Z3e8ln0srWTgrF13v28voQrEP+bG+YHqO4sig4OPXj7kX2vHEu4Cf9gOyqQWFv9QqYU8FoP3sThDhMEUtNX/hR1YBQPrRXYGjhSYb0zvYEB7kgmiTrQuNnqr4t8ZgOq9JEdCAMf15JHvGJCDoR0xc+49wOWAtihFrY6yQCp3kbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242258; c=relaxed/simple;
	bh=x0Xyp/zIO+6+FleUTVVQesecXlobIPbt3eST1diFTzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V45PdRrKT07CFGX9qK7IMrLAN1SNhxy99PhG+p10Wv2yk5zKhPuBQa1PJZSeXD9Z3RTAG+iVk+po7Q0lLAsUI5OwvDkNpTc4Ts+q82Jp9nyW7FKcrtvMUu/LRa4uv3Kwfqlm2HwCGffWmgAr2AbDI4LOQ/bNQ3dEiOZfmoP3OMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMk2fQvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMk2fQvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC371C4CECF;
	Tue,  3 Dec 2024 16:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242258;
	bh=x0Xyp/zIO+6+FleUTVVQesecXlobIPbt3eST1diFTzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMk2fQvkvrp6KvpJeDFcpxCiJwwLEv6td53DgFCAtDqaMoJWa3WtkDTHJ93R11uqF
	 8D9gj1pEp0kewLIGovciO0mpKXSIvX8SuUQNhqZHMe97Ou1Kfywa9NWYnCXXGKPxcm
	 qMAiS0oifbT22S3hH4nDnfAJC0zXezbz54UwXP7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 612/826] drm/radeon: Fix spurious unplug event on radeon HDMI
Date: Tue,  3 Dec 2024 15:45:39 +0100
Message-ID: <20241203144807.626709773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



