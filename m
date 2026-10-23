Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774021;
	b=RyItmLbGZk9Aqz4bj0eAucfR1hHLD9WghzmEU+jRpVa6EcB9RxFyZO4Lj8lafT5u9Zfu
	 MBS2EcvjRzIVLkpUfjk9deWZzez97RYuYYN/z9NCin2pyiP2fsldNkR87O/oq+2hcIvfu
	 AY5/JQvb0WL7lZF0vThR3/bAFMw+NX8juug2RjQ0vES2E3seaf6EZM2ycJSiRJiHADTsq
	 JWbovblsUuf4bxl2IOyECzLTIApATJU80useqdJzs5hfBnbfDPoryYsWCZrXBMPle2G0v
	 IH7d9OLjE2tzCblKL6D3oqEilAxgALtrRo02LhG2PAOqd2WRDlz7/7HIHfuuvtTUN2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mWVmfcBQLfezTWLiw+KweI4j4WWzdgI7pnsGRBRCDAI=;
	b=bUpC9+GgqLx5KrfXiBd+CzxqbHnIPjO70NE4i0ZWYnV0i2pOBSWCWcpzrExpI4WBy+YF
	 T2Rc3B80+g88Bjye/Pjk2qBnWMr3qQ+gzC1Ul3ZHmFyj4NGtCcZfexdYfprpqr1wA23r/
	 BJvUUs7K9Wap0IIKdabPdqu50Dub5oSEuwK0zUpmcHMbC1wtefRY7IyyofUoWGUlwdfom
	 7b4mK7AfZszylalkfkq3O8dkfF3++xEMOEyxrvMjcoaz5uxJwz1qXmJ7P6YfqBsn8jn1E
	 LuJKo54XkogstLpMrP5E+FjeT51EIuGpF8A6+6wRCEYgcyTBaaKxILy6NJPA5iMNZAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kof3J8Ug;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D065A606A31A;
	Fri, 23 Oct 2026 16:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kof3J8Ug
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D611F01825;
	Fri, 23 Oct 2026 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774020;
	bh=mWVmfcBQLfezTWLiw+KweI4j4WWzdgI7pnsGRBRCDAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kof3J8Ugl74qmxhhLtauZaM3PfRYRi6NcrcTgcPEhfHRes+9rh/kE6WPvkRzodseM
	 yg0KemG9r+Qg81iI82FoFeCffyaNFGftsFR0qN3f4tK5mAxD2jBzqO28EKqTBuRSPL
	 Q0qMAt0G/52VruGCOpWKd07uwSoByrPhveQ/sK8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 092/193] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Fri, 23 Oct 2026 18:36:09 +0200
Message-ID: <20261023163716.382072314@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit aaabefc79b0ff0018e8e3832169bbe359d0551fc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-viai2c-wmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-viai2c-wmt.c
+++ b/drivers/i2c/busses/i2c-viai2c-wmt.c
@@ -117,7 +117,7 @@ static int wmt_i2c_probe(struct platform
 		return dev_err_probe(&pdev->dev, err,
 				"failed to request irq %i\n", i2c->irq);
 
-	i2c->clk = of_clk_get(np, 0);
+	i2c->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->clk),
 				     "unable to request clock\n");


