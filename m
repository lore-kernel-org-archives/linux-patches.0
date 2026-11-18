Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038532;
	b=LoNelrIE1b/JaqsG1N6uqkSGHuiHlzwyJjOvqiCJfsSJDQorPnEZ77ovbXjixf6l195s
	 ltRVCPRysGLktEVZl+WOnsDqaBMj4z7qZ52gUdGwUuDrwzAKi89zVlwqMJrhEwI6230x7
	 kCFcKZ5jTtqU78mzyoq4fsgAYi3Sj4rcuxlTbFIdG9Iv+VwnkjTlspJWbp0XGf3h5Ccch
	 Qd49zuIuifw0ukjHGO8RcDAiCQiEbN58tFDTNblwr051O98ZjeZhbtoWc9l0ljPRJ372E
	 gcd1f9Uv245LIsMfjwPU8JZXZ/2twNm0YBy+gBd+aeUxLL6iOeSaNICtxCIv7vL1OzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/iJdjFhxvR+KUkQoFLl/+knlk6Wv+hxwl6u0SCAPkII=;
	b=sLi9XQJbJUlzpKnI5VtdH08iWtubP/7z4r+RcNZw5sIvmAD1qFzKE4V74Ic4mEs/FQjn
	 yacReR2mhfo3REp+6gE/4FKL/mYoxviqWvPRa6a93htsiOCH5sfgxSU0/I04+yVPIIL1A
	 baQmaJa9YDyhzFCqZj02afIeV0drO6X/7qqb11qbQ8IpnCT/g6GSzuHrJqZiVkToUla2M
	 dyruAmwbDmXsXqeJUkL6uNh7hGwzEwyAEDyKSPrPSzSfEijzcCCMDARTeLtu3jo8EPfAm
	 c/NDX/XKma430GAJ8+2IQYB9YGf8AUYJ2hCMSZFfvvPUBhHUHHk+AKZcqW4vnqj49NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rW7pdKwr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550FF606A31C;
	Wed, 18 Nov 2026 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rW7pdKwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CACA1F000C4;
	Wed, 18 Nov 2026 21:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038532;
	bh=/iJdjFhxvR+KUkQoFLl/+knlk6Wv+hxwl6u0SCAPkII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rW7pdKwrY0E87wrf/G5osRbwZgEQ4k+zdDwzRyO4uIMYuSBVQXnnSs0mJtyDqg7nd
	 vuo4w+H1oIFUj0O4PcWGU5opzYNScVZJ2Xx4/zap9wegS4sK778m9FjkOqkw3RA6y3
	 VXCehZEVKxfurqj+5Vb+knLE4EtMmtKy3qfiMxNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1775/3318] Input: matrix_keypad - consolidate handling of clustered interrupt
Date: Wed, 18 Nov 2026 15:39:57 +0100
Message-ID: <20261118150415.111192289@linuxfoundation.org>
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

[ Upstream commit 8cf4b3683a713a4b54d44565e8a32b4cca357084 ]

Now that the driver stores interrupt numbers corresponding to individual
GPIOs in non-clustered mode, it is possible to unify handling of both
modes by storing clustered interrupt at position 0 and setting the
number of interrupts in this case to 1.

Link: https://lore.kernel.org/r/20240121053232.276968-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 1527451f87df ("Revert "Input: matrix_keypad - force switch rows to input mode"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 63 ++++++++------------------
 1 file changed, 20 insertions(+), 43 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 1cd1ffb80401a..44ef600b8f191 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -27,9 +27,10 @@ struct matrix_keypad {
 	const struct matrix_keypad_platform_data *pdata;
 	struct input_dev *input_dev;
 	unsigned int row_shift;
-	unsigned int row_irqs[MATRIX_MAX_ROWS];
 
-	DECLARE_BITMAP(disabled_gpios, MATRIX_MAX_ROWS);
+	unsigned int row_irqs[MATRIX_MAX_ROWS];
+	unsigned int num_row_irqs;
+	DECLARE_BITMAP(wakeup_enabled_irqs, MATRIX_MAX_ROWS);
 
 	uint32_t last_key_state[MATRIX_MAX_COLS];
 	struct delayed_work work;
@@ -86,28 +87,18 @@ static bool row_asserted(const struct matrix_keypad_platform_data *pdata,
 
 static void enable_row_irqs(struct matrix_keypad *keypad)
 {
-	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	if (pdata->clustered_irq > 0)
-		enable_irq(pdata->clustered_irq);
-	else {
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			enable_irq(keypad->row_irqs[i]);
-	}
+	for (i = 0; i < keypad->num_row_irqs; i++)
+		enable_irq(keypad->row_irqs[i]);
 }
 
 static void disable_row_irqs(struct matrix_keypad *keypad)
 {
-	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	if (pdata->clustered_irq > 0)
-		disable_irq_nosync(pdata->clustered_irq);
-	else {
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			disable_irq_nosync(keypad->row_irqs[i]);
-	}
+	for (i = 0; i < keypad->num_row_irqs; i++)
+		disable_irq_nosync(keypad->row_irqs[i]);
 }
 
 /*
@@ -233,35 +224,20 @@ static void matrix_keypad_stop(struct input_dev *dev)
 
 static void matrix_keypad_enable_wakeup(struct matrix_keypad *keypad)
 {
-	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	if (pdata->clustered_irq > 0) {
-		if (enable_irq_wake(pdata->clustered_irq) == 0)
-			keypad->gpio_all_disabled = true;
-	} else {
-
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			if (!test_bit(i, keypad->disabled_gpios))
-				if (enable_irq_wake(keypad->row_irqs[i]) == 0)
-					__set_bit(i, keypad->disabled_gpios);
-	}
+	for_each_clear_bit(i, keypad->wakeup_enabled_irqs, keypad->num_row_irqs)
+		if (enable_irq_wake(keypad->row_irqs[i]) == 0)
+			__set_bit(i, keypad->wakeup_enabled_irqs);
 }
 
 static void matrix_keypad_disable_wakeup(struct matrix_keypad *keypad)
 {
-	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	if (pdata->clustered_irq > 0) {
-		if (keypad->gpio_all_disabled) {
-			disable_irq_wake(pdata->clustered_irq);
-			keypad->gpio_all_disabled = false;
-		}
-	} else {
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			if (test_and_clear_bit(i, keypad->disabled_gpios))
-				disable_irq_wake(keypad->row_irqs[i]);
+	for_each_set_bit(i, keypad->wakeup_enabled_irqs, keypad->num_row_irqs) {
+		disable_irq_wake(keypad->row_irqs[i]);
+		__clear_bit(i, keypad->wakeup_enabled_irqs);
 	}
 }
 
@@ -335,6 +311,9 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 				"Unable to acquire clustered interrupt\n");
 			goto err_free_rows;
 		}
+
+		keypad->row_irqs[0] = pdata->clustered_irq;
+		keypad->num_row_irqs = 1;
 	} else {
 		for (i = 0; i < pdata->num_row_gpios; i++) {
 			irq = gpio_to_irq(pdata->row_gpios[i]);
@@ -360,6 +339,8 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 
 			keypad->row_irqs[i] = irq;
 		}
+
+		keypad->num_row_irqs = pdata->num_row_gpios;
 	}
 
 	/* initialized as disabled - enabled by input->open */
@@ -386,12 +367,8 @@ static void matrix_keypad_free_gpio(struct matrix_keypad *keypad)
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	if (pdata->clustered_irq > 0) {
-		free_irq(pdata->clustered_irq, keypad);
-	} else {
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			free_irq(keypad->row_irqs[i], keypad);
-	}
+	for (i = 0; i < keypad->num_row_irqs; i++)
+		free_irq(keypad->row_irqs[i], keypad);
 
 	for (i = 0; i < pdata->num_row_gpios; i++)
 		gpio_free(pdata->row_gpios[i]);
-- 
2.53.0



