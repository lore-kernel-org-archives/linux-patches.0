Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F54A4E1D0;
	Tue, 23 Jan 2024 00:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970278; cv=none; b=uiYBdKVGA735IxehlhjU9AL4YjF5YWx6Tlm38sUzSeyVebrsu0ibShaEXTRnl1hZnKnLtRrPjAKE/aWXJRKTl/2uMV6Jk3qUpDjfdxoQkKHKQw82Zn+MXbtw6LSZ6SuHccw2egySRoXBWfoCYxw7wu2oi6AwY+QyS4dfCll7VDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970278; c=relaxed/simple;
	bh=dxymMWx/Q1u2QHU/Vk9FfI3tfhU2YnUkHWFEiA5XAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQV0jQ0p0EpMjoBCjzXzhXq913jxGEPMMOIQO/yPF4o3Wp8dSiSCQmway9ehb+n7ieaMN43xfrr8ooeGa5tgS9MkqvtYdZ2h5zjjw6SbW2nmREIXiAiyr/1Ip8CH2fA8Xt+kkuS4r5yQdBKKqj0Br6Cuw8msPIFje+8u6yfdtD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idgIp4dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idgIp4dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B187C433F1;
	Tue, 23 Jan 2024 00:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970278;
	bh=dxymMWx/Q1u2QHU/Vk9FfI3tfhU2YnUkHWFEiA5XAXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idgIp4dcR/6LOTtvXMh0fiSy/bde+JU7hBHU+dqlPk59MYwe0kpRpQ6e6S3woydTU
	 doAS/HeJhuHFsxLTIr2EB7vET40zl7yLMeW16ICJ+tRJAjpduFNmnQ/51IuviopjQ1
	 cBzPoLkkGWdrchhN2cqP2vWSceuZXgiup/W9x6+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 607/641] gpio: mlxbf3: add an error code check in mlxbf3_gpio_probe
Date: Mon, 22 Jan 2024 15:58:31 -0800
Message-ID: <20240122235837.236811536@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit d460e9c2075164e9b1fa9c4c95f8c05517bd8752 ]

Clang static checker warning: Value stored to 'ret' is never read.
bgpio_init() returns error code if failed, it's better to add this
check.

Fixes: cd33f216d241 ("gpio: mlxbf3: Add gpio driver support")
Signed-off-by: Su Hui <suhui@nfschina.com>
[Bartosz: add the Fixes: tag]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-mlxbf3.c b/drivers/gpio/gpio-mlxbf3.c
index 7a3e1760fc5b..d5906d419b0a 100644
--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -215,6 +215,8 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 			gs->gpio_clr_io + MLXBF_GPIO_FW_DATA_OUT_CLEAR,
 			gs->gpio_set_io + MLXBF_GPIO_FW_OUTPUT_ENABLE_SET,
 			gs->gpio_clr_io + MLXBF_GPIO_FW_OUTPUT_ENABLE_CLEAR, 0);
+	if (ret)
+		return dev_err_probe(dev, ret, "%s: bgpio_init() failed", __func__);
 
 	gc->request = gpiochip_generic_request;
 	gc->free = gpiochip_generic_free;
-- 
2.43.0



