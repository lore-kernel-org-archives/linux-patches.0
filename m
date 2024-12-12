Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950402210E3;
	Thu, 12 Dec 2024 17:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023677; cv=none; b=OSkxHwP3TIsS61vqI4+4EpfoQbXQPVCMkwY3w4wFxjNAMsi/wn4LE03RtFrKunH7ETuIDKTw64BxI3cPbWVCfdgmdW5NZ1x/2a55uz6J0zES1BFwmPdcujdl1Rc/2dMKwrF9f8gKVu0nPliN9uxbjEl+mEpf61QdGcC3OxKV6F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023677; c=relaxed/simple;
	bh=PMWPURCtWUR4slymZnEWIdsnGHlHcdh6JcvzYwXNDvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4Vh8I1v/J35KKg26TaUx2duJZpqjBZgXLXiaveKeMnHhlgoqslo1m7OX2Ge3H3GNk/XCkPHovgV3kWoIJfXzsaQ+sSD7Z8MWZ5hnB2kodz0OGfeGYgzcvuWTygkMDTWKgj9x/6FWSRpR62keceyRQCSSYuDaYn0NidKen2TF/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJAw6DjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJAw6DjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12993C4CECE;
	Thu, 12 Dec 2024 17:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023677;
	bh=PMWPURCtWUR4slymZnEWIdsnGHlHcdh6JcvzYwXNDvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJAw6DjXxYy0pDwJQBHuj0eAzP8mk+SEHh3F8PLmomXrQq7fYycXL/7I5pYynZq34
	 PPUwNYbEZsW4tJp4G16ERj62Ez25mACExwUi/YrBHF9xO3836JnstPn0tvYGopXZ4T
	 BtTfAFpjCufvkS5UboOLsPG7CgW8v4U+P1KHLu0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/459] ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()
Date: Thu, 12 Dec 2024 15:56:23 +0100
Message-ID: <20241212144255.305067477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit 63c1c87993e0e5bb11bced3d8224446a2bc62338 ]

This patch checks if div is less than or equal to zero (div <= 0). If
div is zero or negative, the function returns -EINVAL, ensuring the
division operation (*prate / div) is safe to perform.

Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Link: https://patch.msgid.link/20241106014654.206860-1-luoyifan@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 3aa1cf2624020..3a7f0102b4c5c 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -380,8 +380,8 @@ static long stm32_sai_mclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	int div;
 
 	div = stm32_sai_get_clk_div(sai, *prate, rate);
-	if (div < 0)
-		return div;
+	if (div <= 0)
+		return -EINVAL;
 
 	mclk->freq = *prate / div;
 
-- 
2.43.0



