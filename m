Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773937;
	b=dOFPDjY+9dAhQkgv713dnOusGvT4nRZp0EEMLV1ddHBSUhRncWTq7yyfMgvHOPH0ip01
	 NqA9rX7W2B1U2bqF2mDD2GMUKXMKjtQkY4aIXYzNX4zmOtnol/BvcQB1dQOH7cPAW+nJ7
	 VnXKnFKNrageXzjrDlWAbWMsAHMdzIGQiaztEwLaRyQEIRr2hBEb+rrv0iPGk6F/nsD9i
	 7o7RHvf+j30t1RZg1N5FrU2lpo7HEjxyEAf12CGPVhB4x2uCm81pPt52UHawdwFJszmbp
	 eo+eTDyPt5iqMlMmOY2WXfOUjxH7hiOjgV8ZIPSGuQ0+sNNXxklyPLZl91TYFnsPeiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2xi3esEXytCnw8Gxf1wQnA7UET3a58tqMZsx4y8NKhI=;
	b=zYCqzXlDYUXRG+selEQKfmugxd7/9PgVf/bbnhJAilE0A9NUqg/iL0gkyjhhjd4N+2AA
	 oD8Ga6H2aU/kMrEVzFlIUHBAJHBCFsi/sO2sHjf4CvAJvbwhXKSJgpFoZvOhZGmAlv4pj
	 UFnRzrcvewqWZMHyay73qyG466qWofCCL4et4wBPnQ8PH0kPqVtq5+2r/tmHYQBvCosuH
	 sWwEOa39KAjhbFKw75nbCNm2rGNMgO3zdK+Ed2vIqQR+87tg8EIXbutXKZY+FDRKTAMdh
	 vlHyPEk/wpbeuoQ2R3Na2/oXVYhpvbkvQmdORXpcRVjvMbwlYjEXFE44SHlHFDXHZfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KK8mN1Co;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D94606A31A;
	Fri, 23 Oct 2026 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KK8mN1Co
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0461F01825;
	Fri, 23 Oct 2026 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773936;
	bh=2xi3esEXytCnw8Gxf1wQnA7UET3a58tqMZsx4y8NKhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK8mN1CojP2xh6/yloKpUj4IXHU1izX8Pu2i+o42uQKncKT9GIq9P1BrOU4H/WQKL
	 62AMYkAk02YY0PnBGwo6JFfHZjr2bRE1x0Cd/AedUgXC52Nb6AKkUHcfGH+8ixmEue
	 /N3CKs3hyI12DD7IT3FwR/T3DvWCt8YCcwKcKdok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/193] gpio: mxc: fix race between gpiochip registration and IRQ domain setup
Date: Fri, 23 Oct 2026 18:35:44 +0200
Message-ID: <20261023163715.788613977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 205cccd06e545694754e1bf8d626ea96e742cd8a ]

devm_gpiochip_add_data() makes the GPIO chip visible to consumers
immediately. Since the chip sets .to_irq = mxc_gpio_to_irq, which calls
irq_find_mapping(port->domain, offset), any to_irq() call between
gpiochip registration and IRQ domain creation will operate on a NULL
domain.

Fix by moving devm_gpiochip_add_data() after the IRQ domain and generic
irq chip are fully initialized, ensuring port->domain and the irq chip
handlers are ready before the chip becomes visible to consumers.

Fixes: d37a65bb4663 ("gpio/mxc: Move Freescale MXC gpio driver to drivers/gpio")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20261013-gpio-mxc-cleanup-v7-4-c4d769587d3e@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index e3a80f17d0412..32ded7b548fb7 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -500,10 +500,6 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 	else /* silence boot time warning */
 		port->gen_gc.gc.base = -1;
 
-	err = devm_gpiochip_add_data(&pdev->dev, &port->gen_gc.gc, port);
-	if (err)
-		goto out_bgio;
-
 	irq_base = devm_irq_alloc_descs(&pdev->dev, -1, 0, 32, numa_node_id());
 	if (irq_base < 0) {
 		err = irq_base;
@@ -524,6 +520,15 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto out_irqdomain_remove;
 
+	/*
+	 * Register the GPIO chip last: devm_gpiochip_add_data() makes the
+	 * chip visible to consumers immediately, so the IRQ domain and
+	 * generic irq chip must be ready before any to_irq() call.
+	 */
+	err = devm_gpiochip_add_data(&pdev->dev, &port->gen_gc.gc, port);
+	if (err)
+		goto out_irqdomain_remove;
+
 	list_add_tail(&port->node, &mxc_gpio_ports);
 
 	mxc_update_irq_chained_handler(port, true);
-- 
2.53.0



