Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6A436C9D1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302225; cv=none; b=ddEjGykz8lZmzBn7oJmD+eT7TUi4M7Bnhn/9Njvdao72Vprr4aLv4DW66YCmQ50psaDuNIzsxF4oLecJnfZXJgytr5enUmYG8b2Pqy60SzQ77lb6QPHUMuP09c9wxY/86+S2sMbQwD2X4xdezwYQGH67dQcEMmI+MWifn5X/xEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302225; c=relaxed/simple;
	bh=hSVKnxuX9a9FBLoWjuRZdQ5eR0P5X7yyvJpAqRwjL48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k85e+hikVYrWkO5LqJl+EIaQtyotD8kue6EShqKSIgBah1mgMrhSNHXmMIsYHCtmqjt4vsAtakJqoW9CdnhRSXbRNlyisE6Bf5YxWLp25Q/+CrPUNCDT032JmO0HDGBJWfCx+cA/Pfy4fEEfSmaftqG/qVy2w9hMK12ywu4Vg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W047BAw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W047BAw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A0BC19423;
	Sat, 28 Feb 2026 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302224;
	bh=hSVKnxuX9a9FBLoWjuRZdQ5eR0P5X7yyvJpAqRwjL48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W047BAw6zkgu0GembVYeSD95VanN8mqmEvgiSJqa5CVfHRXjtNwiV2JtOdzAkwSW/
	 JLGRaD0h+hjopqUVVNe87+eDp0g6sMFIlmdiqx2YcfO6RORiC0+XUw6slljJVLs2pM
	 M0yE5V6cIIjRmQX0PtZY4ZkyxMMa4+HxfneiHMxbtoeP4qRLD7eP2scqPFjG8r1Q1k
	 6jmns7U/W0pNVOVLOSBNWJY1LCKbPLxT7z8FfUJlmPEtP6jvmaeyUhPr/Smo8MewR4
	 Q7+uqZSM4uXX8LoXOoBdzaHKaih8jAVXiy4EF2+TeJEMdYn+lt/d2rlN3yx6S2IZSS
	 v/U1Lgt2dDC9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kery Qi <qikeyu2017@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/283] watchdog: starfive-wdt: Fix PM reference leak in probe error path
Date: Sat, 28 Feb 2026 13:06:15 -0500
Message-ID: <20260228180709.1583486-233-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 0606142ffc5e2..3842a0b1b6cb8 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -444,7 +444,7 @@ static int starfive_wdt_probe(struct platform_device *pdev)
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

