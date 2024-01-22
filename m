Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032CA14532F;
	Tue, 23 Jan 2024 00:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969580; cv=none; b=ZMYHLAT49AUiHLp0QnSFDdwmmYi+rtuGaG/d31zyUd4vn1O9FkPHbcJk0imN5D06slPs5VMZE/3NiMjpJe5jLx1ugCaXQWRXZIhcRgDxMq/UcSwIU4D2fsDEFRR61nBtosNebAP590huxLtHW8E0fclifIJuZPAH0e5no6sXIvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969580; c=relaxed/simple;
	bh=muBmKaXVH7IWm8po1/KMV4bnrSHFbKEKgvga8owtzYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7uq8QK7Hq8AS9LgjNLIWwl5B3WBGn9qZRFNEKHlvEDDfiVAVlIZ+dytF8tBwXCanbb65Dh6WxN/Khhy3HfcGKZK+/0CpAh4Axaaw7N1UwwAULSCKehfX47nkz4wiFpQQY602JIED+w5M4nNRL6GN9i90cp83s/YOtVG3NiXn0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2Xjvu6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2Xjvu6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA70C433A6;
	Tue, 23 Jan 2024 00:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969579;
	bh=muBmKaXVH7IWm8po1/KMV4bnrSHFbKEKgvga8owtzYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2Xjvu6sweLJOAIZl6A+ySEsluj3tNgboC6iR8hUgzlzev4xgzsZcqzmp5bQa23Pm
	 9eNJRqVf44AKkwK+mP+KyV+IWqkjHi+4LRI1av1JKKHMsIrEjHlt9SwOFPzZg02XOI
	 7ZQob49i/B8XxpDlXjre6qNwnrYZV5KZgi36xZKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 334/641] clk: sp7021: fix return value check in sp7021_clk_probe()
Date: Mon, 22 Jan 2024 15:53:58 -0800
Message-ID: <20240122235828.361015201@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1004c346a2b7393fce37dd1f320555e0a0d71e3f ]

devm_platform_ioremap_resource() never returns NULL pointer,
it will return ERR_PTR() when it fails, so replace the check
with IS_ERR().

Fixes: d54c1fd4a51e ("clk: Add Sunplus SP7021 clock driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20231128133016.2494699-1-yangyingliang@huawei.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-sp7021.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk-sp7021.c b/drivers/clk/clk-sp7021.c
index 01d3c4c7b0b2..7cb7d501d7a6 100644
--- a/drivers/clk/clk-sp7021.c
+++ b/drivers/clk/clk-sp7021.c
@@ -604,14 +604,14 @@ static int sp7021_clk_probe(struct platform_device *pdev)
 	int i;
 
 	clk_base = devm_platform_ioremap_resource(pdev, 0);
-	if (!clk_base)
-		return -ENXIO;
+	if (IS_ERR(clk_base))
+		return PTR_ERR(clk_base);
 	pll_base = devm_platform_ioremap_resource(pdev, 1);
-	if (!pll_base)
-		return -ENXIO;
+	if (IS_ERR(pll_base))
+		return PTR_ERR(pll_base);
 	sys_base = devm_platform_ioremap_resource(pdev, 2);
-	if (!sys_base)
-		return -ENXIO;
+	if (IS_ERR(sys_base))
+		return PTR_ERR(sys_base);
 
 	/* enable default clks */
 	for (i = 0; i < ARRAY_SIZE(sp_clken); i++)
-- 
2.43.0



