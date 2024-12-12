Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C0F21B91D;
	Thu, 12 Dec 2024 15:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018746; cv=none; b=db0zi1GeiOgPsumoxIHxxrlZcLgLG311eE0U52vyb+0Wrf8orhuinFZlSseM5ZqiK2zXz+mW6moJX4a7kf1EGsNMLhuO8RNgl4V4yqiizcjSOxY8g0LbdHWGRxBrCtCgbEpyJ6uYxPNIjGP7JLcGVGZzwgVVBBSXy9Mb4by9wOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018746; c=relaxed/simple;
	bh=dVRIpM7VTAFFSrZYL39ulgRz777tPcGY5Yjx38Q3uao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiUsPqITTskt1MQNEPlmg6X0fmbvtM1ysL6YqdW2FBAjdHEQzQ2c3Wq1iS/lMP6KbtTI7zIzFkqErfWAjmMA7ehTp0qIfHKkQoLHUrReQlosvrmiwDt5BTmFQGdGiQj8pFORbw8CV1LkjOpFk76dahALdX9ecP6nwgLcC/H4qXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wzkl+P5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wzkl+P5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8140CC4CECE;
	Thu, 12 Dec 2024 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018745;
	bh=dVRIpM7VTAFFSrZYL39ulgRz777tPcGY5Yjx38Q3uao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzkl+P5k2lxa2JaLT2hEuSoy9ANyKBVy+9WeZLFqwcY+5E7PZUv4di6pOXnWdIJN7
	 pdNBkNypvw7wJvR0TrnKpmPFiTwInrow3k9KkeTOP6Ftn1QASqZDwtAf9usehSlAyu
	 Bhs3WvW4GF76aq8V8Ug3z9OKe3pu3yJJ5bPPl5Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/772] ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()
Date: Thu, 12 Dec 2024 15:49:25 +0100
Message-ID: <20241212144350.778669309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb31b49e65978..3d237f75e81f5 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -378,8 +378,8 @@ static long stm32_sai_mclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	int div;
 
 	div = stm32_sai_get_clk_div(sai, *prate, rate);
-	if (div < 0)
-		return div;
+	if (div <= 0)
+		return -EINVAL;
 
 	mclk->freq = *prate / div;
 
-- 
2.43.0



