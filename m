Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72272915
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ED2C433D2;
	Mon,  8 May 2023 10:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542478;
	bh=iuLf9SzfjGXvPRsP0q5LqlMIekYEJnAl5RUXrLLn9Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLLmbP+NCYDM6mqGdQwgJzA7zEhD5SUNfmi+U4NPaKnTaYWMZJcm6XnIDHZNPLYrS
	 /1wVl+k2rRY3piglF6oVZfBeKbpcihneEZAhGWawyYE4xU8idHnlr0aQQEUJgM8YNC
	 taCgGPyjimNh3opX4TBXoBbbUxn+qp3EX7LvSdYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 447/663] spi: atmel-quadspi: Dont leak clk enable count in pm resume
Date: Mon,  8 May 2023 11:44:33 +0200
Message-Id: <20230508094442.581576496@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c18bbac353ffed50be134b0a2a059a2bd540c503 ]

The pm resume call is supposed to enable two clocks. If the second enable
fails the callback reports failure but doesn't undo the first enable.

So call clk_disable() for the first clock when clk_enable() for the second
one fails.

Fixes: 4a2f83b7f780 ("spi: atmel-quadspi: add runtime pm support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20230317084232.142257-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 70637e46290a4..2dbb37b1840f3 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -786,7 +786,11 @@ static int __maybe_unused atmel_qspi_runtime_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	return clk_enable(aq->qspick);
+	ret = clk_enable(aq->qspick);
+	if (ret)
+		clk_disable(aq->pclk);
+
+	return ret;
 }
 
 static const struct dev_pm_ops __maybe_unused atmel_qspi_pm_ops = {
-- 
2.39.2



