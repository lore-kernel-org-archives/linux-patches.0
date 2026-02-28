Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0058379EFA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301902; cv=none; b=jgW4ytzOFl/y00yMKlZf6ycoMQ6Ctv3ESwsnDFkUZnx1AV35e2LONPCEr7M537y4SJXPkbcsWSFdaQTdpiFsNV3Mmqp0u7hVMOX9TPFhdn6kkX06dUlEjeMoq9HjaHYMzHFgT+ynyZeG8lO5wLphFIVvgg7arICuK2OWz3d+9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301902; c=relaxed/simple;
	bh=UtuYo4GDHQOyKqq+ubCUWqFEWnvi5pW3lyvXM9rSgPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4u4Y5VLJlnZC7ib9y0bksgw22aSuNJ71ENRR3PcyyAKOsR5PG+b0WMBuRXXXhCRF0xiaxvyD2QqUNeUzsfoKSSW1PMMAlVJN7WtNObDBqiTwN0XJS3XXpO4MMU2ofaDaAn8eOVDaxETrrrSz3T/g2BjzlyXKjUZtoiJYgaj730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAx5mH65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAx5mH65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF23C19425;
	Sat, 28 Feb 2026 18:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301902;
	bh=UtuYo4GDHQOyKqq+ubCUWqFEWnvi5pW3lyvXM9rSgPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAx5mH65Gfdmo+0qTu32KUEBIShWjm5H3HW3MSX69h3LhlvTRDttVzFyC6jip5ud1
	 Uvmg7w4nf8y9RmsSrGdntJt4+UmNgcrbRMMXjAfDaD3J8mS1/1Yln5jsQyodD/XaIG
	 1PcHz/IJtYn6cdr0rLHBnk3ce3X+Z4HExON+z9oiE5OW5FeE/dR2bqfl431GUNlAyR
	 jtlfpUsIoU4p0HhQS22Juk1JDn+8L2iOZoRLCV6Wf5WQ0fEURXbrdRnLNizLRva9DK
	 UM/N5Pg8ouwhTmy2EBOD8a2QsCFAk/cK6WSvb/fWelGOotj4y98P0sc0w5tGyrneca
	 mNeOD85emd/pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kery Qi <qikeyu2017@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/385] watchdog: starfive-wdt: Fix PM reference leak in probe error path
Date: Sat, 28 Feb 2026 12:59:14 -0500
Message-ID: <20260228180011.1568201-332-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 3f2d8d79cceb05a8b8dd200fa81c0dffc59ec46f ]

The PM reference count is not expected to be incremented on return in
functions starfive_wdt_probe.

However, pm_runtime_get_sync will increment pm usage counter
even failed. Forgetting to putting operation will result in a
reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: db728ea9c7be ("drivers: watchdog: Add StarFive Watchdog driver")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/starfive-wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/starfive-wdt.c b/drivers/watchdog/starfive-wdt.c
index 763b11b6f402c..8244f282bee86 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -446,7 +446,7 @@ static int starfive_wdt_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, wdt);
 	pm_runtime_enable(&pdev->dev);
 	if (pm_runtime_enabled(&pdev->dev)) {
-		ret = pm_runtime_get_sync(&pdev->dev);
+		ret = pm_runtime_resume_and_get(&pdev->dev);
 		if (ret < 0)
 			return ret;
 	} else {
-- 
2.51.0

