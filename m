Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207812;
	b=Gyc42I6DULmzWDdwfbAEW8fERB5G8ChfCn1ddkt7CZnqjCpES2wbQOkLP6xW2i5TqsSC
	 z2gu/0+28o/4vIqbkKg6wzQKrmKx0kXx3+Yqd9KEnZqlN5IG6+vUvZIH6c3+3vMh15wWg
	 lEY1kFiDrzb9t/TBVZcqmTXCCFzKkQsq9Nm9BtTxyLIpu/o9ePLbJFqcPdKq+2qnn8U56
	 ZytT7ECb/rZ/AybequzMV9w/J/9uiEBccVb7yb+k4bOJBfyh5otSJ99D/+VFYeBVqvdbw
	 dW15Syc2hNmqnHYRlOAQ37E9ztnWRr7K+WH8/hhSWj4W/9XyKbUBpjkkqaOqgMn1dig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rOoj91GAyrRVVKIE1VTTpVMSCBtq5nY/7AX2fiSkHBc=;
	b=y6dO5qSrPfyy2kozVWd898VLB02CzAy364FRAPrueTTMQ8/PJqiHE299xCkMdCiJ6eKY
	 kToLYjR65M38iMDmRIUBhqTVf2IYLJ0SxD3KGFDSoESdzLhGiOUSLhPa2gacqM8M/nFqR
	 +GAaXh5OWJQKI08RNsRJdv1ell3sq3FXCD9/aUBtW9/npnjbQACd1/GKwKLCkvvz7f3ZS
	 rChzYBf0jIHO2PxqHqAv/7sTB9w7jpdxaoXFmcPpHdWi130b6rSnXgRhjI/VTt2QcqpQ6
	 uxuB9AtYF21ntYoa60+3R+ti6cTQu061R1Kwj1imYwr4+tJz8atd2dqv5gFuH5g8EmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzBlbSQi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F93E606A31A;
	Wed, 28 Oct 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzBlbSQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B9E1F01825;
	Wed, 28 Oct 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207812;
	bh=rOoj91GAyrRVVKIE1VTTpVMSCBtq5nY/7AX2fiSkHBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzBlbSQi//UFvENYNFdb5+gRkwWCLH7b7AYnp0qgC8nCmknwC6L94NJrLDDZy7y2Z
	 U/lhxaYfhUIOJtgKTFqeyjgMStpMQ7jTLFEYfwAGb79SLPbLdwLItbxG2wEUEXf2bz
	 kRIncm2X7iScvM+M6ZNJVNcTw8n/lAt0Jg8oFFGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/247] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Wed, 28 Oct 2026 17:59:11 +0100
Message-ID: <20261028165950.916125612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit aaabefc79b0ff0018e8e3832169bbe359d0551fc ]

In wmt_i2c_probe(), i2c->clk is acquired using of_clk_get(). If any
subsequent operation fails or when the module is unloaded, the clock
reference count is never decremented via clk_put(), leading to a
resource leak.

Switch to devm_clk_get() so that the clock is automatically managed
and released.

Fixes: 560746eb79d3 ("i2c: vt8500: Add support for I2C bus on Wondermedia SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260916070631.1965713-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-viai2c-wmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-viai2c-wmt.c b/drivers/i2c/busses/i2c-viai2c-wmt.c
index 133dc41fe387b..029473ef3fc50 100644
--- a/drivers/i2c/busses/i2c-viai2c-wmt.c
+++ b/drivers/i2c/busses/i2c-viai2c-wmt.c
@@ -117,7 +117,7 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, err,
 				"failed to request irq %i\n", i2c->irq);
 
-	i2c->clk = of_clk_get(np, 0);
+	i2c->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->clk),
 				     "unable to request clock\n");
-- 
2.53.0



