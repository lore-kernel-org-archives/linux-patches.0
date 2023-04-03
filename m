Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D576FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49083C433EF;
	Mon,  3 Apr 2023 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532112;
	bh=h4opIhCPYWueRi63sJlKWYPFKp4iHME/8+8CngXdwKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvCq1rYgZ7k5gh22TeBEYUN/OwpDrLpBnXK16UmkjqTL/uCwMhmvMMqSQSuTEICAJ
	 xpTEIq7d0UbMFChhu8j3XBbqZL47zUr4/mLivUHhlc4XdcU4R17AlrH+MdUsiKpzJn
	 Ce+JYralPVLx0GNkCyIBerJCg5t+GEgX+hH1pLq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/173] regulator: Handle deferred clk
Date: Mon,  3 Apr 2023 16:09:07 +0200
Message-Id: <20230403140418.739420691@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 02bcba0b9f9da706d5bd1e8cbeb83493863e17b5 ]

devm_clk_get() can return -EPROBE_DEFER. So it is better to return the
error code from devm_clk_get(), instead of a hard coded -ENOENT.

This gives more opportunities to successfully probe the driver.

Fixes: 8959e5324485 ("regulator: fixed: add possibility to enable by clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/18459fae3d017a66313699c7c8456b28158b2dd0.1679819354.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 3de7709bdcd4c..4acfff1908072 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -175,7 +175,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->enable_clock = devm_clk_get(dev, NULL);
 		if (IS_ERR(drvdata->enable_clock)) {
 			dev_err(dev, "Can't get enable-clock from devicetree\n");
-			return -ENOENT;
+			return PTR_ERR(drvdata->enable_clock);
 		}
 	} else {
 		drvdata->desc.ops = &fixed_voltage_ops;
-- 
2.39.2



