Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB305611E;
	Mon, 14 Oct 2024 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918315; cv=none; b=QzIL7pFja/st2jYoqKGTgolC5vkCthLhwTBfk4e6Z3RWh+EIpCwrXvRl/GMBHDV4croII/0fh/6UzKGG7bVizcNwLnLjgLBbnozmoNVb+eZcJ7RGrSUNwwjybraH1a5AE/GSTJNRwvU34OPukReUDeD0lvZ6FYmh2e1MOMp9dNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918315; c=relaxed/simple;
	bh=8w5eZQmFf2jSdR0oBmCd5L9x42ZXB9k+Ngx4VmmMYhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RY2YTIxIN69B/XEUkCtpxHWTTNZs4A65+vzAkmfThAI3fOY7uXVaHZhO1GrEMsc7TlI4I5kNQXrwqVXiEhjC25ZRio/evlBfgO4rq9Z4vBBvqoTftEstuO6HhDa85RqWPnRls3xF9dQC5EPJ68Dm+2Jz+qZpqW15IMY4/GR7JcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qPx9eja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qPx9eja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDEAC4CEC3;
	Mon, 14 Oct 2024 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918315;
	bh=8w5eZQmFf2jSdR0oBmCd5L9x42ZXB9k+Ngx4VmmMYhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qPx9ejaz8mErqAd7/tmTNF/KF13Tuq3Poaia30DszFHs0PrxyQokuc3J5/oi8bXv
	 2VF4JKsZAjws3U4x9+aRQOzDW1iEF4BdMIuHD5rzIaULA8x6dPVLHdcsDIojKHCkH2
	 AR28oE88XrEjJoeg/MJCstE04eW8nVSe1b989ihg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/798] ep93xx: clock: Fix off by one in ep93xx_div_recalc_rate()
Date: Mon, 14 Oct 2024 16:13:33 +0200
Message-ID: <20241014141228.110557367@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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



