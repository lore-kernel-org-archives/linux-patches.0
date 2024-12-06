Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8EC148832;
	Fri,  6 Dec 2024 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497941; cv=none; b=Wb/hcQTD3CdrIytVsD21QaKzWhWuosEu9dY8VgN1OPtaDH96mcPh8XRX5cAX6Jx9xVy4cEMt8YzIJYXnEAe5xWmOjMcvNIGDjB0ATw3gMOg6aLj06y8HNI7fIBZnGaGocf4esnCN1aFCZDLmwjxIl9DeFwEEqxMccHAxnt9aAWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497941; c=relaxed/simple;
	bh=ykb+FjwW5cbKjVXdlBmm2lGK1Pat6oE9Xw3OMl/hRB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaeqUXVEizEtMTl15JJzaIuLOYDDRfUr0n4U4lsPhF9n9LrH9ulsm2nuiLKt2C+vjWBmBXb4kWENQGobCs5TDG8rJTmBOawhKygNqll6eCuOzPTdacm9Kap5ZPlDqsl0HkOY0M/bWXavbJec42wuNRV6px53yhQJmKuhi01/xew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0m5OMsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0m5OMsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55016C4CED1;
	Fri,  6 Dec 2024 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497941;
	bh=ykb+FjwW5cbKjVXdlBmm2lGK1Pat6oE9Xw3OMl/hRB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0m5OMscv/J0QXv7kT+3Jq+f+qK0EFlk110ea4GtR+yYGbL8z1HE0TQsm0vVVGm34
	 d6TvFAK8Qy5KMLkSQFELPBY3aZ0cRNTzDcQe6BekLJePbHa8rXz0I1wdv4+Vm0Vz61
	 geT7MTjte60oaPHNDBMIuWIPEd4GsQ07C6HiQQs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 438/676] drm/radeon: Fix spurious unplug event on radeon HDMI
Date: Fri,  6 Dec 2024 15:34:17 +0100
Message-ID: <20241206143710.459606754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff0ff2642a8d0..fc22fe709b9c1 100644
--- a/drivers/gpu/drm/radeon/radeon_audio.c
+++ b/drivers/gpu/drm/radeon/radeon_audio.c
@@ -758,16 +758,20 @@ static int radeon_audio_component_get_eld(struct device *kdev, int port,
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



