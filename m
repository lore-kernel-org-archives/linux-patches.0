Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81D22AE7C;
	Mon, 10 Mar 2025 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629238; cv=none; b=In91CeiypfOqJBNHAbnb9cWWjKrZG8z2mjnm8ycKYkbAAAfhcSaHCfs3ebdg6K6FqaVG/1eYPHWkKpYLQazzYgnSNnY+HyKkNpizVqYETGJcSK5Gjgv0angfIhn4lNCFoCZonKDFD7lnh1Hm5cT6lqil8IhXWws9pEyGtGVnrtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629238; c=relaxed/simple;
	bh=UrJx82ZQnAYNCgP52c+WiklDua+ZO8I0scsnxfmfq0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1MWtcvEmbNVRxp4wbvHXFrU+O02h0Fa43JUAHN8uR5WG0JIne62EcSwBBZcLvGP2zYIqLGdZxDX7V7y0790rGQTUC2VQY7qrgvnHh45H1EUS0Lej/0+rTbf8JyLbvvO3P/x+QTF273mSgjh6qbAKJkQSYJzrOQOQwxXIJJJz8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt4GT09q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt4GT09q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BD6C4CEE5;
	Mon, 10 Mar 2025 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629238;
	bh=UrJx82ZQnAYNCgP52c+WiklDua+ZO8I0scsnxfmfq0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt4GT09qRLAXcoV8CRjL0BByiUOdqkpO8A1gIIHw2TSddihv6l5F61rhST8nXDiBb
	 MYR2MxAb6qrA0CXd+LVavUwoAqmp0q//8vKPAIwvfWIsmHpK7A7L7AwXYe7VhPVQJp
	 SXDXcn5dJK64XpW/eEKWP4L8IygeuAcwShcSSAAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/620] usb: chipidea: ci_hdrc_imx: use dev_err_probe()
Date: Mon, 10 Mar 2025 18:01:12 +0100
Message-ID: <20250310170554.546418970@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 18171cfc3c236a1587dcad9adc27c6e781af4438 ]

Use dev_err_probe() to simplify handling errors in ci_hdrc_imx_probe()

Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220614120522.1469957-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 74adad500346 ("usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index d8efa90479e23..caa91117ba429 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -355,25 +355,18 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		data->pinctrl = devm_pinctrl_get(dev);
 		if (PTR_ERR(data->pinctrl) == -ENODEV)
 			data->pinctrl = NULL;
-		else if (IS_ERR(data->pinctrl)) {
-			if (PTR_ERR(data->pinctrl) != -EPROBE_DEFER)
-				dev_err(dev, "pinctrl get failed, err=%ld\n",
-					PTR_ERR(data->pinctrl));
-			return PTR_ERR(data->pinctrl);
-		}
+		else if (IS_ERR(data->pinctrl))
+			return dev_err_probe(dev, PTR_ERR(data->pinctrl),
+					     "pinctrl get failed\n");
 
 		data->hsic_pad_regulator =
 				devm_regulator_get_optional(dev, "hsic");
 		if (PTR_ERR(data->hsic_pad_regulator) == -ENODEV) {
 			/* no pad regualator is needed */
 			data->hsic_pad_regulator = NULL;
-		} else if (IS_ERR(data->hsic_pad_regulator)) {
-			if (PTR_ERR(data->hsic_pad_regulator) != -EPROBE_DEFER)
-				dev_err(dev,
-					"Get HSIC pad regulator error: %ld\n",
-					PTR_ERR(data->hsic_pad_regulator));
-			return PTR_ERR(data->hsic_pad_regulator);
-		}
+		} else if (IS_ERR(data->hsic_pad_regulator))
+			return dev_err_probe(dev, PTR_ERR(data->hsic_pad_regulator),
+					     "Get HSIC pad regulator error\n");
 
 		if (data->hsic_pad_regulator) {
 			ret = regulator_enable(data->hsic_pad_regulator);
@@ -465,9 +458,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 				&pdata);
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "ci_hdrc_add_device failed, err=%d\n",
-					ret);
+		dev_err_probe(dev, ret, "ci_hdrc_add_device failed\n");
 		goto err_clk;
 	}
 
-- 
2.39.5



