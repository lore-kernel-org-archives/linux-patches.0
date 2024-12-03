Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F95C1F429B;
	Tue,  3 Dec 2024 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238355; cv=none; b=IuV9TJIGJj8nU6aA6D10EByELA5PuqzPEoV3JeA+1vAA4xSqKq0TopRjcqPrhxddJHTMVxjlV4+CarFdOXI8euuL05j6dojAxAPpRluGx1m2BXykWMT+ayKPQH+IiOSUHAEh0ACQg1NbBD29I0SU6PaRG6adTjqT/dfXs1qjeSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238355; c=relaxed/simple;
	bh=H0r7p4wmzQMfdamX3XbzIVBZrLwPIrp7J8fRj5oTRgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbwb+3HNCyMnou9fJ+iJ5HqbMiazzk+pdsXKonewoXvZ5MJXncmwyAmoqf5UsoHV2iqjMK1jISMW+EkEeY5m5Lf+bGulhhrL3L4zC9GHNsaGX3QerG0b4OmsGA/xl8uGUdrMgYtFxsME34OzUEdEBkYrapdaCGtvi0KMAcTAkPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwQbi3oI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwQbi3oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0996EC4CECF;
	Tue,  3 Dec 2024 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238355;
	bh=H0r7p4wmzQMfdamX3XbzIVBZrLwPIrp7J8fRj5oTRgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwQbi3oIYKcu3Y0wu4RWZk4pUj7UVVrBp0mm2Xgqs5wEDImRqBxLIPWAo2M15qX0Q
	 ElNZ3r5Oil+poGOCizEN8XAAE3PigO/NiEUa7yBIgU9Pz+svAGf8wV4GPvtl8EgXA0
	 9QCElCEZLFbXSU6Dc+7sIiIEMZqcvfvNvRYQBPic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 251/817] drm/bridge: it6505: Drop EDID cache on bridge power off
Date: Tue,  3 Dec 2024 15:37:03 +0100
Message-ID: <20241203144005.569344869@linuxfoundation.org>
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
index 1e1c06fdf2064..bb449efac2f4e 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -3101,6 +3101,8 @@ static __maybe_unused int it6505_bridge_suspend(struct device *dev)
 {
 	struct it6505 *it6505 = dev_get_drvdata(dev);
 
+	it6505_remove_edid(it6505);
+
 	return it6505_poweroff(it6505);
 }
 
-- 
2.43.0



