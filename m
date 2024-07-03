Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DCF176AB0;
	Wed,  3 Jul 2024 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004509; cv=none; b=fZq7wdpkgfqMqqyZgsvUrSN7QPWTgky2EikzFTCPRCsjH/qkylWE3x04rgYAWMSFLj6BfF+Hs+OSP0B3CFcCE04SLBzjILgqNU8L/XVg9z8J+iQWQ6xuQet4KIb2edPo1fjKm+V5B5HDV4QfGSMDe8wmYF5/fqPKORdYwYaDMM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004509; c=relaxed/simple;
	bh=/NpKifaek+7WedkD7/fwy2lzTptMbj4C/gRz7cfIb7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTUaNvGGAIAm7Y6E9P4EEy7zE7P7D/vidOvYbCmbUx7f9TfbxZYbgNk3/ISxb2YOF/ExdsdnHhvZIuiDaTIISz4ZyYtMtA9ivAv/VyT5hAt3vlKZwtkTmG1N0oIz2gxkKHiYWvAERLrg6UIaxTQtv0iv8hDy0CSHOgte2zFNlyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgUVsHPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgUVsHPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5B3C2BD10;
	Wed,  3 Jul 2024 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004509;
	bh=/NpKifaek+7WedkD7/fwy2lzTptMbj4C/gRz7cfIb7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgUVsHPnRaXuO/Gwof6G7ay1qfvFB54+HbO0Ngpu31eTm4fv+c5ArxxQB8b1gACjX
	 zkvAGE5ZRxxgVSat+Y5910uo0ttBh+f+jAMQgIhAHfXTjFsrSIF9G//d9if+2WXy3+
	 lBnTqXQKN5aDbutTGF6jcVgDkib+ceI5UaHIIurg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Miotk <adam.miotk@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/290] drm/bridge/panel: Fix runtime warning on panel bridge release
Date: Wed,  3 Jul 2024 12:37:27 +0200
Message-ID: <20240703102906.693002929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Miotk <adam.miotk@arm.com>

[ Upstream commit ce62600c4dbee8d43b02277669dd91785a9b81d9 ]

Device managed panel bridge wrappers are created by calling to
drm_panel_bridge_add_typed() and registering a release handler for
clean-up when the device gets unbound.

Since the memory for this bridge is also managed and linked to the panel
device, the release function should not try to free that memory.
Moreover, the call to devm_kfree() inside drm_panel_bridge_remove() will
fail in this case and emit a warning because the panel bridge resource
is no longer on the device resources list (it has been removed from
there before the call to release handlers).

Fixes: 67022227ffb1 ("drm/bridge: Add a devm_ allocator for panel bridge.")
Signed-off-by: Adam Miotk <adam.miotk@arm.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240610102739.139852-1-adam.miotk@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/panel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index c916f4b8907ef..35a6d9c4e081e 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -252,9 +252,12 @@ EXPORT_SYMBOL(drm_panel_bridge_remove);
 
 static void devm_drm_panel_bridge_release(struct device *dev, void *res)
 {
-	struct drm_bridge **bridge = res;
+	struct drm_bridge *bridge = *(struct drm_bridge **)res;
 
-	drm_panel_bridge_remove(*bridge);
+	if (!bridge)
+		return;
+
+	drm_bridge_remove(bridge);
 }
 
 /**
-- 
2.43.0



