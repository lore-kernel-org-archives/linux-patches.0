Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BAE23BD06;
	Sat, 12 Sep 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224479; cv=none; b=A6kkFRHPCdoB+TFhwFp1ElheIGFqtJxNhgnhDQCYog1piGKliNIohc/xZqCW04422a4tm7wNU8XzBOnN3oZm7unKcliVlCJ6+sS25Q5/5Cc3eJj05T77ji/4h+IQZaUBHry8kb+cfS2SxC9DlPS87knTAkzWR2MWAIEc/tLBz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224479; c=relaxed/simple;
	bh=oY+XPiwRKX1CoB9Hd13tPyQYp5P0qafB13yH6IzByJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqRdrPJ3VBmIoI2cScYrLmJIp1ToITnol6uiHGTQKDm7n0pSBGZ+D7IImL/dtd0tF6zI1RKQNXqYSHprKy+ttywID+TAPSjaSZi0DmSkb/LoXd6TyjD3z5IvHKXyNszy9k+tMZo6Z4WhLkREtZei7lNiuhz2G87aYJFNwbMxhcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4Cla9Wh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4Cla9Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFAB1F000FF;
	Sat, 12 Sep 2026 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224478;
	bh=Rt9wuyfTzE0k9DvqFUe5UM7cX+/FzBX0+GHrkgh5JlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4Cla9Wh9T5rwU/c3wXQKvX7Jd4g1FyjcOteFLxi8XAoeIUgY5LMCtcS86ym8atik
	 b9Hm4X1JAQIvkB3Z/vQggx9i2zueERhAL59/S931vyXOvA4cg8safNvMJRgD6NcRJJ
	 Ll0GDWyoPTJK142EkGClDKbjTeSvcs7kl7ychuJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0957/1424] power: supply: sc2731_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065628.746306854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



