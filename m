Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB04372691;
	Sat, 12 Sep 2026 08:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203055; cv=none; b=AKtX//ezxfNtTFqYprzPyGNVBnwPSjiSqYg6APxBxL89s8lA4ZlXOTHUDeW8g3RDhmIyhk8R91uPTC31ri8wMGnn+QMNxmHdGm/JrWMqf3t6p5Yn8bdFfvd8E2oqyhxjJhoNhAJXXjRhxGNOzEOu7s+MBxE0igK1vm6jEASi+MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203055; c=relaxed/simple;
	bh=KFPFlPjSbg/dbu3WkGMuf0P2GZ0YvTwr3jf2JjUDJZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMEFpEVHg1B7uXS49YOzdFEurWpjp3ThnwWkg3LINtkWp6oU+cBuZ018pFrHmo+r4avFAZJnUXvs6CDEi9vkGKhMkm20vHE/7/7xcjzZqZvWC0Kd7m63dzGlC5He0Z6EKhvmv6fe9tsiyTq7RJoRiLho6Wmh5OwX3vGeqvtGjkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JueVUWVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JueVUWVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266A71F000FF;
	Sat, 12 Sep 2026 08:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203054;
	bh=jEkFi0UjJGdmDvvbZB6V/gNLvl7Q0ZXlU049JuwzBGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JueVUWVFqo34x/XcjmueVu9tNhOYwTn3Jag4Ppkk7iwGUelutln5JD+0Gj+vev64N
	 N2kQAWEFGc0dmqhJNHYgAbCrM0SMvAWMcw2Y7skTYBeM6wB2Hcd0adyiQWshTA0NmM
	 a8PUKKISbQUkPytbEFgw9irRqq+T4NujhYEOefwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1287/1815] fbdev: kyro: Validate overlay viewport coordinates
Date: Sat, 12 Sep 2026 08:50:37 +0200
Message-ID: <20260912065719.227016348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d756b3603fa6a..c237389888229 100644
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



