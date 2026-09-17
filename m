Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF794398F5;
	Thu, 17 Sep 2026 18:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671112; cv=none; b=KuDqegk9EihPP1ztP46wuiAukmARy6KaICMLyqsLZWN6jD92mFo+vKybG/mLG47xZ8TqD1QttgbWp2BGWsSIR2scIc8tQ9n5JNUdrNh1zAUsuY2sf5sQGwB8b1c1puP0ZyoE1KKSXZOO2+D6YPwJmk9NFv6nSkW5P9MRKwdRMbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671112; c=relaxed/simple;
	bh=U+QW97qmos5PXnCmpkQJGfCSMsmzgzvy5r9ln530MIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMDlYeXQ+Dby5C7DKksl5bkatR4lXcB8kCDbtdX5pRrk1nzRXx2yRT5otQxHN5zBSkZBByER/Cc3pjrfGY54FZE9ljQb+a4HtO/m45EHaP3kvNMXrNvRCQ+SFoOQrwQ7jShFRbYxlxNH52Q6MW9m4cWqUeB0TWnpQWyzdnSeSGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AGwKu08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AGwKu08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854011F000FF;
	Thu, 17 Sep 2026 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671111;
	bh=EowKXCkjJm9oBDUaWSycoufolWMZjRJnSYrkPY3tce8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AGwKu08jpz63xITgNnNrD2tkSkl/iN+kTdu7TXFe9GlMeEINgbQdENji7LFNNrE9
	 w9x0/PtV+nNFnNLtI4OYuboakeRaTISGECzNinA6nJFD+XxffffFulEDpJRg+UmMUv
	 pGqh5DGdGDHA3chtDGcnqK6KUssRVg1MvQ4Tp86M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 0870/1102] hwmon: (applesmc) fix key backlight workqueue leak on register failure
Date: Thu, 17 Sep 2026 16:13:33 +0100
Message-ID: <20260917151602.400725951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit 5a0aacaa2d593d7582ecfe289529b937b6dc5d3c upstream.

applesmc_create_key_backlight() allocates applesmc_led_wq before calling
led_classdev_register(). When register fails, the error is returned to
applesmc_init(), which jumps to out_light_sysfs and skips
applesmc_release_key_backlight(), leaking the workqueue.

Destroy the workqueue on the register failure path. The bug was introduced
when the inline init block was refactored into a helper that returns errors
directly, dropping the old out_light_wq unwind label.

Fixes: 0b0b5dff8967 ("hwmon: (applesmc) Simplify feature sysfs handling")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260828105413.2401385-1-congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/applesmc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1249,12 +1249,17 @@ static void applesmc_release_light_senso
 
 static int applesmc_create_key_backlight(void)
 {
+	int ret;
+
 	if (!smcreg.has_key_backlight)
 		return 0;
 	applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
 	if (!applesmc_led_wq)
 		return -ENOMEM;
-	return led_classdev_register(&pdev->dev, &applesmc_backlight);
+	ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
+	if (ret)
+		destroy_workqueue(applesmc_led_wq);
+	return ret;
 }
 
 static void applesmc_release_key_backlight(void)


