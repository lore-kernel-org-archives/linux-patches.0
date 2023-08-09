Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ED8847D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B95C433C7;
	Wed,  9 Aug 2023 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578357;
	bh=ZuyOmiYij5xC3a6HX90W7ItMYe7QSxKV6ddJBoSIejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5r9j57ISlZQYrHKl8Q11npZGuaohLhazloor+PXsXn1s5lHuj1z7eSMbxHrGppqL
	 cJM7mwTiaoDLPk96MDS+Pg5KDBnWLl9MewU5l0eX+oasJnk1qx0DDCrWuQn5epeAvi
	 rK0HXGt1JhPU06EBavhA8pA6EgARxb3N818xXG4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/127] net: dsa: fix value check in bcm_sf2_sw_probe()
Date: Wed,  9 Aug 2023 12:40:17 +0200
Message-ID: <20230809103637.650631989@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit dadc5b86cc9459581f37fe755b431adc399ea393 ]

in bcm_sf2_sw_probe(), check the return value of clk_prepare_enable()
and return the error code if clk_prepare_enable() returns an
unexpected value.

Fixes: e9ec5c3bd238 ("net: dsa: bcm_sf2: request and handle clocks")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20230726170506.16547-1-ruc_gongyuanjun@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index cde253d27bd08..72374b066f64a 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1436,7 +1436,9 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
-	clk_prepare_enable(priv->clk);
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
 
 	priv->clk_mdiv = devm_clk_get_optional(&pdev->dev, "sw_switch_mdiv");
 	if (IS_ERR(priv->clk_mdiv)) {
@@ -1444,7 +1446,9 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		goto out_clk;
 	}
 
-	clk_prepare_enable(priv->clk_mdiv);
+	ret = clk_prepare_enable(priv->clk_mdiv);
+	if (ret)
+		goto out_clk;
 
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
-- 
2.40.1



