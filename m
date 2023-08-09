Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F217756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB68FC433C7;
	Wed,  9 Aug 2023 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580119;
	bh=4xmf+ocLZp5ivzDGC7z2SkHgsShuZyYwQi8U9ZHOmgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhsdOluvzJ5vSJBZAMuqsg5enzEXt4u917WBAgRj9UL0Qv9iLnMkoH7jatK9r2fPU
	 EnEkBBBMbqAoNf0sQz5XKIIomf4Cwcu79Aeashp/cpdsgXpBfqilh7HY3Jjik4QhnY
	 j1Qs52RMBeWL3Gyy5mfMLMdIM4NAlfIEqKZns7wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nik P <npliashechnikov@gmail.com>,
	Nathan Schulte <nmschulte@gmail.com>,
	Friedrich Vock <friedrich.vock@gmx.de>,
	dridri85@gmail.com,
	Jan Visser <starquake@linuxeverywhere.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/323] pinctrl: amd: Use amd_pinconf_set() for all config options
Date: Wed,  9 Aug 2023 12:40:41 +0200
Message-ID: <20230809103707.435343109@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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

[ Upstream commit 635a750d958e158e17af0f524bedc484b27fbb93 ]

On ASUS TUF A16 it is reported that the ITE5570 ACPI device connected to
GPIO 7 is causing an interrupt storm.  This issue doesn't happen on
Windows.

Comparing the GPIO register configuration between Windows and Linux
bit 20 has been configured as a pull up on Windows, but not on Linux.
Checking GPIO declaration from the firmware it is clear it *should* have
been a pull up on Linux as well.

```
GpioInt (Level, ActiveLow, Exclusive, PullUp, 0x0000,
	 "\\_SB.GPIO", 0x00, ResourceConsumer, ,)
{   // Pin list
0x0007
}
```

On Linux amd_gpio_set_config() is currently only used for programming
the debounce. Actually the GPIO core calls it with all the arguments
that are supported by a GPIO, pinctrl-amd just responds `-ENOTSUPP`.

To solve this issue expand amd_gpio_set_config() to support the other
arguments amd_pinconf_set() supports, namely `PIN_CONFIG_BIAS_PULL_DOWN`,
`PIN_CONFIG_BIAS_PULL_UP`, and `PIN_CONFIG_DRIVE_STRENGTH`.

Reported-by: Nik P <npliashechnikov@gmail.com>
Reported-by: Nathan Schulte <nmschulte@gmail.com>
Reported-by: Friedrich Vock <friedrich.vock@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217336
Reported-by: dridri85@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217493
Link: https://lore.kernel.org/linux-input/20230530154058.17594-1-friedrich.vock@gmx.de/
Tested-by: Jan Visser <starquake@linuxeverywhere.org>
Fixes: 2956b5d94a76 ("pinctrl / gpio: Introduce .set_config() callback for GPIO chips")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230705133005.577-3-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index d5f5661de13c6..c140ee16fe7c8 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -190,18 +190,6 @@ static int amd_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
 	return ret;
 }
 
-static int amd_gpio_set_config(struct gpio_chip *gc, unsigned offset,
-			       unsigned long config)
-{
-	u32 debounce;
-
-	if (pinconf_to_config_param(config) != PIN_CONFIG_INPUT_DEBOUNCE)
-		return -ENOTSUPP;
-
-	debounce = pinconf_to_config_argument(config);
-	return amd_gpio_set_debounce(gc, offset, debounce);
-}
-
 #ifdef CONFIG_DEBUG_FS
 static void amd_gpio_dbg_show(struct seq_file *s, struct gpio_chip *gc)
 {
@@ -686,7 +674,7 @@ static int amd_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int amd_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
-				unsigned long *configs, unsigned num_configs)
+			   unsigned long *configs, unsigned int num_configs)
 {
 	int i;
 	u32 arg;
@@ -776,6 +764,20 @@ static int amd_pinconf_group_set(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+static int amd_gpio_set_config(struct gpio_chip *gc, unsigned int pin,
+			       unsigned long config)
+{
+	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
+
+	if (pinconf_to_config_param(config) == PIN_CONFIG_INPUT_DEBOUNCE) {
+		u32 debounce = pinconf_to_config_argument(config);
+
+		return amd_gpio_set_debounce(gc, pin, debounce);
+	}
+
+	return amd_pinconf_set(gpio_dev->pctrl, pin, &config, 1);
+}
+
 static const struct pinconf_ops amd_pinconf_ops = {
 	.pin_config_get		= amd_pinconf_get,
 	.pin_config_set		= amd_pinconf_set,
-- 
2.39.2



