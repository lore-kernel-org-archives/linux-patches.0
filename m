Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0143375D5;
	Tue, 21 Jul 2026 22:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674443; cv=none; b=jvQT6j1YMJsdL8Mk2vU01G/v2wSlgPACq3QheTRT7wDU+UUolJD0rLop/P+C7KPmuYz7hXML4jQ/BFthnzuoZJmOnrV2TGo2dX/ZDJ9AyjO/gGztetVFc5ooWim3JqlBhxlr5Pgwqai7X8eJnErwqw94BVE85eZ3VZzwj08eNCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674443; c=relaxed/simple;
	bh=yRAmbvkg19SD6tzuhRiK9z2oz6bhuQqy02c4A3XP0xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzpV5g1wqwCclCIULbeww1KPXZoJDRKjEqGT9UaMK/qsZnS22GIcVSnDR28GjNpdhb8ZcnTE4bd84NYrxKVTGdLhP7dM/F6KQsFTJ+VkUDdyZIYJkVBuD2U34l/7l/7BshjjFA4bqRZjCSopMjDUL7wJ2DUwzOx7bTqvoeK07W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPv6sEwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPv6sEwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED571F000E9;
	Tue, 21 Jul 2026 22:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674442;
	bh=IdFiP4LDVRoEmNQ4SzmWD0Yy+2YBWf/NSDciJ3nns0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPv6sEwlIuZ+cGL3hUuPk/jNYgRuFKXMmbWuXm3ujEjgCha9EYWvnvegMdRehu/VX
	 rFDglNt5cRR5kkGYmbbeaW/6GJVo1KcTz3lSZSRD0q1PS5SrzP4A2XK91SA5vPY4Kf
	 C1/TM5eVrLBJV11O5YqLG1Ll7/nq5KfPBQ932m/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 500/699] spi: uniphier: Fix completion initialization order before devm_request_irq()
Date: Tue, 21 Jul 2026 17:24:19 +0200
Message-ID: <20260721152406.974026813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 	priv->master = master;
 	priv->is_save_param = false;
 
+	init_completion(&priv->xfer_done);
+
 	priv->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
@@ -690,8 +692,6 @@ static int uniphier_spi_probe(struct pla
 		goto out_disable_clk;
 	}
 
-	init_completion(&priv->xfer_done);
-
 	clk_rate = clk_get_rate(priv->clk);
 
 	master->max_speed_hz = DIV_ROUND_UP(clk_rate, SSI_MIN_CLK_DIVIDER);


