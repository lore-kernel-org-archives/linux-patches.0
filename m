Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9761E5711;
	Tue,  3 Dec 2024 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240723; cv=none; b=WZcXUCtEReptKaj/YuDCGT01TpZbP2MrOw0PZRNzR/pxdArirVCnOQxDSMmg2sxN0xVpGar+VrDxKnMdR6CsR8bENVPmZyAPIFmhCjijF7dRlQsQv2NBsPAWSd/elSi4D7vLry8wYOG07KMJgpw+ax/7+CccVJ0WITJCeSJFzQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240723; c=relaxed/simple;
	bh=z4ETVYUTa6lNwZ39kk86YuNs0/S9juK4KXfcsEOfO8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvK/1WCrKA2LnDI+kz+o7+5H5vMvp0lBFel2u2aF9/aGmjf2QyyQ6+zeenZt1gTm36sS9lpiAQl1m0xp9Xs9fgoH3IlsNTuxYaB4oVM1kz28xnksU6Y02dtWYkjrh4L7eg7JJgDzrqcQUrEY48DQN23NLZ+lQ3kFt6/XB5CJ2OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWQiyeAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWQiyeAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F5CC4CECF;
	Tue,  3 Dec 2024 15:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240723;
	bh=z4ETVYUTa6lNwZ39kk86YuNs0/S9juK4KXfcsEOfO8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWQiyeAoiO0f6RQUpmsE99YVjObat3my+NYkMAPNEsbvwljIywKE0nGcOKA6DyKkQ
	 jxDy5cyfXFkZQFK34UleOiJhgJfRG2BIMj2OnIIJI9vMo6GelCwsaDOqEy2po9/yLd
	 2jI3d6yrFJmVV9jjJv4kjHTvuRbCV+Fmzy/bLSDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/826] drm/bridge: it6505: Drop EDID cache on bridge power off
Date: Tue,  3 Dec 2024 15:39:05 +0100
Message-ID: <20241203144752.244515371@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 574c558ddb68591c9a4b7a95e45e935ab22c0fc6 ]

The bridge might miss the display change events when it's powered off.
This happens when a user changes the external monitor when the system
is suspended and the embedded controller doesn't not wake AP up.

It's also observed that one DP-to-HDMI bridge doesn't work correctly
when there is no EDID read after it is powered on.

Drop the cache to force an EDID read after system resume to fix this.

Fixes: 11feaef69d0c ("drm/bridge: it6505: Add caching for EDID")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240926092931.3870342-3-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 87b8545fccc0a..e3a9832c742cb 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -3107,6 +3107,8 @@ static __maybe_unused int it6505_bridge_suspend(struct device *dev)
 {
 	struct it6505 *it6505 = dev_get_drvdata(dev);
 
+	it6505_remove_edid(it6505);
+
 	return it6505_poweroff(it6505);
 }
 
-- 
2.43.0



