Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03825326AD;
	Wed, 23 Sep 2026 14:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174011; cv=none; b=ResOiEgge+aeNN8HIRrojEaoZZiEL9TMHbjCPPcjNkmWutajsG6qPPHlMZRaIaxirrEtcodVPcIUwGkmDTzny0Nl6KPk9bIXpVj6zYds8lgarBYr4OYJrMVHIBdK059FtHFnGxrUqp7E8f7hj8tr7G2mzC4jQ4XEWv9bvQLTcJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174011; c=relaxed/simple;
	bh=22Uoa8JbnwejUdnO96eO5CquQPsWoTWzEuDp3XO8Kgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D1E0Rsco63hb6Np37KV0X0gz/3Yu8f66o4JtCB7DQFJEwwCaZ+2XHcu/vC/EiTwFyd444Rq8oaV5RYj9OS4irF6QS2v2vTGGGNhlTlWZ/izmZ1oMMMv73IhHlOe5NIVi9ey8NM1sGbr8lLVoLsDYvKpIecoJ4dFomELYr99x93Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctCswzcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctCswzcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F56C1F000FF;
	Wed, 23 Sep 2026 14:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174009;
	bh=VSk0VwB/KgDoLQY862AD6gFtwknk9Qkd7YWVZ5bqOdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctCswzcb72m+/VQp5TpsPZHXM41YHXvToXCw+iNbPU05SmZnmhcFF5999k76XPYoY
	 B9BzEH7ItBXyHiAAwqpoRa1V9iwkaskQ2nk+OcUJLsv7d43SQ+is8pnH2EkjxVIAes
	 sfqe1Q/7EJd2+OU2S5Le3dwWuT0JX/hFTrl7wiF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 374/438] watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog
Date: Wed, 23 Sep 2026 16:06:35 +0200
Message-ID: <20260923140654.557074384@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jun <lijun01@kylinos.cn>

commit 7cb575b71ab98194d2e040bded3a7281e089c5ed upstream.

da9063_wdt_suspend() and da9063_wdt_resume() only check watchdog_active(),
when the watchdog is left running by the driver sets
WDOG_HW_RUNNING in da9063_wdt_probe() but userspace never opens the
device, so WDOG_ACTIVE remains cleared, the wdt_disable() will not be
executed in da9063_wdt_suspend. In this case, the suspend callback is
a no-op and the watchdog keeps counting during system suspend,
leading to an unexpected system reset.
Check WDOG_HW_RUNNING and wdd，can fix this issue.

Fixes: a7ceca4398bc8 ("watchdog: da9063: optionally disable watchdog during suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://patch.msgid.link/20260917013710.2754679-1-lijun01@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/da9063_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/da9063_wdt.c
+++ b/drivers/watchdog/da9063_wdt.c
@@ -271,7 +271,7 @@ static int da9063_wdt_suspend(struct dev
 	if (!da9063->use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_stop(wdd);
 
 	return 0;
@@ -285,7 +285,7 @@ static int da9063_wdt_resume(struct devi
 	if (!da9063->use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_start(wdd);
 
 	return 0;


