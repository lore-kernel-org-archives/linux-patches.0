Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E313317E8EE;
	Wed,  3 Jul 2024 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004000; cv=none; b=H05evZzcsT+B3NfY2Ykn7uVZ63Ws+wlHjv+x3ajofClpjBqgl2HU4EUvD9/wHnQX897ugxQgo9EBLKVcBIkoyIIt3G6QfDxqz0yuMwV3JT7q14c/y0Q/QI9/dI6PxbkJyxH/v+rd5TlyLQpY+JdsUBsff8o/cU9y1VlzdvdkBPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004000; c=relaxed/simple;
	bh=UbLH1ncyTM02kgoSG8r9gZ+EWuTgKpE9qtM2t7KscIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1mOrFJpB/84H5x4+vuw0u6i/J0wJiD3kdxrR5+h5G1oajiKAartQf7vO850VY2djqqHbiSF2WVDdxHt3+ymGCYGgLR7hTnkXZDcuYJyatHh3FL9Sp/9Oh78DhFAXa1qYnqy+xC6QDWfhLa4Z/qLveVVMGmP03K9dmUnX1iJ+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDaom17T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDaom17T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6592FC2BD10;
	Wed,  3 Jul 2024 10:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003999;
	bh=UbLH1ncyTM02kgoSG8r9gZ+EWuTgKpE9qtM2t7KscIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDaom17Truxc6n2AihzEyaF/Qk3mf4NkS8QuJn+QzYzWwhPUU5he9PHWzm8TcBQlh
	 z2OC+tfQUPfmW1adfnVE6lMydMOQHemZzp6uCNyi7YIMTcZpck35dK15ZQZJ8UgRpV
	 DOpCnN7png3Jr7TXr7z+mcf+wCXMzCE8odR2lSBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Miotk <adam.miotk@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/189] drm/bridge/panel: Fix runtime warning on panel bridge release
Date: Wed,  3 Jul 2024 12:38:40 +0200
Message-ID: <20240703102843.737799300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b12ae3a4c5f11..695dba0f018f8 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -203,9 +203,12 @@ EXPORT_SYMBOL(drm_panel_bridge_remove);
 
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



