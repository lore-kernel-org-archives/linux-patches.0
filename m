Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7478D1D1E65;
	Wed,  2 Oct 2024 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880249; cv=none; b=sTXHSJvUrClA5T3A09cmC6jCLHkx7iW1h7LkeOZy+V8qhDKeaWGEEBjYGCDvwlSzrRgzr0TmTC3GZx3POS95RbWnXP7DwmXZiVwN18wzwK/CulMn0AukMFuu35G1NiVkuifuPvG7eAlm0oo66QjMUcxMfP3oFm1HIwEmqNR5vCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880249; c=relaxed/simple;
	bh=6pHXlCp/QhNlWyXuy5DYQZidTQI77NRR5sYqnTgeH7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bm+LKOjicH2n0navfOv3KtQmop7vJcl865NeLSaW1CoQl5rUkIJCHs3FNj7w2IAD8e595j0Qaqh3o0q50DH58JI/trNjh/2zetEvYsBOCJXTA1Kr5DHtEvlm7nbelDp1azWyu1iGQWbQgzbZx86UwFC7AWOLQ9WmG/Wr77IWXdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfEGeTju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfEGeTju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A3DC4CEC2;
	Wed,  2 Oct 2024 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880249;
	bh=6pHXlCp/QhNlWyXuy5DYQZidTQI77NRR5sYqnTgeH7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfEGeTjuhyDg9u3zexCTJWP/iOk5XE9PGaQ4o2ekw5P0CoqTd7p9MyVyQO5erlNR2
	 CDmwzqYz1c7tNqvtbzqiVwhUfdrp5L2MVliLyw9W76SXBbZNeMQ6stYj6d57GVUxxF
	 YEa7E9L2LTMQRTSDcqgDzcbGXeWrvfVwVLLSryEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 367/538] ep93xx: clock: Fix off by one in ep93xx_div_recalc_rate()
Date: Wed,  2 Oct 2024 15:00:06 +0200
Message-ID: <20241002125806.914516786@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Dan Carpenter <alexander.sverdlin@gmail.com>

[ Upstream commit c7f06284a6427475e3df742215535ec3f6cd9662 ]

The psc->div[] array has psc->num_div elements.  These values come from
when we call clk_hw_register_div().  It's adc_divisors and
ARRAY_SIZE(adc_divisors)) and so on.  So this condition needs to be >=
instead of > to prevent an out of bounds read.

Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Reviewed-by: Nikita Shubin <nikita.shubin@maquefel.me>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/1caf01ad4c0a8069535813c26c7f0b8ea011155e.camel@linaro.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-ep93xx/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index 85a496ddc6197..e9f72a529b508 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -359,7 +359,7 @@ static unsigned long ep93xx_div_recalc_rate(struct clk_hw *hw,
 	u32 val = __raw_readl(psc->reg);
 	u8 index = (val & psc->mask) >> psc->shift;
 
-	if (index > psc->num_div)
+	if (index >= psc->num_div)
 		return 0;
 
 	return DIV_ROUND_UP_ULL(parent_rate, psc->div[index]);
-- 
2.43.0



