Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017929;
	b=AwjpmwBQxc3T1VFjTSagO+g5sn/+9Qes2k6aNqKM7VMctxQKZ5iWH1cI+yVFGIh4Qscj
	 Y7S8/nNq9BL4JkXt/nL1YtSjbXwV50+COfC4JZpoXM3ZY8JGB3pLTb+9evNWM9Zv4/agT
	 YUw3pHKLMng2NTNLewmbuC8A2B9/NAnN6mZq8L5DB8Bff9RXeyXZUHVhQm7SGQfQs2N4n
	 Y0GdrxyWvj9YiswHUl6tGDhHgkInf63uDR20dr93VfBdqGTrQgp01ctOF2v70Xlgj05Xn
	 9aKBXZxuwc52t1+c+KnzhA/XP8AR6pLD0F+luzFNuAkafuIiDVNfTB+DqSHZLhQh/pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wa9YsBb5p93d7mXGwwbsWVR77EnBef4SflIhqtIEHAE=;
	b=f9dybEy6l173KMAe7fbPbL6y6XsczFTQjnWLODewYJPp0SS1wneheDtYcHMV+0KdvKU8
	 x0arAZzHYfrSCPPVVWf2NSGx4LyTGKVOhsZAaBQ6BewOKWspQqkNVsnuCLcnSUo0JxI7M
	 93/ZxfQCM1YYmN/Zn9o3ldAjLw18qfmz2Ol4Q1DlWewjj441Dp88ceUusBUUbVQEcuHKg
	 KUbQ//zJlXhzp45R/rBkJKLUNxm7XvtbH4i157kT4tHfIGhZktSfMTMaK/VNdYKmTILRh
	 W/SOr63XW+FwL/y9soKJGg48YIwHXjqkTzBeqxeb6fxyXAvv/m2YyNdlECqEKvadqyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYFOTpWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127E5606A325;
	Wed, 18 Nov 2026 16:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYFOTpWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C3E1F000C6;
	Wed, 18 Nov 2026 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017928;
	bh=Wa9YsBb5p93d7mXGwwbsWVR77EnBef4SflIhqtIEHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYFOTpWu8JQ8tpdV925glZrGIUbynYlwkaBbLiZ30Fg90hgHDL0SilbpRnyJgAO7L
	 XxKwkvtpiNNibendjPMQI4mp8CdFbN6ek7D91d3m3D4wi9mh8EaBdko/dyc2MxRnUt
	 QioyRjH1zVkZkTMqVap0nY25BPUog+NX8Y3DnJ9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1060/2651] pinctrl: nuvoton: Fix clock reference leak in ma35_get_bank_data()
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118150326.141186852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a854aa8e550502ef05c2836a4b426141d735bed1 ]

ma35_get_bank_data() obtains the bank clock with of_clk_get() and
stores it in bank->clk, but returns clk_prepare_enable() directly.  If
that call fails, the reference taken by of_clk_get() is never dropped,
and the driver has no other clk_put() for it.

Drop the reference when clk_prepare_enable() fails.

Fixes: f805e356313b ("pinctrl: nuvoton: Add ma35d1 pinctrl and GPIO driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-ma35.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-ma35.c b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
index dafa85c105a13..a79ebf4be2c3c 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-ma35.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
@@ -557,6 +557,8 @@ static int ma35_gpiolib_register(struct platform_device *pdev, struct ma35_pinct
 
 static int ma35_get_bank_data(struct ma35_pin_bank *bank)
 {
+	int ret;
+
 	bank->reg_base = fwnode_iomap(bank->fwnode, 0);
 	if (!bank->reg_base)
 		return -ENOMEM;
@@ -569,7 +571,11 @@ static int ma35_get_bank_data(struct ma35_pin_bank *bank)
 	if (IS_ERR(bank->clk))
 		return PTR_ERR(bank->clk);
 
-	return clk_prepare_enable(bank->clk);
+	ret = clk_prepare_enable(bank->clk);
+	if (ret)
+		clk_put(bank->clk);
+
+	return ret;
 }
 
 static int ma35_pinctrl_get_soc_data(struct ma35_pinctrl *pctl, struct platform_device *pdev)
-- 
2.53.0



