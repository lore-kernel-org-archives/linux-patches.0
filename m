Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE582BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4B8C433D2;
	Tue,  7 Mar 2023 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212823;
	bh=hEFn9n/9+hp/VLZHOweCo97ICRUH9F4WDcfe7yXqt2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiVp7YLpbbluWlLRR8JA2aef4V2jn4ZfiSgeVSRnvvkPHIuvaJQoDjvaNdrwS7W6p
	 sWpt5WF0CLF5z99oz1JNIzl282HSvV4PipwbK0SlwsASGeull56YhdacwiCUDhR7e/
	 KrfoFHz1RxR4dszOkcl8SWXaOdTEdjuk4lpagVX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/885] pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain
Date: Tue,  7 Mar 2023 17:53:33 +0100
Message-Id: <20230307170014.134530398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index e485506ea599c..e198233c10bad 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1380,6 +1380,7 @@ static struct irq_domain *stm32_pctrl_get_irq_domain(struct platform_device *pde
 		return ERR_PTR(-ENXIO);
 
 	domain = irq_find_host(parent);
+	of_node_put(parent);
 	if (!domain)
 		/* domain not registered yet */
 		return ERR_PTR(-EPROBE_DEFER);
-- 
2.39.2



