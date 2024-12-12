Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2121217640;
	Thu, 12 Dec 2024 15:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019198; cv=none; b=BSSKGAaJEiOhY/gz7+2Kl2Yq8QxxPw9sqJtCrYL3Qy0+42Rpb25RnmRq30ddyF9qGNn98p2cJWyqDYQpH6FulZfbaa08D6MCJzJyfMHTu6nwHXYatASToIs3Vi44c2XfHkdsNgpjNU0zY+073u/MwvM3CSUnMe+Ttnc56G6O1uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019198; c=relaxed/simple;
	bh=tGB3k66oOUB6/+cZYd+TsNLR+d4jYEkCU8uP9uC9y70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaArNlcK6rtXwvbkYFEMzOFk8CGg8oNfHBsEZss3qLYbNOXxyFUURoeZ0eff2FxR0bZH/eTn2ekOVs97/M1h1eUzdGBrBo1dtJgcuk6luCygynfVAA6IXpIl3BzC9Em/jOKD6BV0k1wCrDHtFhHZxG6nI8bcsWHSHsPMmhqfrGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYFl/IQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYFl/IQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A54C4CECE;
	Thu, 12 Dec 2024 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019198;
	bh=tGB3k66oOUB6/+cZYd+TsNLR+d4jYEkCU8uP9uC9y70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYFl/IQlsomZ6gwPVN/1Ul5bHq/Yxj4QvzsYkrGm6vr8sHo39zFO0dzYQppKw7JkU
	 Dg1T8LqzzjHAWAvOIM9sBXcy+qU/1FJHUFM/8RTJpb4rQv3PpWIcep15L1MXk3imkE
	 XPzZ/bKgWcZgf4ZFBfJljY6kcSU2VMvUOQX0ndCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/772] drm/bridge: anx7625: Drop EDID cache on bridge power off
Date: Thu, 12 Dec 2024 15:51:29 +0100
Message-ID: <20241212144355.881787227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 193015c75b454..e14c9fdabe2ba 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2567,6 +2567,8 @@ static int __maybe_unused anx7625_runtime_pm_suspend(struct device *dev)
 	mutex_lock(&ctx->lock);
 
 	anx7625_stop_dp_work(ctx);
+	if (!ctx->pdata.panel_bridge)
+		anx7625_remove_edid(ctx);
 	anx7625_power_standby(ctx);
 
 	mutex_unlock(&ctx->lock);
-- 
2.43.0



