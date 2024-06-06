Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF11C370C;
	Thu,  6 Jun 2024 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683651; cv=none; b=rs1Vn947Zimb7yTwk5fj/WvPejtpA4tjBnd3MUc4FV+7FmBJl7OLMiblj6y+1Ki2wewLZP5wq6dednfaFzDN+uQg5J0Uljuv0XjNsNKhlk2cBYwTtpKNBO6Ht9dG0bhbSaGED4sK4gznUII8n9TiPoew9A+/wfUi1u1JuqWUqJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683651; c=relaxed/simple;
	bh=mV1ndGEHaJmnB6AVU/WKLlbpJozYlhvQ17eH3G9/Mek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrbkbLlri4Zl2iS/weT6JM+YEhA4OqiY8cK1cUWEnVzjKOnlaNdslfd7F75e76GlppHR2CyOLxF0EfwJEr4Zx9r9UhgmV2MAuXZTYt4uZT8Ds1oATVMbTC2sKulYjDhY964rauHeqenRE4YGXaslAcjm0Z3PP7RtINASb6BP+cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwIjg1pA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwIjg1pA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAADC2BD10;
	Thu,  6 Jun 2024 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683651;
	bh=mV1ndGEHaJmnB6AVU/WKLlbpJozYlhvQ17eH3G9/Mek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwIjg1pA2suzayLEnUoEbRY524rCHOC4KJ3Ix29zHYC8ti1FR+XgQN+BkQwomy+cv
	 35OndcnOp5ganRbGQLLWN22+iGyQEATb9h9rrbLm3up1JisR1rWHoE02bjehJWGANr
	 j07QLIK375H3F4Ic/Z5UyURT98t1GJV6t0E+P4qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 493/744] i2c: synquacer: Fix an error handling path in synquacer_i2c_probe()
Date: Thu,  6 Jun 2024 16:02:45 +0200
Message-ID: <20240606131748.256709334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 55750148e5595bb85605e8fbb40b2759c2c4c2d7 ]

If an error occurs after the clk_prepare_enable() call, it should be undone
by a corresponding clk_disable_unprepare() call, as already done in the
remove() function.

As devm_clk_get() is used, we can switch to devm_clk_get_enabled() to
handle it automatically and fix the probe.

Update the remove() function accordingly and remove the now useless
clk_disable_unprepare() call.

Fixes: 0d676a6c4390 ("i2c: add support for Socionext SynQuacer I2C controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-synquacer.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-synquacer.c b/drivers/i2c/busses/i2c-synquacer.c
index bbea521b05dda..a73f5bb9a1645 100644
--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -550,17 +550,13 @@ static int synquacer_i2c_probe(struct platform_device *pdev)
 	device_property_read_u32(&pdev->dev, "socionext,pclk-rate",
 				 &i2c->pclkrate);
 
-	i2c->pclk = devm_clk_get(&pdev->dev, "pclk");
-	if (PTR_ERR(i2c->pclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-	if (!IS_ERR_OR_NULL(i2c->pclk)) {
-		dev_dbg(&pdev->dev, "clock source %p\n", i2c->pclk);
-
-		ret = clk_prepare_enable(i2c->pclk);
-		if (ret)
-			return dev_err_probe(&pdev->dev, ret, "failed to enable clock\n");
-		i2c->pclkrate = clk_get_rate(i2c->pclk);
-	}
+	i2c->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
+	if (IS_ERR(i2c->pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->pclk),
+				     "failed to get and enable clock\n");
+
+	dev_dbg(&pdev->dev, "clock source %p\n", i2c->pclk);
+	i2c->pclkrate = clk_get_rate(i2c->pclk);
 
 	if (i2c->pclkrate < SYNQUACER_I2C_MIN_CLK_RATE ||
 	    i2c->pclkrate > SYNQUACER_I2C_MAX_CLK_RATE)
@@ -615,8 +611,6 @@ static void synquacer_i2c_remove(struct platform_device *pdev)
 	struct synquacer_i2c *i2c = platform_get_drvdata(pdev);
 
 	i2c_del_adapter(&i2c->adapter);
-	if (!IS_ERR(i2c->pclk))
-		clk_disable_unprepare(i2c->pclk);
 };
 
 static const struct of_device_id synquacer_i2c_dt_ids[] __maybe_unused = {
-- 
2.43.0



