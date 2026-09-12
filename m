Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82424299920;
	Sat, 12 Sep 2026 08:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200836; cv=none; b=Iyr4F/574hjAXtr/+5DRB8CAhYadgQuPjDvp6+ArCblPPINDTJpSYqHk2BtNoLKQB9XHbYTcIvWqrhPoGn9GXz0h/VZGowBt2yqaWAxPdamKVFF6+XqLkkaCIitNTAZW1GGR8QiBekKBMxnQQSiAYDOhUvaBOtl1ln/YIxfPDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200836; c=relaxed/simple;
	bh=uXuZnjT03ETVBZaE83VLBJ8ZrPhA8as6L2asUz22vtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLHSRYhmlNlJy4UQa7g5/uG7k8hRkq+zY3QCMydySUCWIqpGInSIESiRh89oyvyiJO5r55xFgFheX+hV4jODrtvK1RC7yswTDVp857HxU6GdrCUs/hD6pONtVxCxLFlK7FfDTCsiNyn0b5pMMIeNnenyYYDpb+5QTVlShZBQUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6lMuwzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6lMuwzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228BD1F000FF;
	Sat, 12 Sep 2026 08:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200835;
	bh=s4HAhVbJA9UOBanzC438hohM1jkccbG/AHlRXnCragc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6lMuwzvqRkCP4Unkf071IYnzixAvsldxkf7XZBaixHUfyoJsQc5u4a2YOxg40Qjr
	 LklEwRBUpYRxlPmVlw80hGHRtXKgwdJryFNixnT1G7AjC//utsLQNttXeaAfWpp2Zs
	 yiWzQmYvDXa7VrPzKrO2BM8bOIzrizvUPxs851BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0819/1815] power: supply: sc2731_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:42:49 +0200
Message-ID: <20260912065708.139276917@linuxfoundation.org>
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
index 58b86fd787713..2b25e44da7978 100644
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



