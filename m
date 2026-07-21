Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C808946C4BC;
	Tue, 21 Jul 2026 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663868; cv=none; b=cAKlnMPiHS+YTT2secc59V1hha4j55YHhpDkKz8fjDriJF35eTH8qJEwUCwLtUWSw5bV6NH1vON/xflZzE6QgBCemxj0T057WhS2drgLtZR6iNxxrW0WV7MfA7dxjM/WavDF+jIkJpQX/d/imQ3RhQPWa9r6V+ngSAPJ2PGbE8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663868; c=relaxed/simple;
	bh=A/YZxn4003Pv746xZ1Le5G9Gns2YvLvRk7lEQTHNKBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnUAcOaPKTTzs6hFY/JTPX9Pgbib9e1tItSkUsD8eVO9cICop+aUfn+NxKOOqd8zBRTg0RtmluLwHlB3cHvLqvqlZEK4mDgxLyuP7kB14/74+0onLhYS5piSleBR6H0xh8v2D7FKdrQOUFe2IWwjVPuiRteMVQDJjjR9KrOvOD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAxNY+16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAxNY+16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B221F000E9;
	Tue, 21 Jul 2026 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663866;
	bh=4w7/pBvuVYTqcuqBm92RX2WfHedvSyj0LL1S0xhlNs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAxNY+16+oNMTgtqI0uap6xg+tcpIDwY5g7j5BtwQ5O3dSgTKMBPW9eWZLUI7SNRO
	 JfpxGvKnXLJq5LMSv20qLcU/nu859P5QfVCsyCSUUJjtMaMSmV4UykZXcrD0iQasYB
	 6IlK22AJlMnVRUuqvl8GzFjOEYPU8vAuMEBxDMtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0986/1276] spi: uniphier: Fix completion initialization order before devm_request_irq()
Date: Tue, 21 Jul 2026 17:23:49 +0200
Message-ID: <20260721152508.081295487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


