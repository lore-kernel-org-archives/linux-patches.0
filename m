Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC31D3557F3;
	Fri,  7 Aug 2026 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117673; cv=none; b=bFP0LqjmfFz39l5/+jAC99O8pPPk1cqUscihqDuw9ZyP9/thLcGR2qblCnjtU8TDoMLjzjeRM0gC8POPBHZbzNVI33myeo1uZ21kdbJvO2g/kJoAngdj+bT8L20a6+R4vEcdUHqbtAthJzIWxGREf0WWWGoMvaUbLpVFy/3yJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117673; c=relaxed/simple;
	bh=/YL1VKvU4JKcsRRGwUMGTPfwFSCKtgnc7ST5oc80K+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jppR2i9BlIZFXx0g+SPE18I3Bg1U/ZlE9MjLvdfJoIv203UBq1XQdKRT5fstzJJzZzLP9+SNJzXgNcHzWQem/Mkh4R9q3LO9szaozrp4YpxFe8vHv6itZKxowX9tyfkxoszayBg0dO9K/fUAq0uNdLy0T/FEeB/hpHpQQiq7x5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqFCqc1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqFCqc1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458541F000E9;
	Fri,  7 Aug 2026 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117671;
	bh=2oPaecYzrTpGRr/cpDufAtRgA6Ct7hTDt0CowiNQuz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqFCqc1DE2c0NWOZu88+MHysKRRuzeZ4jFkucGY13/+9Y4IzviPRxReOADN0U1n3G
	 ZjsMVVd9dvUZvKN1dYHZV1wjfhP99OW05NTOG79s1aXG6eZL8HfDLXFV8lKZpttdgp
	 4B69OwNKKvuDEckoYiGiHzKSxxBtcFbsKgk57TzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Alex Elder <elder@riscstar.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 356/438] i2c: spacemit: request IRQ after controller initialization
Date: Fri,  7 Aug 2026 16:39:12 +0200
Message-ID: <20260807143435.561120581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit cdac670237258c8ca063aa8a16998f680d81b80d upstream.

spacemit_i2c_probe() requests the IRQ before it enables the clocks, resets
the controller and runs init_completion(). If an interrupt is already
pending, the handler runs too early: it reads registers while the clocks
are still off and calls complete() on an uninitialized completion. Request
the IRQ after the controller and completion are initialized, but still
before the adapter is registered.

Fixes: 5ea558473fa3 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Cc: <stable@vger.kernel.org> # v6.15+
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260723021140.2293844-1-lilinmao@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-k1.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -723,11 +723,6 @@ static int spacemit_i2c_probe(struct pla
 	if (i2c->irq < 0)
 		return dev_err_probe(dev, i2c->irq, "failed to get irq resource");
 
-	ret = devm_request_irq(i2c->dev, i2c->irq, spacemit_i2c_irq_handler,
-			       IRQF_NO_SUSPEND, dev_name(i2c->dev), i2c);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to request irq");
-
 	clk = devm_clk_get_enabled(dev, "func");
 	if (IS_ERR(clk))
 		return dev_err_probe(dev, PTR_ERR(clk), "failed to enable func clock");
@@ -755,6 +750,11 @@ static int spacemit_i2c_probe(struct pla
 
 	init_completion(&i2c->complete);
 
+	ret = devm_request_irq(i2c->dev, i2c->irq, spacemit_i2c_irq_handler,
+			       IRQF_NO_SUSPEND, dev_name(i2c->dev), i2c);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to request irq");
+
 	platform_set_drvdata(pdev, i2c);
 
 	ret = i2c_add_numbered_adapter(&i2c->adapt);


