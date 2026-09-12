Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E467362120;
	Sat, 12 Sep 2026 10:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208849; cv=none; b=q31HzhQ+fzieoFIUxpmq5Q6Yl8EE9Fn0+e5KzFBBcaIBuUFULkQYyWsguGaib1R96jg4+8tKdyhrcCEeYbEAQ6KZP/s5M4I9ZSluYcj3yRGjTCF7hNS5FKoBkpmMsRAzJxvjmAJt9cVzYjwIrHXOVTIXhES1XmLPr1h87BD+WuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208849; c=relaxed/simple;
	bh=85pPAzHlvgeMqqurMm/DivEPnyx4YYpjOkizbFnCv/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B02njC3QyTJqyQOnBFY7f//MO7zWPJ41aaPJDjAXWcWoVPFA44tRHV6YuqpLSNIjFZUdOsy0SX/P+BS62YUBWAZ1BbFcE0eY2CEN4Xw7R9njEmB50dE+mCEkOGmng95J2mfyyIDGFNhl6LJyVXgn47CQ5R+JtmW3sNEd+spVBtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL7fokua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL7fokua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70691F000FF;
	Sat, 12 Sep 2026 10:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208847;
	bh=huZY+JkMMcS8+3TEz2mvO/YCzg5aJkBuMrq3eHDMGOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mL7fokua48NEKZyVdfCYDdN0uU2fs4ZuCiZyWM6NAuNdCD8DhtEWVhBARLttxFDif
	 OsyMvpqglcu14Lnhbod63sv8yBjbgeItwkrAjc7y3EyQkQiwbk7t4gCGUTAv0DqdMy
	 9ODyurVM6IreY30fYR6ncNX4UzM5qXAjK3Jm666U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0702/1518] power: supply: sc2731_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:47:51 +0200
Message-ID: <20260912065639.313336737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



