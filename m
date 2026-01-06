Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B403559DB;
	Tue,  6 Jan 2026 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720581; cv=none; b=n/vrkYhUdN81RyLevdEE4l97n1iLUTj2Apl+3UCdqoHOcAwFRilFeXuXQ1KiKUv29ECPCTpCr2IF+ICIEO/zY1wOk/dlp1ZMY2h80VtfxH569bLbl64z8ctfG0q+k6y9l/d+hIRhb7L5vIaQpupfXNm2RFIRmzQR4NuCs1zA+vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720581; c=relaxed/simple;
	bh=DJ+IJpE8Vmf9cVrIWl9ukbYvtAFfoNJbiq4jczMQMQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9eiQIk0JOxlRL3cI5iLFWM/ecY074nCKKIYsDRhmio4xa+AxMWcj9GNrxGldEhOKwZoEBzSVMzerVwirByapzWBz621VnUE9PnuvN2NtKgsYgacog7lvvWJ97fk/FIW/T4GGvsWmvve2TxvkDE/ig7EXQ8rfhEPqd/JSEevZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7ji4JvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7ji4JvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD54C19423;
	Tue,  6 Jan 2026 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720581;
	bh=DJ+IJpE8Vmf9cVrIWl9ukbYvtAFfoNJbiq4jczMQMQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7ji4JvH4gtmer+vqSp/G0P47TGRAWyQMtUp4Rchr8LWYdoRhAi0/Q50Fxu0ytkEU
	 JSfNp8UuskNpjfsn4cYo+wrd5/YYmgx3mItPU8Kk+sw4BJk68K0h3as1sr934D6nPW
	 HZHR6QhBSWF4RPwazR/F8viQDr7wLE5dbs3buHUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyl5933@chinaunicom.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 248/567] gpio: regmap: Fix memleak in error path in gpio_regmap_register()
Date: Tue,  6 Jan 2026 18:00:30 +0100
Message-ID: <20260106170500.489193691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit 52721cfc78c76b09c66e092b52617006390ae96a upstream.

Call gpiochip_remove() to free the resources allocated by
gpiochip_add_data() in error path.

Fixes: 553b75d4bfe9 ("gpio: regmap: Allow to allocate regmap-irq device")
Fixes: ae495810cffe ("gpio: regmap: add the .fixed_direction_output configuration parameter")
CC: stable@vger.kernel.org
Co-developed-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20251204101303.30353-1-guanwentao@uniontech.com
[Bartosz: reworked the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -310,7 +310,7 @@ struct gpio_regmap *gpio_regmap_register
 						 config->regmap_irq_line, config->regmap_irq_flags,
 						 0, config->regmap_irq_chip, &gpio->irq_chip_data);
 		if (ret)
-			goto err_free_bitmap;
+			goto err_remove_gpiochip;
 
 		irq_domain = regmap_irq_get_domain(gpio->irq_chip_data);
 	} else


