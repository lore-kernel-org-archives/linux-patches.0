Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D839472F98;
	Tue, 21 Jul 2026 22:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672487; cv=none; b=kBvooajn8erVEM6Ts/HLOen85NEmCRFUur0mDpoeb+pLcT1ZKACC3Z/YtAUld58jP+bLvCpycmltTKHWKxZbNSTnaMf6VrpgFjH7wPhV77p7CtbPdwAhHPp1gBr98AiBSi8oYPhr2pN0KXhqUR36iNZGNxxWjwFqRirpLsRYU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672487; c=relaxed/simple;
	bh=aTEW04Nid5CpY8Ch76cIJ8WQw6Kmpza/b8SCJZjFYoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co/6+5JezWKfDEkiaRbtw4LonzpCd7NZagpIIz9iVugZyjPzop2vUDGReWfWjuzlU28AeJbeSS9TpO2RBRe3gO+xcY8gvK61J1OCgOitp4EkEWhwip3sj0vZTZjGeq+GBCcJ/N8MFDejj9jJn0RYAWwFyYVLUZmr4lYLwCnuHSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwwC0fX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwwC0fX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E80B1F000E9;
	Tue, 21 Jul 2026 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672486;
	bh=BKMYoQ7krk8uH8k8Ne6EL3vShu11472kPA459DDiPK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwwC0fX8oOgiyReLdgg0kenREyFAZEwrvNfpVxreW0mMSb/G2s2RWEYK7Sm6G3Npl
	 LL5RRVjGuLYMss/BiVGEU0mSQo2nGGLt0FyGCL713et3JPzNafiJ/tRHS3vfa7XVQv
	 ecTZ+6yEeZt8mHt8sHXoO3y4wjSZxvJ3EdOHP6Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 644/843] spi: uniphier: Fix completion initialization order before devm_request_irq()
Date: Tue, 21 Jul 2026 17:24:39 +0200
Message-ID: <20260721152420.555113376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


