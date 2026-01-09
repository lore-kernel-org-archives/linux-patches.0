Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC30633D50F;
	Fri,  9 Jan 2026 11:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959751; cv=none; b=Z6NKMH7abfvnaT5K62aUb8sh4GQjQPSv91TbVCi7v/ZpmUs9BiRXpi7loGp/cwGQSVr/BKKc1JM3T65lOZm2lObXAx2k7QlobbYss6mZn/DMTjGHL9x+nFrp0GBMALhZKe4GoqotnbH9mIqD3s88kAIUnYF5Jq+e0tm6dF1fHAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959751; c=relaxed/simple;
	bh=cCpoHhWWvJ0WPuP7rZ8KhOdHw5wP/poofHSCQMgR+Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7Me2FMgHPkq0QuJXwzHjRoHqaBXkExwHw600QC/1EvU8tqXMigs35R3CQOZQDqXd7tC3xwM1rbE9nRmzq8Fs6qPiMNbRfP/EF/DyluL8rtiibrPwaEDmE3E5MW665aQbz9GKNFx9HtUmXt1g5c7ChfXiEezATwKEqJr9CN1W9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkBBhhxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkBBhhxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEA1C4CEF1;
	Fri,  9 Jan 2026 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959751;
	bh=cCpoHhWWvJ0WPuP7rZ8KhOdHw5wP/poofHSCQMgR+Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkBBhhxbRH4INM6CZTT5o1qDxgYx43KomT+o1DIQvme3HihPLWlkp0pjCUEN+gJvu
	 F8xqJbpJYTacWreOck3FL7Cd2C55q1KAEQK8RUDu9yzK5xm0WEQc4YxwIFLaFO5J3s
	 EIHjiaOo77SRwnh2eQTfLpRKZ4kASuQt2AsDERd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/737] watchdog: starfive: Fix resource leak in probe error path
Date: Fri,  9 Jan 2026 12:35:01 +0100
Message-ID: <20260109112140.088198056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4b344db38030..0606142ffc5e2 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -498,12 +498,14 @@ static int starfive_wdt_probe(struct platform_device *pdev)
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



