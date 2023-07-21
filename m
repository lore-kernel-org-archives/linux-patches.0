Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73481F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ABDC433C9;
	Fri, 21 Jul 2023 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956067;
	bh=8ryoyp9p1FLTIgoJ7+V29JsBT72Rm9wfJiO8W22obeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPWO8hUljCh2EXG36uHcvhgW0rT4nKBuaTYIXrmNqrDre6xEo7aKD5HVG2aGmLULX
	 FTeeE4nINsr+vS4J9nwIt+kdXqM6b4OZYehMyaQvM+jfgLosJmVP4rqtMy6+HxHM3/
	 3uVtGNXU3SUO3rAV0T0MZTIaTsri0FlRBC762o4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Visser <starquake@linuxeverywhere.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.4 121/292] pinctrl: amd: Drop pull up select configuration
Date: Fri, 21 Jul 2023 18:03:50 +0200
Message-ID: <20230721160534.024591209@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3f62312d04d4c68aace9cd06fc135e09573325f3 upstream.

pinctrl-amd currently tries to program bit 19 of all GPIOs to select
either a 4kΩ or 8hΩ pull up, but this isn't what bit 19 does.  Bit
19 is marked as reserved, even in the latest platforms documentation.

Drop this programming functionality.

Tested-by: Jan Visser <starquake@linuxeverywhere.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230705133005.577-4-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   16 ++++------------
 drivers/pinctrl/pinctrl-amd.h |    1 -
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -209,7 +209,6 @@ static void amd_gpio_dbg_show(struct seq
 	char *pin_sts;
 	char *interrupt_sts;
 	char *wake_sts;
-	char *pull_up_sel;
 	char *orientation;
 	char debounce_value[40];
 	char *debounce_enable;
@@ -317,14 +316,9 @@ static void amd_gpio_dbg_show(struct seq
 			seq_printf(s, "   %s|", wake_sts);
 
 			if (pin_reg & BIT(PULL_UP_ENABLE_OFF)) {
-				if (pin_reg & BIT(PULL_UP_SEL_OFF))
-					pull_up_sel = "8k";
-				else
-					pull_up_sel = "4k";
-				seq_printf(s, "%s ↑|",
-					   pull_up_sel);
+				seq_puts(s, "  ↑ |");
 			} else if (pin_reg & BIT(PULL_DOWN_ENABLE_OFF)) {
-				seq_puts(s, "   ↓|");
+				seq_puts(s, "  ↓ |");
 			} else  {
 				seq_puts(s, "    |");
 			}
@@ -751,7 +745,7 @@ static int amd_pinconf_get(struct pinctr
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_UP:
-		arg = (pin_reg >> PULL_UP_SEL_OFF) & (BIT(0) | BIT(1));
+		arg = (pin_reg >> PULL_UP_ENABLE_OFF) & BIT(0);
 		break;
 
 	case PIN_CONFIG_DRIVE_STRENGTH:
@@ -798,10 +792,8 @@ static int amd_pinconf_set(struct pinctr
 			break;
 
 		case PIN_CONFIG_BIAS_PULL_UP:
-			pin_reg &= ~BIT(PULL_UP_SEL_OFF);
-			pin_reg |= (arg & BIT(0)) << PULL_UP_SEL_OFF;
 			pin_reg &= ~BIT(PULL_UP_ENABLE_OFF);
-			pin_reg |= ((arg>>1) & BIT(0)) << PULL_UP_ENABLE_OFF;
+			pin_reg |= (arg & BIT(0)) << PULL_UP_ENABLE_OFF;
 			break;
 
 		case PIN_CONFIG_DRIVE_STRENGTH:
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -36,7 +36,6 @@
 #define WAKE_CNTRL_OFF_S4               15
 #define PIN_STS_OFF			16
 #define DRV_STRENGTH_SEL_OFF		17
-#define PULL_UP_SEL_OFF			19
 #define PULL_UP_ENABLE_OFF		20
 #define PULL_DOWN_ENABLE_OFF		21
 #define OUTPUT_VALUE_OFF		22


