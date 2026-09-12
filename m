Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533A23B2FCA;
	Sat, 12 Sep 2026 18:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238720; cv=none; b=m7hhaRPaMEH9kSvzdtHy9BgKkZceBGEkOfbU4vhqUc+KEaTCRbtVxhralWTwFrH4QVehq5K3hGa5x8yOtViG1egYAGyje5HjTTUkwcav1o4DVw8BZvqIDvS2EWuhdDtiM7lMHtvTWJTCYe6nYreDk/D/uu/rkEUF6W7lgpuFPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238720; c=relaxed/simple;
	bh=/WCMthYiWlDeyZYxwzV+uzJgciNEZmQA4m/5UqQ2KYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fknr44BB9q8NULcP3gh/GEuMRjvbxsApaWpepa5gVHOPN5iD6LiruV9yjr1VLQRuu8vhhV7uYPhqczP7/iBw6IZYJ72W/HEikojV25LytshvNtSHeQZFwOI2m2kvrahNXTn9DV1r9Qz5+l82qXozP6m7J8MZ3o/v72zZCRE0sp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bjNuiW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bjNuiW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263D31F000FF;
	Sat, 12 Sep 2026 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238719;
	bh=rXmp9Q/f4oy+qqp5LEe33P5vg2W66yEysRe12h7Ltds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bjNuiW+9Yv8tTumQXWpBYEaKkyi7fKn98DNbBujOzZYawIm92kkBtdRT/NSQSQyy
	 zo+M72WOPBGLVAje69u7EZhIpvDELh+h/KxRJsIYyd07KNEgG3zEsPAbake6aAX5Yt
	 TEJZlhmdOincFMQBkhZwYh5hfyyEizlzZZkKvCUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/935] usb: renesas_usbhs: Fix power-off ordering on unbind
Date: Sat, 12 Sep 2026 08:58:42 +0200
Message-ID: <20260912065538.101392552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 589b9e6f96be6bd8dd0d45fda8e948c31dc2fe94 ]

Move the usbhsc_power_ctrl() call to before hardware_exit() and
reset_control_assert() in usbhs_remove(), so the PHY is powered off
while priv->phy is still valid, rather than after hardware_exit()
has already cleared it.

Fixes: eb9ac779830b ("usb: renesas_usbhs: Fix synchronous external abort on unbind")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260702073832.175047-1-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/renesas_usbhs/common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index b3fbb51d8ee43..b31b9542b9567 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -802,9 +802,6 @@ static void usbhs_remove(struct platform_device *pdev)
 
 	flush_delayed_work(&priv->notify_hotplug_work);
 
-	usbhs_platform_call(priv, hardware_exit, pdev);
-	reset_control_assert(priv->rsts);
-
 	/*
 	 * Explicitly free the IRQ to ensure the interrupt handler is
 	 * disabled and synchronized before freeing resources.
@@ -821,6 +818,9 @@ static void usbhs_remove(struct platform_device *pdev)
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);
 
+	usbhs_platform_call(priv, hardware_exit, pdev);
+	reset_control_assert(priv->rsts);
+
 	usbhsc_clk_put(priv);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.53.0



