Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ACE36A37E;
	Wed, 30 Sep 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788831; cv=none; b=L79WNt+mkTZ7g1q/02/K9IG+BpG8UsyZXe3SqF4PjU/LJ1p3Nkst4riznlxi+LY0wbG6xix2adTxrtSZrpVMDLYod96FCVRin7F+mUhLBUqejBqyiDXviWqlE/J1Tz59vuHvDXXGwiH7rI760I6Wz/8xcQ+niVpHgEZsPOIAhJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788831; c=relaxed/simple;
	bh=VoHhusmN4eqPDUmyBhQHvzSNzXocankYg9p9HyH9PXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+GMHQauKMEHR+k1yDL8PtujJwJI6HfawL3YPDb3/EFQIIYaPbnSPYlsElv8ughVmRXAM/lfOGkS7JGb56pFMjbGxDBJfffp7xXd3xyfaoQlugHUgy1Mv67HFO2KFveDC/mP1gDoWlXCcBWhsKddIys8G6WMJo3iQSbly+xRRZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRPdp8Gl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRPdp8Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464641F000FF;
	Wed, 30 Sep 2026 17:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788829;
	bh=aQiAGZGH6DOgA+1OZX/D1Bq/K64wf6k4iC8Q5nnMeug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRPdp8Glrh7fU/4euxwMlQ6uCFJI+IoLT9xmp80+DQyX8W8PG9AOaemv5wYLS5Iwg
	 kVdwzc1926d6Sml7x1nrAg63NYx8K21z7l4OkmXaZehVG3m1a8S3KghLuscUBpo5X7
	 1YXqUJ3vIAKRsGk+EJN/gPKB3YhU1hikTQplHEas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 256/877] watchdog: rtd119x: Avoid division by zero
Date: Wed, 30 Sep 2026 17:19:27 +0200
Message-ID: <20260930152420.246027304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


