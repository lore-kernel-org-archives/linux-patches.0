Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED340BA51
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D5AC4339E;
	Thu, 13 Apr 2023 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681425516;
	bh=Riwglc43l4f0bQiMlyIBog53NVU6UB5IMNh6rCQlKeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prQzSi6ipArSlSdvcYVNPRKaicI220MjMHQx5fTrtv22/VLWFypqD52LU3ieWCddT
	 X9aaRS3qeAXd7nuI97DL9Rp5kD+Y4fF7/BUhJw6hQLIpnIZdfY7GXDQ0yCDz4A9vFF
	 nUvG9coNsPE6nYXydRBXy8H8IK8hiuXQga+fqQEqQHyLKw5djHl75wm7wK6Avv7E57
	 dwpDsJs09Lpr1nLW7BssgDITCmG2tbHE6HaiqN0aXzBw4i9wRW7G8CFD20kFnjYO4E
	 GX6sZ7plP038awaeI4JY1QRtL/T9IOaP4ld2k3pDfM5sHQcDeGdkhNuHaHWZ3eM1So
	 vHp/lwQHjXIZQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 3/6] spmi: pmic-arb: Convert to platform remove callback returning void
Date: Thu, 13 Apr 2023 15:38:31 -0700
Message-ID: <20230413223834.4084793-4-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230413223834.4084793-1-sboyd@kernel.org>
References: <20230413223834.4084793-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230306073446.2194048-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 8b6a42ab816f..42a593418aad 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1674,7 +1674,7 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int spmi_pmic_arb_remove(struct platform_device *pdev)
+static void spmi_pmic_arb_remove(struct platform_device *pdev)
 {
 	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
 	struct spmi_pmic_arb *pmic_arb = spmi_controller_get_drvdata(ctrl);
@@ -1682,7 +1682,6 @@ static int spmi_pmic_arb_remove(struct platform_device *pdev)
 	irq_set_chained_handler_and_data(pmic_arb->irq, NULL, NULL);
 	irq_domain_remove(pmic_arb->domain);
 	spmi_controller_put(ctrl);
-	return 0;
 }
 
 static const struct of_device_id spmi_pmic_arb_match_table[] = {
@@ -1693,7 +1692,7 @@ MODULE_DEVICE_TABLE(of, spmi_pmic_arb_match_table);
 
 static struct platform_driver spmi_pmic_arb_driver = {
 	.probe		= spmi_pmic_arb_probe,
-	.remove		= spmi_pmic_arb_remove,
+	.remove_new	= spmi_pmic_arb_remove,
 	.driver		= {
 		.name	= "spmi_pmic_arb",
 		.of_match_table = spmi_pmic_arb_match_table,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

