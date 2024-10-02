Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBBF1D0425;
	Wed,  2 Oct 2024 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875690; cv=none; b=UAZ4LReLMySRCxI3EZyOXSl+va3Y/L3oKUzCJOktvaMUNeEC2zOXSM9vjzg3yf43xrNYyAOui+PqOEIhxnf5lmJgtDUlZpLWcPn5dNWHNh+FDIFIR0lY9Lm1wKI88iS6l+bmN+xpFAAO9PxfnC8TQ5MS9dyBQp/jR6WCKMN/VWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875690; c=relaxed/simple;
	bh=7cZsu2pN4ZbFNW/1ZEU0Y0gslQQsxZsh3KTa1ZnbSp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT2oeNn96WeXv5RjfjmLslrTooC659yxkrmX49Lp7wSY8wJkHD59IulqBN0VS56MtEo52vO2NE2/N3T54q3kcw5NSwWG75JN734/HgoBzznvnVrWl2Ge7xmmzDN9jS/FbYpTD6ikvN/VXSPGNRe8XqF3TMaytXFyhfNB+DF8bjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LES6eYlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LES6eYlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97893C4CEC5;
	Wed,  2 Oct 2024 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875690;
	bh=7cZsu2pN4ZbFNW/1ZEU0Y0gslQQsxZsh3KTa1ZnbSp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LES6eYlQDI1a6hU+ucMG/KMt5VQR455y/0TLmFLTj5HgZB+fV/BcHGWLJ3+v3bQaA
	 8ZPQC8J33wKdHggHtIF4BMme85Xq1lPxwFHXii2Ik3ok5mXRAfiKKTBkhacdbjUTVC
	 wvsNC8PeBuKiFrMwlew1q0HvPIPPgsx+oippi+VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 156/695] reset: k210: fix OF node leak in probe() error path
Date: Wed,  2 Oct 2024 14:52:34 +0200
Message-ID: <20241002125828.706591797@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b14e40f5dc7cd0dd7e958010e6ca9ad32ff2ddad ]

Driver is leaking OF node reference on memory allocation failure.
Acquire the OF node reference after memory allocation to fix this and
keep it simple.

Fixes: 5a2308da9f60 ("riscv: Add Canaan Kendryte K210 reset controller")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240825-reset-cleanup-scoped-v1-2-03f6d834f8c0@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-k210.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-k210.c b/drivers/reset/reset-k210.c
index b62a2fd44e4e4..e77e4cca377dc 100644
--- a/drivers/reset/reset-k210.c
+++ b/drivers/reset/reset-k210.c
@@ -90,7 +90,7 @@ static const struct reset_control_ops k210_rst_ops = {
 static int k210_rst_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *parent_np = of_get_parent(dev->of_node);
+	struct device_node *parent_np;
 	struct k210_rst *ksr;
 
 	dev_info(dev, "K210 reset controller\n");
@@ -99,6 +99,7 @@ static int k210_rst_probe(struct platform_device *pdev)
 	if (!ksr)
 		return -ENOMEM;
 
+	parent_np = of_get_parent(dev->of_node);
 	ksr->map = syscon_node_to_regmap(parent_np);
 	of_node_put(parent_np);
 	if (IS_ERR(ksr->map))
-- 
2.43.0



