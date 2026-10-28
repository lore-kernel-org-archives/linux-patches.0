Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210190;
	b=pfhEOLBOQu6zbc6sB12VtY4xkBteSlmsk0e5fTj4rUOwc515/VYvV2e+eyqt1in2IDHw
	 G0LxM3Uf9QredS9iqBYu0NYZIdFgEy15zNQPGo91xL/2+3Ccw4JpYDh2K1+LQydqR3PF5
	 x2MteDiclawRgaKl0ILLVOLgE1PN3UdEX96KJPJV7U+G2KdKt5zeXw80gjHbwvM5aZsJE
	 3PhapznMbz0+oSyF1QlJRfpX0eoLXlmf1fUnbMvURb6B47vwz+VNafXgPabZGIUzt0ai+
	 JeXft05HJ9GUZOrL+B7zmgmRI4VgyVYecTXp6hhof0vxzqym8yPQ0AZotJ2M3b35gCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hFX5NXz79IN0ioEJ+zd4CONYUOkXQ/0zFPrc5CgUMoI=;
	b=4tRcSxcn93Oj/QXomuCgVfxuXi61i4Kji0QC/IMosA2FXHnTj5cXDVxVMVnZ1OfHVkbC
	 ogk5reuQbwCEt9Iam+Q7yJ82lj1ONClY+u2aCsfvnzJgFRCFmwER6fMt5p4wfnxi2rXdg
	 kJBflhkCp0AHa9rnU1Ys9hS83htkVgEPNEPP2wJOaFJP4tGVWWTWjUTJY9DNOj+g7NH8y
	 cf8zezDvwf8ocR6QjzjnBIeBszaTcR2KMmyZXU6fmqQf+3kM8hvcE9HG2oHeAjkAG9lRm
	 vijRvZFgWD3Kq6TOOh7TmkH++LimPOrYKjdKeVS/h4WQWIuQ3NrUTX2nznR6VrYTOuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIeN2q2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F93F606A31C;
	Wed, 28 Oct 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIeN2q2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1F01F01825;
	Wed, 28 Oct 2026 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210190;
	bh=hFX5NXz79IN0ioEJ+zd4CONYUOkXQ/0zFPrc5CgUMoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIeN2q2ZtJ3qib+4Nx50kthlgl3f/KcijLZeftYW3lMyw6H5cZbfQ/j1Uc0Ff8aKO
	 ryOxO6wmB4Hvuz7xUs7C23F1eat7gLmJXhM6nkrk+6Q+/7S37ynY7bZ9qKRnLpjauJ
	 I1DlLl0tDSTYCVIjPq1cav3AyziMXZ7eynk5r8KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/168] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Wed, 28 Oct 2026 18:00:45 +0100
Message-ID: <20261028165945.668256458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the change to the unrefactored driver using i2c_dev instead of i2c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-wmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index 76118abc6e104..8682143e15acc 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -389,7 +389,7 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	i2c_dev->clk = of_clk_get(np, 0);
+	i2c_dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c_dev->clk)) {
 		dev_err(&pdev->dev, "unable to request clock\n");
 		return PTR_ERR(i2c_dev->clk);
-- 
2.53.0



