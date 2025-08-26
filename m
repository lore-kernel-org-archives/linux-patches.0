Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220CF26AEC;
	Tue, 26 Aug 2025 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208026; cv=none; b=utf7suWGhQMKLeIni9K6rpu5Q3qZ9ebF9cQTw+ClPZEWyKrGqT1Z2Y3LjMjDQyBG7Fla6/aoF06NnghtTe6XOZs2tRqKy6Y+7IEu1g7FqGiGJfAhdQDZTjH7+O4bavL6wZ+x/OPNvR+fyMd8+iMgwK7k4k+Tb/pgUwL2DyiD4zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208026; c=relaxed/simple;
	bh=FgiwsldzhmF0a/r3t70MfVU1hLYHQtcfQUebCfd3rkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI61eoQHBfLGNvo81rRk0unWFiX0aRnn2ti4r4NEqFpF8lOtxIhgMkPj6GjvhSx8BgoJyojGVjPts+sF66KNMe+WHVpKFvN1GY8dI9WdBnlvUOfHv+MQNgK0w5j9heZYmXikd2A0qztSrPY/YO3DeJmBl20YNcTkHu1x++0yLj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3i9SEu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3i9SEu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3DCC4CEF1;
	Tue, 26 Aug 2025 11:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208025;
	bh=FgiwsldzhmF0a/r3t70MfVU1hLYHQtcfQUebCfd3rkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3i9SEu9bPonnsoVRDizuVKJIY1LUF3lRqX+S3RigTf2aDHTMKpPFXjSovNzsOn2i
	 qY4wk20KuSFRT8iCza3/rxF9w5kd3b3wED64xj6tg3IJfu/OEdvWtyiWPPaJRrSwDe
	 DrgMwNou/9TOCZtUVvBYeHZgv/hHpE5zKjuVCobo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 409/457] regulator: tps65219: regulator: tps65219: Fix error codes in probe()
Date: Tue, 26 Aug 2025 13:11:33 +0200
Message-ID: <20250826110947.403347737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 11cd7a5c21db020b8001aedcae27bd3fa9e1e901 ]

There is a copy and paste error and we accidentally use "PTR_ERR(rdev)"
instead of "error".  The "rdev" pointer is valid at this point.

Also there is no need to print the error code in the error message
because dev_err_probe() already prints that.  So clean up the error
message a bit.

Fixes: 38c9f98db20a ("regulator: tps65219: Add support for TPS65215 Regulator IRQs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aKRGmVdbvT1HBvm8@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65219-regulator.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps65219-regulator.c b/drivers/regulator/tps65219-regulator.c
index 5e67fdc88f49..d77ca486879f 100644
--- a/drivers/regulator/tps65219-regulator.c
+++ b/drivers/regulator/tps65219-regulator.c
@@ -454,9 +454,9 @@ static int tps65219_regulator_probe(struct platform_device *pdev)
 						  irq_type->irq_name,
 						  irq_data);
 		if (error)
-			return dev_err_probe(tps->dev, PTR_ERR(rdev),
-					     "Failed to request %s IRQ %d: %d\n",
-					     irq_type->irq_name, irq, error);
+			return dev_err_probe(tps->dev, error,
+					     "Failed to request %s IRQ %d\n",
+					     irq_type->irq_name, irq);
 	}
 
 	for (i = 0; i < pmic->dev_irq_size; ++i) {
@@ -477,9 +477,9 @@ static int tps65219_regulator_probe(struct platform_device *pdev)
 						  irq_type->irq_name,
 						  irq_data);
 		if (error)
-			return dev_err_probe(tps->dev, PTR_ERR(rdev),
-					     "Failed to request %s IRQ %d: %d\n",
-					     irq_type->irq_name, irq, error);
+			return dev_err_probe(tps->dev, error,
+					     "Failed to request %s IRQ %d\n",
+					     irq_type->irq_name, irq);
 	}
 
 	return 0;
-- 
2.50.1



