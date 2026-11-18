Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038529;
	b=r9QJR/8zUaW3ZOu3B6Bq4UnY13ULVfbykbYGduSqkPLZKtJxIPcznrQG8FHggounE9nO
	 56hTnlB10ESsc/HUh1JO/lq3efSLAy5pulG3dH92VwbIdq0TbaPCHpG0XvCgPIQL/bTWV
	 6orlYw7ap96Ya2Wk8LWt3pYOc62f5Hwha29I8mvsCuDtkEiDvDgyIoSyABBVbG8+Qt1L1
	 L94UmBk/G20QxlBuPt5kT6DbAZYXNA8191MMjhsocDaJivZZLC1i95S//N3uWsNLDAbNe
	 H3u9EP6i0/BPh6fzdER9NdxVldDkw4n+66Vs8CUCrIg81mrPIlFo/1UQVURmRTndw2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Ld4f5nKTqdTwbMQG6kgnFe0NQ3cc7EIal5fo7UYZZs=;
	b=qEYnoCWKuCqw+3IeovJ0q3wwdf/7uikxEemEaVpgzLreFjLgZfI9xeb6WIjmFrnF04AI
	 +YAnImv/MTLb65tYGiM+01KHz6pmYOL+DFlXWl7kx6ftBEq1ctEC8SWDfkqCz4mpSnadn
	 WCoWbsaw37PQ4zDB00P1qOzK9zbc//HA5MMU3cNyTnKJuIejT6xQHVDflvbqSMxHAKL7G
	 jLCJtFmXm2ojlfdlV7Nr8++bXw4HuvBoabvlyvmjQ494f8RGRLOJ3WKs4cphUTfUYEX4v
	 LA6VoWFHdtOHKQM3QVB1jRHyQXNZBsIkXzKudYzwbKPFO+eyYJMFN4qjYcqU0X+1TMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omYHAwIk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8478B606A31C;
	Wed, 18 Nov 2026 21:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omYHAwIk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45FA1F000C4;
	Wed, 18 Nov 2026 21:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038529;
	bh=0Ld4f5nKTqdTwbMQG6kgnFe0NQ3cc7EIal5fo7UYZZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omYHAwIkaOYEwRvOWF0LMxuCtLx1g6DOllHWnM80gagQh6aqRYwQDsI9duANnpxjo
	 hsK36zFgLS8IRUWlU1WrajhklVGVy+xkXz/X208mypD8MeI+AEC+CwCgiz9z8+toYn
	 dNMNOoWNsbar7WR0vN2OHvlzJumfJx2RfgQhsB7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1774/3318] Input: matrix_keypad - avoid repeatedly converting GPIO to IRQ
Date: Wed, 18 Nov 2026 15:39:56 +0100
Message-ID: <20261118150415.079467037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit a96fb711c6be76bcfbcf594a865002fa7c0eb525 ]

There is no need to do conversion from GPIOs to interrupt numbers.
Convert row GPIOs to interrupt numbers once in probe() and use
this information when the driver needs to enable or disable given
interrupt line.

Link: https://lore.kernel.org/r/20240121053232.276968-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 1527451f87df ("Revert "Input: matrix_keypad - force switch rows to input mode"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 48 ++++++++++++++------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 50fa764c82d2b..1cd1ffb80401a 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -27,6 +27,7 @@ struct matrix_keypad {
 	const struct matrix_keypad_platform_data *pdata;
 	struct input_dev *input_dev;
 	unsigned int row_shift;
+	unsigned int row_irqs[MATRIX_MAX_ROWS];
 
 	DECLARE_BITMAP(disabled_gpios, MATRIX_MAX_ROWS);
 
@@ -92,7 +93,7 @@ static void enable_row_irqs(struct matrix_keypad *keypad)
 		enable_irq(pdata->clustered_irq);
 	else {
 		for (i = 0; i < pdata->num_row_gpios; i++)
-			enable_irq(gpio_to_irq(pdata->row_gpios[i]));
+			enable_irq(keypad->row_irqs[i]);
 	}
 }
 
@@ -105,7 +106,7 @@ static void disable_row_irqs(struct matrix_keypad *keypad)
 		disable_irq_nosync(pdata->clustered_irq);
 	else {
 		for (i = 0; i < pdata->num_row_gpios; i++)
-			disable_irq_nosync(gpio_to_irq(pdata->row_gpios[i]));
+			disable_irq_nosync(keypad->row_irqs[i]);
 	}
 }
 
@@ -233,7 +234,6 @@ static void matrix_keypad_stop(struct input_dev *dev)
 static void matrix_keypad_enable_wakeup(struct matrix_keypad *keypad)
 {
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
-	unsigned int gpio;
 	int i;
 
 	if (pdata->clustered_irq > 0) {
@@ -241,21 +241,16 @@ static void matrix_keypad_enable_wakeup(struct matrix_keypad *keypad)
 			keypad->gpio_all_disabled = true;
 	} else {
 
-		for (i = 0; i < pdata->num_row_gpios; i++) {
-			if (!test_bit(i, keypad->disabled_gpios)) {
-				gpio = pdata->row_gpios[i];
-
-				if (enable_irq_wake(gpio_to_irq(gpio)) == 0)
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			if (!test_bit(i, keypad->disabled_gpios))
+				if (enable_irq_wake(keypad->row_irqs[i]) == 0)
 					__set_bit(i, keypad->disabled_gpios);
-			}
-		}
 	}
 }
 
 static void matrix_keypad_disable_wakeup(struct matrix_keypad *keypad)
 {
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
-	unsigned int gpio;
 	int i;
 
 	if (pdata->clustered_irq > 0) {
@@ -264,12 +259,9 @@ static void matrix_keypad_disable_wakeup(struct matrix_keypad *keypad)
 			keypad->gpio_all_disabled = false;
 		}
 	} else {
-		for (i = 0; i < pdata->num_row_gpios; i++) {
-			if (test_and_clear_bit(i, keypad->disabled_gpios)) {
-				gpio = pdata->row_gpios[i];
-				disable_irq_wake(gpio_to_irq(gpio));
-			}
-		}
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			if (test_and_clear_bit(i, keypad->disabled_gpios))
+				disable_irq_wake(keypad->row_irqs[i]);
 	}
 }
 
@@ -306,7 +298,7 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 				   struct matrix_keypad *keypad)
 {
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
-	int i, err;
+	int i, irq, err;
 
 	/* initialized strobe lines as outputs, activated */
 	for (i = 0; i < pdata->num_col_gpios; i++) {
@@ -345,11 +337,19 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 		}
 	} else {
 		for (i = 0; i < pdata->num_row_gpios; i++) {
-			err = request_any_context_irq(
-					gpio_to_irq(pdata->row_gpios[i]),
+			irq = gpio_to_irq(pdata->row_gpios[i]);
+			if (irq < 0) {
+				err = irq;
+				dev_err(&pdev->dev,
+					"Unable to convert GPIO line %i to irq: %d\n",
+					pdata->row_gpios[i], err);
+				goto err_free_irqs;
+			}
+
+			err = request_any_context_irq(irq,
 					matrix_keypad_interrupt,
 					IRQF_TRIGGER_RISING |
-					IRQF_TRIGGER_FALLING,
+						IRQF_TRIGGER_FALLING,
 					"matrix-keypad", keypad);
 			if (err < 0) {
 				dev_err(&pdev->dev,
@@ -357,6 +357,8 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 					pdata->row_gpios[i]);
 				goto err_free_irqs;
 			}
+
+			keypad->row_irqs[i] = irq;
 		}
 	}
 
@@ -366,7 +368,7 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 
 err_free_irqs:
 	while (--i >= 0)
-		free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
+		free_irq(keypad->row_irqs[i], keypad);
 	i = pdata->num_row_gpios;
 err_free_rows:
 	while (--i >= 0)
@@ -388,7 +390,7 @@ static void matrix_keypad_free_gpio(struct matrix_keypad *keypad)
 		free_irq(pdata->clustered_irq, keypad);
 	} else {
 		for (i = 0; i < pdata->num_row_gpios; i++)
-			free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
+			free_irq(keypad->row_irqs[i], keypad);
 	}
 
 	for (i = 0; i < pdata->num_row_gpios; i++)
-- 
2.53.0



