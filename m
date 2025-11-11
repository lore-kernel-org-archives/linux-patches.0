Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195CA24A043;
	Tue, 11 Nov 2025 01:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825483; cv=none; b=n/iuF+22LSnnzX/WvbRmRuPZ5QiGPP7wAkbtd7l1VZzHsW6C2j99EG7RzvWx1ywncpGCI3uYXgVlR93ai/jrhXiy9S2DbxCPBgEjguKD6spkGoxkcvP8NwbOlBluYAKW+WdzepA1idlFEju5OhkAA+AlrQnyA6SmTWSz7Y122Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825483; c=relaxed/simple;
	bh=3pyB7iweHj8ROjnXrc1+/ZH4m0pIxBsZoBE4x0/yrf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hDsMKi9FtqeSNOuyh/HJIutjET5oszXk8jAL8xT2Ndej89HqqxaRPXrpxR3J1GWcd6vkKvCdsqIgEr1D0LWc4aFXZVPafrbxptqr8cjwu18wroIXbpj1De03pJAeQd+lEIVa97wwiuU9BtcfHKPNd68BIgsDwjDKZFSo6ck/TCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPjan6xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPjan6xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E182C113D0;
	Tue, 11 Nov 2025 01:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825482;
	bh=3pyB7iweHj8ROjnXrc1+/ZH4m0pIxBsZoBE4x0/yrf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPjan6xyn2JahGBqhB+3OR8pcxitJmg1AsHQfjuHcmtpBsO9yt7DnyceSNcUChuFo
	 kZh9MtDmQKUigrJ8/Wejo5XGq8n3enYHl2GNfzXLpUNr5+J+tuhfbaOYLT4Em+wq98
	 xXmGNwjjybXsGLjv6SkUDAikNLuSCFNUG/u3odl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu Wenbo <qiuwenbo@kylinsec.com.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 804/849] platform/x86: int3472: Fix double free of GPIO device during unregister
Date: Tue, 11 Nov 2025 09:46:14 +0900
Message-ID: <20251111004555.868602484@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu Wenbo <qiuwenbo@kylinsec.com.cn>

commit f0f7a3f542c1698edb69075f25a3f846207facba upstream.

regulator_unregister() already frees the associated GPIO device. On
ThinkPad X9 (Lunar Lake), this causes a double free issue that leads to
random failures when other drivers (typically Intel THC) attempt to
allocate interrupts. The root cause is that the reference count of the
pinctrl_intel_platform module unexpectedly drops to zero when this
driver defers its probe.

This behavior can also be reproduced by unloading the module directly.

Fix the issue by removing the redundant release of the GPIO device
during regulator unregistration.

Cc: stable@vger.kernel.org
Fixes: 1e5d088a52c2 ("platform/x86: int3472: Stop using devm_gpiod_get()")
Signed-off-by: Qiu Wenbo <qiuwenbo@kylinsec.com.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Link: https://patch.msgid.link/20251028063009.289414-1-qiuwenbo@gnome.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/int3472/clk_and_regulator.c | 5 +----
 include/linux/platform_data/x86/int3472.h              | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
index 476ec24d3702..9e052b164a1a 100644
--- a/drivers/platform/x86/intel/int3472/clk_and_regulator.c
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -245,15 +245,12 @@ int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
 	if (IS_ERR(regulator->rdev))
 		return PTR_ERR(regulator->rdev);
 
-	int3472->regulators[int3472->n_regulator_gpios].ena_gpio = gpio;
 	int3472->n_regulator_gpios++;
 	return 0;
 }
 
 void skl_int3472_unregister_regulator(struct int3472_discrete_device *int3472)
 {
-	for (int i = 0; i < int3472->n_regulator_gpios; i++) {
+	for (int i = 0; i < int3472->n_regulator_gpios; i++)
 		regulator_unregister(int3472->regulators[i].rdev);
-		gpiod_put(int3472->regulators[i].ena_gpio);
-	}
 }
diff --git a/include/linux/platform_data/x86/int3472.h b/include/linux/platform_data/x86/int3472.h
index 1571e9157fa5..b1b837583d54 100644
--- a/include/linux/platform_data/x86/int3472.h
+++ b/include/linux/platform_data/x86/int3472.h
@@ -100,7 +100,6 @@ struct int3472_gpio_regulator {
 	struct regulator_consumer_supply supply_map[GPIO_REGULATOR_SUPPLY_MAP_COUNT * 2];
 	char supply_name_upper[GPIO_SUPPLY_NAME_LENGTH];
 	char regulator_name[GPIO_REGULATOR_NAME_LENGTH];
-	struct gpio_desc *ena_gpio;
 	struct regulator_dev *rdev;
 	struct regulator_desc rdesc;
 };
-- 
2.51.2



