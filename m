Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E133922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090F5C433EF;
	Wed,  7 Jun 2023 20:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171500;
	bh=eUyy4o0ZFlQgxEmoGpUGIqucDH7lEIHYip0rJcopiEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jka50RxcQtf3fx1FK+z0hc9BRvFUbHxjffPL7iYxx82XVIM24fDA9iMb2Q0/AXWOu
	 j2b1hr7kl1C5ByPaj5y/af/gx7kgnwlo2vnZwluG438lUvkp7dbVnuwuTFcaZzxms8
	 jZoZEnGCd3ubee6E/bcat58ptybLiP8ifKOp3k64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/159] watchdog: menz069_wdt: fix watchdog initialisation
Date: Wed,  7 Jun 2023 22:15:44 +0200
Message-ID: <20230607200905.018457033@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <jth@kernel.org>

[ Upstream commit 87b22656ca6a896d0378e9e60ffccb0c82f48b08 ]

Doing a 'cat /dev/watchdog0' with menz069_wdt as watchdog0 will result in
a NULL pointer dereference.

This happens because we're passing the wrong pointer to
watchdog_register_device(). Fix this by getting rid of the static
watchdog_device structure and use the one embedded into the driver's
per-instance private data.

Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230418172531.177349-2-jth@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/menz69_wdt.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/menz69_wdt.c b/drivers/watchdog/menz69_wdt.c
index 8973f98bc6a56..bca0938f3429f 100644
--- a/drivers/watchdog/menz69_wdt.c
+++ b/drivers/watchdog/menz69_wdt.c
@@ -98,14 +98,6 @@ static const struct watchdog_ops men_z069_ops = {
 	.set_timeout = men_z069_wdt_set_timeout,
 };
 
-static struct watchdog_device men_z069_wdt = {
-	.info = &men_z069_info,
-	.ops = &men_z069_ops,
-	.timeout = MEN_Z069_DEFAULT_TIMEOUT,
-	.min_timeout = 1,
-	.max_timeout = MEN_Z069_WDT_COUNTER_MAX / MEN_Z069_TIMER_FREQ,
-};
-
 static int men_z069_probe(struct mcb_device *dev,
 			  const struct mcb_device_id *id)
 {
@@ -125,15 +117,19 @@ static int men_z069_probe(struct mcb_device *dev,
 		goto release_mem;
 
 	drv->mem = mem;
+	drv->wdt.info = &men_z069_info;
+	drv->wdt.ops = &men_z069_ops;
+	drv->wdt.timeout = MEN_Z069_DEFAULT_TIMEOUT;
+	drv->wdt.min_timeout = 1;
+	drv->wdt.max_timeout = MEN_Z069_WDT_COUNTER_MAX / MEN_Z069_TIMER_FREQ;
 
-	drv->wdt = men_z069_wdt;
 	watchdog_init_timeout(&drv->wdt, 0, &dev->dev);
 	watchdog_set_nowayout(&drv->wdt, nowayout);
 	watchdog_set_drvdata(&drv->wdt, drv);
 	drv->wdt.parent = &dev->dev;
 	mcb_set_drvdata(dev, drv);
 
-	return watchdog_register_device(&men_z069_wdt);
+	return watchdog_register_device(&drv->wdt);
 
 release_mem:
 	mcb_release_mem(mem);
-- 
2.39.2



