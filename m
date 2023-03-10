Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEBE8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736A8C4339B;
	Fri, 10 Mar 2023 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459903;
	bh=oxmmiXYISxLLpuPc0AV5Or/kwc07aad/G/Z3bNrp1Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRNpnVNXtR/Tr6fOdbwQdHjrEqJAirgj///ptuJVB6kY0Sa35oIhhkpkNoS993C65
	 LPlsGjKazW8y/HD+aijVQ0z6snT51ucUkCgfkhX1M/HLMhLo0XecQbIrNSIIHzkJr8
	 uaW7MpyQpk3PxTr+RZdkLjWOl+49uY65jzmKhkEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/529] pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain
Date: Fri, 10 Mar 2023 14:35:02 +0100
Message-Id: <20230310133812.329368884@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit dcef18c8ac40aa85bb339f64c1dd31dd458b06fb ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: d86f4d71e42a ("pinctrl: stm32: check irq controller availability at probe")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20230102082503.3944927-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 60406f1f8337e..2d852f15cc501 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1338,6 +1338,7 @@ static struct irq_domain *stm32_pctrl_get_irq_domain(struct device_node *np)
 		return ERR_PTR(-ENXIO);
 
 	domain = irq_find_host(parent);
+	of_node_put(parent);
 	if (!domain)
 		/* domain not registered yet */
 		return ERR_PTR(-EPROBE_DEFER);
-- 
2.39.2



