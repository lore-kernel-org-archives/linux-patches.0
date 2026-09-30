Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7498C511E8F;
	Wed, 30 Sep 2026 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786133; cv=none; b=jXH3DZ2KxXmRq7SBIJYUqF87f55lOzvGeCyDQtSoP78WQYVI11MJQGoIua9+uvN9Hqd1N+6ZsYxC5m5/JCU4Md0djlHLcJdaCwA/ytQmDZgzLFGMUBuALToHIMBYwIDv14sUP4s5MEhl1ZYq6vf2vxK4PV5kxpIg/v+kytpmcsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786133; c=relaxed/simple;
	bh=+kcziqFZ9YDq6trylgbEcMIz1ZFHd9zQ9xNTn2mKZOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7vPv9RFTPLqPjedDM4+x34rF5IAXIT+gVhZ2j+1CT7qIWiC9VSSIoWxUPpYoYMJgqvNjiKby5c5oxIR2R1x7iyLbvtvG9aJ0eaxJYBKs3OML99a4aLztKNvMe5bC9wUTVo2vRpwGHE05YoLSdlSZfHnGS1yyFhR2prYuXckVmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV6qvxcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV6qvxcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4381F000FF;
	Wed, 30 Sep 2026 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786132;
	bh=ywdawMZeX5sx7q/VglTTUFbR6pezf3VkJefubFE9MmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gV6qvxcf2eVXui+VvWAZOlajSJRxPN6MsyFeQY0CDb7lKqLNFFDxyt++XtKNMf1FX
	 Lp7pjtfO0uwYkTR3pnKC3iTRqPQ1tsnPytGoL39EBrexZP1ngDf1Hrzys6v8Yfr9YS
	 DqiQ6/CedAYUJgN8CZvIiO2ViSCpN/+mkfB4x0dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 754/982] watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog
Date: Wed, 30 Sep 2026 17:24:50 +0200
Message-ID: <20260930152432.948778293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,7 +262,7 @@ static int __maybe_unused da9063_wdt_sus
 	if (!use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_stop(wdd);
 
 	return 0;
@@ -275,7 +275,7 @@ static int __maybe_unused da9063_wdt_res
 	if (!use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_start(wdd);
 
 	return 0;


