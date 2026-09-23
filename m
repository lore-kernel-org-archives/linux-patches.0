Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A4753C3A0;
	Wed, 23 Sep 2026 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175217; cv=none; b=YxcSDlNtg88Vz/av6GcmcE0iSCPY24KpoVyZp/JabDRSdZAS5TOc6ztsrVZoXaS0UBAAZDybaz27kUgChBj/CTrYJn4GjQ0bLQmBwTtFKkYxnpgjvD/zMi+L2C27uRtM9whpPB0huuM4PMGW548+lSBbRprZlClMFhL1iq7oq+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175217; c=relaxed/simple;
	bh=TvtbFl5gFNVTK0ydsZ6QJBdeunHIBg3zhkSJTY8ILx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyVN5Wk4zVwXsQrO7ET64bG5YUa6dFnqUVSpjY/1FDQYTcvGyp84pYE9jlRakY3NFQ6iAUML73c6YbyhXkcFbQL+2f7wxfBVvUjJn2M6RPJPgYsI2nDAJPylJwETOr7/3eAHc/Z5qNdePeaTqsOMvCS/EE06BgQtl9hdZRIcoro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va/sDZ+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va/sDZ+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEB81F000FF;
	Wed, 23 Sep 2026 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175215;
	bh=O9Ookv3N0nsHb4dQXPLR55NntBGf4GY3kgLyb7+kpz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Va/sDZ+GQCZwvUbVQfwoZLaEp5DUiXrXNoe3a3MJKKy3qzSZ+koi4KSKBxqb0qsSU
	 GfsuYdNPmchV7xh3p4MXjVCg8UN5rGUjnQ3zREyJ1/0+whSIoWfP7LgaVUKqio4xYh
	 NFfYmB2L2HORNliC61AiI70fFB7LqSP1LioDOBWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 322/398] watchdog: starfive-wdt: Fix runtime PM leak in starfive_wdt_pm_start()
Date: Wed, 23 Sep 2026 16:06:36 +0200
Message-ID: <20260923140651.765336990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


