Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84DD27CCF0;
	Tue, 27 May 2025 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368209; cv=none; b=H7r/1NX0eyZ1scz/5IcL4cj80QjZA1YYjy5Nb/cwOdq97lujOV0gmK8+QxfY+rzf7MMXf+ionbIwk+KVeqif8v32lpmgoQinyqGVJqxpj4Aj1E6wCoTMsQChjue2PO0d92lIOW/pdBPtgd3G60QYgFZtNR50TuafAW844ETsaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368209; c=relaxed/simple;
	bh=sdkJ9xApZ8q/nAzzoyxuxQpUVh4JyTof264j2rboJFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyHmN3N0W+K75TA+5AwA3KNtjqIWqVvAONrYSQyk57wQQGf+sSQjfg90X2idTgccqWA0mIWeM2KJqLCz+RWjcW/azGZbbnqBedPBJBm2cDywCHsioCImABmL1V1C1IVdxQ3A3J3wOGVKdHe/o7WawtNpnuzSegYxYad0RJHhiqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC6E5dkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC6E5dkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375EEC4CEE9;
	Tue, 27 May 2025 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368209;
	bh=sdkJ9xApZ8q/nAzzoyxuxQpUVh4JyTof264j2rboJFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC6E5dknsO4YJvV3zj0ytM4MR647s8/wTdvBGaFqUFT7bZd9zdJMHFDOZ/qNqnFb/
	 CSxrRFkwNBa1HzPYUayoBKLDxwpSqDWQli2pDl4aDrKpk7CyP4hvgyudB2lGz3OTM6
	 m61LZucyxkrbPTPrkCUIoRUlwIdbRmzZKcNGqesY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 633/783] watchdog: aspeed: fix 64-bit division
Date: Tue, 27 May 2025 18:27:10 +0200
Message-ID: <20250527162538.926213389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 48a136639ec233614a61653e19f559977d5da2b5 ]

On 32-bit architectures, the new calculation causes a build failure:

ld.lld-21: error: undefined symbol: __aeabi_uldivmod

Since neither value is ever larger than a register, cast both
sides into a uintptr_t.

Fixes: 5c03f9f4d362 ("watchdog: aspeed: Update bootstatus handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250314160248.502324-1-arnd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/aspeed_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/aspeed_wdt.c b/drivers/watchdog/aspeed_wdt.c
index 369635b38ca0e..837e15701c0e2 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -254,7 +254,7 @@ static void aspeed_wdt_update_bootstatus(struct platform_device *pdev,
 
 	if (!of_device_is_compatible(pdev->dev.of_node, "aspeed,ast2400-wdt")) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		idx = ((intptr_t)wdt->base & 0x00000fff) / resource_size(res);
+		idx = ((intptr_t)wdt->base & 0x00000fff) / (uintptr_t)resource_size(res);
 	}
 
 	scu_base = syscon_regmap_lookup_by_compatible(scu.compatible);
-- 
2.39.5



