Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E51F76B1;
	Tue,  3 Dec 2024 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237684; cv=none; b=DA1/grgaCylzqWv8DoHbraT+515oiJw0aWP+8ZEU317bDq6XxLwMakgBH0oorHG/9WgFOFDqNLEPvJtWNqYJ4cUsU7cS6oxRXL/olyv7GYoA1sXXB8MXRQuPSnOn5pacS3OprfQEkmMQ780SL1TKg6wZV9NpeoDJlEOMCjrqpFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237684; c=relaxed/simple;
	bh=mhx2LXmccfMMXeyf0HW2MGyg3dacZt9l/0KwHyhNmvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy55GMRuLujZRRao12CLm/5aheKi+8NRjJWmb9LhvNo/Qj2sJis5dQGH+UX3yUqL+Avy2YZIcE7/NjeU1cwcJ5RAsGJcNYW7XzzLL4IYgw8ZWyoodOZYEzzh0yYHRkdCXpvr3jkE1kDniQPoC7lYiQnE2zrM1zj4zIPfiNnzAJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2BBaEqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2BBaEqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA29C4CED9;
	Tue,  3 Dec 2024 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237683;
	bh=mhx2LXmccfMMXeyf0HW2MGyg3dacZt9l/0KwHyhNmvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2BBaEqn/Cgv7jI7MBleHr6A/KZyLxBpYXWpnMbQdfjBGZvw0Kc/KZGueMRDwPxIT
	 xMd3SanI4mFCrfEHEEXpD5U3dIpGfipfZ8CN7gUP4wTkCl4CPjQY13xp7jkcJxiqTb
	 CELQe4YaAx2wNo4X/hepis6x9iAQJCyJbn7ll7Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 033/817] ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()
Date: Tue,  3 Dec 2024 15:33:25 +0100
Message-ID: <20241203143956.942770130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index ad2492efb1cdc..19307812ec765 100644
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



