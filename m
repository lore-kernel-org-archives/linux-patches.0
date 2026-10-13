Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22913E0C57;
	Tue, 13 Oct 2026 11:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892489; cv=none; b=lvo6vaXZfuIdp1myx0Iz8BJqzAgYYMxGFpG9jK8uLlFIoJoeiKzCVavNk8+4uNlxHRk6Zh67P+Lld6MxsLfCE1usYxSNANlzpgN/FodzUeIMzCwiSD06uTRDaIFAa+Pf8MkmrX5f4cuyCiMex1NrTKKBfTLB8JG6C66irQABrbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892489; c=relaxed/simple;
	bh=j7viy39oYrRzQdew+0TDGHKLK5C5VYOdaVcnJokH+Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLQsLE/Q78Xmhy/Z9OgBI5eM4/S+lFRdyollvlM9YaT/nRf8YviTUDQzBC1avYH1tFnPUC9urwPq6Ar03y0mGv/Sbx80/6qynTXOQ4mvMXKgyDplbCHo+JydSDfqcO73A7V3IwjUDYto9HRQIm3pHn0XyRsBRl5PXOcYWJgkHHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X14z11Lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X14z11Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343611F000FF;
	Tue, 13 Oct 2026 11:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892488;
	bh=BRx8JhPWTxzt2GXac9vtXEMZFU5aYYpOXijNLD4bIUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X14z11LfgGH34qSkez96EfMysC9hFQQBybhBz4HOMbEQRGtz6nA+Xg0Yd5H9XYSR2
	 y3xCVOgpIE1t0RtIKGIcdB4oo9lwMhr8ZLbc8lARH+aryrKDjicT0y6Tk+JVPZqcbR
	 GVm0vWf94JLdtD/R42RqIUgTDyrUDBLKH1Um4T2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.2 190/281] drm/bridge: Fix unlocked list access in drm_bridge_attach()
Date: Tue, 13 Oct 2026 13:38:26 +0200
Message-ID: <20261013112859.777558618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 57889076afd1be890150c32ffde3b691fe5707c8 ]

drm_bridge_attach() inspects bridge->list to warn about bridges being
attached without a previous drm_bridge_add() call, but it does so
without holding bridge_lock.

The list head can be concurrently written by drm_bridge_add(),
drm_bridge_remove() and __drm_bridge_free() while they operate on
neighbouring entries of bridge_list or bridge_lingering_list, all of
them under bridge_lock.  Hence the unlocked read is a data race, even
though it is unlikely to change the outcome of list_empty() in practice.

Perform the check with bridge_lock held.

Fixes: 76f1a9711b83 ("drm/bridge: add warning for bridges attached without being added")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Tested-by: Robin Räber <robin.raebi@gmail.com>
Link: https://patch.msgid.link/20260901-dw-hdmi-qp-scramb-v11-14-bc12954a0688@collabora.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 3618cb12483e2..9124cbe1ff889 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -558,8 +558,10 @@ int drm_bridge_attach(struct drm_encoder *encoder, struct drm_bridge *bridge,
 	if (!bridge->container)
 		DRM_WARN("DRM bridge corrupted or not allocated by devm_drm_bridge_alloc()\n");
 
-	if (list_empty(&bridge->list))
-		DRM_WARN("Missing drm_bridge_add() before attach\n");
+	scoped_guard(mutex, &bridge_lock) {
+		if (list_empty(&bridge->list))
+			DRM_WARN("Missing drm_bridge_add() before attach\n");
+	}
 
 	drm_bridge_get(bridge);
 
-- 
2.53.0



