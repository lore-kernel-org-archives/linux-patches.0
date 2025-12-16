Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D051F354AF7;
	Tue, 16 Dec 2025 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885810; cv=none; b=o+hSuFLc1ovzp56E8b0mDy3wSGETs6ltFHTfjMxLcxP56Z7KLjVcA9aoN0dxWEpQCYk3LvCSlpDAe/2oeznq9BaYPlJ7RjwSYKOB0Qdxi5t+g3ojX2c9EszDwSDUzlilvchAqaJMPalocqXteDmaUgIloLUkL6AW2w6nnwjEZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885810; c=relaxed/simple;
	bh=+7IhLtaLbvMH58cudiz4LzxJp9VI9qT3lfjn83pmges=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJ/oU/XYpydeJuamK+5HwHmuaboMJdgj+DPyKqIh9JPzPVpiEmKKc9/5e3a2yovl+lZ+uCYg+nyTlcjp5EY7AxTelw1dIlQbHHhghkb9cfkSebBmYlr9K6mrVExZjHXaoWLLbBfUpeyc1i+SSVAp7GK+/Iz+WALE7lXQtTIuOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/kvCURq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/kvCURq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B43C4CEF1;
	Tue, 16 Dec 2025 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885810;
	bh=+7IhLtaLbvMH58cudiz4LzxJp9VI9qT3lfjn83pmges=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/kvCURqJGBirsfXbde45TdYDhLOVxc6q8rF4QPhKzrzFqhBqNGTS8Ere/NQyF2Zz
	 G1Dz83scD9uqxBDFLIITP7kcC+eRC5E32IeaF3PmzSHK8OXvijHK/6btRL6Xs8ss2m
	 RIyW/8mPUbDpgL3slF42CRIVrQZejPD52D8j+A74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 252/507] watchdog: starfive: Fix resource leak in probe error path
Date: Tue, 16 Dec 2025 12:11:33 +0100
Message-ID: <20251216111354.622027586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 355918d62f63d..ed71d3960a0f2 100644
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



