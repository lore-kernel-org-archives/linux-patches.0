Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9887223313;
	Thu, 12 Dec 2024 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022153; cv=none; b=Yrcabl+hdYnvSd36jOYRHUmOYWnrjrg0n+QXVkJzAz+dasJT7R2aZ4oyrmZfScEYs7+tXS6T2+S+HopFAgjb3KKBCmFt4r9YcaJfHxY5blf5+z/KMol1vGj2sxHnXfHV9HAmw6fc58QBzOI7OIyohmn8yG60Iz0chocyB2xI+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022153; c=relaxed/simple;
	bh=Ab4B+AV8PLzW3+eS873XQXDRhRweaCVpcp6Gob89mFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKMrxr0jDrGVE3u3PQed/Fegzk0bWQfXzdwB3SxQOqwaeme82n6gyQnE0bHY4EMFrdM+bcJi7dPoakwt9cWzEDI/Gmc72u3PJNdQiWYlgHlVj5EmsC+8lijrib188jZK0fT3USyg4S0/gHbOQvQ8shbKfIJdyMyN+OIfeWXmaRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIPJHsXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIPJHsXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5498AC4CECE;
	Thu, 12 Dec 2024 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022152;
	bh=Ab4B+AV8PLzW3+eS873XQXDRhRweaCVpcp6Gob89mFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIPJHsXl9RCeMXDnsXGdbkt9MvU0hXJIjrCJMtdFa3zQ286Kwpyzcn0wAFgJfPUFN
	 ssS3/6RXTw+dHe1hwN+3N0+rAu67tU/l++807MbQC+0S3WPUBS39xhph/LI+RQ7O8U
	 kF5Vw0qzQ1UBH42zAJ07pg9Oz9al2pQFPfrKJNrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/565] drm/bridge: anx7625: Drop EDID cache on bridge power off
Date: Thu, 12 Dec 2024 15:55:58 +0100
Message-ID: <20241212144317.919231168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f895ef1939fa0..01612d2c034af 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1704,6 +1704,8 @@ static int __maybe_unused anx7625_runtime_pm_suspend(struct device *dev)
 	mutex_lock(&ctx->lock);
 
 	anx7625_stop_dp_work(ctx);
+	if (!ctx->pdata.panel_bridge)
+		anx7625_remove_edid(ctx);
 	anx7625_power_standby(ctx);
 
 	mutex_unlock(&ctx->lock);
-- 
2.43.0



