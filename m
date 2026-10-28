Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211909;
	b=PSXs2yDatsI+q05Dl0QWPlHvrXgkpZfstGY+Dy2zhuBE73w8l6VAdcFuoiETBGq0K0Ib
	 UdEylYvdyE8CDUrKMUaecD/HqmvcqIpr8eVn121nsVF5NZMGwFIzWOTSkXgynyMrJqXmo
	 rEN82kD/zqCB/ch230Km4mvZsj7P1UBeJxDHZKefhC+yFlrVt5/4byxHaXF1rZq2C2dRo
	 mPNmiHiL1a50WuG71cRoDzhBL/mHbC1EyxNWmEtWyskX9QrsF3HoZ90FymGhV2s20jO71
	 5sAeFK/Lz5UxU4/iZ+3/iTRcXgy97ljLaqqxsARlDDMm94KStMaPHn42WF7Rk2Em44Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JQ7ALKWJT1IJS337O8tFALPk3gQHy4XfZzv7klNaU4=;
	b=0NWMgTlfKGt9c23E5HRmHzprPL9O5nesI2JUKgbAaD0m/sRiikrjn4hydNSkGaeEyFKA
	 pMfI+eiZ2JexlYooEGg+TeGleeNI43GE+XmrdC2d3VEUnDe9iIWM9UCX8FsZdPH4oftN0
	 /HSnc1nsKXu/NdfwvKBAY9RXWSleb1NHQFp32Fd81JWLu2PXgBS1+3FXi7MlroLDZC6Ge
	 /1hs0HPsB1nFkS3guCN3gow6xKrUlZOr+fzQvPIKWXLNUVGDsWDA1NfDDBIu4YJ3mN8dK
	 DZivKoxvwMbfKzGWpwLgbvxDNVpnZ8mQWEh0ZMhRIoFLLuvz7VUM9ysw/JXEHvixuWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViVXSo8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626F3606A31D;
	Wed, 28 Oct 2026 18:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViVXSo8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BB51F01825;
	Wed, 28 Oct 2026 18:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211909;
	bh=7JQ7ALKWJT1IJS337O8tFALPk3gQHy4XfZzv7klNaU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViVXSo8FZ2CNOW14EfO2JSINYEw85mFgZjo8wc3UYAcX5HRz0e9wx+uB53jMIt5Fc
	 8OJHdl4U1CuhlUhx3tx/J/7FZJGMp+xgevgy7RdMvPlYPB02DZO6AMDyUzeEnCKbWP
	 DDKpgBDjc3KY6yzLZP8sJ/Gj0CjZNzzWFoO7312I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 542/571] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
Date: Wed, 28 Oct 2026 18:01:29 +0100
Message-ID: <20261028170020.898434578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the clock assignment to use i2c_dev instead of i2c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-wmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index 88f5aafdce5b4..33d085e564f57 100644
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



