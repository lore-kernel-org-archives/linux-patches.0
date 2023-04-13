Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696FBBA4E
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F8BC433D2;
	Thu, 13 Apr 2023 22:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681425516;
	bh=TB9f6dRHMA0rIjXItrHT/Bu0YIp1W1oxyGnuQSn4ftY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoJMnSoi1IRiWJ/EmUcgYHLLsrDtndDcwiSaZ7PqubVIqPYDJeBgak6Vr0p/vsX+a
	 ugSBDf3/HaV4KDmICVLWiobs1YEjQIL/akKqBzp59GRZtEehxhlphZRBZTjTyjKiN/
	 Uj7nBcbd8hEtRRCLWw9tj1Xe+7i9M/N1YPtxR6JlcCPC/LxkEche+uc7DWjg+Kf16L
	 5G8quJDkxyB27nFycmk0SnIBrdfntZRndgvsCcduLtuDZW53M4OKqrrH/+nj13J0bP
	 vAjcUApHsa/i9KWAs8Rc7bQtAEGMhwEA2CgUxky5eFmCaYFi4ObqWVB2l9bm2ZRME6
	 ilTilQmVmztzQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/6] spmi: hisi-spmi-controller: Convert to platform remove callback returning void
Date: Thu, 13 Apr 2023 15:38:29 -0700
Message-ID: <20230413223834.4084793-2-sboyd@kernel.org>
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
Link: https://lore.kernel.org/r/20230306073446.2194048-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/hisi-spmi-controller.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spmi/hisi-spmi-controller.c b/drivers/spmi/hisi-spmi-controller.c
index 5bd23262abd6..9cbd473487cb 100644
--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -324,13 +324,12 @@ static int spmi_controller_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int spmi_del_controller(struct platform_device *pdev)
+static void spmi_del_controller(struct platform_device *pdev)
 {
 	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
 
 	spmi_controller_remove(ctrl);
 	spmi_controller_put(ctrl);
-	return 0;
 }
 
 static const struct of_device_id spmi_controller_match_table[] = {
@@ -343,7 +342,7 @@ MODULE_DEVICE_TABLE(of, spmi_controller_match_table);
 
 static struct platform_driver spmi_controller_driver = {
 	.probe		= spmi_controller_probe,
-	.remove		= spmi_del_controller,
+	.remove_new	= spmi_del_controller,
 	.driver		= {
 		.name	= "hisi_spmi_controller",
 		.of_match_table = spmi_controller_match_table,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

