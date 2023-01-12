Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5435079C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5B3C433EF;
	Thu, 12 Jan 2023 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533208;
	bh=snVdolLYDEP+WbZ08Xn/oUHKCZW+Jky/wCxRtwjWqH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwoZK3isKOVKyQ+bDwPzGvPK58R4U1TWs+vFrP7y7KjyWyMvwbtnNBZ57z4BDGKdC
	 nsJkJ5qEVNXjWMiYraJKplFir6ExVLnNo+Q2FNxHPDiwRGTD5YdMYGz084W4Txedug
	 Ot0Gm024ptTcm0hcjItgShzYNs/pmNsFdzEj5o5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	William Breathitt Gray <william.gray@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/783] counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update
Date: Thu, 12 Jan 2023 14:51:30 +0100
Message-Id: <20230112135541.662386767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit fd5ac974fc25feed084c2d1599d0dddb4e0556bc ]

The ARR (auto reload register) and CMP (compare) registers are
successively written. The status bits to check the update of these
registers are polled together with regmap_read_poll_timeout().
The condition to end the loop may become true, even if one of the register
isn't correctly updated.
So ensure both status bits are set before clearing them.

Fixes: d8958824cf07 ("iio: counter: Add support for STM32 LPTimer")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20221123133609.465614-1-fabrice.gasnier@foss.st.com/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-lptimer-cnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/counter/stm32-lptimer-cnt.c b/drivers/counter/stm32-lptimer-cnt.c
index 937439635d53..b084e971a493 100644
--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -69,7 +69,7 @@ static int stm32_lptim_set_enable_state(struct stm32_lptim_cnt *priv,
 
 	/* ensure CMP & ARR registers are properly written */
 	ret = regmap_read_poll_timeout(priv->regmap, STM32_LPTIM_ISR, val,
-				       (val & STM32_LPTIM_CMPOK_ARROK),
+				       (val & STM32_LPTIM_CMPOK_ARROK) == STM32_LPTIM_CMPOK_ARROK,
 				       100, 1000);
 	if (ret)
 		return ret;
-- 
2.35.1



