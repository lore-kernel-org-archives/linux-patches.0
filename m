Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B8134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057A8C433C9;
	Mon, 26 Jun 2023 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803779;
	bh=oL/zh7i/hSXwrGKNTavv9AXBuIVM0dmjjSCpdnWImu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibN/hcpGp6m3Mg0F9f3o/yx/9EZSiqfoT4Ov1CXYHwjzGTkTR+E1/xt82nj6/voEo
	 FepcwZWWGUnKKONfKJeROjkwZeBlLUhPdG8K42JuBzMKWz1i21PIHgr/0asJPiKeHe
	 GLLUDPbgkYu15HMPCcEHdzhjULIHKqB5M0avoRlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 174/199] platform/x86: int3472: Avoid crash in unregistering regulator gpio
Date: Mon, 26 Jun 2023 20:11:20 +0200
Message-ID: <20230626180813.367620711@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Yao <hao.yao@intel.com>

[ Upstream commit fb109fba728407fa4a84d659b5cb87cd8399d7b3 ]

When int3472 is loaded before GPIO driver, acpi_get_and_request_gpiod()
failed but the returned gpio descriptor is not NULL, it will cause panic
in later gpiod_put(), so set the gpio_desc to NULL in register error
handling to avoid such crash.

Signed-off-by: Hao Yao <hao.yao@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Link: https://lore.kernel.org/r/20230524035135.90315-1-bingbu.cao@intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/intel/int3472/clk_and_regulator.c  | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
index 1086c3d834945..399f0623ca1b5 100644
--- a/drivers/platform/x86/intel/int3472/clk_and_regulator.c
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -101,9 +101,11 @@ int skl_int3472_register_clock(struct int3472_discrete_device *int3472,
 
 	int3472->clock.ena_gpio = acpi_get_and_request_gpiod(path, agpio->pin_table[0],
 							     "int3472,clk-enable");
-	if (IS_ERR(int3472->clock.ena_gpio))
-		return dev_err_probe(int3472->dev, PTR_ERR(int3472->clock.ena_gpio),
-				     "getting clk-enable GPIO\n");
+	if (IS_ERR(int3472->clock.ena_gpio)) {
+		ret = PTR_ERR(int3472->clock.ena_gpio);
+		int3472->clock.ena_gpio = NULL;
+		return dev_err_probe(int3472->dev, ret, "getting clk-enable GPIO\n");
+	}
 
 	if (polarity == GPIO_ACTIVE_LOW)
 		gpiod_toggle_active_low(int3472->clock.ena_gpio);
@@ -199,8 +201,9 @@ int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
 	int3472->regulator.gpio = acpi_get_and_request_gpiod(path, agpio->pin_table[0],
 							     "int3472,regulator");
 	if (IS_ERR(int3472->regulator.gpio)) {
-		dev_err(int3472->dev, "Failed to get regulator GPIO line\n");
-		return PTR_ERR(int3472->regulator.gpio);
+		ret = PTR_ERR(int3472->regulator.gpio);
+		int3472->regulator.gpio = NULL;
+		return dev_err_probe(int3472->dev, ret, "getting regulator GPIO\n");
 	}
 
 	/* Ensure the pin is in output mode and non-active state */
-- 
2.39.2



