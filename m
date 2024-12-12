Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A6B6F2FE;
	Thu, 12 Dec 2024 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021798; cv=none; b=OhGAKWwguhH0Z5fD/JWUqCLSpV2fBPQOXvwENlSUIXVFWUbaMHba99c7VS9cHUo+wvB7NDQSSsc/gvJ/eioU6curCvx8RJyogBERauMMNd3rTgR8T8kgo3pMX7ESRyeirLTEi1pdHr8E7vI7/dvLZjJM4RuSfULc9WaKKBCUS78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021798; c=relaxed/simple;
	bh=moC7ggwc4ImsNdG8gaSoTuPRngs4E8AHHzzHdQE0Os0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gC27ZKWhg5pbZSkY2oKkgHec28WhiRNyqulNrQrUAv19tCHd76LTvoQa+uoKT8EWy3hyxCjLj3fzjIInVUiSvZB5KOU6c+otCT4hoLGpx3td7d2SZLtoY1wEoNxNQtULUr0xiDg6qI8TE/1k2oKnG5bijRAeOenluUV3WQXFRmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eU/S5+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eU/S5+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F0CC4CED3;
	Thu, 12 Dec 2024 16:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021797;
	bh=moC7ggwc4ImsNdG8gaSoTuPRngs4E8AHHzzHdQE0Os0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eU/S5+USkX3go6CCEnHBVdUVatClxcJ2MPI7Nlidn/kFouF8Qvb66dwV+5U46p7g
	 YReQDdAHQ8iMdPcL4q/dXvHntcNwg05+uTL4uW2DO+0UTHxZgymFgGmdyNtStPKfvJ
	 TIXcJKVynxOg8fJLbtBxQZ2PZ8rTBpg30+TDknmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/565] ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()
Date: Thu, 12 Dec 2024 15:54:21 +0100
Message-ID: <20241212144314.102994564@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9c3b8e2096565..aa9cdd93b5778 100644
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



