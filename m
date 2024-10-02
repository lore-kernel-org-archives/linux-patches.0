Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C41D2B1A;
	Wed,  2 Oct 2024 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878496; cv=none; b=ZEEKMoTkpX/WDcOqFQDVn5m90XXpu5v6s1Db9FIesro0KCwPAO0XqYIb0+1iy3dNAWtMY+zWuhACXRS9CRlUgoin4KSdw6eNq3U23/ubkmDARXuaf1Aqp7jrYfAw033dI9t2u210b0pXdYyJIRXRinQ+PJCAeCzBe7AKKZNz+Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878496; c=relaxed/simple;
	bh=llkE6TyvZfhjC5vhnIrC8UFYmN5MZcybhc+rBdfr4Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxpiwommXZviOcaRX4Vol5kSV2xhsyS/9JSDrGK+7GFWGYLBT9To7+HCIF2CCEr2fqxF1grflgLo1mMebADyIJAX9iPeJkWHbZBwu+UCYmrGiUPukP7fPZ53a6tm1+WYxibLobfoXywAXY6teRgL9eDg49Fwi/bLcSm5+EHWOJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b1h0WGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b1h0WGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8C6C4CEC5;
	Wed,  2 Oct 2024 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878496;
	bh=llkE6TyvZfhjC5vhnIrC8UFYmN5MZcybhc+rBdfr4Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b1h0WGXddRtmrb/y6+jDF4bDDUgVDGY4auFTPmfXx8awrKzp9p5LDdCTcie0OCor
	 FUboM68p4qT3ZNgZeNAJ8nQPSIfhqZKyVWMwNQaKM8KKZNSDyhiCpLl5CuCCKKG2Ls
	 qZwx05MIgYS0E0FtdGC6N12RKf4xFgcC7c5EOnU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 432/634] ep93xx: clock: Fix off by one in ep93xx_div_recalc_rate()
Date: Wed,  2 Oct 2024 14:58:52 +0200
Message-ID: <20241002125828.153425521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



