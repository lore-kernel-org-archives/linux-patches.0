Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC77474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7574C433EF;
	Tue, 10 Jan 2023 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375600;
	bh=n53qNVpwsShEcDcp0InQiGVJ7v/tZlALFobTjaxJ2+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7gXQGemGaP4MDizCqzkkbb6kjTMleUh8QIL1xtIs8RmUeC7brOrglP8233JoR1fQ
	 g/8Ol4jBIl7To2I1bFXZV81Fb/LNavEQ430FNW9dSZwM4blFFUaaG/+AdwCpsrqkOk
	 t9PZ5dXX3N83rYXjYZoSbNm0zls2V4yjMsxkpZUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/290] gpio: sifive: Fix refcount leak in sifive_gpio_probe
Date: Tue, 10 Jan 2023 19:05:35 +0100
Message-Id: <20230110180040.405647993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

[ Upstream commit 694175cd8a1643cde3acb45c9294bca44a8e08e9 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 96868dce644d ("gpio/sifive: Add GPIO driver for SiFive SoCs")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index 7d82388b4ab7..f50236e68e88 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -209,6 +209,7 @@ static int sifive_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	parent = irq_find_host(irq_parent);
+	of_node_put(irq_parent);
 	if (!parent) {
 		dev_err(dev, "no IRQ parent domain\n");
 		return -ENODEV;
-- 
2.35.1



