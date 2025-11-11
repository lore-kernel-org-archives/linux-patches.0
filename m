Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CE72DE707;
	Tue, 11 Nov 2025 01:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823740; cv=none; b=ayI/m/myG7f3K5W/bR31/ExBYy9jzS/ye4NBmzsJkmdIezJx/AgJ2aPGx8ZWrDBifXG1vdQDQY09BKqM8Vhts1T1Lj76chaxu0lK7hd+eJZSl65bhZETeRvjfgXWpOu0rKa7amSAIDeVEFT6FcoZ5PZAstjLnGTkJxgL7yv7iwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823740; c=relaxed/simple;
	bh=h8A/mU3RdA9NqqnTf/jLVAfmEQnb6mXghUUNnxGlTXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jsvfr5at5mg+Sf/zqfoir3nilzmqqvhWpRChIGZ4TvRiJXTSd1AQGU69EHC0cYdTiLZ2s1dZOqqlz8UGFae3qVZc8IElt1jYcK5KHhdtRdOTT/qmAhxJxo2IqHjdKBr9S1dUzkUPD5z4G3TaavIM2GNUW898L4G9l1ts86r75Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGybXumW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGybXumW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6FCC116B1;
	Tue, 11 Nov 2025 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823740;
	bh=h8A/mU3RdA9NqqnTf/jLVAfmEQnb6mXghUUNnxGlTXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGybXumWRkvFknBELeXUi/y3iRm7fjgcG/6lu/G7sBiXiyhj+tH6w7ewaKtRWOBEt
	 XLfN7OiZ6NkspZP16yQ0XqdHQDI8DX07l/Rcft5XfFJuxtJk0Fe8jwuCPhXt2wVTW7
	 94e+FFYQdFwK3O4m3tTlEbd9qIYpPL7PrMEnjCfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 360/849] extcon: axp288: Fix wakeup source leaks on device unbind
Date: Tue, 11 Nov 2025 09:38:50 +0900
Message-ID: <20251111004545.122239924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 93ccf3f2f22ceaa975b462156f98527febee4fe5 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Link: https://lore.kernel.org/lkml/20250501-device-wakeup-leak-extcon-v2-2-7af77802cbea@linaro.org/
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-axp288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index d3bcbe839c095..19856dddade62 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -470,7 +470,7 @@ static int axp288_extcon_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	device_init_wakeup(dev, true);
+	devm_device_init_wakeup(dev);
 	platform_set_drvdata(pdev, info);
 
 	return 0;
-- 
2.51.0



