Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99EB5158BC;
	Thu, 17 Sep 2026 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664098; cv=none; b=uTKyCVdOKGKVJ5Bg6+b7APLxHUJFUElksIcJSLU1bwiAT0w6cx0KUkdsy33Eq3HPzd3fH28+YZ7OLX26rX/czdVItRtx+Y+njilnj99rpx2Nw/WXtzhbwS0+1Q6x8gjql6Mvy4XGQe52b1jXf7j7MltxuEWA40kj2uUXUVY5V7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664098; c=relaxed/simple;
	bh=HGjql4KwmuTaY9WCj76AWp7iedGLenwCcjQFLdqYgo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyQIX8jVat4I7R/sPXwk4882ulyQP1oCoHwP35NIT8DToP4H5pp6YLuK1fC5w8oUhqKxpxaEnYq7/2URp2atlEM9ddXW2DWmTUTFmQsD3tZRWJk8GeaA0RpUbviOVvIbjRYtN+0oAtnAM1T+3xX7P60j/uQZuFvSsgTdhphNZcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kygeI2zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kygeI2zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB4C1F000FF;
	Thu, 17 Sep 2026 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664096;
	bh=ZMmHAb38irvKOAS4bjd9JvhtMiUXSktfR6AhBScGL3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kygeI2zghJF0Aa/ml2XPulWlwjrcZBwADK4ZRtt8bcZQAawTltxDTyrxGBPJMMDrh
	 wXpv4ZHWXX2pDdEXZAiItrn/64TB9pvEcOMeK1eZ1kQ+sd8SK2Tdx3vSKxkNQldS7w
	 oGemhbIVvRGGPmnZhYNsUDMdZBbxk0/QaidgEMjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0210/1250] thermal/drivers/tegra/soctherma: Switch to devm cooling device registration
Date: Thu, 17 Sep 2026 16:00:05 +0100
Message-ID: <20260917151557.816400321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>

[ Upstream commit ee126267bc04bfb03816ae9d71ca24c5bf99e739 ]

Use devm_thermal_of_cooling_device_register() to simplify resource
management and avoid manual cleanup in error paths.

As a side effect this change has the benefit of solving an existing
issue. Before, the function tegra_soctherm_remove() only called
debugfs_remove_recursive() and never called thermal_cooling_device_unregister()
for any of the cooling devices registered here.

After the driver removal, the thermal framework's cdev list would
still hold references to thermal_cooling_device objects whose devdata
pointer (ts) pointed to memory already freed by the platform device's
devm cleanup.

With this change, the cooling device is unregistered when the driver
is removed, thus fixing the issue above.

Signed-off-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260424160019.41710-2-daniel.lezcano@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/tegra/soctherm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/tegra/soctherm.c b/drivers/thermal/tegra/soctherm.c
index 5d26b52beaba7..9d3eb3be2db02 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -1700,9 +1700,9 @@ static void soctherm_init_hw_throt_cdev(struct platform_device *pdev)
 			stc->init = true;
 		} else {
 
-			tcd = thermal_of_cooling_device_register(np_stcc,
-							 (char *)name, ts,
-							 &throt_cooling_ops);
+			tcd = devm_thermal_of_cooling_device_register(dev, np_stcc,
+								      (char *)name, ts,
+								      &throt_cooling_ops);
 			if (IS_ERR_OR_NULL(tcd)) {
 				dev_err(dev,
 					"throttle-cfg: %s: failed to register cooling device\n",
-- 
2.53.0



