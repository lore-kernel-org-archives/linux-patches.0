Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8015B2F9D9E;
	Tue, 30 Sep 2025 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244839; cv=none; b=joUvL/V9ZGyE44NnSO14TgoEtlXjDEm8nAkIM0kRb4X4JFqcHQcLSKoRtgAkg9xUQDItLz9AHuc+HjmHaKE19DDF03E3Bdki9yjCnu7KpI0H8c05bdn/cqeRQFhFRUvc4yzqb+kwqXvRvWPakt0JPamiMu6kCJ3vO+Z4G1G/amw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244839; c=relaxed/simple;
	bh=c/5pYdg/pFhkcFkCI4AGk85O1Y1K8khGVrQjNQgegeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5W6SZsIMAqbGh4UdcOo2BHWDUHe77jMWlGWu7JarMnd5T0+NwtbQA7bs2yhAFEFzV0nGuta200t58OKjucXFKgpmr8pIodhqmRyD4wo6HxhuoFdFdXY3WJOf2QxEOfAmvnLTL4veZNyxYEBsuvJamlbH5+ASu9CaGrKFn20EYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGxTn+NT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGxTn+NT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CF6C116B1;
	Tue, 30 Sep 2025 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244839;
	bh=c/5pYdg/pFhkcFkCI4AGk85O1Y1K8khGVrQjNQgegeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGxTn+NTxCcf87UPIff3tVLSuNuhZj+68QD1JeYBhiwsLwFjb/RWppUOZVdWIcPtU
	 iYESRO98WQALEYbxkSeEMJs+vS6mWLN23mZC7ABWOd2GaiQBvvOF3oUyJuvsIUJZ1m
	 hQjhB7bPEPALxhvNWpSQGocYtGeZCL2ESeyMmDh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.16 122/143] pinctrl: airoha: fix wrong MDIO function bitmaks
Date: Tue, 30 Sep 2025 16:47:26 +0200
Message-ID: <20250930143836.094685115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit a061e739d36220c002da8b2429d5f16f637eb59a upstream.

With further testing with an attached Aeonsemi it was discovered that
the pinctrl MDIO function applied the wrong bitmask. The error was
probably caused by the confusing documentation related to these bits.

Inspecting what the bootloader actually configure, the SGMII_MDIO_MODE
is never actually set but instead it's set force enable to the 2 GPIO
(gpio 1-2) for MDC and MDIO pin.

The usage of GPIO might be confusing but this is just to instruct the
SoC to not mess with those 2 PIN and as Benjamin reported it's also an
Errata of 7581. The FORCE_GPIO_EN doesn't set them as GPIO function
(that is configured by a different register) but it's really to actually
""enable"" those lines.

Normally the SoC should autodetect this by HW but it seems AN7581 have
problem with this and require this workaround to force enable the 2 pin.

Applying this configuration permits correct functionality of any
externally attached PHY.

Cc: stable@vger.kernel.org
Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index ee5b9bab4552..b405dfa20891 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -108,6 +108,9 @@
 #define JTAG_UDI_EN_MASK			BIT(4)
 #define JTAG_DFD_EN_MASK			BIT(3)
 
+#define REG_FORCE_GPIO_EN			0x0228
+#define FORCE_GPIO_EN(n)			BIT(n)
+
 /* LED MAP */
 #define REG_LAN_LED0_MAPPING			0x027c
 #define REG_LAN_LED1_MAPPING			0x0280
@@ -718,17 +721,17 @@ static const struct airoha_pinctrl_func_group mdio_func_group[] = {
 	{
 		.name = "mdio",
 		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_PON_MODE,
-			GPIO_SGMII_MDIO_MODE_MASK,
-			GPIO_SGMII_MDIO_MODE_MASK
-		},
-		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_2ND_I2C_MODE,
 			GPIO_MDC_IO_MASTER_MODE_MODE,
 			GPIO_MDC_IO_MASTER_MODE_MODE
 		},
+		.regmap[1] = {
+			AIROHA_FUNC_MUX,
+			REG_FORCE_GPIO_EN,
+			FORCE_GPIO_EN(1) | FORCE_GPIO_EN(2),
+			FORCE_GPIO_EN(1) | FORCE_GPIO_EN(2)
+		},
 		.regmap_size = 2,
 	},
 };
-- 
2.51.0



