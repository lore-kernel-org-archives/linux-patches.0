Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774716;
	b=rDYfm+8MkJ6Nip+oiNUHh1++JXd1OlT5JS3uznMRY0X4qBbPZDaZC6xwtWW6auYCYrBD
	 EzPO7RkIlr7P8On8g9a6tIIDlQX/p4RJNRaVb0SuKUBH+KIAB7djCAxq+q5KWC23I/0XI
	 zGyWv3ZFYneNlqtI12GhX2c324LBGl/KN+EStnSgE1/iby7I631ggy5KZivTE47bXOHeY
	 LaXuHQCfgBwTanqdWVzaXTrgcgbsI3T1U7/dVHc5yR8DtUdGRW9egFzo0IlIkgOFftWhj
	 DZLwV1DnHQV6IiXbHgiKI/blAekryhWWGNyJHPwWLobylctSXXiseo9+93KM5lMX3qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BR87p2nQDlbVSrjfrkhDwKkawVfPoPMNQwmcezsLcow=;
	b=eAi2Iw9mXfw7cTKMzXQnGqWx3oBers6YzEcjke+rnX8niEIxk+V9w+RY75cR2wz4OIig
	 AlYfIWSVGQrazaLHE6L6drrmw0kBGWB+iBUxyPtAO0VHBZHhGLnlBRBSaI8QNQQo1bXSv
	 i2rWKipCK2ZjCpG4ED2jv8s7iBA6mLr/HLWuoAGX/MwwKjDFRSiTftEueXNrNOA2+E3zr
	 hcy5tMd4m7VHnnEd9mDma/kojdNfGpJGjaq3Foj9FWzhtw+QsHwbfZAqURHX1LHtMZNoI
	 dOkfpTvh12D7NONPOFKp+1Nj77e9oRZvr91LHmWYi8/oEWG5y9fPotGjihZhoRynRGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KR9H5/QA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93B1606A31B;
	Fri, 23 Oct 2026 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KR9H5/QA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5F31F01825;
	Fri, 23 Oct 2026 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774715;
	bh=BR87p2nQDlbVSrjfrkhDwKkawVfPoPMNQwmcezsLcow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KR9H5/QA9EzJDUvR5H09+5HOMr4uQVjw1XYljgsOB2Md0VO5BS2ny/YW6IGQYaOjZ
	 M5rXYLMYLl1IYA+SzsmlQliQWL1KvStNSC1QrBQE117uA9bJUbc/PXdoR9RoTeOMs3
	 QnEujTELX4zWsuQH49zw7YeWqhRKWQeMj9ts+O9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 086/242] gpio: mxc: fix race between chained IRQ handler install and probe completion
Date: Fri, 23 Oct 2026 18:38:48 +0200
Message-ID: <20261023163715.811249877@linuxfoundation.org>
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

[ Upstream commit 38d44f78f041ffe60c8e2443b99434a199e7541d ]

mxc_update_irq_chained_handler() is called before the IRQ domain, the
generic IRQ chip, and the port list entry are set up. If an interrupt
arrives in that window:

 - mx3_gpio_irq_handler() calls generic_handle_domain_irq() with
   port->domain still NULL.
 - mx2_gpio_irq_handler() walks mxc_gpio_ports, but the port has not
   been added to the list yet.

Additionally, if any of the subsequent probe steps
(gpio_generic_chip_init(), devm_gpiochip_add_data(),
irq_domain_create_legacy(), or mxc_gpio_init_gc()) fail, the error
paths never unregister the chained handler, leaving a dangling handler
that points at freed memory.

Move the handler installation after all its dependencies are ready and
after list_add_tail(), so the handler is never live while the data
structures it touches are incomplete, and is never installed if probe
fails.

Fixes: 5f6d1998adeb ("gpio: mxc: release the parent IRQ in runtime suspend")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20261013-gpio-mxc-cleanup-v7-1-c4d769587d3e@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 7e2690d92df6f..e05f276a50e8d 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -474,8 +474,6 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 	} else
 		port->mx_irq_handler = mx3_gpio_irq_handler;
 
-	mxc_update_irq_chained_handler(port, true);
-
 	config.dev = &pdev->dev;
 	config.sz = 4;
 	config.dat = port->base + GPIO_PSR;
@@ -525,6 +523,8 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 
 	list_add_tail(&port->node, &mxc_gpio_ports);
 
+	mxc_update_irq_chained_handler(port, true);
+
 	platform_set_drvdata(pdev, port);
 	pm_runtime_put_autosuspend(&pdev->dev);
 
-- 
2.53.0



