Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DFC497B76;
	Wed, 23 Sep 2026 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173893; cv=none; b=HurZdr+cGkwklHtqZDhOZWhLNzKVkQgi4FOyfAcHubUIvR+kTWdt3HVSkKPvfKQ0DKl/RHgPl6Y4pXTRvG2BhRTBJriQEVg/JwqbQe2oBER/u8FxcAKYKct2S6EGRchzTd+P5OkPk5fWU2e+3KVlHidUj6LqC7HWMc+iIxmcM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173893; c=relaxed/simple;
	bh=EZDQxlY8nBRsnbUeAtAWk9Bx4SdU036Imp3PZbky254=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX65fhwrOaqabIWLy+Ak7NOZKsDZh2lPxJRYYKdCymMeBRal227eXLDSyp9Sc1maRdqW9NYTsE5Ph0UGkdSHyxIofByJE0TnXDZeeuR0HyTFnspLGCdvxWShpD250JDhykKIsGdQm23GzB/qr4MJ6R+pcvLgr+KbVtsskohr//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVj3iHaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVj3iHaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA05B1F000FF;
	Wed, 23 Sep 2026 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173892;
	bh=GP6s44sND9OP4lf9+wwxEoLgp8OXQXpeXUp7Wos6YVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVj3iHaD3LA0ynHQfT+wQCnnnzTfszxC/6HIvzI6KAy6Yy2ZX7T7OQOW6lWpdVWdn
	 0+yiTMRrvnjtAGaG+IYvawtYOwQGsNjcMl/vCwRPojX6RMD8rWUc7MN7lgC2f++8QT
	 vAs8nVN0KOTXKt2zpHjV3hUT7Ig4BfPbSSZiZwE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 378/438] watchdog: rtd119x: Avoid division by zero
Date: Wed, 23 Sep 2026 16:06:39 +0200
Message-ID: <20260923140654.662856112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
 


