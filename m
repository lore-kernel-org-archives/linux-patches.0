Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30036341ADD;
	Wed, 30 Sep 2026 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796438; cv=none; b=pB5R2Qb24CA0B0rfSS6sJXYqd67seeTvXKydvRw8cdBdmAPa7Q40EbAi0wfe++qlKEWhO4QTgKQd7amzRNuxAhpGwwpzQLjpuwLQCEQCjPI5S/CNM6h2XEPhu4YyMd8axaD4PMxA1eUMlVEtDzthtlMJSWqx3M/u6P7Trb/+CyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796438; c=relaxed/simple;
	bh=KsG5ZlSKm3vXW64Crx+3cXGHn13QXJ9miIoRIjT8Nr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJJYOT89aM5jjRZR+TtfAI5SMiOe7/GPH7CaoIawfksk+uFzADhiPd2gLsmndOy+Rcb3a2+5Kk8WyLTRs2PK8PhFrmdE6PHVYdR+QGEnriVJrh7WfogO0Y9ErhF4+zBOhww8WQ8qdcXkopIdbzqikfmAgM0RgCaPiHGFExTftfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bq5PVNRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bq5PVNRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B1C1F000FF;
	Wed, 30 Sep 2026 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796437;
	bh=2diSfwc7A98xFW2iBrlfZ3YXfaVP4Xip7e+KA21EwAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bq5PVNRVeA+CfirCDZgh26Luk1yeKmbwvQ3s7ol36zk+Wk1gMOsjOU2ydb2jGlenz
	 hTe899aF3ia2wAdJyYjPSBZga6LLKl6go3OQ21dpp/ujqPxWjj5U2XnB7+7JYIOXLf
	 IrWjOt6ItOF9+LyvvHun3iXG2cp0pckAGChixHwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0914/1193] watchdog: rtd119x: Avoid division by zero
Date: Wed, 30 Sep 2026 17:26:38 +0200
Message-ID: <20260930152454.548167087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 5af7d2cbd20f893def03c8310a460ade66a5d822 upstream.

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: 2bdf6acbfead ("watchdog: Add Realtek RTD1295")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-3-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rtd119x_wdt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -98,6 +98,7 @@ static int rtd119x_wdt_probe(struct plat
 {
 	struct device *dev = &pdev->dev;
 	struct rtd119x_watchdog_device *data;
+	unsigned long rate;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -111,10 +112,14 @@ static int rtd119x_wdt_probe(struct plat
 	if (IS_ERR(data->clk))
 		return PTR_ERR(data->clk);
 
+	rate = clk_get_rate(data->clk);
+	if (!rate)
+		return -EINVAL;
+
 	data->wdt_dev.info = &rtd119x_wdt_info;
 	data->wdt_dev.ops = &rtd119x_wdt_ops;
 	data->wdt_dev.timeout = 120;
-	data->wdt_dev.max_timeout = 0xffffffff / clk_get_rate(data->clk);
+	data->wdt_dev.max_timeout = 0xffffffff / rate;
 	data->wdt_dev.min_timeout = 1;
 	data->wdt_dev.parent = dev;
 


