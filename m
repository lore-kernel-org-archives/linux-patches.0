Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430E1427B;
	Tue, 23 Jan 2024 02:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975359; cv=none; b=N4QSDamrO5vWIADCdI74fEZI3VfWOsdzVQgboFhrXyp1J+WXbRa5+SJ+GhmwwsQXsS46w2An4eSMqqj1E5h37OqA80RVOJoKvknDR4yK2LXqmnKwWlB8I8OhLBUdiKnc14OheEsSTw8mW17fqL/udWSQUCX8luL4o3BqoMN6F5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975359; c=relaxed/simple;
	bh=qI9R8FjIaVSby/Gi+N8DeHYiSOfy/AUP3nparIrROS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRcLELQSHXPnYdM+QhJWbTT6iOosdpg7WVvgEeog3Vh+Hv9mMM8CN5AgHA/URC5L/q6XrVszfIoO2XQXYtpbqw8mlIP3hdyNkKkhXMlOjF6i19IO23riXPX4QoQtR7iuTnIlG+AjtelC6QHCo+wq0dP5vAFU3U3oqFt1fQoP7FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qs29Niqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs29Niqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C12C43399;
	Tue, 23 Jan 2024 02:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975358;
	bh=qI9R8FjIaVSby/Gi+N8DeHYiSOfy/AUP3nparIrROS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qs29NiqfmsJd4sRI2mAvtQVPKnPhWQHDWdQ0NbzolRxLcM4LaWbRoHRZg5XBx8brt
	 MIHipWCdjiIYLuO1HOly8qg1XciHAM7z2KCcvybUpESapwWYuptFucqkQhEfZA2bpa
	 MYrzgQ2kA9s2/EiCIbSw9O/h2ByZqcXv5onro6BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/583] watchdog: rti_wdt: Drop runtime pm reference count when watchdog is unused
Date: Mon, 22 Jan 2024 15:55:54 -0800
Message-ID: <20240122235821.295133377@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit c1a6edf3b541e44e78f10bc6024df779715723f1 ]

Call runtime_pm_put*() if watchdog is not already started during probe and re
enable it in watchdog start as required.

On K3 SoCs, watchdogs and their corresponding CPUs are under same
power-domain, so if the reference count of unused watchdogs aren't
dropped, it will lead to CPU hotplug failures as Device Management
firmware won't allow to turn off the power-domain due to dangling
reference count.

Fixes: 2d63908bdbfb ("watchdog: Add K3 RTI watchdog support")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Tested-by: Manorit Chawdhry <m-chawdhry@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20231213140110.938129-1-vigneshr@ti.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index 8e1be7ba0103..9215793a1c81 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -77,6 +77,11 @@ static int rti_wdt_start(struct watchdog_device *wdd)
 {
 	u32 timer_margin;
 	struct rti_wdt_device *wdt = watchdog_get_drvdata(wdd);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(wdd->parent);
+	if (ret)
+		return ret;
 
 	/* set timeout period */
 	timer_margin = (u64)wdd->timeout * wdt->freq;
@@ -343,6 +348,9 @@ static int rti_wdt_probe(struct platform_device *pdev)
 	if (last_ping)
 		watchdog_set_last_hw_keepalive(wdd, last_ping);
 
+	if (!watchdog_hw_running(wdd))
+		pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 
 err_iomap:
@@ -357,7 +365,10 @@ static void rti_wdt_remove(struct platform_device *pdev)
 	struct rti_wdt_device *wdt = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&wdt->wdd);
-	pm_runtime_put(&pdev->dev);
+
+	if (!pm_runtime_suspended(&pdev->dev))
+		pm_runtime_put(&pdev->dev);
+
 	pm_runtime_disable(&pdev->dev);
 }
 
-- 
2.43.0



