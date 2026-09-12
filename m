Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD303911D6;
	Sat, 12 Sep 2026 19:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243169; cv=none; b=Seq0z7nRpGCgJMDjyAleIyr+obVTV96YCBZCwozOD+x/HkAMygB+70n7mMwcgNHSoI9zBYjL88NgjmyJU99nEAfFq8O9Ef+Ocux5RB6h77U/hAYTvP1xWk5YaQGUQqWSKsAfZRNIQ2pa6YOM5T8kcKI0HU48EEoaycmhncK3WQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243169; c=relaxed/simple;
	bh=OnTo7lh9g5xlLWdgD4XfnguhenWgPGfUj0m8YHpUS8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiFTQJ5XyfTj+/YT2bCX5j7l9afmZM4VFHRoJKo4EC2t5ARdcGO7MSE5BCBkDvYKqnJIolImt1tcOoEUxgZQkyJcXhdrrhN3nX4QT+BIUN30jtcqWxMaZ9bf5GxlV1+x0hFnSLNAM39GalT/7xXblCseV0+YaUGThZAIjIYROZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNOwlqhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNOwlqhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B651F000FF;
	Sat, 12 Sep 2026 19:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243168;
	bh=i1JrSe/MioL6ddfCjj+LUpvzLCasOLbHxFN44aVnvSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNOwlqhCU1qY/8OhTAivvFNtDKazlaiseGFYUIkUjjA7ZS06S7A6saa6IBIKMJz2c
	 lhQ+aM+G09DYkFENkbooeM/VBaawaP1Y1tBjLrFU++cx6+HPwlt6Cu+NxPCWFUIJ5S
	 P+JfhiAfkAoPEYhIgjs5FmPJWsyte1/6PkeIVUOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 662/798] fbdev: kyro: Validate overlay viewport coordinates
Date: Sat, 12 Sep 2026 09:04:50 +0200
Message-ID: <20260912065532.282998050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 7b5c7bc55e13e7f5ac7b1eaf5c6d690389ea5ee3 ]

The overlay viewport end coordinates are computed from the viewport
origin and dimensions using 32-bit unsigned arithmetic. Large input
values can cause these calculations to wrap around before the resulting
coordinates are passed to SetOverlayViewPort().

SetOverlayViewPort() packs the viewport coordinates into 16-bit
register fields. The X coordinates are additionally adjusted by +2
and +1 before being written. Validate the coordinate calculations
for 32-bit wraparound and ensure that the adjusted coordinates fit
within their 16-bit register fields before calling
SetOverlayViewPort().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 25801e8e3f74a..4979339dbc008 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -368,6 +368,9 @@ static int kyro_dev_overlay_create(u32 ulWidth,
 
 static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight)
 {
+	u32 right;
+	u32 bottom;
+
 	if (deviceInfo.ulOverlayOffset == 0)
 		/* probably haven't called CreateOverlay yet */
 		return -EINVAL;
@@ -377,11 +380,30 @@ static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight
 	    (x < 2 && ulWidth + 2 == 0))
 		return -EINVAL;
 
+	/*
+	 * SetOverlayViewPort() adjusts X coordinates by +2 (left) and +1
+	 * (right) before packing them into 16-bit register fields.
+	 */
+	if (x > U16_MAX - 2 || y > U16_MAX)
+		return -EINVAL;
+
+	right = x + ulWidth;
+	bottom = y + ulHeight;
+
+	if (right < x || bottom < y)
+		return -EINVAL;
+
+	right--;
+	bottom--;
+
+	if (right > U16_MAX - 1 || bottom > U16_MAX)
+		return -EINVAL;
+
 	/* Stop Ramdac Output */
 	DisableRamdacOutput(deviceInfo.pSTGReg);
 
 	SetOverlayViewPort(deviceInfo.pSTGReg,
-			   x, y, x + ulWidth - 1, y + ulHeight - 1);
+			x, y, right, bottom);
 
 	EnableOverlayPlane(deviceInfo.pSTGReg);
 	/* Start Ramdac Output */
-- 
2.53.0



