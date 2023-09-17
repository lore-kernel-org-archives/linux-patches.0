Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9A16FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3565C433C8;
	Sun, 17 Sep 2023 19:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979932;
	bh=Z5vACDYnhDiJvy+1UfnUT7QZfxfG31KrBRMU2TrcjGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYaTt8tJ7ZVkJ2icfxlEyaZc8dcAmS2Nvw2bOz07YyJ1M7P7TGuDIOVqZ7Ce96Kl8
	 Z7ZR1sH8XeOFqZ9pUmejilUuQu/2sHMK0xQrV5+2ch45MFkrvMNqTg/4VzPzHJsH3K
	 ZeCzTUUNTR7Of8QTr69mQeJtRO8SYn/uS3IIlui4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.5 049/285] clk: qcom: dispcc-sm8550: fix runtime PM imbalance on probe errors
Date: Sun, 17 Sep 2023 21:10:49 +0200
Message-ID: <20230917191053.375624870@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit acaf1b3296a504d4a61b685f78baae771421608d upstream.

Make sure to decrement the runtime PM usage count before returning in
case regmap initialisation fails.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Cc: stable@vger.kernel.org      # 6.3
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/dispcc-sm8550.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -1761,8 +1761,10 @@ static int disp_cc_sm8550_probe(struct p
 		return ret;
 
 	regmap = qcom_cc_map(pdev, &disp_cc_sm8550_desc);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto err_put_rpm;
+	}
 
 	clk_lucid_evo_pll_configure(&disp_cc_pll0, regmap, &disp_cc_pll0_config);
 	clk_lucid_evo_pll_configure(&disp_cc_pll1, regmap, &disp_cc_pll1_config);
@@ -1777,9 +1779,16 @@ static int disp_cc_sm8550_probe(struct p
 	regmap_update_bits(regmap, 0xe054, BIT(0), BIT(0));
 
 	ret = qcom_cc_really_probe(pdev, &disp_cc_sm8550_desc, regmap);
+	if (ret)
+		goto err_put_rpm;
 
 	pm_runtime_put(&pdev->dev);
 
+	return 0;
+
+err_put_rpm:
+	pm_runtime_put_sync(&pdev->dev);
+
 	return ret;
 }
 


