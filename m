Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9448C32BF22;
	Tue, 16 Dec 2025 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884359; cv=none; b=jpyG6qqjiZGd7FhI9flzkbQzn18inJlAFsqi6tCKyLHwIOCcLK0COcI3tzFyqLvGy6Z3IQ/Fwaj6UoobRyxX71setYRAU5L0soJfy8mpnoNClJkL/NxgmmcSFhdbCPG3goHWEyEmRkX9HxxdK70bLvvoLZmCjwwZSGSgNYu8pyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884359; c=relaxed/simple;
	bh=TO2Pbgrx3vIWYr5u9aowCGB+9F/f5s5baN5jtmpChOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV9N5ba+RR7hxlJb5G/myDT8u1iAFDi3w9mwupP2XpOqAeQyz1xoOwrW0qdM6nFe73d1CrBfeAEn+Pemc40vPeCf4/OivKcwbdwfxQO5K4etxtwSrLTLrjf1aOZDk527IUc9fdyfZtwo0afmF//UyVZOPn2zqgZw+AJe1FPoUns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FNflvrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FNflvrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2E0C4CEF1;
	Tue, 16 Dec 2025 11:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884359;
	bh=TO2Pbgrx3vIWYr5u9aowCGB+9F/f5s5baN5jtmpChOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FNflvrc4otC062WKYB/ZDd3GrGf8xxhvzMtC9J0DylbXo09gPLSi3BHiy6qurFvs
	 oJZTQeSORUl0cfAm1trpyHcz2URaVxbDpkb5TAp7ImlsRJMPi++/ayvPx1ikySwVeZ
	 Z3ya+BnFIfSdcJddCf0mxyx0UXM21jZptmqDc4i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/354] watchdog: starfive: Fix resource leak in probe error path
Date: Tue, 16 Dec 2025 12:12:15 +0100
Message-ID: <20251216111326.999877929@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 5bcc5786a0cfa9249ccbe539833040a6285d0de3 ]

If pm_runtime_put_sync() fails after watchdog_register_device()
succeeds, the probe function jumps to err_exit without
unregistering the watchdog device. This leaves the watchdog
registered in the subsystem while the driver fails to load,
resulting in a resource leak.

Add a new error label err_unregister_wdt to properly unregister
the watchdog device.

Fixes: 8bc22a2f1bf0 ("watchdog: starfive: Check pm_runtime_enabled() before decrementing usage counter")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/starfive-wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/starfive-wdt.c b/drivers/watchdog/starfive-wdt.c
index 19a2620d3d389..763b11b6f402c 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -500,12 +500,14 @@ static int starfive_wdt_probe(struct platform_device *pdev)
 		if (pm_runtime_enabled(&pdev->dev)) {
 			ret = pm_runtime_put_sync(&pdev->dev);
 			if (ret)
-				goto err_exit;
+				goto err_unregister_wdt;
 		}
 	}
 
 	return 0;
 
+err_unregister_wdt:
+	watchdog_unregister_device(&wdt->wdd);
 err_exit:
 	starfive_wdt_disable_clock(wdt);
 	pm_runtime_disable(&pdev->dev);
-- 
2.51.0



