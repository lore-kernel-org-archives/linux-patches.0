Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217234;
	b=DqAJ4yMMJSWnype7t6KQcLyXnqM+c6rfsG+ntocGt6g8/POB2B253Qq8uqbMZYspqS5M
	 dhHvyjFMnb22i4qjGDTuS7FwVbE2PS6AtSA/tAvn2qD5CS31h+YumEQKN6KG1ubCI67DU
	 VpQrGK5WebAyyd6iok73bTgXS1m47OwHQdHp5s4UlHTj5Zc36RJUWwDxjfuC3zipClWlx
	 jSzgQOVG/ajLpMhRgQmLFsG8D4jSB4ZiarZ4NlnKaqMGMbkH3qRvGUGSdXer7n7d9bGdC
	 GrW0J4FQ/TzL+vTzPy8oKZ0lTQiJZB0qeDav6bzKu+MTXowkizI/t5Yssb/MUvUXIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i3DX4JxLCSoMcAdwHhBCeHd8cCTr5qdB6EqBKWLdanI=;
	b=TdnLScVHzpT/8aC3y1xfWfYglSPRkm8klBawM485T3DM4qXH6cNiQNN48IReNnBNo3K3
	 rws+HoJ2knPl1lIf1ctGfGmbfxibIQvNjkAMly7QQP0MSlj3rXb/zZOdzqWafp68MHKHN
	 LwJePXJsx3Dy/Jhh7Ytgibq0MKy0X0IOf7feZ9BUbN3KMgEXbY1bNqRVXAnk/m+hDxbH5
	 MI+1icqDbVEiCDE4YrlA+V2KI2r4h984OxiiEM5NooXBCdw/tDinpDOJMmwIN1D8F6OQH
	 pH5J0AR9gPOc8fXlRbw9kBS6bw5U5NvEN7LPRj6IZ5UVEotSwMlhk99DMKLG413DigA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eenOBYdO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683FA606A31C;
	Wed, 28 Oct 2026 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eenOBYdO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668991F01828;
	Wed, 28 Oct 2026 19:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217234;
	bh=i3DX4JxLCSoMcAdwHhBCeHd8cCTr5qdB6EqBKWLdanI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eenOBYdOC9YzZdyx8byZmD77yInUU6apk9BThyXCTC5X315Ok6JGfrXS8fA8wf/6m
	 nJ31UWOcyxs9+LnudVG/xL9b46SK/lfLarJNFC7UHNlBmzu/zTcXSdjVzwkOhC9K/c
	 aBp2yqsO/8NlU46NXutUjeUDjpS1HDDyKo2xyYyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1788/1887] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Wed, 28 Oct 2026 18:04:44 +0100
Message-ID: <20261028170540.139308866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted i2c->clk to i2c_dev->clk within the existing error-handling context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-wmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index 7d4bc87360793..a1716dddfca8e 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -391,7 +391,7 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	i2c_dev->clk = of_clk_get(np, 0);
+	i2c_dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c_dev->clk)) {
 		dev_err(&pdev->dev, "unable to request clock\n");
 		return PTR_ERR(i2c_dev->clk);
-- 
2.53.0



