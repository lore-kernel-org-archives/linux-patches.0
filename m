Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B33579C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEFEC4314A;
	Wed, 30 Nov 2022 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833333;
	bh=8c6cGaX6SK4swEO8QA4slEwcwCBgNLv76k5WAZaDzyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+NPRQ/+wXB8DmoGPZR9tFlU1xwAXSMYTplaogiu2qWE7VehlSv0hl/Lj6i49RcBV
	 89H5saLOAi5/R9o94pODTJ16+x7esKg+YmarQlGWVkWhuDJka0iGv/X1qnjb2gFmHv
	 5po92xyKTsTPrGgaBn96E4CnXX7ZkHcW/rAvnEG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/206] bus: sunxi-rsb: Remove the shutdown callback
Date: Wed, 30 Nov 2022 19:22:00 +0100
Message-Id: <20221130180534.729476032@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 5f4696ddca4b8a0bbbc36bd46829f97aab5a4552 ]

Shutting down the RSB controller prevents communicating with a PMIC
inside pm_power_off(), since that gets called after device_shutdown(),
so it breaks system poweroff on some boards.

Reported-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Fixes: 843107498f91 ("bus: sunxi-rsb: Implement suspend/resume/shutdown callbacks")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20221114015749.28490-2-samuel@sholland.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 60b082fe2ed0..9c209492b267 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -816,14 +816,6 @@ static int sunxi_rsb_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void sunxi_rsb_shutdown(struct platform_device *pdev)
-{
-	struct sunxi_rsb *rsb = platform_get_drvdata(pdev);
-
-	pm_runtime_disable(&pdev->dev);
-	sunxi_rsb_hw_exit(rsb);
-}
-
 static const struct dev_pm_ops sunxi_rsb_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(sunxi_rsb_runtime_suspend,
 			   sunxi_rsb_runtime_resume, NULL)
@@ -839,7 +831,6 @@ MODULE_DEVICE_TABLE(of, sunxi_rsb_of_match_table);
 static struct platform_driver sunxi_rsb_driver = {
 	.probe = sunxi_rsb_probe,
 	.remove	= sunxi_rsb_remove,
-	.shutdown = sunxi_rsb_shutdown,
 	.driver	= {
 		.name = RSB_CTRL_NAME,
 		.of_match_table = sunxi_rsb_of_match_table,
-- 
2.35.1



