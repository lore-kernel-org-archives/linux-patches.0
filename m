Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E3A288B9;
	Sat, 12 Sep 2026 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231181; cv=none; b=YjJJmCauroeBGdawoxfgaEvNlEwVtRrbfg33HZiinDRTZvAHee0cAwl6uCiG1iE356YX5TDw52h5tX3vvdEn6Fi9Atx7PGAWiobGVkaPEdSG+8rEIp/KHuHrQYIt2Fvhyk7+pu/HIN+ozQAbaNkkkjmjbTn875LreY6U6ny++OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231181; c=relaxed/simple;
	bh=P221x/YdtMvIZaxoucMy4jgHXxwSKl+tSAPBTcaT20E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K87vBkcwTcBov9iSGGf7jr3y6UVNF721aVXt/RIJllTpTgRU+t/JcXCMQnjROm8dS4aZ7XaJwSdqy+JAqqjyLHVzVE1yJO2otW91eXbcgscWsLH8HiHQGI41wT/VAJkRKOFl0SqA946q2pN2kN9OnhLRmK1+7yDo1XVkJr+o4Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAi8t+DR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAi8t+DR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9681F000FF;
	Sat, 12 Sep 2026 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231180;
	bh=kzMQoStjRywX9XufwHm/HY7B1XXQrkaowasBpWLpiio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAi8t+DRrXzJZvsUvHwvz0Wxzxx0tEU20n47QTTuf3iVu5qQ0BVadCuKFWS39EcNQ
	 o6PK120PWpktkyrzwTyluhOanwLG6/we0SaC+cLIXhB0JiDqr7XVVd6/o3ERbMcDfk
	 dWdvOnq8MASMHbtGSotQ8EDgsmNbv8VHioXUzxiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0946/1191] fbdev: kyro: Validate overlay viewport coordinates
Date: Sat, 12 Sep 2026 09:01:14 +0200
Message-ID: <20260912065609.471537195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b4b93054c5208..f3e214397ea95 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -369,6 +369,9 @@ static int kyro_dev_overlay_create(u32 ulWidth,
 
 static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight)
 {
+	u32 right;
+	u32 bottom;
+
 	if (deviceInfo.ulOverlayOffset == 0)
 		/* probably haven't called CreateOverlay yet */
 		return -EINVAL;
@@ -378,11 +381,30 @@ static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight
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



