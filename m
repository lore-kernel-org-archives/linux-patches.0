Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A97A334C24;
	Fri,  9 Jan 2026 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960669; cv=none; b=XKxjJBHH55HXRLtwdSTcb0q1uD5JR+i+Z4aHksEfz3gFKAtL8ndlVrwEHW6o6kxS2q9JlrOfK52jvdgyM+JVgJIIRHvfGg5EIEV1TMiEL3wV+8PeFjETbQHVqzWjREU8EYkfSc+oFu0ssJnIOLXeHapO3J5+wpYoHFX9sudX79g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960669; c=relaxed/simple;
	bh=aMH0aMAFdl+2FNXCLNpTUfCFI+xiLT6FJhz38i3Rw/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQpK75AUUkW6W00px+leYSKQOeMiHLy1xAvi3m3w4hrOoeAPnB4iiMzZMOAqYOT/O72ojK1QnKy8vlIkZMYI3fq+FSXnKVDL+PBkgAc/PkciO0XDL/PRECrmi792JGDTBvlbfMSClXy9gcqcAJp0+kL20orVAKD7gzFqLIt9OC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peEaSKuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peEaSKuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B990DC19422;
	Fri,  9 Jan 2026 12:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960669;
	bh=aMH0aMAFdl+2FNXCLNpTUfCFI+xiLT6FJhz38i3Rw/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peEaSKuzVugi+f/f6bV0q94tvK06u9tMMZ6rnYsLwUBust2zq/y92/BF6pCKGgjwN
	 H+qWu9ekpRulQaNjl508z7Nsl0BYQWrqOFY3VvU4Q4tqGIBmYVKq38yCw0YWDg6Tm1
	 44VMcFKgOuUIGG7bjJqLIUxlm232R8HD+f/73BPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyl5933@chinaunicom.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 483/737] gpio: regmap: Fix memleak in error path in gpio_regmap_register()
Date: Fri,  9 Jan 2026 12:40:22 +0100
Message-ID: <20260109112152.155758955@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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


