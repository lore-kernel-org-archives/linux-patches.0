Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB33517A2F6;
	Tue, 21 Jul 2026 19:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661495; cv=none; b=gKjY0We+LkU8x1wwd3z1uDJCl8JOeJGqGat/aC8fLZ1TjJpLQ1Zg0p/gb358uGGNcVpVlp+An2kUNTjPLreohSQjJ/6x4mMao3rpkbucfv9ynpDtjjnwoB0tHxLrcNPErwowhYhFh0qluZIFgjwFqifIQsxe+sqB2zv+XIS3bNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661495; c=relaxed/simple;
	bh=HlTs5PnU+6B87eQ7v0L/FHp8NrlUS99gWxd1I5gEz6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7a2BhF/L/T6Un38415pjOgEuySncPWCaTzTfvTMA8hGZg5H2W/oWWZcE4f3omzZwf4jW1AC6yGBbpFL5S+R8Srsc82HJsM5fo9c60hK14OlqJ/lEy4iMetDhMalUFExhncCP3ezJY8PEIYi7wFkRStaCExzihDWnSGkDUnOvR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZSxSJxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZSxSJxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C431F000E9;
	Tue, 21 Jul 2026 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661494;
	bh=1DY/PNeli4GyhShUObLkajwCWKDUiIzLbDEShD8G/9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZSxSJxR0dY6sqvDCcL5vkKH5fJPtUXjc098XSc9OsEJJiQBgi//fDLewKed3gy5P
	 2pjhptjg//UrcfilK5lafzrhz7T0vXXCDdKRF4ue76crVlEJ8IrysZYxpLAl1VYUBO
	 pLfnqWQfSitB46Up2NH8CQAqDDXWjUaIRfa0406A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0086/1276] watchdog: sprd_wdt: Remove redundant sprd_wdt_disable() on register failure
Date: Tue, 21 Jul 2026 17:08:49 +0200
Message-ID: <20260721152448.018941488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 96b3cfc3b8ad0524d12fed1e08bc5df3ff345f64 ]

The driver uses devm_add_action_or_reset() to register sprd_wdt_disable()
as a managed cleanup action.

When devm_watchdog_register_device() fails, the devm core will invoke
the cleanup action automatically.

The explicit sprd_wdt_disable() call in the error path is therefore
redundant and results in adouble cleanup.

Fixes: 78d9bfad2e89 ("watchdog: sprd_wdt: Convert to use device managed functions and other improvements")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260223-sprd_wdt-v1-1-2e71f9a76ecb@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sprd_wdt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/sprd_wdt.c b/drivers/watchdog/sprd_wdt.c
index 4e689b6ff1418c..aacf04616fefe2 100644
--- a/drivers/watchdog/sprd_wdt.c
+++ b/drivers/watchdog/sprd_wdt.c
@@ -320,10 +320,9 @@ static int sprd_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(&wdt->wdd, 0, dev);
 
 	ret = devm_watchdog_register_device(dev, &wdt->wdd);
-	if (ret) {
-		sprd_wdt_disable(wdt);
+	if (ret)
 		return ret;
-	}
+
 	platform_set_drvdata(pdev, wdt);
 
 	return 0;
-- 
2.53.0



