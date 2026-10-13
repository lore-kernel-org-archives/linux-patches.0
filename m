Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDED3CA486;
	Tue, 13 Oct 2026 12:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894503; cv=none; b=pFaEIfh+EUVxlM5qJdvI/aVke3wFJZWRX1js6eOVrOMMyCfkjv3IjqM1PudOJRmJ/e4Lfc3bs17UXFcfH4qe1wfxcW3d+uQYuTCzAHubE3eB+vEB8OSI+OuWSKTUoXJ/dsDNNLkaR8Vwb7IneM5st5AWEJTqK6lGiZb9ErRP4Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894503; c=relaxed/simple;
	bh=ND06y5EjR78Y73alOo/4LGl3HOneiV69A3pDQ1l7ZVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLv3InDxSbKWiVoWM55m78PFeOSaIq/84kMqvO+7i+9lqWYaTjHcmlP1+zRy3aFdd2BcDW0L+Wvia8DKX+vvjnCEfjPnL3CLeSPBYLn6T5Ju/S64fG9gIFfBPJn9piKJQVLTKMAAv0GH+bMVNpHkhZxyDF1ahSvXNE1fgNHefhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1GBecGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1GBecGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E921F000FF;
	Tue, 13 Oct 2026 12:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894502;
	bh=SBYLKHwu2RkVl81nfTAxfdUaMIqmd9DlnNAGegXBOQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1GBecGeXkwCkfvFchhm6zW/raEHIOMKWcpy0t5c4eUZG/6l/1twRg5WeCc15IfXk
	 /tAFhqy4RewjkgVWuaqd93F+5j4QZTUt34eJI35GCWoxLi8j0sO8I1Ocls0aXqcEUf
	 3jALAyYGSfTOZPJoiXgeUPhJjczvp6wyDdEwy7dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/621] gpio: exar: initialize the ID before registering its cleanup
Date: Tue, 13 Oct 2026 13:38:53 +0200
Message-ID: <20261013112933.587647099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4d69e74034b208588636ecc177e0dd43a7696af3 ]

devm_add_action_or_reset() invokes the cleanup action immediately when
registering the action fails.  gpio_exar_probe() currently stores the
allocated ID in exar_gpio only after registering the action, so that
failure makes exar_devm_ida_free() release ID 0.  If the allocated ID is
nonzero, this leaks that ID and can free ID 0 belonging to another device.

Store the ID before registering the cleanup action so both the immediate
failure path and normal device teardown release the correct allocation.

Fixes: 5300ebb695fa ("gpio: exar: use devm action for freeing the IDA and drop remove()")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/179070265834.12871.48183786512201899.idr-bug-79@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-exar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-exar.c b/drivers/gpio/gpio-exar.c
index 9053662f18177..f629cc526f3ee 100644
--- a/drivers/gpio/gpio-exar.c
+++ b/drivers/gpio/gpio-exar.c
@@ -199,6 +199,7 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	index = ida_alloc(&ida_index, GFP_KERNEL);
 	if (index < 0)
 		return index;
+	exar_gpio->index = index;
 
 	ret = devm_add_action_or_reset(dev, exar_devm_ida_free, exar_gpio);
 	if (ret)
@@ -214,7 +215,6 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	exar_gpio->gpio_chip.set = exar_set_value;
 	exar_gpio->gpio_chip.base = -1;
 	exar_gpio->gpio_chip.ngpio = ngpios;
-	exar_gpio->index = index;
 	exar_gpio->first_pin = first_pin;
 
 	ret = devm_gpiochip_add_data(dev, &exar_gpio->gpio_chip, exar_gpio);
-- 
2.53.0



