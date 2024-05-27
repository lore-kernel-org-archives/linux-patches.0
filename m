Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356BE15EFC3;
	Mon, 27 May 2024 19:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837796; cv=none; b=o9JPQSYAMXII4X3Z3RZm6++qb5QmeGTkDNexdLtfSWzfr2azK62rvDY9Cpd5CiYItDscKBea04YcBZ+ZS6F/P19nCXtvemos96PD8nlp/qKJmzYBTRVWkwLCfjYZFQQttsag9HxOgoAuWwDJaEJB9+CUDtuAkTP3Uo/DMAm9Twg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837796; c=relaxed/simple;
	bh=QxrsMTxIu9AveLLpzfGep58pYikIOx3qf77zOnHIg2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgjL4KYbYjsZbXHvh/H5GWuNpILhqz8jgGeFHxEw6htEqji5yRSVdpuOi6+ey8Rq7gMdaHKH+MTTFzKKV7HxMxQOR11GAvk/vqX4kK+/2LpnhUrLXiifDkZ/3WN++AOicD7zUQ6AxldH5aHrRgr2DMbZ8aSnK93fMlkNvUcgIeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZAZ/igQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZAZ/igQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD947C32786;
	Mon, 27 May 2024 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837796;
	bh=QxrsMTxIu9AveLLpzfGep58pYikIOx3qf77zOnHIg2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZAZ/igQNAogJNfWWzhmNY6tb5ds055HRNAUh+QsWy95AX1Hrn2bK6IaV6sHe2crN
	 iX23aZPehGyb1WiuTsrb9fyDSkareKeYMtCwJ02gOmen6A2v40FwqL7iEmrk8gc88A
	 DdbhJAjl3FBTEJvdoncb3ytvGix3YvzkhL216TtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 148/493] hwrng: stm32 - use logical OR in conditional
Date: Mon, 27 May 2024 20:52:30 +0200
Message-ID: <20240527185635.280878757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



