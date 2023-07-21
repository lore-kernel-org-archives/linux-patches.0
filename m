Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8737320F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D7FC433C8;
	Fri, 21 Jul 2023 19:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967278;
	bh=hlxwbAxZHnNv3G2CKMRV4ejAE0sEv3+SY+Nix9/tL7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8N92/K9Ir8v8BoZ1CdEWEg8qK9cbz3pNQ2zloipb4SCmAyByAns3pbaTciyK1zhF
	 ipWB4xUhC+v+GEWbhG4sCnX6Z8SAO7OKl8e7rxN+EdzTCAqqfoyFJXzawIYfdJFTml
	 zaAS/AtA/gRKyELag3Uree+PTyK4ziqkG3YfhDv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 079/223] pinctrl: amd: Add fields for interrupt status and wake status
Date: Fri, 21 Jul 2023 18:05:32 +0200
Message-ID: <20230721160524.230930854@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit 010f493d90ee1dbc32fa1ce51398f20d494c20c2 upstream.

If the firmware has misconfigured a GPIO it may cause interrupt
status or wake status bits to be set and not asserted. Add these
to debug output to catch this case.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230328174231.8924-3-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -211,6 +211,8 @@ static void amd_gpio_dbg_show(struct seq
 	char *wake_cntrl1;
 	char *wake_cntrl2;
 	char *pin_sts;
+	char *interrupt_sts;
+	char *wake_sts;
 	char *pull_up_sel;
 	char *orientation;
 	char debounce_value[40];
@@ -243,7 +245,7 @@ static void amd_gpio_dbg_show(struct seq
 			continue;
 		}
 		seq_printf(s, "GPIO bank%d\n", bank);
-		seq_puts(s, "gpio\tint|active|trigger|S0i3| S3|S4/S5| Z|wake|pull|  orient|       debounce|reg\n");
+		seq_puts(s, "gpio\t  int|active|trigger|S0i3| S3|S4/S5| Z|wake|pull|  orient|       debounce|reg\n");
 		for (; i < pin_num; i++) {
 			seq_printf(s, "#%d\t", i);
 			raw_spin_lock_irqsave(&gpio_dev->lock, flags);
@@ -274,12 +276,18 @@ static void amd_gpio_dbg_show(struct seq
 				else
 					interrupt_mask = "😷";
 
-				seq_printf(s, "%s|     %s|  %s|",
+				if (pin_reg & BIT(INTERRUPT_STS_OFF))
+					interrupt_sts = "🔥";
+				else
+					interrupt_sts = "  ";
+
+				seq_printf(s, "%s %s|     %s|  %s|",
+				   interrupt_sts,
 				   interrupt_mask,
 				   active_level,
 				   level_trig);
 			} else
-				seq_puts(s, "  ∅|      |       |");
+				seq_puts(s, "    ∅|      |       |");
 
 			if (pin_reg & BIT(WAKE_CNTRL_OFF_S0I3))
 				wake_cntrl0 = "⏰";
@@ -305,6 +313,12 @@ static void amd_gpio_dbg_show(struct seq
 				wake_cntrlz = "  ";
 			seq_printf(s, "%s|", wake_cntrlz);
 
+			if (pin_reg & BIT(WAKE_STS_OFF))
+				wake_sts = "🔥";
+			else
+				wake_sts = " ";
+			seq_printf(s, "   %s|", wake_sts);
+
 			if (pin_reg & BIT(PULL_UP_ENABLE_OFF)) {
 				if (pin_reg & BIT(PULL_UP_SEL_OFF))
 					pull_up_sel = "8k";


