Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEBA3587D0;
	Tue, 16 Dec 2025 12:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887268; cv=none; b=J4zCHlbmiEMLipnmqsRaO1VGXhHWi8oWhchh1NHrmnzSQp2FsmMoVJpB4nHbeftRdGmXzZOIrdTlzLfkb2sUItXuVdWw5UZUJHS223ZOqYF8yffpvnPiXKaWXNHlzZOliCZumj4tzRh5jZHKQ23r5sBYB7mGJOHCv2kGjTM1z9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887268; c=relaxed/simple;
	bh=CJgTQRH54igN+TMbYzLH/VC2l067rseaRiOUBfkJmNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1YlYimnjfPnjGni8XBZKFi78EgOyCr8eP3FRSREwALpGqX3VlEJ+Jc6oxW8DUtXv7g2GW39s7my0T1CJR3jmLiY8yoM4WEqpmPj9mziY5LBiMX/gXE8r1uQIBeRGMxIjmbxL+BpYI1WhWJKmhU3VjS9RP4Ya6U96Qewmt3Rjio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya7dOwvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya7dOwvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDDFC4CEF1;
	Tue, 16 Dec 2025 12:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887268;
	bh=CJgTQRH54igN+TMbYzLH/VC2l067rseaRiOUBfkJmNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya7dOwvqMal2p257hHH3nV0sqVzDIxIQ47VE6mYubpxyYgkpGCt6zM1hF9FCr7rG1
	 38LCHXej/my7tEujx70x6ZQXiUSAuuw4wUfJhJbo6gpNwvZpuJPisiNjx3gIAjxjEl
	 OL0YHfYqKjLZl6EVLQ16qvyESQ6N9NBZAL9VhPaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/614] power: supply: cw2015: Check devm_delayed_work_autocancel() return code
Date: Tue, 16 Dec 2025 12:09:06 +0100
Message-ID: <20251216111407.858757624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 92ec7e7b86ec0aff9cd7db64d9dce50a0ea7c542 ]

Since devm_delayed_work_autocancel() may fail, add return code check and
exit cw_bat_probe() on error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0cb172a4918e ("power: supply: cw2015: Use device managed API to simplify the code")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://patch.msgid.link/20251008120711.556021-1-i.abramov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cw2015_battery.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cw2015_battery.c b/drivers/power/supply/cw2015_battery.c
index 2263d5d3448fd..0806abea2372f 100644
--- a/drivers/power/supply/cw2015_battery.c
+++ b/drivers/power/supply/cw2015_battery.c
@@ -699,7 +699,13 @@ static int cw_bat_probe(struct i2c_client *client)
 	if (!cw_bat->battery_workqueue)
 		return -ENOMEM;
 
-	devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
+	ret = devm_delayed_work_autocancel(&client->dev, &cw_bat->battery_delay_work, cw_bat_work);
+	if (ret) {
+		dev_err_probe(&client->dev, ret,
+			"Failed to register delayed work\n");
+		return ret;
+	}
+
 	queue_delayed_work(cw_bat->battery_workqueue,
 			   &cw_bat->battery_delay_work, msecs_to_jiffies(10));
 	return 0;
-- 
2.51.0



