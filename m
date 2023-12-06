Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495682DF9A
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 23:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtlXVGsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DC0C433CD;
	Wed,  6 Dec 2023 23:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701904656;
	bh=6JfBdb+tpPHhDepnCfkjAjsjvnC4Fs4rfNHqqamKfJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtlXVGsXz2TXYLBoQPOAOPi787gCgqWL0dRemgzUi9stC6047e0TTgEULxWGYZ7f0
	 iaiqNBG6FrMll4RjwFeMNXFdUTGAnToZWWVgrPXsF9yxR4n2Sp9sOAGD+aFo9hrHHc
	 cu+HbZQvyeOA0YfIZDgHO1kqdXGKTucbZW4CA5X2qKNvC5sEM/lYeJR5rzIuB9l4Aq
	 PiZkf9wm+IHPtUxkjlqgzLFiqykvibjO2aRGqavaMr5PmTnKR/p4BqE09aEXUj04DC
	 WvdjFe05QBGozxmRaGgdFq0Kucz0ciJD6x7X3Q6QVMerITsNgRlpiJ+6yLDkmHwmWK
	 i6HfCK2B3bwvg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fei Shao <fshao@chromium.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 6/8] spmi: hisi-spmi-controller: Use devm_spmi_controller_add()
Date: Wed,  6 Dec 2023 15:17:29 -0800
Message-ID: <20231206231733.4031901-7-sboyd@kernel.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
In-Reply-To: <20231206231733.4031901-1-sboyd@kernel.org>
References: <20231206231733.4031901-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fei Shao <fshao@chromium.org>

Convert to the device-managed version of spmi_controller_add() and
delete the unnecessary driver remove callback.

Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20230824104101.4083400-5-fshao@chromium.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/hisi-spmi-controller.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/spmi/hisi-spmi-controller.c b/drivers/spmi/hisi-spmi-controller.c
index a5525902656a..674a350cc676 100644
--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -308,7 +308,7 @@ static int spmi_controller_probe(struct platform_device *pdev)
 	ctrl->read_cmd = spmi_read_cmd;
 	ctrl->write_cmd = spmi_write_cmd;
 
-	ret = spmi_controller_add(ctrl);
+	ret = devm_spmi_controller_add(&pdev->dev, ctrl);
 	if (ret) {
 		dev_err(&pdev->dev, "spmi_controller_add failed with error %d!\n", ret);
 		return ret;
@@ -317,13 +317,6 @@ static int spmi_controller_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void spmi_del_controller(struct platform_device *pdev)
-{
-	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
-
-	spmi_controller_remove(ctrl);
-}
-
 static const struct of_device_id spmi_controller_match_table[] = {
 	{
 		.compatible = "hisilicon,kirin970-spmi-controller",
@@ -334,7 +327,6 @@ MODULE_DEVICE_TABLE(of, spmi_controller_match_table);
 
 static struct platform_driver spmi_controller_driver = {
 	.probe		= spmi_controller_probe,
-	.remove_new	= spmi_del_controller,
 	.driver		= {
 		.name	= "hisi_spmi_controller",
 		.of_match_table = spmi_controller_match_table,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

