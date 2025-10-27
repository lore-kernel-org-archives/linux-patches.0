Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D732D9EEC;
	Mon, 27 Oct 2025 19:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592987; cv=none; b=SSCkJZV1MI0n1O9RgXPw4pJvoTMJ7qNLgM+iJcejZcAYosOABjcClOqsw0sdrJLRIZlyTPNCU6bmijTwJ52Z1gDTkeQjGNamTxDaPIj8g1ek/rVqEHl0eTTm+RiIai7vdnssd2BAfOkJplsWsVd9cuQSfigigQuz0TnXCJO7jfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592987; c=relaxed/simple;
	bh=4cztcUXbbBz+Cetgwvxd7OJ0noM2NvLPtjL0ceI/t1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn5oj+c9xgfwC9jkUWTa6bW1bT4029AIhS/QcMqjfdrDEFim5YTmcfubmILoBVk04LkSKXHyDF2fjQUCAuNKgyFCnNxk6zcUbrmOKD/tRIHjh/ZqKKBxs+b8MX2bXVlQmiTbe7kiFdYVAo5xS1+OY502szp5zpluIof2TPqP11g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOvfH2j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOvfH2j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2549C4CEF1;
	Mon, 27 Oct 2025 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592986;
	bh=4cztcUXbbBz+Cetgwvxd7OJ0noM2NvLPtjL0ceI/t1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOvfH2j4QKfEZz9EBmJkcAMT8gOGarsu+8dKcLmFOBJxznfhiWp9h18MW3huSOlkZ
	 wU9rbUIfCP0uMhqvW2SAOfaA6YtzB4E9K4XO8JQLFIxmfZF4XJq1hi67IovuPZruoo
	 j5355gRBzhDqEe1ybzOPyhHFeRscktEcE0Iz4rN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/117] gpio: ljca: Fix duplicated IRQ mapping
Date: Mon, 27 Oct 2025 19:36:53 +0100
Message-ID: <20251027183456.378201173@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4c4e6ea4a120cc5ab58e437c6ba123cbfc357d45 ]

The generic_handle_domain_irq() function resolves the hardware IRQ
internally. The driver performed a duplicative mapping by calling
irq_find_mapping() first, which could lead to an RCU stall.

Delete the redundant irq_find_mapping() call and pass the hardware IRQ
directly to generic_handle_domain_irq().

Fixes: c5a4b6fd31e8 ("gpio: Add support for Intel LJCA USB GPIO driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251023070231.1305-1-vulab@iscas.ac.cn
[Bartosz: remove unused variable]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ljca.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-ljca.c b/drivers/gpio/gpio-ljca.c
index c2a9b42539744..c3a595c6f6c72 100644
--- a/drivers/gpio/gpio-ljca.c
+++ b/drivers/gpio/gpio-ljca.c
@@ -281,22 +281,14 @@ static void ljca_gpio_event_cb(void *context, u8 cmd, const void *evt_data,
 {
 	const struct ljca_gpio_packet *packet = evt_data;
 	struct ljca_gpio_dev *ljca_gpio = context;
-	int i, irq;
+	int i;
 
 	if (cmd != LJCA_GPIO_INT_EVENT)
 		return;
 
 	for (i = 0; i < packet->num; i++) {
-		irq = irq_find_mapping(ljca_gpio->gc.irq.domain,
-				       packet->item[i].index);
-		if (!irq) {
-			dev_err(ljca_gpio->gc.parent,
-				"gpio_id %u does not mapped to IRQ yet\n",
-				packet->item[i].index);
-			return;
-		}
-
-		generic_handle_domain_irq(ljca_gpio->gc.irq.domain, irq);
+		generic_handle_domain_irq(ljca_gpio->gc.irq.domain,
+					packet->item[i].index);
 		set_bit(packet->item[i].index, ljca_gpio->reenable_irqs);
 	}
 
-- 
2.51.0



