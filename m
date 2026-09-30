Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44A13DDAFC;
	Wed, 30 Sep 2026 19:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796427; cv=none; b=El2nPbkjLQ1MSnnrR2IqP3QDbPdpOKwo4L8FyPZHqCzVhAoDNIEVl80b2+ehJa7Y2vTFKiT4fkDC+xRyPr18f6KS0q0sKGgdTvECEx8tA5Wm/rdgSbZcvi85egWQCRCjsi0G+znbr9v5oWqPY2jgCNe2lec9YuizSzaJATdVWag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796427; c=relaxed/simple;
	bh=tsRG80Slc1C2GOWD1gGZWJKwoL5BtJ3sjleWRTjLohs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nNXrgXSm/j+u9HRjNBZ7MC9+PA0ZyjawGAoWjPU8dCZrd5cSRA69xneXX3bqffaqz/4TEDZ/SXsUgZc40zXholKQSxG87Nq8S1lRHtJ5BH6R2LtaRjWPzi76MyPqQiuFip5NHiKWvyDilCcsBsQn2X5UBk3pgSCMr41ahEhNhUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEbLkyko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEbLkyko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCEB1F0089B;
	Wed, 30 Sep 2026 19:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796425;
	bh=Y7BHFZmAIsjCIXhiSxIPP2nh5zQBHENPQlBuRlW1E6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEbLkykoPJD5KitRkCBY/iIzwPkphXooCzJHWXh4fdG9lggvCXf3vKgCeOd3Lj5qc
	 PUE1QY+nS/u0KNBp+fYzXC8vPFxpzIp0RZRU/jrLeW/kQEt1kppHyi3kDLpOFcxUDD
	 h2Fg9Ukklh4qLJeUZISPYl3HfZImtYn6sUmfE1xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0910/1193] watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog
Date: Wed, 30 Sep 2026 17:26:34 +0200
Message-ID: <20260930152454.458845677@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -271,7 +271,7 @@ static int __maybe_unused da9063_wdt_sus
 	if (!use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_stop(wdd);
 
 	return 0;
@@ -284,7 +284,7 @@ static int __maybe_unused da9063_wdt_res
 	if (!use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9063_wdt_start(wdd);
 
 	return 0;


