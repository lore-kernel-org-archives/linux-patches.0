Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD532BA4F
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404F8C4339C;
	Thu, 13 Apr 2023 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681425516;
	bh=1ut5ph7e7MTXUwUNQA6pS+bDTFfCrhkn8nTjBsvJ2ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuoWqeeI/4fHwhbcFRfE3XXX4wRw3ynb3QYEVORZyifc7y5EjVS7aGK0vth4n7Kbs
	 jCRl3llEpbF56D80gAeaUKJqY8e8FtoU1zpK+ojPn7tqFkJuv0g0KRVCgy8bY8brqt
	 IwJX6HeEBeW6D1nj55ybN+6Wvgl/e9WkkXilY4KDJIl51bsKNTeCPf7lkPibaGa6X6
	 C/gdjRENXOpQUtNOYQAIdqQxANYr3J6OvyhlDB7k79qbjO2qyizSMQuGKZyUn88dzj
	 bGZJnH94/H/HPtpNd6+KHFgzohUlyNmnc3m/Em6nyf58Hk6itMM9eEVxr2aHm/+khj
	 Mx0N/QM6Xj+CQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 2/6] spmi: mtk-pmif: Convert to platform remove callback returning void
Date: Thu, 13 Apr 2023 15:38:30 -0700
Message-ID: <20230413223834.4084793-3-sboyd@kernel.org>
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
Link: https://lore.kernel.org/r/20230306073446.2194048-3-u.kleine-koenig@pengutronix.de
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index ad511f2c3324..fbcb3921e70c 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -503,7 +503,7 @@ static int mtk_spmi_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int mtk_spmi_remove(struct platform_device *pdev)
+static void mtk_spmi_remove(struct platform_device *pdev)
 {
 	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
 	struct pmif *arb = spmi_controller_get_drvdata(ctrl);
@@ -511,7 +511,6 @@ static int mtk_spmi_remove(struct platform_device *pdev)
 	clk_bulk_disable_unprepare(arb->nclks, arb->clks);
 	spmi_controller_remove(ctrl);
 	spmi_controller_put(ctrl);
-	return 0;
 }
 
 static const struct of_device_id mtk_spmi_match_table[] = {
@@ -533,7 +532,7 @@ static struct platform_driver mtk_spmi_driver = {
 		.of_match_table = of_match_ptr(mtk_spmi_match_table),
 	},
 	.probe		= mtk_spmi_probe,
-	.remove		= mtk_spmi_remove,
+	.remove_new	= mtk_spmi_remove,
 };
 module_platform_driver(mtk_spmi_driver);
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

