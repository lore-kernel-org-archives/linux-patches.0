Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6302EBB8D;
	Tue, 21 Jul 2026 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666513; cv=none; b=iZilgYHJ2+P9HNtlJx2kWu8k57+hsNHSXpYZVHGcQgDEELt8kSF4xej/PeWxkSmQBDGxoGQyxSpRegK7atCNTokVmUYYna/+w/idJFJau9CIojDtlHAIkucS8qa84bZoqFvVyRdcKeziF1mwkUYO1nPqpKGXZCSnOQVb66FBsv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666513; c=relaxed/simple;
	bh=ak+KG7ZD6aBidBE8rogGTgmFHyZwsxp2t1cPHwnuR+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/WjSkB/NXgRnSfpkWRl+MfJFaOTyVK9ZEfuhcs3SflyuEoeoP8qoCXQLmlSnVj/U6OcZsygWI6DUrGGnOwu53x5mh/fa1qJETEmnYZJruAeK+ephbBnp6xguBLBzxLJdH/TGh2blHKQzklO9eQkLA1TFPtZkTSI2MggDbmRQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsmslUG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsmslUG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E381F000E9;
	Tue, 21 Jul 2026 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666512;
	bh=HqRWHzLyCv78qERH9OM+IS2+Ly4ols+r4PowXWLHXLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsmslUG+U1vkHHTUYXu3DiWgFAusmHE1SBm4VcDVqV5FiPRO24XwCWdkIABVxZM3U
	 XMU51UE24wWh5Z28yl4KYBYYGY/+EsY/PJ79Sv8RYYz1kxCbMt3mgieyXLKbPjkkaw
	 Xu/Qz1u0IdgLcg2uDsul41NeeHPbCZS4VNwAEk84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0711/1266] gpio: mlxbf3: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:19:08 +0200
Message-ID: <20260721152457.774257803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0482862a90169f4daaba0ed31a85d8304bf51e04 ]

mlxbf3_gpio_probe() logs a devm_gpiochip_add_data() failure but still
returns success. That leaves the platform device bound even though the
GPIO chip was not registered.

Return the registration error so probe failure matches the missing
gpiochip state.

Fixes: cd33f216d241 ("gpio: mlxbf3: Add gpio driver support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260615091918.43333-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mlxbf3.c b/drivers/gpio/gpio-mlxbf3.c
index ed29b07d16c190..a662989ff21e7c 100644
--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -252,7 +252,8 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 
 	ret = devm_gpiochip_add_data(dev, &gs->gc, gs);
 	if (ret)
-		dev_err_probe(dev, ret, "Failed adding memory mapped gpiochip\n");
+		return dev_err_probe(dev, ret,
+				     "Failed adding memory mapped gpiochip\n");
 
 	return 0;
 }
-- 
2.53.0



