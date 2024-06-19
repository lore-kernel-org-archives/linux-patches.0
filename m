Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9096882871;
	Wed, 19 Jun 2024 13:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802299; cv=none; b=I92B/U9+6OTHiVk724QRYSH6r4MYPXxLbbt6/aF8+przQ4/ari5oKC9jAfRA8ccscbb58lTWtcxpOKrccjCWcTyKKMSvj1kqCTE9S8cp5kqzMvu5eMEZ28D8Iq5r6IC6KSx3+dd0654a70ffon5DoW5HQeWVwK0yRebcaRgYGHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802299; c=relaxed/simple;
	bh=/ODmtIK+yOSjeSy2HEcD9jsEruDAF24zJv8xn8sAxX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4QgYsoQ7NLfJPxexLLieXhFgiFYyqadFc82ZsiduSOs/LTSyDBDinVGBvA7a0el8L3TFrJ+iVfh/k3lwuhZJBKELBszqaGcU8/5rxSrksM7jyw7AlAElVgy/uKQAgQ4BlPmsglZPcM0aKR1Q0D41opvPh53bfVI3KqH+dBwnms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTwx8S7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTwx8S7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6EEC2BBFC;
	Wed, 19 Jun 2024 13:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802299;
	bh=/ODmtIK+yOSjeSy2HEcD9jsEruDAF24zJv8xn8sAxX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTwx8S7IWiQLVTHnziismP8zHoQkMPDrmmNFHa5woXHtUayNByxOHa02wl6YxDj6U
	 VW5fRgk0XWDGJU819C7KqoKzXnTaAI/BuuSDB0++QaqmQX0oANiCENkfZv8G+1mz13
	 AyXb2fByGMoNLF5D8QLUq2W9EVkHYb1Z9A1hZnp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Miotk <adam.miotk@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/267] drm/bridge/panel: Fix runtime warning on panel bridge release
Date: Wed, 19 Jun 2024 14:54:59 +0200
Message-ID: <20240619125612.028011920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 9316384b44745..a1dd2ead8dcc4 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -360,9 +360,12 @@ EXPORT_SYMBOL(drm_panel_bridge_set_orientation);
 
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



