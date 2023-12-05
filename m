Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D202A6AA0;
	Tue,  5 Dec 2023 03:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opTnGf1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64215C433C7;
	Tue,  5 Dec 2023 03:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746573;
	bh=GtDem1sDcIf2VXPlKzOtSRk0Kb1YEMFv1K7C2YzlQ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opTnGf1nf4tdmG5zCi1KYk4WIppYH8cVYXwxj0kBzYMVLR/+Kk3l0h+/QpQAILb28
	 +wN2LOPEkdijHaWJJJ8RQPrERqP0CUyWOJ6EI0n99fukn8qojvmnijRZfhS3WSDCcG
	 tLP6pCv6VKpm1WjyoM2NKTXs0vQZutmkDYeE4Lr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Valentin Caron <valentin.caron@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/134] pinctrl: stm32: Add check for devm_kcalloc
Date: Tue,  5 Dec 2023 12:15:47 +0900
Message-ID: <20231205031540.249346729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b0eeba527e704d6023a6cd9103f929226e326b03 ]

Add check for the return value of devm_kcalloc() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: 32c170ff15b0 ("pinctrl: stm32: set default gpio line names using pin names")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20231031080807.3600656-1-nichen@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index a73385a431de9..419eca49ccecb 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1378,6 +1378,11 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 	}
 
 	names = devm_kcalloc(dev, npins, sizeof(char *), GFP_KERNEL);
+	if (!names) {
+		err = -ENOMEM;
+		goto err_clk;
+	}
+
 	for (i = 0; i < npins; i++) {
 		stm32_pin = stm32_pctrl_get_desc_pin_from_gpio(pctl, bank, i);
 		if (stm32_pin && stm32_pin->pin.name)
-- 
2.42.0



