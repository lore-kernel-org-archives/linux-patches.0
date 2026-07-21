Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A6F3EBF23;
	Tue, 21 Jul 2026 17:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653905; cv=none; b=uS6h5/M3HlW0wD9CgnU3RoUoSf10oOT8YxKFrovndmME8JlLPXh4191TgrbXgBhWItrCXI9fvJfQ60jW0p05Vux1z+xtDjnBQ+JI1FdhP9lfH8pMHqsjzPGpxVGEbu1SxEU4J8v072rjqQiqDave9SrT9arpFDgG7GxeW6ikkBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653905; c=relaxed/simple;
	bh=0lwHBqTgU3AYsO41Zqnsl6QQrQTh4qI3dNqi8Fl68K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMBzMeA+p7emzMBcR8JqRvymFwh7/kODbwTYxWkJS+cexPlYDpqzzabrch913W+4j9Wg3WQ/melFz0cRZuI9hxCd4rpYMexxjrUarWAQaqDS7Gja/THR1ArApqJ9vLW9vMMsSwDqaIKjh8oLiLJgAVr309yKiA2RdtEmT6C5mRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ysp0nNVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ysp0nNVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D92D1F00A3E;
	Tue, 21 Jul 2026 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653903;
	bh=szn59mvPT9Xp0zdHp4hBuBANCWxbrxBlUQCCcm6iZ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ysp0nNVIC9FFOcKH3e+tkYqgcDwhr5LEz16nZ1RICWf0mP5hwZksGKc6855jJkwb7
	 Qt12UQRI42jBqwLEjnmY6Hgw93TG2oWR+bW8DiwzBurtKCLUkDunmkljG4U/R8la+o
	 ubBxZBOiLTiZL0uxll7RMV6PlLyZdBbMNl6M/FIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Mader <robert.mader@collabora.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Melissa Wen <mwen@igalia.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1476/2077] drm: Guard DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE
Date: Tue, 21 Jul 2026 17:19:09 +0200
Message-ID: <20260721152627.608734786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Mader <robert.mader@collabora.com>

[ Upstream commit ac7c6b4308c5e757eb278d47b9c0761c31ac9d6b ]

The client cap is currently advertised unconditionally, even for drivers
that do not support plane color pipelines. If clients supporting the latter,
like Wayland compositors or tools like drm_info, enable the client cap on
such drivers they will be left without both color pipeline and the legacy
properties COLOR_ENCODING and COLOR_RANGE, effectively breaking YUV->RGB
conversion support.

Prevent that by only marking the cap supported if there are actually planes
with color pipelines.

Note: while the color pipeline replacement for the legacy properties is
still under review (1), we can assume that it will work as a drop-in
replacement. That means any plane on any hardware currently supporting
the legacy properties will be able to offer a functionally equal color
pipeline and there will be no technical reason keep using the legacy
properties if both the driver and the client support the new API.

[1] https://lore.kernel.org/dri-devel/20260623164812.81110-1-harry.wentland@amd.com/

Signed-off-by: Robert Mader <robert.mader@collabora.com>
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Fixes: 179ab8e7d7b3 ("drm/colorop: Introduce DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE")
Link: https://patch.msgid.link/20260703073230.19982-1-robert.mader@collabora.com
Suggested-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ioctl.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index e2df4becce629a..9039a39c43243a 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -373,13 +373,25 @@ drm_setclientcap(struct drm_device *dev, void *data, struct drm_file *file_priv)
 			return -EINVAL;
 		file_priv->supports_virtualized_cursor_plane = req->value;
 		break;
-	case DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE:
+	case DRM_CLIENT_CAP_PLANE_COLOR_PIPELINE: {
+		struct drm_plane *plane;
+		bool has_plane_with_color_pipeline = false;
+
 		if (!file_priv->atomic)
 			return -EINVAL;
 		if (req->value > 1)
 			return -EINVAL;
+		drm_for_each_plane(plane, dev) {
+			if (plane->color_pipeline_property) {
+				has_plane_with_color_pipeline = true;
+				break;
+			}
+		}
+		if (!has_plane_with_color_pipeline)
+			return -EOPNOTSUPP;
 		file_priv->plane_color_pipeline = req->value;
 		break;
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.53.0



