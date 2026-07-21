Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853ED3B47DF;
	Tue, 21 Jul 2026 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667364; cv=none; b=MH6JmbzjMuBLhEJixh62VlM9dLc1JK6eFTjAd4TQg8iecbDorE3GpwmuLngL5J5U06a4f0zvEQ3SsLPN1xuXwPiXMzEYA4yQpz3VgQduf0DHFSlPX8ENrYQXyO7aPZAsZc+NF5EKeL5wnB+VbNhJbNDAvaQZYZ/ViSTIxP6hnfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667364; c=relaxed/simple;
	bh=qMOQV9KRFfaB3XRmoCUx1yxfzrwjoIvcTi9mnm6v8Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4zPFPqVdoFa40qz6eI4s4vzbLHltFSA2ZpfLbC98cwh5xv1PJ/bSk9eXJiJzeWBq2Jrx/nhKGXviupcnmQK9d2q/Kgde8N7sMNhiunfALbKjZTiycnV54/us8pSg5eELIVDaarMsgMkYMhApXv5+LqvfsLYX5PDFtMWXAX2pYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYFv3cRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYFv3cRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0E91F000E9;
	Tue, 21 Jul 2026 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667363;
	bh=jIiPbAuL477p9e+XYdh0mj3GYuFKDbfqZyMldVic+6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYFv3cRAvnQ5CVPGn6NBOFmpY5oNsUBJy/0SFoofNgx1gAzLSUVw3sDg7Fdka8Lo1
	 w9OjPNmFwE9oAjy/ePfNsbEbgV6QdAqs9rgtn5DH3S5J6SZ/3l/joGNB3ZIRCcTv1I
	 0sDq9JDGaOkfv08zPlIrsznRuq5u82mQUbRFjlqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 1033/1266] spi: uniphier: Fix completion initialization order before devm_request_irq()
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152504.939083198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit f3ad1c87d8201e54b66bd6072442f0b5d5a308ee upstream.

The driver calls devm_request_irq() before initializing the completion
used by the interrupt handler. Because the interrupt may occur immediately
after devm_request_irq(), the handler may execute before init_completion().

This may result in calling complete() on an uninitialized completion,
causing undefined behavior. This has been observed with KASAN.

Fix this by initializing the completion before registering the IRQ.

Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Fixes: 5ba155a4d4cc ("spi: add SPI controller driver for UniPhier SoC")
Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://patch.msgid.link/20260616011223.201357-1-hayashi.kunihiko@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -659,6 +659,8 @@ static int uniphier_spi_probe(struct pla
 	priv->host = host;
 	priv->is_save_param = false;
 
+	init_completion(&priv->xfer_done);
+
 	priv->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
@@ -686,8 +688,6 @@ static int uniphier_spi_probe(struct pla
 		goto out_host_put;
 	}
 
-	init_completion(&priv->xfer_done);
-
 	clk_rate = clk_get_rate(priv->clk);
 
 	host->max_speed_hz = DIV_ROUND_UP(clk_rate, SSI_MIN_CLK_DIVIDER);


