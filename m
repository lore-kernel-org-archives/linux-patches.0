Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD2E1F130E;
	Tue,  3 Dec 2024 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238352; cv=none; b=ulP9JuBJFuPKj5xr5wfJNTyWx5BKcxBuLkfCIUn0h1ed1MKgoaFCQgO3d6JMJ+DFA/wdAgK83gZRmagvpecQx7WzFFOd0yhlWXg3xhPuI0/mvDvC6xxbuWVAlqUCRrsjTNT2Th2qGmmQNYI54as5VLd5TkoE36/uuQmliChYg5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238352; c=relaxed/simple;
	bh=A3RukrrG4CJbn3siuuxMmGAcT2lGshn4fSLhMnwNG6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJWqxL+68szEzHzPFF/lUVPSq5cf3Im5zPblIsBFSZ28RQDYt/ECeuC/ZZk78Yx4yXuZDHyMSZYWf6vri2bJxLMeshOM/EyTNkMcz3DihG6+a98k0Q3Br1qEjrg7/+6YJBofOc08ZI3UQhKe9/bt05+O2vb6irrLxfGrwku9mjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSQ5LXfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSQ5LXfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227D4C4CECF;
	Tue,  3 Dec 2024 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238352;
	bh=A3RukrrG4CJbn3siuuxMmGAcT2lGshn4fSLhMnwNG6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSQ5LXfXp7xjCkP5b4BXmf+s8MyVCx+K1udgA3uopc+puxw/v15xttkrMXgHZUqR4
	 Lh3OTiVX5pCgdwirLNm+DRRwZHW3KYJabNu0omDo1I2gzq8iqZFSRkijjZYYkeN6MR
	 nDBEjeFlN/7CMYPXH5DB205/VJ70SkYaDkmkxMo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 250/817] drm/bridge: anx7625: Drop EDID cache on bridge power off
Date: Tue,  3 Dec 2024 15:37:02 +0100
Message-ID: <20241203144005.530698248@linuxfoundation.org>
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

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 00ae002116a14c2e6a342c4c9ae080cdbb9b4b21 ]

The bridge might miss the display change events when it's powered off.
This happens when a user changes the external monitor when the system
is suspended and the embedded controller doesn't not wake AP up.

It's also observed that one DP-to-HDMI bridge doesn't work correctly
when there is no EDID read after it is powered on.

Drop the cache to force an EDID read after system resume to fix this.

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240926092931.3870342-2-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 88e4aa5830f3c..5c6bd7be25c0e 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2561,6 +2561,8 @@ static int __maybe_unused anx7625_runtime_pm_suspend(struct device *dev)
 	mutex_lock(&ctx->lock);
 
 	anx7625_stop_dp_work(ctx);
+	if (!ctx->pdata.panel_bridge)
+		anx7625_remove_edid(ctx);
 	anx7625_power_standby(ctx);
 
 	mutex_unlock(&ctx->lock);
-- 
2.43.0



