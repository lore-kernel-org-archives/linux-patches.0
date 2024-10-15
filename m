Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21ED20721A;
	Tue, 15 Oct 2024 13:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998231; cv=none; b=j6smaOABRoggXKi5GmizST1CbLRq/AwcAWU/2apuSP8OULt3yZcCVXPEJ+mY66A/s858KGLelMwTcpC3X1r9Uwh+TPH7rErkRubCMCcjn88yfT03SlSx2XavL+uhupvfwA4f5YobrnuoJW9/cOtDanA3HX+QP3M14fCTJ+WQisE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998231; c=relaxed/simple;
	bh=rNiuBf0A3ElEhYOVK6Tb+5R9hM/EF93GAb+orQnyubo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7awtdna1BglMxp+j9pcHym+iMmEAdTToSmQ8y1vWl70liInXz6VFLP1rtU0bgH2SJBnEfecWa1Cf946sfVaI3GQBtfkVnO6H/ig0c99PIr3K2UTPnc69ajbzMGwE5UqUaJyPCUOeDBZnfoAAGn91V9cnxrgij98F6YP/LR30Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkrHzEhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkrHzEhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A5C4CECF;
	Tue, 15 Oct 2024 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998231;
	bh=rNiuBf0A3ElEhYOVK6Tb+5R9hM/EF93GAb+orQnyubo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkrHzEhz8zCbaC+qksxvZW7xdJcIJj0F/t5MJz+jb7Arzyd8YjzyvO+Mc4WmtiS4j
	 1i8MOpVWOcPY6+lUDgmQgQxbNl85N7qmYTWkAJPyCn4lBCt5QdbzW62zfcY2OhmWBx
	 6T3ktuimowMP9BGK5ffPYdR/K9PvxpEnTQamcAK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/518] i2c: xiic: Simplify with dev_err_probe()
Date: Tue, 15 Oct 2024 14:45:21 +0200
Message-ID: <20241015123933.091411661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 9dbba3f87c7823cf35e63fb7a2449a5d54b3b799 ]

Common pattern of handling deferred probe can be simplified with
dev_err_probe().  Less code and the error value gets printed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 0c8d604dea43 ("i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -838,11 +838,10 @@ static int xiic_i2c_probe(struct platfor
 	mutex_init(&i2c->lock);
 
 	i2c->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(i2c->clk)) {
-		if (PTR_ERR(i2c->clk) != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "input clock not found.\n");
-		return PTR_ERR(i2c->clk);
-	}
+	if (IS_ERR(i2c->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->clk),
+				     "input clock not found.\n");
+
 	ret = clk_prepare_enable(i2c->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to enable clock.\n");


