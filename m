Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774662;
	b=PxnvxT/HkDnP5AWH/kIG19UksFTaQvfoc5rnBnqytUNMd6Ra5WInnEqcDoXKxGkNn28J
	 lD9q93SfNkVaqwwtse1eXJQYmuvvO49SAuUHB7m+8sJCBCsWFbGTjZvr22MlH4uRGJjZM
	 xsE8NYd/lRQ25ja1qIL7M5crWW85XkbVYk2L+7J/GbyjgKqA5P00XI1UeZUogMLlYMV67
	 weyjA67rAwSOLsBUNAgh1ALtCgqsj+/2yDK12ULPZRvbKp5WFbAwt9l2lJYt9SeDN6jec
	 jtYWYo0DNutZgIHir3JMxtpEGL54kSKofeVX3IW2640LBjCy1/sjXnI1OWm7vchBLYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TGeeB+ZSa7VeqqpZDVhtNwlDOt/izxUp3bxFqoFUEmc=;
	b=2CEAsRRrgzEWiWweBCUafSQZKxCQ0BLYCeo8C/4UCZZ51IwFytOlUEy+O/P7qZMnE8uE
	 W23TLRTFHnq1CNBYTYIN8EKFPWnEq+xbDVdW7Tkw6qhFNb8W/l5CF+blkMNULn/UWfGvw
	 2mwNzarkmzsGkkHYfAzRis3SWuXREnU1SKJGJGKe/xPez/NcDZaXuS4YMaE+Puj7S59kk
	 OvQVrDjUReKmDBxSNDGVJ6ULi8CRf+1wQMDrH+uci/JhSZY25BkHsqbVH4Zm0fG/rp3tP
	 DNDWvfKGKPQGXlcvH1mkQskFM9Ko2vt06W6qAtiCUpVmUkxktHwsYWZwv9DKRFJgyCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFuC8iyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3650F606A31B;
	Fri, 23 Oct 2026 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFuC8iyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863071F01825;
	Fri, 23 Oct 2026 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774662;
	bh=TGeeB+ZSa7VeqqpZDVhtNwlDOt/izxUp3bxFqoFUEmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFuC8iyUljRbKOk9EOLJ3FfOE2vWEw4dzIpL5oQEMmGCA0797KVr9gdQrnK4kHMRb
	 oeiaNAg3rEoeKJpI1ea6P7LhED4AtlMIloJobvRPXKrDTefqWYEE6zup/Ou1TMaYcD
	 +v7oDFMBMSmmP263DUCPF7aN/abvEj+OfqHs/BAA=
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
Subject: [PATCH 7.2 089/242] gpio: mxc: fix race between gpiochip registration and IRQ domain setup
Date: Fri, 23 Oct 2026 18:38:51 +0200
Message-ID: <20261023163715.883473419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



