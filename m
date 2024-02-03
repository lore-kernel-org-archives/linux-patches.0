Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36BA182DB;
	Sat,  3 Feb 2024 04:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933435; cv=none; b=WslynaHMaHMngfNigV6IH0cFBlzzysarzB7rOXd85a5YvWzBcCprWrBgct2hI+SKf4RVZdnvtKhYsjdIFD6FiP60EbNMuE2knGUIJSoxIfV4LN8r4j7HEMQZZzy0GvPecKwCC9TAhIYtUg8ilrkvbhL63sIQyJGzY/9EcC1eMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933435; c=relaxed/simple;
	bh=WlGpuWPvw1qNnG8U6iIgz+vZJpxayMon764Azjnhlg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeInNeUNLPpU0e0c0+3jICRw3GHvLXiwVz8O6u1kTuMtTqrkSaTJQ5cr0gwD+BYiaUF2JPbRfHRoDh80Krgq3TRaDRKMgLMINICQ8SVSq1FYCpBpjwMfZoJn1LQu5x5Vfr+9yq1rDaEhwnwUev/F3ppR3tKSV1q26tVteOrnHdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhxAouPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhxAouPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5C2C433B2;
	Sat,  3 Feb 2024 04:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933435;
	bh=WlGpuWPvw1qNnG8U6iIgz+vZJpxayMon764Azjnhlg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhxAouPuFZR4JEQaodnx1CpI+K/BKOx/3KTPLFddKPd1DLMX2t4eRuN/lF2fJ9C0y
	 AoH+ZXpHk495Cco/i4nqzQs6hA4dchcHfLolk2pPUfLCGSImZpdWiL9/urDQfwQkj/
	 C3Z2bhckyJJ7CvFQm979bQkGfYTcsKo8s15tbegQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Yu-Che Cheng <giver@chromium.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/219] spmi: mediatek: Fix UAF on device remove
Date: Fri,  2 Feb 2024 20:05:38 -0800
Message-ID: <20240203035339.691413103@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Che Cheng <giver@chromium.org>

[ Upstream commit e821d50ab5b956ed0effa49faaf29912fd4106d9 ]

The pmif driver data that contains the clocks is allocated along with
spmi_controller.
On device remove, spmi_controller will be freed first, and then devres
, including the clocks, will be cleanup.
This leads to UAF because putting the clocks will access the clocks in
the pmif driver data, which is already freed along with spmi_controller.

This can be reproduced by enabling DEBUG_TEST_DRIVER_REMOVE and
building the kernel with KASAN.

Fix the UAF issue by using unmanaged clk_bulk_get() and putting the
clocks before freeing spmi_controller.

Reported-by: Fei Shao <fshao@chromium.org>
Signed-off-by: Yu-Che Cheng <giver@chromium.org>
Link: https://lore.kernel.org/r/20230717173934.1.If004a6e055a189c7f2d0724fa814422c26789839@changeid
Tested-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20231206231733.4031901-3-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index 01e8851e639d..bf8c0d4109b1 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -475,7 +475,7 @@ static int mtk_spmi_probe(struct platform_device *pdev)
 	for (i = 0; i < arb->nclks; i++)
 		arb->clks[i].id = pmif_clock_names[i];
 
-	err = devm_clk_bulk_get(&pdev->dev, arb->nclks, arb->clks);
+	err = clk_bulk_get(&pdev->dev, arb->nclks, arb->clks);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to get clocks: %d\n", err);
 		goto err_put_ctrl;
@@ -484,7 +484,7 @@ static int mtk_spmi_probe(struct platform_device *pdev)
 	err = clk_bulk_prepare_enable(arb->nclks, arb->clks);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable clocks: %d\n", err);
-		goto err_put_ctrl;
+		goto err_put_clks;
 	}
 
 	ctrl->cmd = pmif_arb_cmd;
@@ -510,6 +510,8 @@ static int mtk_spmi_probe(struct platform_device *pdev)
 
 err_domain_remove:
 	clk_bulk_disable_unprepare(arb->nclks, arb->clks);
+err_put_clks:
+	clk_bulk_put(arb->nclks, arb->clks);
 err_put_ctrl:
 	spmi_controller_put(ctrl);
 	return err;
@@ -521,6 +523,7 @@ static int mtk_spmi_remove(struct platform_device *pdev)
 	struct pmif *arb = spmi_controller_get_drvdata(ctrl);
 
 	clk_bulk_disable_unprepare(arb->nclks, arb->clks);
+	clk_bulk_put(arb->nclks, arb->clks);
 	spmi_controller_remove(ctrl);
 	spmi_controller_put(ctrl);
 	return 0;
-- 
2.43.0



