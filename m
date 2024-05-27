Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAF61607A2;
	Mon, 27 May 2024 19:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836498; cv=none; b=Y0clch7krwsv+dG3TZPLtmxL4jo0k2ABZiBqkhjbr3FKXlonIfkwBpCal1qipsuYyP/xoqt3S7K1rgGs4y22UeAbmvYBi4Bu1vqVzaUj8OFYA4QocA5DMwrQen4axi65HVolzsxsimDFs0Rrkl73R0kUSMbuvd/mzCy3WXgsC4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836498; c=relaxed/simple;
	bh=Qgwql/U99ThihlbcOURd4AsmNkUEg1CbI4lRsIWLd2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AB1PekIvEFByr569ZrRXo+om79VtQxIqbt0ZLgFlfeWmYZdeWiXq8gfZh0FoN2655vnn+VwBvKF2c4nXvcZ/ziERqaQDhZKirzza0SZF9LuHf9JdK7QF/94qgk3gW0ffJsFaw96JtLHgKRAeVG+GZCdNpUc3JzP2Ijc7LzW04FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6S5m+lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6S5m+lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B36C2BBFC;
	Mon, 27 May 2024 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836498;
	bh=Qgwql/U99ThihlbcOURd4AsmNkUEg1CbI4lRsIWLd2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6S5m+ltw0LOeM17YixfUiZ+Ri0t7K+ApyLORsm3p/dxmcfVX5fedmHbCI+xwp68N
	 sC3mO0pf8tohhH9VFc2uEo3mU6hwivXplhUtCNq4x4oQ0Tmyzc9x5QsOITpXXQNgKH
	 5o7GzFgG0Pp2PJhrlZIu11TWidjcfjc1I/CjFnFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 076/427] hwrng: stm32 - use logical OR in conditional
Date: Mon, 27 May 2024 20:52:03 +0200
Message-ID: <20240527185608.899551843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 31b57788a5024d3a114b28dad224a93831b90b5f ]

The conditional is used to check whether err is non-zero OR whether
reg variable is non-zero after clearing bits from it. This should be
done using logical OR, not bitwise OR, fix it.

Fixes: 6b85a7e141cb ("hwrng: stm32 - implement STM32MP13x support")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 379bc245c5202..1cc61ef8ee54c 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -353,7 +353,7 @@ static int stm32_rng_init(struct hwrng *rng)
 	err = readl_relaxed_poll_timeout_atomic(priv->base + RNG_SR, reg,
 						reg & RNG_SR_DRDY,
 						10, 100000);
-	if (err | (reg & ~RNG_SR_DRDY)) {
+	if (err || (reg & ~RNG_SR_DRDY)) {
 		clk_disable_unprepare(priv->clk);
 		dev_err((struct device *)priv->rng.priv,
 			"%s: timeout:%x SR: %x!\n", __func__, err, reg);
-- 
2.43.0



