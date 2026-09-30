Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199235111A7;
	Wed, 30 Sep 2026 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788893; cv=none; b=Wg7Xj97x7wtIJ1mbuX1dEDsI+ZTrzvtdCR6arBEVsv0Hr2zk7UBPVPwH6aCUx9t5/G1UlUwRJ5WxmlPYW3AAz9jZI8HImHN2a4T0fCs5yTad6S1xnvUA3l7kUZuOSVWyq/+bFQDfHvP0IaeFECYITZKplt+xsHumtDnHLdBaLK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788893; c=relaxed/simple;
	bh=kAJ4IkP3/U5lIZsqTefTlP9wGYcfCXuGKOM1q0QkIog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW0btZgShWQnJSlt8k46/XmZXizWZwCiaVt03rlOSjTHmiqVPtXla1mUABeTUEBrDDzqAws2cIsQNW55aEi2dtne76PJrh3EtVWbptucQlQKikHzOJR9Ls45hgzrEOq5kW6eEKRuVLLdlf8O6PnQPLrCSaaFzrZM3AOchf2Ri4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea8Yam/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea8Yam/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7627F1F000FF;
	Wed, 30 Sep 2026 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788892;
	bh=8leqWOI1gWow8gFxm+AQ6JyEIUj8Bn7eH4tRMAIysCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ea8Yam/zL9COPD8tFg9+VK/mc4b+ehLAGKE2B7Kvx0Sym9k25/P5r0LBpMwn4hLR7
	 c0m3GLIwDbANLMfqXoYFufMFKCiJWljrCsK7iqtKkZQXf/1ZcmbMqFbi9QAA0zsnXX
	 oqs60MTuJDs1X8FFxizZvJiWjqzi397f5boYU69Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 258/877] watchdog: starfive-wdt: Fix runtime PM leak in starfive_wdt_pm_start()
Date: Wed, 30 Sep 2026 17:19:29 +0200
Message-ID: <20260930152420.288988519@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8f0ca55016a7647109ae2bc91bcb346fc8b13785 upstream.

starfive_wdt_pm_start() takes a runtime PM reference with
pm_runtime_get_sync(), which increments the usage counter even when it
fails, and returns the error without dropping it again.  The watchdog
core does not invoke the stop callback when start fails, so the
reference taken on the error path is leaked.

Use pm_runtime_resume_and_get() instead, which keeps the usage counter
balanced when the resume fails.

Fixes: db728ea9c7be ("drivers: watchdog: Add StarFive Watchdog driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916170704.2086331-1-vulab@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/starfive-wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -371,7 +371,7 @@ static void starfive_wdt_stop(struct sta
 static int starfive_wdt_pm_start(struct watchdog_device *wdd)
 {
 	struct starfive_wdt *wdt = watchdog_get_drvdata(wdd);
-	int ret = pm_runtime_get_sync(wdd->parent);
+	int ret = pm_runtime_resume_and_get(wdd->parent);
 
 	if (ret < 0)
 		return ret;


