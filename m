Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B67A3D69;
	Tue, 23 Jan 2024 02:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975792; cv=none; b=ULmxMEYqOoN5ab9IrV5iSKTkcFh6Kew6R7edUabyLu4COYqNPXvA42DbeWuN2iP13yzDrABCEDp+feCLxBexEd636wuvQypH3DOqyV3wqPNCWlHPud8tiFcGRJKj87yWpGkHZbkExx36LQ+36yV9NlEFzFUOo3LQT47wtNHq0Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975792; c=relaxed/simple;
	bh=4Tm5IOmZm8KtqbXDgK0a8Bend+R5G2OCFqlG6AR+ceQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3yi5aCOCHAiwk2Z4345sQRiQYxEEVNWs8qs5xSTiEFHonehgpeQYOjLudzuJuUiTAc0AsWZMMDF3FY9R2UEhUsC5Cxoy3hAaSsX6fJM91XI8V3gCed3gT4PJMhUfx986kBv8/21nA2lc4B2Faq9u50ZMYiGMPS84Wprbjob+UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+tPotCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+tPotCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C735CC43394;
	Tue, 23 Jan 2024 02:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975791;
	bh=4Tm5IOmZm8KtqbXDgK0a8Bend+R5G2OCFqlG6AR+ceQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+tPotCbLPUVSeiFw+wbsevNnAgNxZ78UwxTerun6Fkk1K4h81BD5udU+EwzDRI9x
	 PNPL5r9H/6jqAcaenYg6EsYf4TgGtNS8laWx67ASIHFdevWBGh5bROht2Vf7RoWG3H
	 yKxx7owtmMm2DjWY8oJHevij5RBg6Scq2vEPhRzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 549/583] gpio: mlxbf3: add an error code check in mlxbf3_gpio_probe
Date: Mon, 22 Jan 2024 16:00:00 -0800
Message-ID: <20240122235828.943758160@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



