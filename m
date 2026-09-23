Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12C374E64;
	Wed, 23 Sep 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175226; cv=none; b=OxCPrWvJhOAPdDcjPEef22s+HAd4U1mrvAXNnh/yBpp1rODrfrXtquhOIdtK/RgRhoTnfheEx01djCMU42HVx7WiR+uxg7HF/KXhvAb3F68KspD6lSaRbgk9NAUxm2sDiDdF7mQMP6yOJYgqI59LZiqHNWdk3cOkYAvqUOy+jW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175226; c=relaxed/simple;
	bh=wCxrsUoUncHegxjJyFHcKQagK8cVOyeopymOZ/rJztU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7f4qGmkENpKMLnFExMeUDz50/4J1vPTs4PsB+H6Twtdx7yS3n5VJOYGvJ/5tGINUuvjzmXoc2E7vXTBf91UafUiBCFiVxgxzHzVohXRCHm15YhMfU5kYsD0/t8tGiavqFVctcMja4CH/VsCEb/3wt/ZLYjnsmmRV3EFp4mRroM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hskSGcx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hskSGcx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD41E1F000FF;
	Wed, 23 Sep 2026 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175225;
	bh=gvCFfwfhIwaY7fuKRDk4z0ivO4xgSCHmX+cvNAqtY4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hskSGcx7dZnBAWWsGHvrt2R0SmYSIlQCUCB48XQJqm5P4Y6VLLhw/V+USNY3HUQH5
	 ZzFKBE46zklceHmDD4DaysYt7XOO0QzATd87VBBb76GhcFSE1Dw1GBmUb2VDJ+H5mG
	 yOJouVEIMz5J9yTAWSmRmLQoTajL2rJoxhHuSIAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 315/398] watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog
Date: Wed, 23 Sep 2026 16:06:29 +0200
Message-ID: <20260923140651.586966865@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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


