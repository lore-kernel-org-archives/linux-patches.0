Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478241F8F13;
	Fri,  6 Dec 2024 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497067; cv=none; b=mJGCs3LXhsSj7cxOqKXEWO2NTHkb1aDQAMYW+vdNbDYYM0famkoa4/bbzaRFrbDvcxXdDe6GMCR4bTmS7JDjn6UI9F0i3Wa/HqqueZQpqf3JXeMm6UI/iwOIp1Kst7ho6JgbiqI0uHGfNgZyIR2GbHUarF9VYmJSRhsJYjOHCJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497067; c=relaxed/simple;
	bh=ivBta/DdumJiRl5D0o2BtOVddM4HirCVfhW/SNvTRbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN32xoxw6wHDKYXqLW4DNWrM15PlSlRWsYZzsn/eCinrJu6DYU/dj7i7ZiJuDr54dgZUBVUgtTZVJTGhFTzUZGPgp2iW9b0O+hBV7dc9JrZjzlW6lQJ70Q/qKwZSN6y3sfyXjxGGAkkOaSJN6osU/AprmhRVVAQTntKZ9CUoJTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9LB9rK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9LB9rK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A263BC4CED1;
	Fri,  6 Dec 2024 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497067;
	bh=ivBta/DdumJiRl5D0o2BtOVddM4HirCVfhW/SNvTRbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9LB9rK7OmDEe7r/jmdN9S2i4F+yWicKNZ1DElzaXRizyZ59I+CgPNQe0b5ZDhfwk
	 /XYFxoIy6tVIDaKC8nWcKW+pGffQ6cQNm1ryZ+2noPmKI8Dt4f1xlh6xajJrU/ZMzH
	 NFHhhnXUMmLaGYfkBHHpKVC3nwKq239Bhe8VIIv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/676] drm/bridge: it6505: Drop EDID cache on bridge power off
Date: Fri,  6 Dec 2024 15:30:04 +0100
Message-ID: <20241206143700.573933368@linuxfoundation.org>
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
index 4ad527fe04f27..93eb8fba23d42 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -3104,6 +3104,8 @@ static __maybe_unused int it6505_bridge_suspend(struct device *dev)
 {
 	struct it6505 *it6505 = dev_get_drvdata(dev);
 
+	it6505_remove_edid(it6505);
+
 	return it6505_poweroff(it6505);
 }
 
-- 
2.43.0



