Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B9A1E480;
	Tue, 26 Aug 2025 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215802; cv=none; b=SVXCH+SmPKn7eC+n/PVgxZkfRarprGGTnQW9jCnMx3BXdnKCRqXmogSKrs96WEAPPI/bySu02e9pdLP0HbvfhGMmtvGpecsoFl/lnAu1MAN0aYeHhoRYYmGQAi9C6KjZKBhFNO3jtgfM0/Eer56ciFfvx09vVdtiynTxx6jDowI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215802; c=relaxed/simple;
	bh=E4F94PlqugWNCiigEGLJSutgBh3NAiJuyy6yjGyQwZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMdRQDDrZk8+rsr6zdu11Yd+kmoW9/5Oo4d6nFxNqsaPWEsylGhwRZkBNiRnXlI5uNF4cpox+ksL890Q9SmAbs21WHqz3KzTH3S0yxnRpPmnve+6EOULvvHpfuFc9H4WgtPQ6U0BSuMMindvco9ZVyB8xqEzW9pi0vPXTn2KBko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+oLyAfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+oLyAfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14080C4CEF1;
	Tue, 26 Aug 2025 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215802;
	bh=E4F94PlqugWNCiigEGLJSutgBh3NAiJuyy6yjGyQwZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+oLyAfKiQ1qhvSsCnZildTlzlcCIiN3034ahxVSSRgDykn4O7Iy9KUpnsvuSnMyb
	 GFrIIUUlzCLhE2RprC3IofPP/jmtTd200QNTet30raa63oYc0U4UQjnYEbVdIhGYG3
	 Vy1PTjTUydYHG+QhKqhWeEof3FXu/Km2BBAKeUkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/644] power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set
Date: Tue, 26 Aug 2025 13:04:23 +0200
Message-ID: <20250826110950.735984745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 2937f5d2e24eefef8cb126244caec7fe3307f724 ]

When the kernel is not configured  CONFIG_OF, the max14577_charger_dt_init
function returns NULL. Fix the max14577_charger_probe functionby returning
-ENODATA instead of potentially passing a NULL pointer to PTR_ERR.

This fixes the below smatch warning:
max14577_charger_probe() warn: passing zero to 'PTR_ERR'

Fixes: e30110e9c96f ("charger: max14577: Configure battery-dependent settings from DTS and sysfs")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250519061601.8755-1-hanchunchao@inspur.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max14577_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/max14577_charger.c b/drivers/power/supply/max14577_charger.c
index f244cd902eb9..e4461caecea3 100644
--- a/drivers/power/supply/max14577_charger.c
+++ b/drivers/power/supply/max14577_charger.c
@@ -501,7 +501,7 @@ static struct max14577_charger_platform_data *max14577_charger_dt_init(
 static struct max14577_charger_platform_data *max14577_charger_dt_init(
 		struct platform_device *pdev)
 {
-	return NULL;
+	return ERR_PTR(-ENODATA);
 }
 #endif /* CONFIG_OF */
 
@@ -572,7 +572,7 @@ static int max14577_charger_probe(struct platform_device *pdev)
 	chg->max14577 = max14577;
 
 	chg->pdata = max14577_charger_dt_init(pdev);
-	if (IS_ERR_OR_NULL(chg->pdata))
+	if (IS_ERR(chg->pdata))
 		return PTR_ERR(chg->pdata);
 
 	ret = max14577_charger_reg_init(chg);
-- 
2.39.5



