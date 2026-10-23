Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774721;
	b=Bq7Mme3Kp2Dx3pc5UsHmAIeyhvwoiAcAOFwwoDzosAJRJjkwmRrPxemeNpMQme0ZmolW
	 L50dae3xNJVCoVBAygj8Gf/YW6GTC3+7Zve3UQE3cjXlf7Z0s1rxnEfxrgMJ0JJxQj5+8
	 BWaOdUjzw9U6wakPi4Zla9G+HhA87mdFQ9gdeEUa3z7BXA3WvNLprHtkayn3JsvXI2jIB
	 +yIct4io1VK7t2aNAyMHSV0OsG75ty/0Z7hBHI3o4J1UEk4/Cu6OIatBmXVDEKiOWO8sP
	 AMOkkHjRSoTzvUvbvrzOMtiaWZ4511cNiBz9+NPdJZUZKtg1p6qYgn40B6TfVYRYz8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/59uE8/+wr0xmDPO8c31a5v4VtZfwpsEFwmT7razLbs=;
	b=VW+UhZl+B47INGM3Xeat42GZflpCdwSssS91mcQ+SgelxYCfETuWmBA1Z48OxtdB08UO
	 1WUXH2z4Y+n1ubhnLAQWTxospYmaX0YFVac+yFMufRsZpOVTKQrTk0S8jiGU7NHyz4YtF
	 B/dY9IPufG0mstJg0VArf6RHW44dbyO39Kv2sJfEXtpJ6fifewdXlOcHfdsT+Cu9r8aLi
	 eFi5DshVAM00NCo4r8eyX4H22DwaSPhzeUsPTiPBIcifrTPSRABpFjjOGelDBNoqs9jnN
	 qe/0NhiWftTSQm42v8FkqTqwJ4aRqCx1j6dp4dgbQ46/tFGiJfic8CO7jUL54exOCnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XATXgP4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F099606A31A;
	Fri, 23 Oct 2026 16:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XATXgP4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC91D1F01825;
	Fri, 23 Oct 2026 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774721;
	bh=/59uE8/+wr0xmDPO8c31a5v4VtZfwpsEFwmT7razLbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XATXgP4Bx4v4vrh6DBa9OhcsUpgs5+vFx7E2IkqcJoVEwzIGHPNXoAgaKZR7Ltat6
	 YSUmfEiiu2vhQC+HK8YcibzJ+RZ8/GJ0C5kFBJ7fpa2RHxu9eGzmeAysRAh+ErvABD
	 pFlZkNnzjs8HqLLIpltIBs4+Lopv+iZyFHHMhyB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 137/242] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Fri, 23 Oct 2026 18:39:39 +0200
Message-ID: <20261023163717.018719926@linuxfoundation.org>
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


