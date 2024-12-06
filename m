Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF831537D4;
	Fri,  6 Dec 2024 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497178; cv=none; b=EeXMtSg5RB1tmLXSrj1/4umwp3qhORD37hI5JxDP4GdjgLSJ0w5dm/0bNZzVCC/RjAQqLljcXnWvw48ZetyFP4In89vmj3XdR2AFwaMaM3ypNe129jB/qPkSte8viAztk+9RFl7sENXLk9W3q3zWbfbwWybZjKtJgtYgDeuNxnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497178; c=relaxed/simple;
	bh=OckQshyvGNGJM2sANzwH2vFMQ6wvb8tH6E2BldEQzGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z60v/z3rwTMOpxTgsJORH7XJe37O2XPTNmYcq7gEd3j2XU2lW+MncDTqYjKzWMmG/FuJs/s78SwEKLaLu3z3y5IZvNrqfOnzIwMdihF6FiCqGwOx5b/yE685dcL1eBOpglM3ExAFKQXyu7sOmZs5Qx9wk/p9vBgGRNRVcBwgGOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gts8nonc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gts8nonc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CCDC4CED1;
	Fri,  6 Dec 2024 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497177;
	bh=OckQshyvGNGJM2sANzwH2vFMQ6wvb8tH6E2BldEQzGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gts8nonciAsYXnfVH49+g0FcpxIa7cdshor2Wglniz6WNmQF/gLfxOYifYddi/+Ji
	 FPNtloBn5khh1btdl/tLWzV2ZifcDTxUx0aIf0HN6pXhOmn4TKgQbBfzudHIwD7Q8i
	 aVfSCA+9gjB3H/52zRxXEW/++2urTsTno5bNyDOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/676] drm/bridge: anx7625: Drop EDID cache on bridge power off
Date: Fri,  6 Dec 2024 15:30:03 +0100
Message-ID: <20241206143700.534733300@linuxfoundation.org>
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
index c1191ef5e8e67..412c6575e87b7 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2573,6 +2573,8 @@ static int __maybe_unused anx7625_runtime_pm_suspend(struct device *dev)
 	mutex_lock(&ctx->lock);
 
 	anx7625_stop_dp_work(ctx);
+	if (!ctx->pdata.panel_bridge)
+		anx7625_remove_edid(ctx);
 	anx7625_power_standby(ctx);
 
 	mutex_unlock(&ctx->lock);
-- 
2.43.0



