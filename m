Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0122264AB;
	Sat, 12 Sep 2026 16:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230527; cv=none; b=BJX990mBsI0+CDILaXGBENLv/rd5tQV3EtgG/phoe6QehisKm6Z6UrIvaXUBUwc2SaOXE80DiW86p5G4msLQiE4xV3ybuPnXs7wsj5gD4rUaxc0sSMrzGMc1M4Pskbec6FozFU7Ys+z/BGLR7531OmAd3NggyTLJsdilFFcn/kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230527; c=relaxed/simple;
	bh=Tx5sNERxEn0cKD2z3HdpZDOIiojeaDic5JMBckCM2M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGyIFhWtRE83D16EQEqpbaArPEcIetZ2b4EUp0UlG+vH20a3CaXQQieDSgG3Nhmlk2lZxspm7Fs/82q2PRTSDs79bveNrdDIbMGC+9lgsktHC3wMNQ63pU5gs0BP/VO1etMvqCmQrBUh46pbnVgGHxAIjD0hWdxTHA8kOnGgtBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIUfI48F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIUfI48F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05371F000FF;
	Sat, 12 Sep 2026 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230526;
	bh=XL6dp7qlyV5uIA3pnSP/NKKysvPhKsqKNPo0YFWmZ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIUfI48FiC/CnDUaYZuuHOLo1O7qV3Vuks7K/sigQE90+Y7Mh9tJ3wsNGjSAAbmeR
	 aVm4svVh0oubalrYt8gAYe+RAAA0AXB3VkveOIod1CeDNsL53i3Xy64jq3Bssn5hXf
	 X3FUCfM1BwwyOCjCx7s30dqmNCSSSJDYUZYUpTJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0785/1191] power: supply: sc2731_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:58:33 +0200
Message-ID: <20260912065605.908910413@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit dfc859bb8d332c525872f1a44028137724fa1998 ]

The USB notifier and initial charger detection can schedule info->work.
The remove path unregisters the notifier, but does not cancel queued or
running work before the devm-allocated driver data is released.

Set the platform drvdata used by remove, then cancel the work after
unregistering the notifier.

This issue was found by a static analysis tool.

Fixes: 8ac1091ed18b ("power: supply: sc2731_charger: Add one work to charge/discharge")
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/5d48b827687168cb1b1bfe85f17945566b42829d.1785321763.git.getshell@seu.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc2731_charger.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/sc2731_charger.c b/drivers/power/supply/sc2731_charger.c
index b3d8b1ca97da7..0b3153eed8c41 100644
--- a/drivers/power/supply/sc2731_charger.c
+++ b/drivers/power/supply/sc2731_charger.c
@@ -466,6 +466,7 @@ static int sc2731_charger_probe(struct platform_device *pdev)
 	mutex_init(&info->lock);
 	info->dev = &pdev->dev;
 	INIT_WORK(&info->work, sc2731_charger_work);
+	platform_set_drvdata(pdev, info);
 
 	info->regmap = dev_get_regmap(pdev->dev.parent, NULL);
 	if (!info->regmap) {
@@ -516,6 +517,7 @@ static void sc2731_charger_remove(struct platform_device *pdev)
 	struct sc2731_charger_info *info = platform_get_drvdata(pdev);
 
 	usb_unregister_notifier(info->usb_phy, &info->usb_notify);
+	cancel_work_sync(&info->work);
 }
 
 static const struct of_device_id sc2731_charger_of_match[] = {
-- 
2.53.0



