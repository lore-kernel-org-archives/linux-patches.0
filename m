Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A681E04AC;
	Wed,  6 Nov 2024 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898710; cv=none; b=JN+F0dfBKCvFlYm9+ySS13uGiJUedtq7KY5D7rc1hW1ywY2YyPeWqoaI41xGaRRb2U4ffl7lsEyelRTDadoPjVUOj/2ii3GYAX5dNc2DW+4rhSJRSX6PHcVibzfgz6RPwosby53eflnpudNdCYi0d+txT2zSYNXP7Xm7Pdv1Bp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898710; c=relaxed/simple;
	bh=3sTycTRln2l/4/CoTkJAy3WKLGXqVsc6KxVpSYKHmYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HykZebWYPJs+VTMAPzrn7WJMjvpyA0j4mGRTq1aZyo7ticudJL+XH+W5ucqcTeE1SLY0QgV2BmD/VUNFwad5gUEnRWjJZgHeldxXdyBK7dihLyc5bCbG+5SubqrWktmLXLh6BACgxpyDtEgcI4+7C4Sp+cKkFqmBOLufn7t5c+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPDFO9sE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPDFO9sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18778C4CECD;
	Wed,  6 Nov 2024 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898710;
	bh=3sTycTRln2l/4/CoTkJAy3WKLGXqVsc6KxVpSYKHmYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPDFO9sEeFqJ4opFbkNOMav51EWQbffUcum//odzxh2yCF9ldDs0fyA39xrRQJLgm
	 4988Qf4JXfoXCwulkhe8IXQLZ6SbTWblAV4UVVcMM+XJqC2OCH9T9AP4Grx4w2G9vL
	 SjxD1j5RHharZsmJvL4GSuaTEpoa3SG3kxuB84RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 329/462] gpio: aspeed: Use devm_clk api to manage clock source
Date: Wed,  6 Nov 2024 13:03:42 +0100
Message-ID: <20241106120339.652193728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit a6191a3d18119184237f4ee600039081ad992320 ]

Replace of_clk_get with devm_clk_get_enabled to manage the clock source.

Fixes: 5ae4cb94b313 ("gpio: aspeed: Add debounce support")
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20241008081450.1490955-3-billy_tsai@aspeedtech.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-aspeed.c b/drivers/gpio/gpio-aspeed.c
index 24bd00a6ae423..9df73ae84841a 100644
--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -1159,7 +1159,7 @@ static int __init aspeed_gpio_probe(struct platform_device *pdev)
 	if (!gpio_id)
 		return -EINVAL;
 
-	gpio->clk = of_clk_get(pdev->dev.of_node, 0);
+	gpio->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(gpio->clk)) {
 		dev_warn(&pdev->dev,
 				"Failed to get clock from devicetree, debouncing disabled\n");
-- 
2.43.0



